package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class NanoShoes extends GameObject
	{		
		
		public function NanoShoes() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_NANOSHOES;
			x = -1000;
		}
		
		override public function update():void
		{
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 3) animFrame = 0;
			}
		}		
	}

}