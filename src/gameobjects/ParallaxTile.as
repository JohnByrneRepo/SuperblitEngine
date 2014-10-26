package gameobjects 
{
	import flash.display.BitmapData;
	import kernel.Bmps;
	import kernel.Globals;
	import kernel.Reg;
	/**
	 * ...
	 * @author
	 * Barnaby Byrne
	 */
	public class ParallaxTile extends GameObject
	{
		public var scrollSpeed:int;
		public var tileWidth:int;
		
		public function ParallaxTile($x:int, $y:int) 
		{
			x = $x;
			y = $y;

			var rn:int = Math.random() * 20;
			bmd = Bmps.parallax1Bmpdata;
			if (rn < 12) bmd = Bmps.parallax1Bmpdata;
			else bmd = Bmps.parallax2Bmpdata;
			
			onScreen = true;
		}
		
		override public function update():void {
			//trace("Player x = " + Reg.player.x);
			if (Reg.player.x > 400) { // && Reg.player.x < Reg.MAP_WIDTH - 400) {
				x -= Reg.player.dirX / 20;
				if (x < -415) x = 415 * 3;
				if (x > 415 * 3) x = -415;
			}
		}
	}
}