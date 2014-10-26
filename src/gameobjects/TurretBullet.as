package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class TurretBullet extends GameObject
	{				
		public function TurretBullet() 
		{
			width 				= 5;
			height 				= 5;
			leftBound			= 0;
			rightBound			= 5;
			upBound				= 3;
			downBound			= 3;
			type				= Globals.OBJTYPE_TURRETBULLET;
			x					= -2000;
			onScreen = false;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			var xp:int=0; var yp:int=0;
			if (direction == Globals.FACING_LEFT) { xp = -4; yp = 0; }
			if (direction == Globals.FACING_RIGHT) { xp = 4; yp = 0; }
			if (direction == Globals.FACING_UP) { xp = 0; yp = -4; }
			if (direction == Globals.FACING_DOWN) { xp = 0; yp = 8; }
			Reg.particles.spawnParticles(7, ctrX + xp, ctrY + yp, "Yellow", 4, 6);
			onScreen = false;
		}
		
		override public function update():void
		{
			if (x<5 || y<5 || x > maxX-5 || y > maxY-5) { onScreen = false; x = -2000; dirX = dirY = 0; }
			if (onScreen == false) return;

			bmd = Bmps.enemybulletBmpdataArray[0];
			if (direction == Globals.FACING_LEFT || direction==Globals.FACING_RIGHT) bmd = Bmps.bullvertBmpdataArray[animFrame];
			if (direction == Globals.FACING_UP || direction == Globals.FACING_DOWN) {
				bmd = Bmps.bullvertBmpdataArray[animFrame];
				upBound = downBound = 0;
				leftBound = 2;
				rightBound = 4;
			}

			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);

			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 3) animFrame = 0;
			}
			x += dirX;
			y += dirY;	
		}		
	}
}