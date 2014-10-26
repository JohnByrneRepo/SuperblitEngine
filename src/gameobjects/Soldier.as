package gameobjects 
{
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	import kernel.*;
	import flash.display.BitmapData;	
	import managers.*;
	
	public class Soldier extends GameObject
	{
		public var notNearWaypoint:Boolean = true;
		
		private const SCROLL_SPEED:int=4;
		private const PLAYER_SPEED:int=6;
		private const JUMP_SPEED:Number=6.3;
		private const GRAVITY_SPEED:Number=0.28;
		private const MAX_FALL_SPEED:int=4;
		private const MAX_PLAYER_SPEED:int = 32;
		
		private var currentSoldierBullet:int = 0;
		private var jumpTimer:int = 0;
	
		public const ROAMING:int = 0;
		public const ATTACKING:int = 1;
		
		public function Soldier() 
		{
			type = Globals.OBJTYPE_SOLDIER;
			direction = Globals.FACING_RIGHT;
			width				= Bmps.soldierBmpdata.height;
			height				= Bmps.soldierBmpdata.height;
			leftBound			= 8;
			rightBound			= 34;
			upBound				= 0;
			downBound			= Bmps.soldierBmpdata.height;
			onScreen = false;
			direction = Globals.FACING_LEFT;
			x = -4000;
			scorePoints = 800;
			shotFrequency = 120;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			if (direction == 0) xp = -4;
			if (direction == 1) xp = 4;
			Reg.particles.spawnParticles(15, ctrX + xp, ctrY, "Yellow", 4, 6);
		}
		
		override public function update():void
		{	
			super.update();
			
			if (x < 0 || y < 0 || x > maxX - 16 || y > maxY - 16) { onScreen = false; x = -9000; dirX = dirY = 0; }
			if (!onScreen) return;

			distToPlayerX = (Reg.player.ctrX - ctrX);
			distToPlayerY = (Reg.player.ctrY - ctrY);
			
			if (++timeSinceShot > shotFrequency)
			{
				timeSinceShot = 0;
			}
						
			if (distToPlayerX < 500 && distToPlayerX > -500 && timeSinceShot==0)
			{
				var d:int = direction;
				shoot(d);
				direction = Globals.STATIC;
				dirX = 0;
			}
			else if (direction == Globals.STATIC)
			{
				if (distToPlayerX > 0) direction = Globals.FACING_RIGHT;
				if (distToPlayerX < 0) direction = Globals.FACING_LEFT;
			}
							
			x += dirX;
			y += dirY;

			walkTime++;   
			if(walkTime>8) // adjusts animation speed
			{
				walkTime=0;				 
			}	
			
			if (direction != Globals.STATIC)
			{
				if (direction == Globals.FACING_RIGHT)
				{
					dirX = 1;
					if (walkTime == 0) walkFrame++; 
					if (walkFrame > 1)
					{
						walkFrame = 0;
					}
					animFrame = walkFrame;
				}
				else
				{
					dirX = -1;
					if (walkTime == 0) walkFrame++; 	
					if (walkFrame > 1)
					{
						walkFrame = 0;
					}
					animFrame = walkFrame + 2;
				}
			}
			
			if (flashing && flashTimer % 2 == 0) animFrame += 4;

			bmd = Bmps.soldierBmpdataArray[animFrame];

			//trace("Facing direction: " + direction);
		}
		
		public function shoot(d:int):void
		{	
			if ((Math.abs(x - Reg.player.x) < 500) && (Math.abs(y - Reg.player.y) < 500)) 
			sfx.play(SoundEffectsManager.sndSoldierShoot);
			if (d == Globals.FACING_LEFT)
			{
				Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].x = ctrX-2;
				Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].dirX = -5;
			}			
			if (d == Globals.FACING_RIGHT)
			{
				Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].x = ctrX+2;
				Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].dirX = 5;
			}
			Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].y = ctrY - 2;
			Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].onScreen = true;
			Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].dirY = 0;
			Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].maxX = maxX;
			Reg.soldierBulletPool[Reg.enemyBullets.currentSoldierBullet].maxY = maxY;
			Reg.enemyBullets.currentSoldierBullet++;
			if (Reg.enemyBullets.currentSoldierBullet > Reg.soldierBulletPool.length - 1) Reg.enemyBullets.currentSoldierBullet = 0;
		}
	}
}