package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Score extends GameObject
	{			
		public var size:int;
		
		public function Score() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_SCORE;
			x = -1000;
			onScreen = false;
		}
		
		override public function update():void
		{
			lifeTime++;
			if (lifeTime > 60) { onScreen = false; }
			fadeTimer++;
			if (fadeTimer > 10)
			{
				y+=(yv*2);
				fadeTimer = 0;
				fadeAmount++;
			}
			//if (fadeAmount > 4) { onScreen = false; x = -2000; }
		}		
	}
}