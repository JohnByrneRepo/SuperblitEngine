package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Slope extends GameObject
	{			
		
		public function Slope() 
		{
			width 				= 40;
			height 				= 40;
			leftBound			= 0;
			rightBound			= 40;
			upBound				= 0;
			downBound			= 40;
			type				= Globals.OBJTYPE_SLOPE;
			x = -1000;
			y = - 1000;
			onScreen = false;
			scorePoints = 50;
			bmd = new BitmapData(width, height, true, 0x00000000);			
		}
		
		override public function update():void
		{
			super.update();
			
			if (slopeType == "TOPLEFT_BOTTOMRIGHT") { bmd = Bmps.spritestripBmpdataArray[27]; }
			else if (slopeType == "BOTTOMLEFT_TOPRIGHT") { bmd = Bmps.spritestripBmpdataArray[29]; }
			
			//bmd = Bmps.spritestripBmpdataArray[27];
			
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