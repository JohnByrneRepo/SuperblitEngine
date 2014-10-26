package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import managers.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Grenade extends GameObject
	{		
		private const MAX_FALL_SPEED:int=4;
		private const GRAVITY_SPEED:Number = 0.18;
		
		public var bounceAmount:Number=1.3;
		public var bounceForce:int=2;
		public var currentParticle:int;
		
		public function Grenade() 
		{
			width 				= 5;
			height 				= 4;
			leftBound			= 0;
			rightBound			= 4;
			upBound				= 0;
			downBound			= 5;
			type				= Globals.OBJTYPE_PLAYERGRENADE;
			bmd = new BitmapData(width, height, true, 0x00000000);
			x = -12000;
			testedExplode = true;
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			if (direction == 0) xp = -4;
			if (direction == 1) xp = 4;
			Reg.particles.spawnParticles(15, ctrX + xp, ctrY, "Yellow", 4, 6);
			testedExplode = false;
		}
		
		override public function explode():void
		{
			spawnParticles();
			bounceCount = 6;
			sfx.play(SoundEffectsManager.sndGrenade);			
		}
		
		override public function update():void
		{
			bmd = Bmps.grenadeBmpdataArray[animFrame]; 
			 
			if (!onScreen) return;
	
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);

			lifeTime++;
			if (bounceCount > 3)
			{
				animFrame = 1;
				flashTimer++;
			}
			else animFrame = 0;
			
			if (bounceCount == 5) 
			{ 
				explode();
			}

			if (cooloff > 0) cooloff--;
			
			x += dirX;
			y += dirY;
			
			if (onGround == 0) dirY += GRAVITY_SPEED;
			if (dirY >= MAX_FALL_SPEED)
			{ dirY = MAX_FALL_SPEED; }
			
			if (x<0 || y<0 || x > maxX || y > maxY) onScreen = false;
		}	
			
		override public function bounce():void
		{	
			bounceCount++;
			dirY = -(bounceAmount) / bounceCount;
		}
	}

}