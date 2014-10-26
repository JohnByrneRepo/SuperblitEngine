package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Infopoint extends GameObject
	{		
		public function Infopoint() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_INFOPOINT;
			x = -1000;
			bmd = new BitmapData(width, height, true, 0x00000000);			
		}
		
		override public function update():void
		{
			bmd = Bmps.infoBmpdataArray[animFrame];
			
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 3) animFrame = 0;
			}
			
			super.update();
		}	
	}
}