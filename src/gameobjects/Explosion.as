package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Explosion extends GameObject
	{		
		public var size:String;
		
		public function Explosion() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_COIN;
			x = -1000;
			scorePoints = 50;
			bmd = new BitmapData(width, height, true, 0x00000000);	
			size = "Normal";
		}
		
		override public function update():void
		{
			if (!onScreen) {
				xv = yv = 0;
				return;
			}
			if (size == "Normal") bmd = Bmps.explosionBmpdataArray[animFrame];
			else if (size == "Small") bmd = Bmps.explosionSmallBmpdataArray[animFrame];
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 2)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 9) onScreen = false;
			}
			x += xv;
			y += yv;
		}		
	}

}