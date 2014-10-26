package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Lavablock extends GameObject
	{		
		public var animType:int;
		public const ANIMATED:int = 0;
		public const STATIC:int = 1;
		
		public function Lavablock() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_LAVA;
			x = -1000;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function update():void
		{
			if (animType == 0)bmd = Bmps.lavaBmpdataArray[animFrame];
			if (animType == 1)bmd = Bmps.lavaBmpdataArray[3];
			//if (animType == 1) bmd = Bmps.spritestripBmpdataArray[3];
	
			lifeTime++;
			if (lifeTime > 10)
			{
				animFrame++;
				if (animFrame > 2) animFrame = 0;
				lifeTime = 0;
			}
		}	
	}
}