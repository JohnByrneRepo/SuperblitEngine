package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Star extends GameObject
	{		
		public var animTime:int = 0;
		
		public function Star() 
		{
			//width 				= Bmps.playerBulletBmpdataArray[0].width;
			//height 				= Bmps.playerBulletBmpdataArray[0].height;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			//bmpDataSheet 		= theBitmapData;			
			//bmpData 			= theBitmapData[0];	
			type				= Globals.OBJTYPE_STAR;
			state				= Globals.STATE_NORMAL;
			x = -1000;
			//y = 0;
		}
		
		override public function update():void
		{
			//x += dirX;
			//x += 7;
			//y += dirY;
			//dirX = xv;
			if (++animTime > 10) 
			{
				animFrame++;
				animTime = 0;
			}
			if (animFrame > 5) animFrame = 0;	
		}		
	}

}