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
	public class Smoke extends GameObject
	{
		
		public function Smoke() 
		{
			onScreen = false;
			x = -2000;
		}
		
		public function reset():void {
			/*x = Math.random() * Globals.SCREEN_WIDTH * 3; // Reg.MAP_WIDTH;
			y = 400;
			onScreen = true;
			yv = Math.random() * 2 + 1;*/
			//bmd = new BitmapData(Bmps.smokeBmpdata.width, Bmps.smokeBmpdata.width);
		}
		
		override public function update():void {
			super.update();			
			//if (Math.abs(ctrX - Reg.player.ctrX) < (Globals.SCREEN_WIDTH / 2) + (Bmps.smokeBmpdata.width / 2)) {
				// It's on screen!
				y += yv;
				xv = 0;
				x -= Reg.player.dirX / 20;
				if (y < -50) reset();
				if (++animTime > 10) {
					animTime = 0;
					if (++animFrame > 3) animFrame = 0;
				}
			//} else {
			//	return;
			//}
			
			bmd = Bmps.smokeBmpdataArray[animFrame];
		}
		
	}

}