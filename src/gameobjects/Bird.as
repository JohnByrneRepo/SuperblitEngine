package gameobjects 
{
	import flash.display.BitmapData;
	import kernel.Bmps;
	import kernel.Globals;
	import kernel.Reg;
	/**
	 * ...
	 * @author 
	 */
	public class Bird extends GameObject
	{
		
		public function Bird() 
		{
			reset();
		}
		
		public function reset():void {
			x = -2000; // Reg.MAP_WIDTH;
			y = 400;
			onScreen = true;
			yv = Math.random() * 3 + 2;
			bmd = new BitmapData(Bmps.birdBmpdata.width, Bmps.birdBmpdata.width);
		}
		
		override public function update():void {
			super.update();			
			//if (Math.abs(ctrX - Reg.player.ctrX) < (Globals.SCREEN_WIDTH / 2) + (Bmps.smokeBmpdata.width / 2)) {
				// It's on screen!
				//y -= yv;
				x += xv;
				x -= Reg.player.dirX / 20;
				if (x < -bmd.width) {
					onScreen = false;
					x = -2000;
				}
				if (++animTime > 4) {
					animTime = 0;
					if (++animFrame > 3) animFrame = 0;
				}
			//} else {
			//	return;
			//}
			
			bmd = Bmps.birdBmpdataArray[animFrame];
		}
		
	}

}