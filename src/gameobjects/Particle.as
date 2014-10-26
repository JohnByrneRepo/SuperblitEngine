package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Particle extends GameObject
	{		
		private const JUMP_SPEED:Number=1.3;
		public var GRAVITY_SPEED:Number=0.18;
		public var MAX_FALL_SPEED:int=2;
	
		//public var shimmerAmount:Number;
		public var shimmerForce:int;
		public var shimmerCount:int;	
		
		public var bounceAmount:Number=1.3;
		public var bounceForce:int;
		public var rotationDirection:int;
		public var rotationCount:int;
		
		public function Particle() 
		{
			width = 5;
			height = 5;
			leftBound			= 0;
			rightBound			= 3;
			upBound				= 0;
			downBound			= 3;
			type				= Globals.OBJTYPE_PARTICLE;
			x = -1000;
			color = "Red";
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function update():void
		{
			if (x < 0 || y < 0 || x > maxX - 3 || y > maxY - 3) { onScreen = false; x = -2000; dirX = 0; dirY = 0; }
			if (!onScreen) return;

			if (type != Globals.OBJTYPE_SCOREBREAKDOWN) {
				lifeTime++;
				if (lifeTime > 50) { animFrame = 1; }
				if (lifeTime > 100) { animFrame = 2; }
				if (lifeTime > 150) { animFrame = 3; }
				if (lifeTime > 200) { x = -2000; onScreen = false; }
			}

			if (type == Globals.OBJTYPE_PARTICLEBEAM) {
				shimmer();
				bmd = Bmps.particleBeamBmpdataArray[animFrame];
				return;
			}
			
			if (type == Globals.OBJTYPE_SCOREBREAKDOWN) {
				rn = Math.random() * 15;
				if (rn < 7) bmd = Bmps.particleBeamBmpdataArray[animFrame];
				else if (rn >= 7 && rn < 10) bmd = Bmps.yellowpartBmpdataArray[animFrame];
				else bmd = Bmps.partBmpdataArray[animFrame];
				y -= Math.random() * 3;
				animFrame = Math.random() * 4;
				var lvlCompletePanelY:int = (490 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2);
				if (y < lvlCompletePanelY + 15) y = lvlCompletePanelY + 358;
				return;
			}

			var rn:int = Math.random() * 10;
			if (rn < 5) bmd = Bmps.yellowpartBmpdataArray[animFrame];
			else bmd = Bmps.partBmpdataArray[animFrame];
			
			x += dirX;
			y += dirY;
			
			if (onGround == 0) dirY += GRAVITY_SPEED;
			
			if (dirY >= MAX_FALL_SPEED)
			{ dirY = MAX_FALL_SPEED; }
			
		}	
		
		override public function shimmer():void
		{	
			shimmerCount++;
			dirY = -2;
			y += dirY;
			if (shimmerCount == 400)
			{
				//dirY *= -1;
				onScreen = false;
			}
		}	
		
		override public function bounce():void
		{	
			bounceCount++;
			dirY = -(bounceAmount+bounceForce) / bounceCount;
		}
	}

}