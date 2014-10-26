package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Cloud extends GameObject
	{			
		public var speed:int;
		
		public function Cloud($size:int, $x:int, $y:int) 
		{
			width 				= 40;
			height 				= 40;
			leftBound			= 0;
			rightBound			= 40;
			upBound				= 0;
			downBound			= 40;
			type				= Globals.OBJTYPE_CLOUD;
			onScreen = true;
			//x = -1000;
			scorePoints = 50;
			bmd = new BitmapData(width, height, true, 0x00000000);	
			
			type = Math.random() * 10;
			speed = Math.random() * 1 + 1;
			
			x = $x;
			y = $y;
			//trace(x);
		}
		
		override public function update():void
		{		
			if (type == 1) { bmd = Bmps.cloudBmpdata; }
			if (type == 2) { bmd = Bmps.cloud2Bmpdata; }
			if (type == 3) { bmd = Bmps.cloudBmpdata; }
			
			x -= speed;
			
			if (x < -(bmd.width + 50)) {
				x = 850;
				//y = Math.random() * 50 + 5;
				speed = Math.random() * 1 + 1;
			}
			
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
		}		
	}

}