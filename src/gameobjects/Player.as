package gameobjects
{
	
	import flash.display.BitmapData;	
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import kernel.*;
	import managers.*;

	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	 public class Player extends GameObject
	{	
		public var trailArrayX:Array;
		public var trailArrayY:Array;
		public var currentTrailIndex:int;
		public var trailBmd:BitmapData;
		public var leftOnce:Boolean;
		public var leftTwice:Boolean;
		public var rightOnce:Boolean;
		public var rightTwice:Boolean;
		public var onInfoPoint:Boolean;
		public var keyCollected:Boolean;
		public var holdingUp:Boolean;
		public var crouching:Boolean;
		public var tiles:Tilemap = new Tilemap();
		public var SCREEN_SCALE:int = 1;
		public var level:int;
		public var currentBullet:int=0; 
		public var currentGrenade:int=0; 
		public var score:int=0; 
		public var shootSpeed:int = 12;
		public var reloadDelay:int = 4;
		public var dead:Boolean;   
		public var shooting:Boolean;  
		public var bullets:Array = [];
		public var rotnX:Vector.<Number>;
		public var rotnY:Vector.<Number>;
		public var numberOfShots:int = 0;
		private var lastY:int = 0;
		private var lastX:int = 0;
		public var mapstartX:Number = 0;
		public var mapstartY:Number = 0;
		private	var inAir:Boolean;
		private	var jumpblocked:Boolean;
		private	var xV:Number = 0;
		private	var yV:Number = gravity;
		private	var maxVelocity:Number = 10;
		private	var playerAcceleration:Number = 0.3;
		public var holdUpTimer:int = 0;
		public var walking:Boolean;
		public var shotAnimLifetime:int = 0;	
		public var jumpFrame:int	
		public var SCROLL_SPEED:int = 4;
		public var PLAYER_SPEED:int = 7;
		public var JUMP_SPEED:Number = 20.0;
		public var GRAVITY_SPEED:Number = 1.3;
		public var MAX_FALL_SPEED:int = 44;
		public var MAX_PLAYER_SPEED:int = 32;
		public var lookDownAmount:int;
		public var running:Boolean;
		public var shoesCollected:Boolean;
		public var suitActivated:Boolean;
		public var suitShotAngle:int;
		public var suitShotTimer:int;
		public var walkSpeed:int;
		public var shimmering:Boolean;
		public var shimmeringTimer:int;
		
		public function Player():void
		{
			//currentGrenade = 1;
			grenadeTime = 0;
			x 					= 2000;
			y 					= 150;
			width				= 50;
			height				= 50;
			leftBound			= 7;
			rightBound			= 40;
			upBound				= 18;
			downBound			= 48;	
			type				= Globals.OBJTYPE_PLAYER;
			direction 			= Globals.FACING_RIGHT;
			health = 5;
			bmd = new BitmapData(width, height, true, 0x00000000);
			trailBmd = new BitmapData(width, height, true, 0x00000000);
			walkSpeed = 5;
			trailArrayX = [];
			trailArrayY = [];
			mapstartY = 15;
		}	
		
		override public function update():void
		{
			if (suitActivated) {
				width 				= 100;
				height 				= 100;
				leftBound 			= 40;
				rightBound 			= 60;
				upBound 			= 17;
				downBound 			= 88;
				walkSpeed 			= 6;
				reloadDelay			= 1;
			} else {
				width				= 50;
				height				= 50;
				leftBound			= 7;
				rightBound			= 40;
				upBound				= 18;
				downBound			= 48;
				walkSpeed			= 8;
				reloadDelay			= 6;
			}
			
			//if (running) {
				if (++currentTrailIndex > 4) currentTrailIndex = 0;
				trailArrayX[currentTrailIndex] = x;
				trailArrayY[currentTrailIndex] = y;
			//}
			
			super.update();
			
			if (shotAnimLifetime > 0) shotAnimLifetime--;		

			if (dirY != 0) onRoof = false;
	
			if (!shimmering) dirY += GRAVITY_SPEED;
						
			if(timeSinceShot>0)
			{
				timeSinceShot--;
			}
			
			if (wallBouncingTimer > 0) wallBouncingTimer--;

			centerPlayerOnMap();
	
			walkTime++;
			
			if (suitActivated) {
				if (walkTime > 3) walkTime = 0;
			} else {
				if (walkTime > 1) walkTime = 0;
			}
			
			if (suitActivated) {
				animFrame = walkFrame;
			} else if (jumping && shotAnimLifetime > 0) {
				animFrame = 2;
			} else if (shotAnimLifetime == 0 && !flashing) {
				//upBound = 7;
				animFrame = walkFrame;
			}
			
			if (!suitActivated && dirX == 0 && shotAnimLifetime == 0 && !flashing) animFrame = 0;
		
			//if (running) {

			/*} else {
				GRAVITY_SPEED = 1.68;
				JUMP_SPEED = 14.0;
			}*/
			
			if (cooloff > 0) cooloff--;
			
			if (jumping && !suitActivated) {
				timeSinceJumped++;
				if (timeSinceJumped < 5) animFrame = 14;
				else if (timeSinceJumped >= 5 && timeSinceJumped <= 15) animFrame = 15;
				else if (timeSinceJumped >= 15 && timeSinceJumped <= 25) animFrame = 16;
				else if (timeSinceJumped > 25) animFrame = 14;
			}
			
			/*else {
				if (direction == Globals.FACING_LEFT) bmd = Bmps.playerNanoShoesBmpdataArrayL[animFrame];
				if (direction == Globals.FACING_RIGHT) bmd = Bmps.playerNanoShoesBmpdataArray[animFrame];				
			}*/
			
			trailBmd = new BitmapData(width, height, true, 0x00000000);
			createFlash();

			x += dirX;
			
			if (dirY > 0) {
				if (!onGround && !onSlope) y += dirY;
			} else {
				if (!suitActivated ) {
					y += dirY;
				} else {
					y += dirY/2;
				}
			}
			
			if (!suitActivated) {
				if (dirY >= MAX_FALL_SPEED) dirY = MAX_FALL_SPEED;
			} else {
				if (dirY >= MAX_FALL_SPEED/4) dirY = MAX_FALL_SPEED/4;
			}
			
			if (x > tiles.maxX - 20) x = tiles.maxX - 20;
			if (x < -10) x = -10;
			
			if (flashing && !suitActivated) animFrame += Bmps.playerBmpdata.width / Bmps.playerBmpdata.height;
			else if (flashing && suitActivated) animFrame += 13; // Bmps.sniperJoeBmpdata.width / Bmps.sniperJoeBmpdata.height;
			
			while (animFrame > 55) animFrame -= 56;
			
			if (suitActivated) {
				if (direction == Globals.FACING_LEFT) bmd = Bmps.sniperJoeBmpdataArrayL[animFrame];
				if (direction == Globals.FACING_RIGHT) bmd = Bmps.sniperJoeBmpdataArray[animFrame];
			} else if (!shoesCollected) {
				if (direction == Globals.FACING_LEFT) bmd = Bmps.playerBmpdataArrayL[animFrame];
				if (direction == Globals.FACING_RIGHT) bmd = Bmps.playerBmpdataArray[animFrame];
			}
			//if (flashing && animFrame < 28) animFrame += 28;
		}
		
		public function createFlash():void {
			var matrix:Array = new Array();
			matrix=matrix.concat([1,0,0,0,128 + Math.random()*128]);// red
			matrix=matrix.concat([0,1,0,0,128 + Math.random()*128]);// green
			matrix=matrix.concat([0,0,1,0,128 + Math.random()*128]);// blue
			matrix=matrix.concat([0,0,0,0.4,0]);// alpha			
			var my_filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			trailBmd.applyFilter
				(
					bmd, 
					bmd.rect, 
					new Point(), 
					my_filter
				);
		}
			
		public function centerPlayerOnMap():void
		{	
			mapstartX = int((x + width / 2) - ((Globals.SCREEN_WIDTH / SCREEN_SCALE) / 2));		
			var halfScreen:int = 32 + ((Globals.SCREEN_HEIGHT / SCREEN_SCALE) / 2);		
			mapstartY = ((y + ((downBound - upBound) / 2)) - halfScreen) + 32 + lookDownAmount;
			if (mapstartX < 0) { mapstartX = 0; }			
			if (mapstartY < 0) { mapstartY = 0; }					
			if (mapstartX + Globals.SCREEN_WIDTH / SCREEN_SCALE >= tiles.maxX)
			{ mapstartX = tiles.maxX - Globals.SCREEN_WIDTH / SCREEN_SCALE ; }
			if (mapstartY + Globals.SCREEN_HEIGHT / SCREEN_SCALE >= tiles.maxY)
			{ mapstartY = tiles.maxY - Globals.SCREEN_HEIGHT / SCREEN_SCALE ; }	
			mapstartY = 15;
		}	

		public function jump():void
		{	
			//trace("trying to jump");
			//if (!jumping && !pressingJump) //&& !jumpedOnce) // jump
			//{
			var jumpTimeMax:int;
			
			if (suitActivated) jumpTimeMax = 25;
			else {
				if (!running) jumpTimeMax = 10;
				else jumpTimeMax = 18;
			}
			if (jumping) {
				jumpTime++;
				if (jumpTime < jumpTimeMax) {
				//trace("jumping");
				//if (onGround == 1)
				//{
					//if (onLeftWall || onRightWall) return;
					if (jumpTime == 1) {
						if (!suitActivated) sfx.play(SoundEffectsManager.sndJump);
						else sfx.play(SoundEffectsManager.sndJumpSuit);
					}
					jumpedOnce = true;
					if (!suitActivated && dirY > -JUMP_SPEED) dirY -= 2;
					else if (dirY > -JUMP_SPEED * 2) dirY -= 2;
					onGround = 0;
					jumping = true;
					timeSinceJumped = 0;
					pressingJump = true;
				}
			}
				//}
				/*if (onRoof == true)
				{
					sfx.play(SoundEffectsManager.sndWallslide);
					dirY = 0;
					//dirX = 0;
				}
				var x1:int = (ctrX - tiles.tileSize) / tiles.tileSize;
				var x2:int = (ctrX + tiles.tileSize) / tiles.tileSize;
				var y1:int = (ctrY - tiles.tileSize) / tiles.tileSize;
				var tileUpLeft:int = tiles.tmpGrid[x1][y1];
				var tileUpRight:int = tiles.tmpGrid[x2][y1];*/
			//}

			/*if (!pressingJump && jumpedOnce && !jumpedTwice)// && dirY < 0) // doublejump
			{
				jumpedTwice = true;
			}*/				
		}
		
		public function walk(key:int):void
		{	
			walking = true;
			if (key == Globals.KEYLEFT) // left
			{
				if (dirX > 0) dirX = 0;
				if (dirX > -walkSpeed) dirX -= 1.4;
				else dirX = -walkSpeed;
				if (running) dirX *= 1.8;
				if (walkTime == 0 && !jumping) walkFrame++; 
				direction = Globals.FACING_LEFT;
			}			
			else if (key==Globals.KEYRIGHT)
			{
				if (dirX < 0) dirX = 0;
				if (dirX < walkSpeed) dirX += 1.4;
				else dirX = walkSpeed;
				if (running) dirX *= 1.8;
				if (walkTime == 0 && !jumping) walkFrame++; 	
				direction = Globals.FACING_RIGHT;
			}
			var animAddon:int = 0;
			
			if (suitActivated) {
				if (walkFrame > 4) walkFrame = 1;
			} else {
				if (walkFrame > 12) walkFrame = 2;
			}
			
			/*else if (walkFrame < 0)
			{
				walkFrame = 8;
			}*/
		}
		
		public function shoot():void
		{
			if (suitActivated) shootSpeed = 8;
			else shootSpeed = 12;
			if (dying) return;
			if (onLeftWall || onRightWall) return;
			Reg.playerBulletsPool[currentBullet].onScreen = true;
			// Shooting delay time
			timeSinceShot = reloadDelay;	
			Reg.playerBulletsPool[currentBullet].direction = 0;
			if (!suitActivated) animFrame = 13;
			if (direction == Globals.FACING_LEFT)
			{
				//trace("Firing left");
				shotAnimLifetime = 5;
				Reg.playerBulletsPool[currentBullet].direction = Globals.FACING_LEFT;
				Reg.playerBulletsPool[currentBullet].x = x - 1;
				Reg.playerBulletsPool[currentBullet].dirX = -shootSpeed;				
				Reg.playerBulletsPool[currentBullet].dirY = 0;	
				Reg.playerBulletsPool[currentBullet].animFrame = 0;	
				Reg.playerBulletsPool[currentBullet].lifeTime = 0;	
				if(!crouching) Reg.playerBulletsPool[currentBullet].y = y + 19;
				if (crouching) Reg.playerBulletsPool[currentBullet].y = y + 31;
				if (suitActivated) {
					var rnd:int = Math.random() * 20 - 10;
					Reg.playerBulletsPool[currentBullet].y = y + 39; // + rnd;
					Reg.playerBulletsPool[currentBullet].x = x + 15; // + rnd;
					//Reg.playerBulletsPool[currentBullet].dirX += rnd;
					Reg.playerBulletsPool[currentBullet].dirY += rnd/5;
				}
				//if (onLeftWall || onRightWall) Reg.playerBulletsPool[currentBullet].dirX *= -1;
			}				
			else if (direction == Globals.FACING_RIGHT)
			{
				//trace("Firing right");
				shotAnimLifetime = 5;
				Reg.playerBulletsPool[currentBullet].direction = Globals.FACING_RIGHT;
				Reg.playerBulletsPool[currentBullet].x = x + 28;
				Reg.playerBulletsPool[currentBullet].dirX = shootSpeed;				
				Reg.playerBulletsPool[currentBullet].dirY = 0;	
				Reg.playerBulletsPool[currentBullet].animFrame = 0;	
				Reg.playerBulletsPool[currentBullet].lifeTime = 0;	
				if(!crouching) Reg.playerBulletsPool[currentBullet].y = y + 19;
				if (crouching) Reg.playerBulletsPool[currentBullet].y = y + 31;
				if (suitActivated) {
					rnd = Math.random() * 20 - 10;
					Reg.playerBulletsPool[currentBullet].y = y + 39; // + rnd;
					Reg.playerBulletsPool[currentBullet].x = x + 50; // + rnd;
					//Reg.playerBulletsPool[currentBullet].dirX += rnd;
					Reg.playerBulletsPool[currentBullet].dirY += rnd/5;
				}
				//if (onLeftWall || onRightWall) Reg.playerBulletsPool[currentBullet].dirX *= -1;
			}			
			Reg.playerBulletsPool[currentBullet].maxX = maxX;
			Reg.playerBulletsPool[currentBullet].maxY = maxY;
			currentBullet++;
			if (currentBullet > Globals.MAX_PLAYER_BULLETS - 1) currentBullet = 0;			
		}		
		
		public function cancelGrenade():void
		{
			Reg.playerGrenadePool[currentGrenade].onScreen = false;
			Reg.playerGrenadePool[currentGrenade].x = -2000;
			Reg.playerGrenadePool[currentGrenade].dirX = 0;				
			Reg.playerGrenadePool[currentGrenade].dirY = 0;				
			grenadeTime = 0;
			grenadePressed = false;
		}
		
		public function readyGrenade():void
		{
			if (direction == Globals.FACING_LEFT)
			{
				Reg.playerGrenadePool[currentGrenade].x = x + 11;
				Reg.playerGrenadePool[currentGrenade].dirX = 0;				
				Reg.playerGrenadePool[currentGrenade].dirY = 0;				
			}				
			else if (direction == Globals.FACING_RIGHT)
			{
				Reg.playerGrenadePool[currentGrenade].x = x + 1;
				Reg.playerGrenadePool[currentGrenade].dirX = 0;				
				Reg.playerGrenadePool[currentGrenade].dirY = 0;				
			}	
			Reg.playerGrenadePool[currentGrenade].y = y + 3;
			Reg.playerGrenadePool[currentGrenade].onScreen = true;
			Reg.playerGrenadePool[currentGrenade].animFrame = 0;
			Reg.playerGrenadePool[currentGrenade].bounceCount = 0;
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			if (direction == Globals.FACING_LEFT) xp = 8;
			if (direction == Globals.FACING_RIGHT) xp = 4;
			Reg.particles.spawnParticles(15, ctrX + xp, ctrY + 10, "Yellow", 4, 6);
		}
		
		public function shootGrenade():void
		{
			// Shooting delay time
			timeSinceShot = reloadDelay;	
			if (grenadeTime < 1) grenadeTime = 1;
			if (direction == Globals.FACING_LEFT)
			{
				Reg.playerGrenadePool[currentGrenade].dirX = -1 * grenadeTime;
			}				
			else if (direction == Globals.FACING_RIGHT)
			{
				Reg.playerGrenadePool[currentGrenade].dirX = 1 * grenadeTime;
			}
			Reg.playerGrenadePool[currentGrenade].dirY = -1 * grenadeTime;
			Reg.playerGrenadePool[currentGrenade].bounceAmount = grenadeTime * 2;
			Reg.playerGrenadePool[currentGrenade].maxX = maxX;
			Reg.playerGrenadePool[currentGrenade].maxY = maxY;
			Reg.playerGrenadePool[currentGrenade].lifeTime = 0;
			Reg.playerGrenadePool[currentGrenade].onScreen = true;
			Reg.playerGrenadePool[currentGrenade].bounceCount = 1;
			Reg.playerGrenadePool[currentGrenade].flashTimer = 0;
			Reg.playerGrenadePool[currentGrenade].released = true;
			throwingGrenade = true;
			grenadeAnimTime = 0;
			currentGrenade++;
			if (currentGrenade > Globals.MAX_PLAYER_GRENADES - 1) currentGrenade = 0;
			
		}
	}
}