package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Coin extends GameObject
	{				
		public function Coin() 
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
		}
		
		override public function update():void
		{
			//if (type == 1) 
			bmd = Bmps.coinBmpdataArray[animFrame];
			//else if (type == 2) bmd = Bmps.nanoshoeBmpdataArray[animFrame];
			
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 7) animFrame = 0;
			}
		}		
	}

}