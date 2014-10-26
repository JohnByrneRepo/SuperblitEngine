package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class SoldierBullet extends GameObject
	{				
		public function SoldierBullet() 
		{
			width 				= 5;
			height 				= 5;
			leftBound			= 0;
			rightBound			= 5;
			upBound				= 3;
			downBound			= 3;
			type				= Globals.OBJTYPE_SOLDIERBULLET;
			x					= -2000;
			onScreen = false;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			Reg.particles.spawnParticles(15, ctrX, ctrY, "Yellow", 4, 6);
			onScreen = false;
		}
		
		override public function update():void
		{
			if (x<5 || y<5 || x > maxX-5 || y > maxY-5) { onScreen = false; x = -2000; dirX = dirY = 0; }
			if (onScreen == false) return;

			bmd = Bmps.bullBmpdataArray[animFrame];
			//bmd = Bmps.bullBmpdataArray[0];

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