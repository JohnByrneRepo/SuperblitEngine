package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class FlashingBlock extends GameObject
	{		
		
		public function FlashingBlock() 
		{
			width 				= 40;
			height 				= 40;
			leftBound			= 0;
			rightBound			= 40;
			upBound				= 0;
			downBound			= 40;
			type				= Globals.OBJTYPE_FLASHINGBLOCK;
			x = -1000;
			scorePoints = 50;
			bmd = new BitmapData(width, height, true, 0x00000000);
			onScreen = true;
		}
		
		override public function update():void
		{
			onScreen = true;
			bmd = Bmps.flashingBlockBmpdataArray[animFrame];
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 7) animFrame = 0;
			}
			//trace("updating flashing block");
		}		
	}

}