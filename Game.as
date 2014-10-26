package  
{	
	/**
	 * @author Barnaby Byrne
	 */
	
	// GAME
	// Declares and initialises all game objects and managers
	// Updates the objects, updates the renderer, and updates the collision manager
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.external.*;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.geom.*;
	import flash.filters.*;
	
	import gameobjects.*;
	import kernel.*;
	import managers.*;	

	// thanks to 
	// parallelrealities for collision tutorial
	// and 
	// 8bitrocket for n-way smooth scrolling tutorial
	 
	public class Game extends MovieClip
	{

		public var infoNo:int;
		public var lookDownAmount:int;
		public var wallSlideCooloff:int;
		public var fadeOutTimer:int = 40;
		public var fadeOutMax:int = 100;
		public var fadingOut:Boolean;
		public var leavingLevel:Boolean;
		public var playerDeath:Boolean;
		public var dialogueTimer:int;
		public var dialogueIndex:int;
		public var dialogueActive:Boolean;
		public var str:String="";
		
		//----------------------------------------------------------------------------------------
		// Waypoint actions

		public const MIRRORX:int=0;
		public const MIRRORY:int=1;
		public const CW:int=2;
		public const ACW:int=3;

		public var lvlStartTimer:int=100;
		public var deathTimer:int;
		
		public var restartX:int;
		public var restartY:int;
		
		//----------------------------------------------------------------------------------------

		private var tileMap:Tilemap;
		private var bgtileMap:Tilemap;
		private var spritetileMap:Tilemap;
		private var tileMaps:Array = [];
		public var jumpPressed:Boolean;
		public var coinsToCollect:int;
		public var currentParticle:int;
		
		//----------------------------------------------------------------------------------------
		// FPS
		
		private var fps:Number;
		private var last:uint = getTimer();
		private var ticks:uint = 0;	
		
		//----------------------------------------------------------------------------------------
		// State
		
		private var gameState					:int = 0;
		
		//----------------------------------------------------------------------------------------
		// Keys
	
		private var keypressedTime				:int=0;
		public var aKeyPress					:Array = [];
		
		//----------------------------------------------------------------------------------------
		// main objects		

		private var bmps						:Bmps					= new Bmps();
		private var maps						:Maps					= new Maps();
		private var reg							:Reg					= new Reg();
		private var sfx							:SoundEffectsManager	= new SoundEffectsManager();
		private var collisions					:CollisionManager		= new CollisionManager();

		//----------------------------------------------------------------------------------------
		// Difficulty level
	
		private var difficulty					:int;				
		
		//----------------------------------------------------------------------------------------
		// Attack waves / sectors

		private var level						:int=1;		
		private var sector						:int=1;	
		
		//----------------------------------------------------------------------------------------
		// Attack waves
	
		private var numberUntilClear			:int=0;
		private var scrolling					:Boolean;
		private var distanceScrolled			:int;
		private var spawnTimeCount				:int;

		//----------------------------------------------------------------------------------------
		// Pause / quit

		private var paused						:Boolean; 
		private var quitprompt					:Boolean; 
		private var pausedCooloff				:int=0; 
		
		//----------------------------------------------------------------------------------------
		// Misc

		private var i							:int;
		private var j							:int;
		private var k							:int;
		private var r							:int;
		private var c							:int;
			
		//----------------------------------------------------------------------------------------
		// Velocity caching

		private var rotnCacheX					:Vector.<Number>=new Vector.<Number>();
		private var rotnCacheY					:Vector.<Number>=new Vector.<Number>();	
		
		/*
		var dialogue1:Array = [];
		*/		
		
		//----------------------------------------------------------------------------------------
		// CONSTRUCTOR
		
		public function Game() 
		{			
			Mouse.hide();
			addChild(renderer);
			
			bgtileMap=new Tilemap();
			tileMap = new Tilemap();
			spritetileMap=new Tilemap();

			renderer.foregroundTiles = tileMap;
			renderer.tileMaps = tileMaps;	

			bgtileMap.depth = 0;
			tileMap.depth = 1;
			
			tileMaps.push(bgtileMap);					
			tileMaps.push(tileMap);					

			reloadLevel();
			
			collisions.tiles = tileMap;
			collisions.sfx = sfx;			
	
			Reg.player.tiles = tileMap;

			//addEventListener(MouseEvent.MOUSE_DOWN, mouseIsDown);
			//addEventListener(MouseEvent.MOUSE_UP, mouseIsReleased);
			//addEventListener(Event.DEACTIVATE, onFocusLost);
			//addEventListener(Event.ACTIVATE, onFocus);		
			addEventListener(Event.ENTER_FRAME, Mainloop);	
		}
		
		//--------------------------------------------------------------------
		// loadLevel
	
		public function reloadLevel():void
		{	
			leavingLevel = false;
			lvlStartTimer = 100;
			renderer.screenWipeTimer = 140;
			clearSprites();
			//bgtileMap.loadMap(maps.mapsArray1[level-1]);
			tileMap.autoTileGrid(maps.mapsArray2[Reg.player.level-1]);
			spritetileMap.loadSprites(maps.mapsArray3[Reg.player.level-1]);
			Reg.player.x = restartX = spritetileMap.startX;
			Reg.player.y = restartY = spritetileMap.startY;			
			Reg.player.exiting = false;			
			collisions.maxX = Reg.player.maxX = tileMap.maxX;
			collisions.maxY = Reg.player.maxY = tileMap.maxY;			
			collisions.tiles = tileMap;
			renderer.update();
			fadingOut = false;
			infoNo = 0;
			sfx.play(SoundEffectsManager.sndLevelStart);
		}
			
		//--------------------------------------------------------------------
		// clearSprites
	
		public function clearSprites():void
		{	
			for (i = 0; i < Reg.pooledGameObjects.length; i++)
			{
				for (j = 0; j < Reg.pooledGameObjects[i].length; j++)
				{
					Reg.pooledGameObjects[i][j].x = -2000;
					Reg.pooledGameObjects[i][j].onScreen=false;
				}
			}
		}
		
		//--------------------------------------------------------------------
		// Mainloop
	
		public function Mainloop(e:Event):void
		{
			renderer.mainCanvas.clear();
			
			// FPS counter
			printTxt("White", String(int(fps)), 3, 15);
			
			ctrTxt("Red", String(Reg.player.score), 3);			
			renderer.update();
			//printDialogue("Red", "PRESS DOWN TO VIEW THE ENVIRONMENT BELOW YOU.", 8, 157);
			if (lvlStartTimer > 0)
			{
				lvlStartTimer--;
				renderer.screenWipeTimer--;
				if (lvlStartTimer > 20) ctrTxt("Red", "LEVEL " + String(Reg.player.level), 110);
				if (lvlStartTimer > 20) ctrTxt("Red", str, 140);
			}	
			if (renderer.screenWipeTimer > 0) renderer.screenWipeTimer--;
			if (keypressedTime > 0) keypressedTime--;
			if (aKeyPress[Globals.PAUSE] && keypressedTime == 0) { paused = !paused; keypressedTime = 20; }
			if(!paused)// && lvlStartTimer>0)
			{
				keyboardMove();
				update();
			}
			else
			{
				ctrTxtBig("Red", "PAUSED", 110);
			}
		}
					
		//--------------------------------------------------------------------
		// ctrTxt
		
		public function ctrTxt(c:String,value:String,y:int):void
		{	
			renderer.mainCanvas.renderTxt(c,value, -2000, y, 1);
			renderer.mainCanvas.renderTxt(c,value, 160-((renderer.mainCanvas.offset+14)/2), y, 1);
		}
		
		//--------------------------------------------------------------------
		// printTxt
		
		public function printTxt(c:String,value:String,x:int,y:int):void
		{	
			renderer.mainCanvas.renderTxt(c,value, x, y, 1);
		}			
		
		//--------------------------------------------------------------------
		// ctrTxtBig
		
		public function ctrTxtBig(c:String,value:String,y:int):void
		{	
			renderer.mainCanvas.renderTxt(c,value, -2000, y, 2);
			renderer.mainCanvas.renderTxt(c,value, 160-((renderer.mainCanvas.offset+14)), y, 2);
		}	
			
		//--------------------------------------------------------------------
		// printTxtBig
		
		public function printTxtBig(c:String,value:String,x:int,y:int):void
		{	
			renderer.mainCanvas.renderTxt(c,value, x, y, 2);
		}	
		
		//--------------------------------------------------------------------
		// printDialogue
		
		public function printDialogue(c:String,value:String,x:int,y:int):void
		{	
			dialogueTimer++;
			if (dialogueTimer == 4)
			{
				dialogueTimer = 0;
				dialogueIndex++;
				if (dialogueIndex > value.length) 
				{
					dialogueIndex = value.length;
				}
				else
				{
					for (i = 0; i < dialogueIndex-1; i++)
					{
						str = str+value.charAt(i);
					}
				}
				renderer.mainCanvas.renderTxt(c,str, x, y, 4);
			}
		}		
		
		//--------------------------------------------------------------------
		// tick
		
		public function tick():void 
		{
			ticks++; var now:uint = getTimer(); var delta:uint = now - last;
			if (delta >= 1000) { fps = ticks / delta * 1000; ticks = 0; last = now; }
		}
		
		//--------------------------------------------------------------------
		// update
		
		public function update():void
		{	
			doCollisions();
			if (sfx.cooloff > 0) sfx.cooloff--;
			tick();
			Reg.player.update();
			Reg.player.onScreen = true;
			screenShake();
			if (Reg.player.spawnParticles)
			{
				spawnParticles(Reg.player.numParticles, Reg.player.ctrX, Reg.player.ctrY, "Yellow", 2, 3);
				Reg.player.spawnParticles = false;
			}
			if (Reg.player.onLeftWall || Reg.player.onRightWall)
			{
				if (wallSlideCooloff == 0) 
				{
					sfx.play(SoundEffectsManager.sndWallslide);
					wallSlideCooloff = 10;
					spawnParticles(3, Reg.player.ctrX, Reg.player.y + Reg.player.downBound -2, "Yellow", 2, 1);
				}
				else wallSlideCooloff--;
			}
			
			if (fadingOut)
			{
				if (fadeOutTimer < fadeOutMax) fadeOutTimer++;
				var matrix:Array = new Array();
				matrix=matrix.concat([1,0,0,0,0]);// red
				matrix=matrix.concat([0,1,0,0,0]);// green
				matrix=matrix.concat([0,0,1,0,0]);// blue
				matrix=matrix.concat([0,0,0,0.8*((fadeOutMax-fadeOutTimer)/fadeOutMax),0]);// alpha						
				var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
				renderer.mainCanvas.backBufferData.applyFilter
				(renderer.mainCanvas.backBufferData, renderer.mainCanvas.backBufferData.rect, new Point(), my_filter);
				if (fadeOutTimer == fadeOutMax)
				{
					if (playerDeath)
					{		
						Reg.player.dying = false;
						Reg.player.x = restartX;
						Reg.player.y = restartY;
						fadingOut = false;
						lvlStartTimer = 100;
						renderer.screenWipeTimer = 100;
						playerDeath = false;
					}	
					if (leavingLevel) 
					{
						ctrTxt("Red", "LEVEL COMPLETE", 100);
						ctrTxt("Red", "PRESS A TO CONTINUE", 120);
					}
				}
			}
			
			// Update pooled game objects
			for (i = 0; i < Reg.pooledGameObjects.length; i++)
			{
				for (j = 0; j < Reg.pooledGameObjects[i].length; j++)
				{
					if (Reg.pooledGameObjects[i][j].onScreen)
					{				
						Reg.pooledGameObjects[i][j].update();
					}
				}
			}
			for (i = 0; i < Reg.playerGrenadePool.length; i++)
			{
				//overlapRange(Reg.playerGrenadePool[i], Reg.ghostPool,60,5);
			
				var g:Grenade = Reg.playerGrenadePool[i];
				
				if (g.spawnParticles)
				{
					for(k = 0; k < Reg.ghostPool.length; k++)
					{
						var g1:Ghost = Reg.ghostPool[k];
						var g2:Grenade = g;
						if
						((
						(g1.x > g2.x-40 && g1.x < g2.x + g2.rightBound+40)
						||
						(g1.x+g1.rightBound > g2.x-40 && g1.x+g1.rightBound < g2.x + g2.rightBound+40)
						)						
						&&
						(
						(g1.y > g2.y-40 && g1.y < g2.y + g2.downBound+40)
						||
						(g1.y+g1.downBound > g2.y-40 && g1.y+g1.downBound < g2.y + g2.downBound+40)
						))
						{
							killObject(g1);
						}
					}
					spawnParticles(20, g.ctrX, g.ctrY, "Yellow", 8, 6);
					g.spawnParticles = false;
					g.onScreen = false;
					g.x = -2000;
					renderer.mainCanvas.screenShake = true;
					renderer.mainCanvas.screenShakeTimer = 40;
				}				
			}		
			for (i = 0; i < Reg.playerBulletsPool.length; i++)
			{
				var b:Bullet = Reg.playerBulletsPool[i];
				
				if (b.spawnParticles)
				{
					var xp:int;
					if (b.dirX < 0) xp = 4;
					else xp = -4;
					spawnParticles(15, b.ctrX+xp, b.ctrY, "Yellow", 4, 6);
					b.spawnParticles = false;
					b.onScreen = false;
					b.x = -2000;
				}				
			}

		}	
		
		//--------------------------------------------------------------------
		// screenShake
		
		private function screenShake():void 
		{	
			if(renderer.mainCanvas.screenShake)
			{
				renderer.mainCanvas.screenShakeTimer--;
				if (renderer.mainCanvas.screenShakeTimer == 0)
				{
					renderer.mainCanvas.shakeoffsetx = 0;
					renderer.mainCanvas.shakeoffsety = 0;
					renderer.mainCanvas.screenShake = false;
				}				
				else if (renderer.mainCanvas.screenShakeTimer % 5 == 0)
				{
					renderer.mainCanvas.shakeoffsetx = Math.random()*4-2;
					renderer.mainCanvas.shakeoffsety = Math.random()*4-2;
				}
				else
				{
					
				}
			}
		}
		
		//--------------------------------------------------------------------
		// collisions
		
		private function doCollisions():void 
		{	
			// FALL OFF SCREEN
			if (Reg.player.y > tileMap.maxY-16)
			{
				Reg.player.y = tileMap.maxY-16;
				killPlayer();
			}
			// TILE COLLISIONS
			Reg.player.onGround = 0;
			collisions.tilemapCollisions(Reg.player);	
			collide(Reg.ghostPool);
			collide(Reg.particlesPool);
			collide(Reg.playerBulletsPool);
			collide(Reg.playerGrenadePool);

			// SPRITE COLLISIONS
			for (i = 0; i < Reg.playerBulletsPool.length; i++)
			{
				overlapRange(Reg.playerBulletsPool[i], Reg.ghostPool,25,5);
			}	
			
			overlaps(Reg.waypointPool, Reg.ghostPool);
			overlaps(Reg.playerGrenadePool, Reg.ghostPool);
			
			if (!playerDeath)
			{
				dialogueActive = false;
				
				overlap(Reg.player, Reg.infopointPool);
				overlap(Reg.player, Reg.checkpointPool);
				overlap(Reg.player, Reg.ghostPool);
				overlap(Reg.player, Reg.coinsPool);
				overlap(Reg.player, Reg.waypointPool);
				
				if (dialogueActive == false)
				{
					dialogueIndex = 0;
				}
				var exitHolder:Array = [Reg.exit];
				overlap(Reg.player, exitHolder);
			}
		}
			
		//--------------------------------------------------------------------
		// collide
	
		private function collide(objs:Array):void 
		{		
			for (i = 0; i < objs.length; i++)
			{
				objs[i].onGround = 0;
				collisions.tilemapCollisions(objs[i]);
			}				
		}	
			
		//--------------------------------------------------------------------
		// overlap
	
		private function overlapRange(obj1:GameObject,obj2:Array,xRange:int,yRange:int):void 
		{		
		// SPRITE COLLISIONS
			if (obj1.onScreen == false) return;
			for (i = 0; i < obj2.length; i++)
			{
				if
				(
				obj2[i].onScreen
				&&
				(
				(obj1.x+obj1.leftBound > obj2[i].x+obj2[i].leftBound-xRange && obj1.x+obj1.leftBound < xRange+obj2[i].x+obj2[i].rightBound)
				||		
				(obj1.x+obj1.rightBound > obj2[i].x+obj2[i].leftBound-xRange && obj1.x+obj1.rightBound < xRange+obj2[i].x+obj2[i].rightBound)
				)
				&&
				(
				(obj1.y+obj1.upBound > obj2[i].y+obj2[i].upBound-yRange && obj1.y+obj1.upBound < yRange+obj2[i].y+obj2[i].downBound)
				||		
				(obj1.y+obj1.downBound > obj2[i].y+obj2[i].upBound-yRange && obj1.y+obj1.downBound < yRange+obj2[i].y+obj2[i].downBound)
				)
				)
				{
					if (obj1.type == Globals.OBJTYPE_PLAYERBULLET)
					{
						killObject(obj2[i]);
						obj1.onScreen = false;
						obj1.x = -2000;
						obj1.dirX = 0;
					}					
					if (obj1.type == Globals.OBJTYPE_PLAYERGRENADE)
					{
						killObject(obj2[i]);
						//obj1.onScreen = false;
						//obj1.x = -2000;
					}
					
				}	
			}	
		}		
		
		//--------------------------------------------------------------------
		// overlap
	
		private function overlap(obj1:GameObject,obj2:Array):void 
		{		
			if (obj1.onScreen == false) return;

			// SPRITE COLLISIONS
			for (i = 0; i < obj2.length; i++)
			{
				if
				(
				obj2[i].onScreen == true
				&&
				(
				(obj1.x+obj1.leftBound > obj2[i].x+obj2[i].leftBound-5 && obj1.x+obj1.leftBound < 5+obj2[i].x+obj2[i].rightBound)
				||		
				(obj1.x+obj1.rightBound > obj2[i].x+obj2[i].leftBound-5 && obj1.x+obj1.rightBound < 5+obj2[i].x+obj2[i].rightBound)
				)
				&&
				(
				(obj1.y+obj1.upBound > obj2[i].y+obj2[i].upBound-5 && obj1.y+obj1.upBound < 5+obj2[i].y+obj2[i].downBound)
				||		
				(obj1.y+obj1.downBound > obj2[i].y+obj2[i].upBound-5 && obj1.y+obj1.downBound < 5+obj2[i].y+obj2[i].downBound)
				)
				)
				{
					if (obj1.type == Globals.OBJTYPE_PLAYER)
					{
						if (obj2[i].type == Globals.OBJTYPE_COIN)
						{
							var xp:int=obj2[i].x + (obj1.width / 2);
							var yp:int=obj2[i].y + (obj1.height / 2);						
							obj2[i].x = -1000;
							obj2[i].onScreen = false;
							//coinsToCollect--;
							Reg.player.score += 50;
							sfx.play(SoundEffectsManager.sndCoin);						
							spawnParticles(4, xp, yp, "Yellow", 2, 3);
						}					
						if (obj2[i].type == Globals.OBJTYPE_GHOST && !fadingOut)
						{
							killPlayer();
						}					
						if (obj2[i].type == Globals.OBJTYPE_CHECKPOINT)
						{
							restartX = obj2[i].x+3;
							restartY = obj2[i].y;
							if (obj2[i].visited == false) sfx.play(SoundEffectsManager.sndCheckpoint);
							obj2[i].visited = true;
						}				
						if (obj2[i].type == Globals.OBJTYPE_EXIT && !leavingLevel)
						{
							sfx.play(SoundEffectsManager.sndExit);
							Reg.player.dirX = 0;
							Reg.player.dirY = 0;
							Reg.player.exiting = true;
							Reg.player.level++;
							if (Reg.player.level == 3) Reg.player.level = 1;
							fadeOutTimer = 0;
							fadingOut = true;
							leavingLevel = true;
							return;
						}			
						if (obj2[i].type == Globals.OBJTYPE_WAYPOINT)
						{
							//printTxt("Red", "waypoint", 10, 80);							
						}							
						if (obj2[i].type == Globals.OBJTYPE_INFOPOINT)
						{
							renderer.mainCanvas.blitAtPoint(Bmps.dialogueOverlayBmpdata, 5, 155);
							Reg.player.onInfoPoint = true;
							//printTxt("Red", "info id " + obj2[i].nodeID, 30, 30);
							if (Reg.player.level == 1)
							{
								var yoffset:int = 161;
								var xoffset:int = 11;
								if (obj2[i].nodeID == 0)
								{
									printTxt("Red", "PRESS KEYBOARD ARROWS TO MOVE LEFT AND RIGHT", xoffset, yoffset);
									printTxt("Red", "PRESS A TO JUMP AND HOLD DOWN TO STICK TO ROOF", xoffset, yoffset+20);
									printTxt("Red", "HOLD S TO SHOOT AND HOLD UP ARROW TO SHOOT UP", xoffset, yoffset+40);
									printTxt("Red", "HOLD G TO THROW GRENADE AND KEEP PRESSED FOR RANGE", xoffset, yoffset+60);
								}
								if (obj2[i].nodeID == 1)
								{
									printTxt("Red", "HOLD DOWN TO VIEW THE ENVIRONMENT AHEAD", xoffset, yoffset);
								}	
								if (obj2[i].nodeID == 2)
								{
									printTxt("Red", "HOLD LEFT OR RIGHT AGAINST A WALL TO SLIDE", xoffset, yoffset);
								}	
								if (obj2[i].nodeID == 3)
								{
									printTxt("Red", "COLLECT COINS FOR BONUS POINTS", xoffset, yoffset);
								}
								if (obj2[i].nodeID == 4)
								{
									printTxt("Red", "SAVE YOUR PROGRESS BY TOUCHING A CHECKPOINT", xoffset, yoffset);
								}	
							}
						}	
					}				
				}	
			}	
		}

		//--------------------------------------------------------------------
		// overlaps
	
		private function overlaps(obj1:Array,obj2:Array):void 
		{		
			// SPRITE COLLISIONS
			for (i = 0; i < obj2.length; i++)
			{
				for (j = 0; j < obj1.length; j++)
				{
					if
					(
					obj1[j].onScreen == true
					&&
					obj2[i].onScreen == true
					&&
					(
					(obj1[j].x+obj1[j].leftBound > obj2[i].x+obj2[i].leftBound-5 && obj1[j].x+obj1[j].leftBound < 5+obj2[i].x+obj2[i].rightBound)
					||		
					(obj1[j].x+obj1[j].rightBound > obj2[i].x+obj2[i].leftBound-5 && obj1[j].x+obj1[j].rightBound < 5+obj2[i].x+obj2[i].rightBound)
					)
					&&
					(
					(obj1[j].y+obj1[j].upBound > obj2[i].y+obj2[i].upBound-5 && obj1[j].y+obj1[j].upBound < 5+obj2[i].y+obj2[i].downBound)
					||		
					(obj1[j].y+obj1[j].downBound > obj2[i].y+obj2[i].upBound-5 && obj1[j].y+obj1[j].downBound < 5+obj2[i].y+obj2[i].downBound)
					)
					)
					{
						if (obj1[j].type == Globals.OBJTYPE_WAYPOINT && obj2[i].type == Globals.OBJTYPE_GHOST)
						{
							if (obj1[j].cooloff == 0)
							{
								if (obj1[j].action == MIRRORX) {obj2[i].direction = 1 - obj2[i].direction; }
								obj1[j].cooloff = 15;
							}
						}						
						if (obj1[j].type == Globals.OBJTYPE_PLAYERGRENADE && obj2[i].type == Globals.OBJTYPE_GHOST)
						{
							for(k = 0; k < Reg.ghostPool.length; k++)
							{
								var g1:Ghost = Reg.ghostPool[k];
								var g2:Grenade = obj1[j];
								if
								((
								(g1.x > g2.x-40 && g1.x < g2.x + g2.rightBound+40)
								||
								(g1.x+g1.rightBound > g2.x-40 && g1.x+g1.rightBound < g2.x + g2.rightBound+40)
								)						
								&&
								(
								(g1.y > g2.y-40 && g1.y < g2.y + g2.downBound+40)
								||
								(g1.y+g1.downBound > g2.y-40 && g1.y+g1.downBound < g2.y + g2.downBound+40)
								))
								{
									killObject(g1);
								}
							}
							obj1[j].explode();
							renderer.mainCanvas.screenShake = true;
							renderer.mainCanvas.screenShakeTimer = 40;
						}					
					}	
				}	
			}
		}

		//--------------------------------------------------------------------
		// killPlayer
	
		private function killPlayer():void 
		{	
			if (Reg.player.dying) return;
			sfx.play(SoundEffectsManager.sndDeath);
			fadeOutTimer = 0;
			fadingOut = true;
			playerDeath = true;
			Reg.player.dirX = 0;
			Reg.player.dirY = 0;
			Reg.player.dying = true;
			var xp:int = Reg.player.ctrX;
			var yp:int = Reg.player.ctrY;
			spawnParticles(100, xp+4, yp, "Yellow", 7, 10);			
		}

		//--------------------------------------------------------------------
		// killObject
	
		private function killObject(obj:GameObject):void 
		{	
			var xp:int=obj.x + (obj.width / 2);
			var yp:int=obj.y + (obj.height / 2);
			obj.x = -1000;
			obj.onScreen = false;
			Reg.player.score += 100;
			sfx.play(SoundEffectsManager.sndExplode);
			spawnParticles(12, xp, yp, "Red", 6, 8);			
		}

		//--------------------------------------------------------------------
		// spawnParticles
	
		private function spawnParticles(parts:int,xpos:int,ypos:int,colr:String, xv:int, yv:int):void 
		{
			// SpawnParticles
			for (i = 0; i < parts; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES-1) currentParticle = 0;
				Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].x = xpos;
				Reg.particlesPool[currentParticle].y = ypos;
				Reg.particlesPool[currentParticle].dirX = Math.random() * xv - (xv/2);
				Reg.particlesPool[currentParticle].bounceCount = 1;
				Reg.particlesPool[currentParticle].bounceForce = Math.random()*yv;
				Reg.particlesPool[currentParticle].maxX = tileMap.maxX;
				Reg.particlesPool[currentParticle].maxY = tileMap.maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 45;
				Reg.particlesPool[currentParticle].onScreen = true;
				Reg.particlesPool[currentParticle].bounce();
			}			
		}

		//--------------------------------------------------------------------
		// keyboardMove
	
		private function keyboardMove():void 
		{		
			if (fadingOut || leavingLevel || lvlStartTimer>10) 
			{
				if (aKeyPress[Globals.KEYJUMP])// && !Reg.player.jumping)
				{	
					if (leavingLevel)
					{
						reloadLevel();	
						return;
					}
				}
				//Reg.player.dirX = 0;
				//Reg.player.dirY = 0;
				return;
			}
			if (Reg.player.wallBouncingTimer == 0 && !Reg.player.onRoof)
			{
				if(aKeyPress[Globals.KEYLEFT]) // left
				{
					Reg.player.walk(Globals.KEYLEFT);				
				}			
				else if (aKeyPress[Globals.KEYRIGHT])
				{
					Reg.player.walk(Globals.KEYRIGHT);				
				}	
				else
				{
					if (Reg.player.dirX > 0) Reg.player.dirX -= 0.15;
					if (Reg.player.dirX < 0) Reg.player.dirX += 0.15;
					if (Reg.player.dirX > -0.2 && Reg.player.dirX < 0.2) Reg.player.dirX = 0;			
				}
			}
			if (Reg.player.onRoof) { Reg.player.dirX = 0; }
			
			if (aKeyPress[Globals.KEYGUN] && Reg.player.timeSinceShot==0)
			{			
				Reg.player.shoot();	
				sfx.play(SoundEffectsManager.sndLaser);
			}		

			if (aKeyPress[Globals.KEYGRENADE] && Reg.player.timeSinceShot==0 && !Reg.player.onRoof)
			{			
				if (Reg.player.grenadeTime < 4) Reg.player.grenadeTime += 0.08;
				Reg.player.readyGrenade();
				Reg.player.grenadePressed = true;
			}
			if (!aKeyPress[Globals.KEYGRENADE])
			{
				if (Reg.player.grenadePressed)
				{
					Reg.player.grenadePressed = false;
					Reg.player.readyGrenade();
					Reg.player.shootGrenade();	
					Reg.player.grenadeTime = 0;
					sfx.play(SoundEffectsManager.sndGrenadetoss);
				}
			}
			if (!aKeyPress[Globals.KEYJUMP])
			{
				Reg.player.pressingJump = false;	
				Reg.player.onRoof = false;		
			}			
			if (aKeyPress[Globals.KEYJUMP])// && !Reg.player.jumping)
			{	
				if(lvlStartTimer<10)Reg.player.jump();
				/*
				if 
				(
				Reg.player.pressingJump 
				&& 
				(Reg.player.onLeftWall || Reg.player.onRightWall)
				&&
				(Reg.player.dirX>1 || Reg.player.dirX<1)
				)
					spawnParticles(10, Reg.player.ctrX, Reg.player.ctrY, "Yellow", 8, 16);
					*/
			}			

			if (!aKeyPress[Globals.KEYUP])
			{			
				Reg.player.holdingUp = false;
			}
			if (aKeyPress[Globals.KEYUP])
			{			
				Reg.player.holdingUp = true;				
			}
			
			if (aKeyPress[Globals.KEYDOWN])
			{			
				if (Reg.player.lookDownAmount < 50)
				{
					Reg.player.lookDownAmount += 4;
				}
				Reg.player.crouching = true;
			}	
			else
			{
				if (Reg.player.lookDownAmount > 0) Reg.player.lookDownAmount--;	
				Reg.player.crouching = false;
			}

			if (aKeyPress[Globals.KEY1])
			{
				renderer.mainCanvas.changeScreenScale(1);				
			}			
			if (aKeyPress[Globals.KEY2])
			{
				renderer.mainCanvas.changeScreenScale(2);					
			}			
			if (aKeyPress[Globals.KEY3])
			{
				renderer.mainCanvas.changeScreenScale(3);						
			}			
			if (aKeyPress[Globals.KEY4])
			{
				renderer.mainCanvas.changeScreenScale(4);					
			}
			if (aKeyPress[Globals.KEYINVENTORY] && keypressedTime == 0)
			{
				renderer.showInventory = !renderer.showInventory;
				keypressedTime=20;
			}
		}			
	}
}