package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class Bullet extends GameObject
	{				
		public function Bullet() 
		{
			width 				= Bmps.bullBmpdata.height;
			height 				= Bmps.bullBmpdata.height;
			leftBound			= 0;
			rightBound			= 10;
			upBound				= 0;
			downBound			= 10;
			type				= Globals.OBJTYPE_PLAYERBULLET;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			var xp:int=0; var yp:int=0;
			if (direction == Globals.FACING_LEFT) { xp = -4; yp = 0; }
			if (direction == Globals.FACING_RIGHT) { xp = 4; yp = 0; }
			if (direction == Globals.FACING_UP) { xp = 0; yp = -4; }
			if (direction == Globals.FACING_DOWN) { xp = 0; yp = 4; }
			Reg.particles.spawnParticles(5, ctrX + xp, ctrY, "Yellow", 7, 12);
			onScreen = false;
		}
		
		override public function update():void
		{
			if (Reg.player.suitActivated) {
				width 				= Bmps.bullSuitBmpdata.width / Bmps.bullSuitBmpdata.height;
				height 				= Bmps.bullSuitBmpdata.height;
				leftBound			= 10;
				rightBound			= 20;
				upBound				= 10;
				downBound			= 20;
				/*leftBound			= 0;
				rightBound			= 10;
				upBound				= 0;
				downBound			= 10;*/
				if (direction == Globals.FACING_RIGHT) bmd = Bmps.bullSuitBmpdataArray[animFrame];
				else if (direction==Globals.FACING_LEFT) bmd = Bmps.bullSuitBmpdataArrayL[animFrame];
			} else {
				width 				= Bmps.bullBmpdata.width / Bmps.bullBmpdata.height;
				height 				= Bmps.bullBmpdata.height;
				leftBound			= 0;
				rightBound			= 10;
				upBound				= 0;
				downBound			= 10;
				if (direction == Globals.FACING_RIGHT) bmd = Bmps.bullBmpdataArray[animFrame];
				else if (direction == Globals.FACING_LEFT) bmd = Bmps.bullBmpdataArrayL[animFrame];
			}
			
			if (x < 5 || y < 5 || x > maxX - 5 || y > maxY - 5) { onScreen = false; dirX = 0; dirY = 0; x = -8000; }
			if (!onScreen) return;
			
			lifeTime++;
			
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);

			if (++flashTimer > 5)
			{
				flashTimer = 0;
				animFrame = Math.random() * 4;
			}
			
			x += dirX;
			
			if (Reg.player.suitActivated && lifeTime < 2) return;
			else y += dirY;		
		}		
	}
}