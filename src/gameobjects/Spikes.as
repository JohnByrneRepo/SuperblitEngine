package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Spikes extends GameObject
	{		
		// direction
		// 0 = bottom
		// 1 = top
		
		public function Spikes() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_SPIKE;
			x = -1000;
			//scorePoints = 50;
			shotFrequency = 50;
			flashing = false;
			direction = 0;
			//scorePoints = 500;			
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function update():void
		{
			if (direction == 0) bmd = Bmps.spikesbottomBmpdataArray[animFrame];
			if (direction == 1) bmd = Bmps.spikestopBmpdataArray[animFrame];				
				
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 3) animFrame = 0;
			}
			if (!onScreen) return;
			lifeTime++;
			if (lifeTime > 50) lifeTime = 0;
		}		
	}

}