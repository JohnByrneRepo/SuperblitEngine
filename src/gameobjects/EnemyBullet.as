package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class EnemyBullet extends GameObject
	{				
		public function EnemyBullet() 
		{
			width 				= 5;
			height 				= 5;
			leftBound			= 3;
			rightBound			= 3;
			upBound				= 3;
			downBound			= 3;
			type				= Globals.OBJTYPE_ENEMYBULLET;
			x					= -2000;
			y					= -2000;
			onScreen = false;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			var xp:int = 0; var yp:int = 0; var xv:int;
			if (direction == Globals.FACING_LEFT) { xv = 1; }//yp = 0; }
			if (direction == Globals.FACING_RIGHT) { xv = 2; }//yp = 0; }
			Reg.particles.spawnParticles(3, ctrX + xp, ctrY, "Yellow", 2, 2, xv);
			onScreen = false;
		}
		
		override public function update():void
		{
			if (x < 5 || y < 5 || x > maxX - 5 || y > maxY - 5) { onScreen = false; x = -11000; dirX = dirY = 0; xv = yv = 0; }
			if (!onScreen) return;

			//if (dirX < 0) direction = Globals.FACING_LEFT;
			//if (dirX > 0) direction = Globals.FACING_RIGHT;
			//if (dirY < 0 && Math.abs(dirY)<-Math.abs(dirX)) obj.direction = Globals.FACING_UP;
			//if (dirY > 0 && Math.abs(dirY)>Math.abs(dirX)) obj.direction = Globals.FACING_DOWN;					
							
			bmd = Bmps.enemybulletBmpdataArray[animFrame];

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