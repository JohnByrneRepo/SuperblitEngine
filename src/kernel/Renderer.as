package kernel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.*;
	
	import managers.*;	
	import kernel.*;
	import gameobjects.*;	

	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class Renderer extends Sprite
	{
		public var infoPointTextTimer:int;
		public var sfx:SoundEffectsManager = new SoundEffectsManager();
		public var starsX:Array = [];
		public var starsY:Array = [];
		public var starsV:Array = [];
		public var dialogueOffset:int = 20;	
		public var fadeAmount:int;		
		public var screenWipeGrid:Array;
		public var screenWipeTimer:int;
		public var screenWipeFrame:int;		
		public var priorityCount:int = 0;		
		public var healthOffset:int = 0;
		public var tileMaps:Array = [];
		public var foregroundTiles:Tilemap;
		public var fadeTimer:int;
		public var wallShade:int;
		
		private	var cols:Array =
		[
		0xAAff115f,
		0x99ff115f,
		0x88ff115f,
		0x77ff115f,
		0x66ff115f,
		0x55ff115f,
		0x44ff115f,
		0x33ff115f,
		0x22ff115f,
		0x11ff115f,
		0x22ff115f,
		0x33ff115f,
		0x44ff115f,
		0x55ff115f,
		0x66ff115f,
		0x77ff115f,
		0x88ff115f,
		0x99ff115f
		];
		public var bd:BitmapData = new BitmapData(16, 16, true, cols[8]);

		//----------------------------------------------------------------------------------------
		// counters
		
		private var i							:int;
		private var j							:int;
		private var k							:int;
		private var r							:int;
		private var c							:int;
		public var tileAnimationTimer			:int;
		public var showInventory				:Boolean;
		
		//----------------------------------------------------------------------------------------
		// game classes

		private var gameState					:int;
		public var mainCanvas					:Canvas	= new Canvas();		
		public var optionsCanvas				:Canvas	= new Canvas();		

		//----------------------------------------------------------------------------------------
		// scolling tilemap
		
		private var rect:Rectangle=new Rectangle(0,0,0,0);
		private var tilex:int;
		private var tiley:int;
		private var bufferBD:BitmapData;
		private var drawpoint:Point = new Point(0, 0);
		private var point:Point=new Point(0,0);
		private var bufferRect:Rectangle = new Rectangle(0, 0, Globals.SCREEN_WIDTH / Reg.player.SCREEN_SCALE, 
															   Globals.SCREEN_HEIGHT / Reg.player.SCREEN_SCALE);
		private var coldraw:int=0;
		private var rowdraw:int=0;
		private var curr_col:int=0;
		private var curr_row:int=0;		
		private var bufferPoint:Point;
		private var backgroundRect:Rectangle;
		private var backgroundBD:BitmapData = new BitmapData(680, 520, true, 0xffffff);	
		private var backgroundPoint:Point = new Point(0, 0);          
	
		public function Renderer()
		{
			screenWipeGrid = new Array(int(Globals.SCREEN_WIDTH / Globals.TILE_SIZE) + 1); 
			for(var arrCreationCount:int = 0; arrCreationCount < screenWipeGrid.length; arrCreationCount++) 
			{  screenWipeGrid[arrCreationCount] = new Array(int(Globals.SCREEN_HEIGHT / Globals.TILE_SIZE) + 1); }		
			rect.width = Globals.TILE_SIZE;
			rect.height = Globals.TILE_SIZE;
			bufferBD = new BitmapData(
										Globals.SCREEN_WIDTH + Globals.TILE_SIZE,
										Globals.SCREEN_HEIGHT + Globals.TILE_SIZE,
										true, 0x000000);
			addChild(mainCanvas.backBuffer);
			//addChild(mainCanvas.textBuffer);
			setupStars();
		}
		
		public function setupStars():void
		{	
			for (i = 0; i < 1000; i++)
			{
				starsX[i] = Math.random() * 825;
				starsY[i] = Math.random() * 490;
				starsV[i] = Math.random() * 9 + 2;
			}
		}
				
		public function updateStars():void
		{	
			for (i = 0; i < 1000; i++)
			{
				starsY[i] ++;
				if (starsY[i] > 490) 
				{
					starsX[i] = Math.random() * 7000;
					starsY[i] = -5;
					starsV[i] = Math.random() * 9 + 2;
				}
			}
		}		
		
		public function renderStars():void
		{	
			for (i = 0; i < 1000; i++)
			{
				var rn:int = Math.random() * 5;
				mainCanvas.blitAtPoint(Bmps.starBmpdataArray[rn], starsX[i] - Reg.player.mapstartX, starsY[i]);
			}
		}
		
		public function update():void
		{
			mainCanvas.backBufferData.lock();
			render();		
			updateStars();
			mainCanvas.backBufferData.unlock();
			fadeTimer++;
		}
		
		public function render():void 
		{
			// background tiles
			renderStars();
	
			for (i = 0; i < Reg.cloudPool.length; i++) {
				mainCanvas.blitAtPoint(Reg.cloudPool[i].bmd, Reg.cloudPool[i].x, Reg.cloudPool[i].y);
			}
			
			for (i = 0; i < Reg.smokePool.length; i++) {
				mainCanvas.blitAtPoint(Reg.smokePool[i].bmd, Reg.smokePool[i].x, Reg.smokePool[i].y);
			}
						
			for (i = 0; i < Reg.birdPool.length; i++) {
				blitAbsolute(Reg.birdPool[i]);
			}
			
			for (i = 0; i < Reg.parallaxLayer1Pool.length; i++) {
				mainCanvas.blitAtPoint(Reg.parallaxLayer1Pool[i].bmd, Reg.parallaxLayer1Pool[i].x, Reg.parallaxLayer1Pool[i].y);
				//trace("plotting parallax layer tile at " + Reg.parallaxLayer1Pool[i].x + ", " + Reg.parallaxLayer1Pool[i].y);
				//mainCanvas.blitAtPoint(Reg.parallaxLayer1Pool[i].bmd, 0, 0);
			}
			
			renderTiles(tileMaps[0], 0); // parallax			
			renderTiles(tileMaps[1], 1); // background
		
			// render flashing blocks
			//for (i = 0; i < Reg.flashingBlockPool.length; i++) { blit(Reg.flashingBlockPool[i]); }	
			
			renderTiles(tileMaps[2], 2); // foreground

			renderObjects();
			if (Reg.player.dying == false) renderHud();
			if (screenWipeTimer > 0)
			{
				if (screenWipeTimer > 90) screenWipeFrame = 0;
				else if (screenWipeTimer > 80) screenWipeFrame = 1;
				else if (screenWipeTimer > 70) screenWipeFrame = 2;
				else if (screenWipeTimer > 60) screenWipeFrame = 3;
				else if (screenWipeTimer > 50) screenWipeFrame = 4;
				else if (screenWipeTimer > 40) screenWipeFrame = 5;
				else if (screenWipeTimer > 30) screenWipeFrame = 6;
				else if (screenWipeTimer > 20) screenWipeFrame = 7;
				
				for (i = 0; i < Globals.SCREEN_WIDTH / Globals.TILE_SIZE; i++)
				{
					for (j = 0; j < Globals.SCREEN_HEIGHT / Globals.TILE_SIZE; j++)
					{
						mainCanvas.blitAtPoint(Bmps.wipe1BmpdataArray[screenWipeFrame], i * Globals.TILE_SIZE, j * Globals.TILE_SIZE);
					}
				}
			}
			//mainCanvas.blitAtPoint(Bmps.interlaceBmpdata, 0, 0);
			//mainCanvas.blitAtPoint(Bmps.cloud2Bmpdata, 200, 200);
		}
		
		//----------------------------------------------------------------------------
		// renderTiles
		
		private function renderTiles(theTileMap:Tilemap, depth:int):void
		{	
			//var scrollSpeed:Number;
			//if (depth == 0) scrollSpeed = 0.5;
			//else scrollSpeed = 1;
			
			bufferBD.copyPixels(backgroundBD, backgroundBD.rect, backgroundPoint, null, null, true);  
			//bufferBD.copyPixels(Bmps.gradientBackgroundBmpdata, Bmps.gradientBackgroundBmpdata.rect, backgroundPoint, null, null, true);  

			rect = new Rectangle(0, 0, theTileMap.tileSize, theTileMap.tileSize);
			point = new Point(0, 0);

			//if (depth > 0) 
			tilex = int(Reg.player.mapstartX / theTileMap.tileSize);
			//else tilex = int((Reg.player.mapstartX * 0.5) / theTileMap.tileSize);
			tiley = int(Reg.player.mapstartY / theTileMap.tileSize);
			//if (Reg.player.level == 1) tiley = 2;
			
			for (coldraw = 0; coldraw < (Globals.SCREEN_WIDTH / Globals.TILE_SIZE) + 1; coldraw++)
			{
				for (rowdraw = 0; rowdraw < 14; rowdraw++)
				{							
					drawpoint = new Point(coldraw * theTileMap.tileSize, rowdraw * theTileMap.tileSize);

					curr_col = coldraw + tilex;
					curr_row = rowdraw + tiley;

					if (curr_col > theTileMap.widthInTiles - 1) {curr_col = theTileMap.widthInTiles - 1; }
					//if (curr_row > theTileMap.heightInTiles - 1) {curr_row = theTileMap.heightInTiles - 1; }
					if (curr_row > 13) {curr_row = 13; }
										
					if (theTileMap.grid[curr_col][curr_row] > 0)
					{	
						if (depth == 0 && Reg.player.level < 3) bufferBD.copyPixels(Bmps.parallaxTilesBmpdataArray[theTileMap.grid[curr_col][curr_row]], rect, drawpoint);// , null, null, true);
						else if (depth == 0 && Reg.player.level >= 3) bufferBD.copyPixels(Bmps.parallaxTilesRedBmpdataArray[theTileMap.grid[curr_col][curr_row]], rect, drawpoint);// , null, null, true);
						if (depth == 1) bufferBD.copyPixels(Bmps.bgtlsBmpdataArray[theTileMap.grid[curr_col][curr_row]], rect, drawpoint);// , null, null, true);
						if (depth == 2) {
						//bufferBD.copyPixels(Bmps.tlsBmpdataArray[0], rect, drawpoint, null, null, true);
						//bufferBD.copyPixels(Bmps.bgtlsBmpdataArray[15], rect, drawpoint, null, null, true);
						if (Reg.player.level < 3) bufferBD.copyPixels(Bmps.tlsBmpdataArray[theTileMap.grid[curr_col][curr_row]], rect, drawpoint, null, null, true);
						else if (Reg.player.level >= 3) bufferBD.copyPixels(Bmps.tlsRedBmpdataArray[theTileMap.grid[curr_col][curr_row]], rect, drawpoint, null, null, true);
						}
					}
					else //if (depth == 2)
					{
						bufferBD.copyPixels(Bmps.bgtlsBmpdataArray[0], rect, drawpoint, null, null, false);
						//bufferBD.copyPixels(Bmps.intblockBmpdata, rect, drawpoint);// , null, null, true); 
						/*if (depth == 0) {
							for (var l:int = 0; l < 10; l++) {
								var pnt:Point = new Point(Math.random() * theTileMap.tileSize, Math.random() * theTileMap.tileSize);
								var rndRectHeight:int = Math.random() * 3 + 1;
								var rndRectWidth:int = Math.random() * 3 + 1;
								var rct:Rectangle = new Rectangle(0, 0, rndRectHeight, rndRectWidth);
								var rnFrame:int = Math.random() * 2;
								bufferBD.copyPixels(Bmps.partBmpdataArray[3], rect, new Point(drawpoint.x + pnt.x, drawpoint.y + pnt.y), null, null, false);
								bufferBD.copyPixels(Bmps.partBmpdataArray[3], rect, new Point(drawpoint.x + pnt.x, drawpoint.y + 2 + pnt.y), null, null, false);
							}
						}*/
					}
				}
			}
			
			rect = new Rectangle(Reg.player.mapstartX, 0, 825, 490);
			point = new Point(0, 0);	
			point = new Point(mainCanvas.shakeoffsetx, mainCanvas.shakeoffsety); 
			
			//if (depth > 0) 
			bufferRect.x = Reg.player.mapstartX % theTileMap.tileSize;
			//else bufferRect.x = (Reg.player.mapstartX) % (theTileMap.tileSize*0.2);
			
			bufferRect.y = Reg.player.mapstartY % theTileMap.tileSize;

			//if (depth == 0) point.x *= 0.8;
			mainCanvas.backBufferData.copyPixels(bufferBD, bufferRect, point);// , null, null, true);
			
			rect = new Rectangle(0, 0, 825, 490);
			
			//mainCanvas.backBufferData.copyPixels(Bmps.interlaceBmpdata, rect, point);// , null, null, true);

		}			

		//----------------------------------------------------------------------------
		// renderObjects

		private function renderObjects():void
		{	
			// exit
			mainCanvas.blitAtPoint
			(
				Bmps.exitanimBmpdataArray[Reg.exit.animFrame],
				Reg.exit.x-Reg.player.mapstartX-8,
				Reg.exit.y-Reg.player.mapstartY-16
			);
			
			// nanoShoes
			if (Reg.player.level > 1) {
				mainCanvas.blitAtPoint
				(
					//Bmps.keycardBmpdataArray[Reg.nanoShoes.animFrame],
					Bmps.nanoshoeBmpdataArray[Reg.nanoShoes.animFrame],
					Reg.nanoShoes.x-Reg.player.mapstartX,
					Reg.nanoShoes.y-Reg.player.mapstartY
				);
			}
			
			// coins
			for (i = 0; i < Reg.coinsPool.length; i++) { blit(Reg.coinsPool[i]); }	
		
			// heart pickups
			for (i = 0; i < Reg.heartPool.length; i++) { blit(Reg.heartPool[i]); }	
				
			// checkpoints
			for (i = 0; i < Reg.checkpointPool.length; i++) { blit(Reg.checkpointPool[i]); }	
		
			// infopoints
			for (i = 0; i < Reg.infopointPool.length; i++) { blit(Reg.infopointPool[i]); }	
			
			// infopoint text
			/*for (i = 0; i < Reg.infopointPool.length; i++) { 
				if (++infoPointTextTimer > 5) infoPointTextTimer = 0;
				if (infoPointTextTimer > 3) mainCanvas.renderTxt("White", "X", Reg.infopointPool[i].x-Reg.player.mapstartX, Reg.infopointPool[i].y - Reg.player.mapstartY - 15, 2);
			}*/	
			
			// lavablocks
			for (i = 0; i < Reg.lavablockPool.length; i++) { blit(Reg.lavablockPool[i]); }	
				
			// spawners
			for (i = 0; i < Reg.spawnerPool.length; i++) { blit(Reg.spawnerPool[i]); }	
			
			// slopes
			for (i = 0; i < Reg.slopePool.length; i++) { blit(Reg.slopePool[i]); }	
					
			/*
			// waypoints
			for (i = 0; i < Reg.pooledGameObjects[6].length; i++)
			{
				mainCanvas.blitAtPoint
				(
					Bmps.spritestripBmpdataArray[10],
					Reg.pooledGameObjects[6][i].x-Reg.player.mapstartX,
					Reg.pooledGameObjects[6][i].y-Reg.player.mapstartY
				);
			}
			*/
			// ENEMIES
			
			// ghosts
			for (i = 0; i < Reg.ghostPool.length; i++) { blit(Reg.ghostPool[i]); }	
			
			// soldiers
			for (i = 0; i < Reg.soldierPool.length; i++) { blit(Reg.soldierPool[i]); }	

			// saucers
			for (i = 0; i < Reg.saucerPool.length; i++) { blit(Reg.saucerPool[i]); }	
	
			// turrets
			for (i = 0; i < Reg.turretPool.length; i++) { blit(Reg.turretPool[i]); }	
			
			// spikes
			for (i = 0; i < Reg.spikesPool.length; i++) { blit(Reg.spikesPool[i]); }	

			// particles
			for (i = 0; i < Reg.particlesPool.length; i++) { 
				if (Reg.particlesPool[i].type == Globals.OBJTYPE_SCOREBREAKDOWN && Reg.paused) continue;
				if (Reg.particlesPool[i].type == Globals.OBJTYPE_SCOREBREAKDOWN) blitAbsolute(Reg.particlesPool[i]);
				else blit(Reg.particlesPool[i]);
			}
			
			// score sprites
			for (i = 0; i < Reg.scorePool.length; i++)
			{
				if (Reg.scorePool[i].onScreen && Reg.scorePool[i].size == 1)
				{
				  mainCanvas.renderTxt
				 (
				  "Fading", 
				  Reg.scorePool[i].scoreString,
				  //50,50,
				  Reg.scorePool[i].x - Reg.player.mapstartX + 80,
				  Reg.scorePool[i].y - Reg.player.mapstartY,
				  1, 
				  Reg.scorePool[i].fadeAmount
				 );
				}				
			}
			
			// Trails
			if (Reg.player.running) {
				for (i = 0; i < 4; i++) {
					mainCanvas.blitAtPoint
					(
						Reg.player.trailBmd,
						Reg.player.trailArrayX[i]-Reg.player.mapstartX,
						Reg.player.trailArrayY[i]-Reg.player.mapstartY+yadd
					);
				}
			}
			
			// Player
			var yadd:int = 0;
			if (Reg.player.onRoof) yadd = 4;
			//if (Reg.player.flashing && Reg.player.flashTimer % 4 == 1){}
			//else 
			if (Reg.player.dying == false && Reg.player.exiting == false)
			{
				mainCanvas.blitAtPoint
				(
					Reg.player.bmd,
					Reg.player.x-Reg.player.mapstartX,
					Reg.player.y-Reg.player.mapstartY+yadd
				);
			}
			

			
			// Projectiles
			
			// Player grenades
			for (i = 0; i < Reg.playerGrenadePool.length; i++) { blit(Reg.playerGrenadePool[i]); }
		
			// Player bullets
			for (i = 0; i < Reg.playerBulletsPool.length; i++) { blit(Reg.playerBulletsPool[i]); }
		
			// Ememy bullets
			for (i = 0; i < Reg.enemyBulletPool.length; i++) { blit(Reg.enemyBulletPool[i]); }	

			// Turret bullets
			for (i = 0; i < Reg.turretBulletPool.length; i++) { blit(Reg.turretBulletPool[i]); }	
		
			// Soldier bullets
			for (i = 0; i < Reg.soldierBulletPool.length; i++) { blit(Reg.soldierBulletPool[i]); }	
			
			// explosions
			for (i = 0; i < Reg.explosionPool.length; i++) { blit(Reg.explosionPool[i]); }	

		}
		
		//----------------------------------------------------------------------------
		// blitAbsolute

		private function blitAbsolute(obj:GameObject):void
		{		
			mainCanvas.blitAtPoint
			(obj.bmd, obj.x, obj.y); return;
		}		
		
		//----------------------------------------------------------------------------
		// blit

		private function blit(obj:GameObject):void
		{		
			if (obj.flashing && obj.flashTimer % 4 == 1) return;
			if (obj.onScreen == false) return;
			mainCanvas.blitAtPoint
			(obj.bmd, obj.x - Reg.player.mapstartX, obj.y - Reg.player.mapstartY); return;
		}
		
		//----------------------------------------------------------------------------
		// renderHud

		private function renderHud():void
		{	
			//return;
			var hudOffsetX:int = 30;
			var hudOffsetY:int = 10;
			mainCanvas.renderTxt("White", "HEALTH", 42, 23, 1);
			mainCanvas.blitStatic(Bmps.heartBmpdata, hudOffsetX - 29, 0);
			mainCanvas.blitStatic(Bmps.healthBarBmpdata, hudOffsetX - 3, hudOffsetY - 2);
			var offset:int = 0;
			//if(Reg.player.health>-1){mainCanvas.blitStatic(Bmps.healthfirstBmpdata, 35, 11);}
			if(Reg.player.health>0){mainCanvas.blitStatic(Bmps.healthfirstBmpdata, hudOffsetX, hudOffsetY);}
			if(Reg.player.health>1){mainCanvas.blitStatic(Bmps.healthfirstBmpdata, hudOffsetX+20, hudOffsetY);}
			if(Reg.player.health>2){mainCanvas.blitStatic(Bmps.healthfirstBmpdata, hudOffsetX+40, hudOffsetY);}
			if(Reg.player.health>3){mainCanvas.blitStatic(Bmps.healthfirstBmpdata, hudOffsetX+60, hudOffsetY);}
			if (Reg.player.health > 4) { mainCanvas.blitStatic(Bmps.healthfirstBmpdata, hudOffsetX + 80, hudOffsetY); }
		}

		//----------------------------------------------------------------------------
		// renderText
			
		public function renderText(col:String,value:String,x:int,y:int):void
		{				
			mainCanvas.renderTxt(col,value,x,y,1);				
		}
			
		//----------------------------------------------------------------------------
		// renderDialogue
			
		public function resetDialogue():void
		{	
			mainCanvas.dialogueLines   = 
			mainCanvas.dialogueLine    = 
			mainCanvas.dialogueIndex0  = 
			mainCanvas.dialogueIndex1  = 
			mainCanvas.dialogueIndex2  = 
			mainCanvas.dialogueIndex3  = 
			mainCanvas.dialogueTimer   = 
			mainCanvas.dialogueOffset0 = 0;
			mainCanvas.dialogueOffset1 = 0;
			mainCanvas.dialogueOffset2 = 0;
			mainCanvas.dialogueOffset3 = 0;
		}	
			
		//----------------------------------------------------------------------------
		// renderDIalogue
			
		public function renderDialogue():void
		{				
			mainCanvas.dialogueTimer += 3;
			if (mainCanvas.dialogueTimer > 1) 
			{
				if (mainCanvas.dialogueLine <4) sfx.play(SoundEffectsManager.sndType);
				mainCanvas.dialogueTimer = 0;
				
				if (mainCanvas.dialogueLine == 0)
				{
					if (mainCanvas.dialogueIndex0 < mainCanvas.dialogueText0.length) 
					{
						mainCanvas.dialogueIndex0++;
					}
					if (mainCanvas.dialogueIndex0 == mainCanvas.dialogueText0.length) 
					{
						if (mainCanvas.dialogueLine < 3) mainCanvas.dialogueLine++;
					}
				}					
				if (mainCanvas.dialogueLine == 1)
				{
					if (mainCanvas.dialogueIndex1 < mainCanvas.dialogueText1.length) 
					{
						mainCanvas.dialogueIndex1++;
					}
					if (mainCanvas.dialogueIndex1 == mainCanvas.dialogueText1.length) 
					{
						if (mainCanvas.dialogueLine < 3) mainCanvas.dialogueLine++;
					}
				}					
				if (mainCanvas.dialogueLine == 2)
				{
					if (mainCanvas.dialogueIndex2 < mainCanvas.dialogueText2.length) 
					{
						mainCanvas.dialogueIndex2++;
					}
					if (mainCanvas.dialogueIndex2 == mainCanvas.dialogueText2.length) 
					{
						if (mainCanvas.dialogueLine < 3) mainCanvas.dialogueLine++;
					}
				}					
				if (mainCanvas.dialogueLine == 3)
				{
					if (mainCanvas.dialogueIndex3 < mainCanvas.dialogueText3.length) 
					{
						mainCanvas.dialogueIndex3++;
					}
					if (mainCanvas.dialogueIndex3 == mainCanvas.dialogueText3.length) 
					{
						if (mainCanvas.dialogueLine < 4) mainCanvas.dialogueLine++;
					}
				}
			}
			
			var dialogueYOffset:int = 351;
			
			if (mainCanvas.dialogueLine >= 0) 
			{
				if (mainCanvas.dialogueLine == 0)
				{
				 mainCanvas.renderDialogueTxt("Red",mainCanvas.dialogueText0, dialogueOffset, dialogueYOffset);
				}
				if (mainCanvas.dialogueLine > 0)
				{
				 mainCanvas.renderTxt("Info", mainCanvas.dialogueText0, dialogueOffset, dialogueYOffset, 1);
				}
			}
			if (mainCanvas.dialogueLine >= 1) 
			{
				if (mainCanvas.dialogueLine == 1)
				{
				 mainCanvas.renderDialogueTxt("Red", mainCanvas.dialogueText1, dialogueOffset, dialogueYOffset + 30);
				}
				if (mainCanvas.dialogueLine > 1)
				{
				 mainCanvas.renderTxt("Info", mainCanvas.dialogueText1, dialogueOffset, dialogueYOffset+30, 1);
				}
			}
			if (mainCanvas.dialogueLine >= 2) 
			{
				if (mainCanvas.dialogueLine == 2)
				{
				 mainCanvas.renderDialogueTxt("Red", mainCanvas.dialogueText2, dialogueOffset, dialogueYOffset + 60);
				}
				if (mainCanvas.dialogueLine > 2)
				{
				 mainCanvas.renderTxt("Info", mainCanvas.dialogueText2, dialogueOffset, dialogueYOffset+60, 1);
				}				
			}
			if (mainCanvas.dialogueLine >= 3)
			{
				if (mainCanvas.dialogueLine == 3)
				{
				 mainCanvas.renderDialogueTxt("Red", mainCanvas.dialogueText3, dialogueOffset, dialogueYOffset + 90);
				}
				if (mainCanvas.dialogueLine > 3)
				{
				 mainCanvas.renderTxt("Info", mainCanvas.dialogueText3, dialogueOffset, dialogueYOffset + 90, 1);
				 //trace("Printing dialogue text");
				}				
			}
		}		
	}
}