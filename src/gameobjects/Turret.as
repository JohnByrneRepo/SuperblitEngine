package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import managers.*;
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Turret extends GameObject
	{		
		// direction
		// 0 = top
		// 1 = bottom
		// 2 = left
		// 3 = right
		
		public var currentTurretBullet:int;
		
		public function Turret() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_COIN;
			x = -1000;
			shotFrequency = 50;
			flashing = false;
			bmd = new BitmapData(width, height, true, 0x00000000);			
		}
		
		override public function update():void
		{
			if ((Math.abs(Reg.player.x - x) > 320) || (Math.abs(Reg.player.y - y) > 240))
			{
				return;
			}
			
			if (direction == Globals.FACING_DOWN) bmd = Bmps.turrettopBmpdataArray[animFrame];
			if (direction == Globals.FACING_UP) bmd = Bmps.turretbottomBmpdataArray[animFrame];
			if (direction == Globals.FACING_RIGHT) bmd = Bmps.turretleftBmpdataArray[animFrame];
			if (direction == Globals.FACING_LEFT) bmd = Bmps.turretrightBmpdataArray[animFrame];

			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 3) animFrame = 0;
			}
			if (!onScreen) return;
			if (++timeSinceShot > shotFrequency)
			{
				if (++attackMode > 1) attackMode = 0;
				timeSinceShot = 0;
				shoot();
			}
			lifeTime++;
			if (lifeTime > 50) lifeTime = 0;
		}
		
		public function shoot():void
		{
			if ((Math.abs(x - Reg.player.x) < 400) && (Math.abs(y - Reg.player.y) < 400)) 
				sfx.play(SoundEffectsManager.sndTurretShoot);
			//if (Math.abs(Reg.player.x - x) < 320 && Math.abs(Reg.player.y - y) < 240)
			//{
				if (direction == Globals.FACING_DOWN)
				{
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirX = 0;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirY = 6;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].x = ctrX;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].y = ctrY-8;
				}					
				else if (direction == Globals.FACING_UP)
				{
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirX = 0;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirY = -6;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].x = ctrX-2;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].y = ctrY+8;
				}	
				else if (direction == Globals.FACING_RIGHT)
				{
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirX = 6;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirY = 0;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].x = ctrX+8;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].y = ctrY-2;
				}	
				else if (direction == Globals.FACING_LEFT)
				{
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirX = -6;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].dirY = 0;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].x = ctrX-8;
					Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].y = ctrY+2;
				}
				
				Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].maxX = maxX;
				Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].maxY = maxY;
				Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].onScreen = true;
				Reg.turretBulletPool[Reg.enemyBullets.currentTurretBullet].direction = direction;
				Reg.enemyBullets.currentTurretBullet++;
				if (Reg.enemyBullets.currentTurretBullet > Reg.turretBulletPool.length - 1) Reg.enemyBullets.currentTurretBullet = 0;
			//}
		}
	}
}