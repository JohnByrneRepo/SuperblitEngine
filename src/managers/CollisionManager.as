package managers 
{
	import flash.display.BitmapData;
	import gameobjects.*;
	import kernel.*;
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class CollisionManager
	{
		public var cooloff:int;
		public var currentParticle:int;
		public var maxX:int;
		public var maxY:int;
		
		public var tiles:Tilemap;
		public var heightForHorizontalTest:int = 0;
		
		// Misc
		private var i:int;
		private var j:int;
		private var k:int;
		private var r:int;
		private var c:int;
		
		// For object to object collisions
		private var o1x1:int;
		private var o1x2:int;
		private var o1y1:int;
		private var o1y2:int;
		private var o2x1:int;
		private var o2x2:int;
		private var o2y1:int;
		private var o2y2:int;
				
		// For object to tilemap collisions
		private var x1:int;
		private var x2:int;
		private var x3:int;
		private var y1:int;
		private var y2:int;
		private var y3:int;
		private var y4:int;
	
		private var lBound:int;
		private var rBound:int;
		private var uBound:int;
		private var dBound:int;
	
		public function CollisionManager() 
		{
		}		
		
		public function traceObj(obj:GameObject):void
		{
			var bd:BitmapData = new BitmapData(100, 25, false, 0x000000);
			Reg.renderer.mainCanvas.blitAtPoint(bd, 120, 35);
			Reg.renderer.mainCanvas.renderTxt("White", "TILEMAP COLLISION DEBUG", 5, 25, 1);
			Reg.renderer.mainCanvas.renderTxt("White", "COLLDING MAP WITH", 5, 35, 1);
			var st:String = String(obj.type);
			if (obj.type == Globals.OBJTYPE_PLAYERBULLET) st = "PLAYER BULLET";
			if (obj.type == Globals.OBJTYPE_SOLDIER) st = "SOLDIER";
			if (obj.type == Globals.OBJTYPE_ENEMYBULLET) st = "ENEMY BULLET";
			if (obj.type == Globals.OBJTYPE_PARTICLE) st = "PARTICLE";
			if (obj.type == Globals.OBJTYPE_GHOST) st = "GHOST";
			Reg.renderer.mainCanvas.renderTxt("White", st, 120, 35, 1);
			Reg.renderer.mainCanvas.renderTxt("White", "OBJECT X and Y ", 5, 45, 1);
			Reg.renderer.mainCanvas.renderTxt("White", String(int(obj.x)) + " " + String(int(obj.y)), 120, 45, 1);
		}
		
		public function tilemapCollisions(obj:GameObject):void
		{		
			if (obj.onScreen == false) return;

			x1 = obj.ctrX / tiles.tileSize;
			y1 = (obj.y + obj.downBound + 4) / tiles.tileSize;
			if (x1 < 0) { x1 = 0; }
			if (x2 > tiles.widthInTiles - 1) { x2 = tiles.widthInTiles - 1; }
	
			/*if (tiles.tmpGrid[x1][y1] == Globals.TILETYPE_SOLID) {
				obj.onSlope = false;
			}
			if (obj.type == Globals.OBJTYPE_PLAYER && obj.onSlope) return;
			*/
			if (obj.type == Globals.OBJTYPE_PARTICLEBEAM) return;
			
			//-------------------------------------------------------------------------------
			// HORIZONTAL
			
			if (obj.downBound - obj.upBound < tiles.tileSize) heightForHorizontalTest = 0;
			else heightForHorizontalTest = obj.downBound - obj.upBound;
			var heightToTest:int = 0;
			var testing:Boolean = true;

			x1 = (obj.x + obj.leftBound + obj.dirX - 1) / tiles.tileSize;
			x2 = (obj.x + obj.rightBound + obj.dirX + 1) / tiles.tileSize;

			if (x1 < 0) { x1 = 0; }
			if (x2 > tiles.widthInTiles - 1) { x2 = tiles.widthInTiles - 1; }
				
			obj.onLeftWall = false;
			obj.onRightWall = false;

			if (
				//obj.onSlope == false
				//&&
				(obj.type == Globals.OBJTYPE_PLAYER 
				||
				obj.type == Globals.OBJTYPE_GHOST
				||
				obj.type == Globals.OBJTYPE_PARTICLE
				||
				obj.type == Globals.OBJTYPE_PLAYERGRENADE
				||
				obj.type == Globals.OBJTYPE_SOLDIER)
			   )
			{
				while(testing)
				{
					y1 = (obj.y + obj.upBound) / tiles.tileSize;
					//y2 = (obj.y + obj.downBound + heightToTest - 1) / tiles.tileSize;
					y2 = (obj.y + obj.downBound - 1) / tiles.tileSize;
					y3 = y2;
					if (Reg.player.suitActivated && obj.type == Globals.OBJTYPE_PLAYER) {
						y3 = (obj.y + tiles.tileSize + 2) / tiles.tileSize;
					}
					
					if (y1 < 0) y1 = 0;
					if (y2 > tiles.heightInTiles - 2) y2 = tiles.heightInTiles - 2;
		
					if (obj.dirX > 0)
					{
						if ((tiles.tmpGrid[x2][y1] == Globals.TILETYPE_SOLID) 
						||  (tiles.tmpGrid[x2][y2] == Globals.TILETYPE_SOLID)
						||  (tiles.tmpGrid[x2][y3] == Globals.TILETYPE_SOLID))
						{
							if (obj.type == Globals.OBJTYPE_PLAYER)
							{
								// Trying to move right 							
								// Place the player as close to the solid tile as possible 
								obj.x = x2 * tiles.tileSize;								
								obj.x -= obj.rightBound;
								obj.dirX = 0;
								obj.onRightWall = true;
								obj.onRoof = false;
								//obj.jumping = false; 
							}
							else if (obj.type == Globals.OBJTYPE_GHOST || obj.type == Globals.OBJTYPE_SOLDIER)
							{
								obj.direction = Globals.FACING_LEFT;
							}
							else if (obj.type == Globals.OBJTYPE_PARTICLE || obj.type == Globals.OBJTYPE_PLAYERGRENADE)
							{
								obj.dirX *= -1;
								if (Math.abs(obj.dirX) > 2) Reg.sfx.play(SoundEffectsManager.sndParticleCollision);
							}
							if (obj.cooloff == 0 && obj.type == Globals.OBJTYPE_PLAYERGRENADE)
							{
								obj.cooloff = 20;
								Reg.sfx.play(SoundEffectsManager.sndGrenadebounce);
							}
						}
					}				
					else if (obj.dirX < 0)
					{
						if ((tiles.tmpGrid[x1][y1] == Globals.TILETYPE_SOLID) 
						||  (tiles.tmpGrid[x1][y2] == Globals.TILETYPE_SOLID)
						||  (tiles.tmpGrid[x1][y3] == Globals.TILETYPE_SOLID))
						{
							if (obj.type == Globals.OBJTYPE_PLAYER)
							{
								// Trying to move left 					
								// Place the player as close to the solid tile as possible 
								obj.x = x1 * tiles.tileSize;
								obj.x += tiles.tileSize - obj.leftBound;
								obj.dirX = 0;
								obj.onLeftWall = true;
								obj.onRoof = false;
								//obj.jumping = false; 
							}
							else if (obj.type == Globals.OBJTYPE_GHOST || obj.type == Globals.OBJTYPE_SOLDIER)
							{
								obj.direction = Globals.FACING_RIGHT;
							}	
							else if (obj.type == Globals.OBJTYPE_PARTICLE || obj.type == Globals.OBJTYPE_PLAYERGRENADE)
							{
								obj.dirX *= -1;
								if (Math.abs(obj.dirX) > 2) Reg.sfx.play(SoundEffectsManager.sndParticleCollision);
							}						
							if (obj.cooloff == 0 && obj.type == Globals.OBJTYPE_PLAYERGRENADE)
							{
								obj.cooloff = 20;
								Reg.sfx.play(SoundEffectsManager.sndGrenadebounce);
							}
						}
					}        
					if (heightToTest >= heightForHorizontalTest-1)   
					{
						break;
					}
					   
					heightToTest += tiles.tileSize;
					   
					if (heightToTest > heightForHorizontalTest-1)
					{
						heightToTest = heightForHorizontalTest-1;
					}
				}
			}	
			else if (
					obj.type == Globals.OBJTYPE_PLAYERBULLET
					|| obj.type==Globals.OBJTYPE_ENEMYBULLET
					|| obj.type==Globals.OBJTYPE_TURRETBULLET
					|| obj.type == Globals.OBJTYPE_SOLDIERBULLET
					)
				{ 
				y1 = (obj.y) / tiles.tileSize;
				if (y1 < 0) y1 = 0;
				
				if (obj.dirX > 0) // bullet trying to move right
				{
					if(tiles.tmpGrid[x2][y1] == Globals.TILETYPE_SOLID)
					{
						//return;
						if (obj.type == Globals.OBJTYPE_PLAYERBULLET) Reg.sfx.play(SoundEffectsManager.sndPistolWall);
						obj.x = x2 * tiles.tileSize;
						obj.x -= tiles.tileSize - obj.leftBound;
						obj.dirX = obj.dirY = 0;
						obj.onScreen = false;
					}
				}				
				else if (obj.dirX < 0) // bullet trying to move left
				{
					if(tiles.tmpGrid[x1][y1] == Globals.TILETYPE_SOLID)
					{
						//return;
						if (obj.type == Globals.OBJTYPE_PLAYERBULLET) Reg.sfx.play(SoundEffectsManager.sndPistolWall);
						obj.x = x1 * tiles.tileSize;
						obj.x += tiles.tileSize - obj.leftBound;
						obj.dirX = obj.dirY = 0;
						obj.onScreen = false;
						//obj.spawnParticles();
					}
				}
			}

			//-------------------------------------------------------------------------------
			// VERTICAL			

			x1 = (obj.x+obj.leftBound+2) / tiles.tileSize;
			x2 = (obj.x+obj.rightBound-2) / tiles.tileSize;	

			if (x1 < 0) x1 = 0;
			if (x2 < 0) x2 = 0;
			if (x2 > tiles.widthInTiles - 1) x2 = tiles.widthInTiles - 1;
		
			if (obj.onRoof)  y1 = (obj.y - 2) / tiles.tileSize;
			if (!obj.onRoof) y1 = (obj.y + obj.upBound + obj.dirY - 1) / tiles.tileSize;
			
			y2 = (obj.y + obj.downBound + obj.dirY + 2) / tiles.tileSize;	

			if (y1 < 0) y1 = 0;
			if (y2 < 0) y2 = 0;
			if (y2 > tiles.heightInTiles - 2) y2 = tiles.heightInTiles - 2;
		
			var blockd:Boolean = false;					

			if (cooloff > 0) cooloff--;

			/*trace("Testing collision vertical for object: " + obj.type);
			trace("x1 = " + x1);
			trace("x2 = " + x2);
			trace("y2 = " + y2);*/		
			
			if (obj.dirY > 0)
			{
				// Trying to move down 						
				if 
				(
				(tiles.tmpGrid[x1][y2] == Globals.TILETYPE_SOLID) || (tiles.tmpGrid[x2][y2] == Globals.TILETYPE_SOLID)
				||
				(tiles.tmpGrid[x1][y2] == Globals.TILETYPE_JUMPTHROUGH) || (tiles.tmpGrid[x2][y2] == Globals.TILETYPE_JUMPTHROUGH)
				)
				{

					if 
					(
					obj.type == Globals.OBJTYPE_PLAYER 
					|| 
					obj.type == Globals.OBJTYPE_GHOST
					||
					obj.type == Globals.OBJTYPE_PARTICLE
					||
					obj.type == Globals.OBJTYPE_SOLDIER
					)
					{
						//if (obj.type == Globals.OBJTYPE_PLAYER && obj.onSlope) return;
						// Place the player as close to the solid tile as possible
						if (obj.dirY > 1.4 && obj.type == Globals.OBJTYPE_PLAYER && obj.jumping)
						{
							if (!Reg.player.suitActivated ) Reg.sfx.play(SoundEffectsManager.sndLand);
							else Reg.sfx.play(SoundEffectsManager.sndLandSuit);
							obj.numParticles = obj.dirY * 4;
						}
						obj.y = y2 * tiles.tileSize;
						obj.y -= obj.downBound;
						obj.dirY = 0;
						obj.onGround = 1;
						obj.onRoof = false;
						obj.jumping = false; 
					}				
					if (obj.type == Globals.OBJTYPE_PARTICLE || obj.type == Globals.OBJTYPE_PLAYERGRENADE)
					{
						obj.y += 2;
						obj.bounce();
						if (Math.abs(obj.dirY) > 2) Reg.sfx.play(SoundEffectsManager.sndParticleCollision);
					}
					if (obj.cooloff == 0 && obj.type == Globals.OBJTYPE_PLAYERGRENADE)
					{
						obj.cooloff = 20;
						Reg.sfx.play(SoundEffectsManager.sndGrenadebounce);
					}
					if (obj.type == Globals.OBJTYPE_PLAYERBULLET
					|| obj.type==Globals.OBJTYPE_ENEMYBULLET
					|| obj.type==Globals.OBJTYPE_TURRETBULLET
					|| obj.type==Globals.OBJTYPE_SOLDIERBULLET)
					{ 
						//return;
						if (obj.type==Globals.OBJTYPE_PLAYERBULLET) Reg.sfx.play(SoundEffectsManager.sndPistolWall);
						obj.y = y2 * tiles.tileSize;
						obj.y += obj.downBound;
						if (obj.type == Globals.OBJTYPE_ENEMYBULLET) // saucer
						{
							obj.direction = Globals.FACING_DOWN;
						}
						obj.dirX = obj.dirY = 0;
						obj.onScreen = false;
					}
				}
			}				
			else if (obj.dirY <= 0)
			{
				// Trying to move up 				
				if((tiles.tmpGrid[x1][y1] == Globals.TILETYPE_SOLID) || (tiles.tmpGrid[x2][y1] == Globals.TILETYPE_SOLID))
				{
					if (obj.type == Globals.OBJTYPE_PLAYER && !obj.onRoof)
					{ 
						if (obj.dirY < 0.4) {
							if (!Reg.player.suitActivated ) Reg.sfx.play(SoundEffectsManager.sndLand);
							else Reg.sfx.play(SoundEffectsManager.sndLandSuit);
						}
						// Place the player as close to the solid tile as possible 				
						obj.y = y1 * tiles.tileSize;
						obj.y += tiles.tileSize - 8;	
						obj.dirY = 0;
						obj.onRoof = true;		
					}
					if (obj.type == Globals.OBJTYPE_PARTICLE || obj.type == Globals.OBJTYPE_PLAYERGRENADE)
					{
						obj.y += 3;
						obj.dirY = 0;
						//obj.bounce();
						if (Math.abs(obj.dirY) > 2) Reg.sfx.play(SoundEffectsManager.sndParticleCollision);
					}
					if(obj.type == Globals.OBJTYPE_PLAYERBULLET
					|| obj.type==Globals.OBJTYPE_ENEMYBULLET
					|| obj.type==Globals.OBJTYPE_TURRETBULLET
					|| obj.type == Globals.OBJTYPE_SOLDIERBULLET)
					{ 
						//return;
						obj.y = y1 * tiles.tileSize;
						obj.y += tiles.tileSize-4;	
						obj.onRoof = true;
						if (obj.type==Globals.OBJTYPE_PLAYERBULLET) Reg.sfx.play(SoundEffectsManager.sndPistolWall);
						if (obj.type == Globals.OBJTYPE_ENEMYBULLET) // saucer
						{
							obj.direction = Globals.FACING_DOWN;
						}
						obj.dirX = obj.dirY = 0;
						obj.onScreen = false;
						//obj.spawnParticles();
					}
					if (obj.type==Globals.OBJTYPE_PLAYERGRENADE)
					{ 
						obj.y = y1 * tiles.tileSize;
						obj.y += tiles.tileSize-4;	
						obj.dirY = 4;
					}
				}
				else if(obj.onRoof)
				{ 
					if (obj.type == Globals.OBJTYPE_PLAYER) { obj.upBound = 7;  obj.onRoof = false; obj.dirY = 3; }
				}
				if (obj.cooloff == 0 && obj.type == Globals.OBJTYPE_PLAYERGRENADE)
				{
					obj.cooloff = 20;
					Reg.sfx.play(SoundEffectsManager.sndGrenadebounce);
				}				
			}
		}
	}
}