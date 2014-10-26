package gameobjects 
{
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	import kernel.*;
	import flash.display.BitmapData;	
	
	public class Ghost extends GameObject
	{
		
		private const SCROLL_SPEED:int=4;
		private const PLAYER_SPEED:int=6;
		private const JUMP_SPEED:Number=6.3;
		private const GRAVITY_SPEED:Number=0.28;
		private const MAX_FALL_SPEED:int=4;
		private const MAX_PLAYER_SPEED:int = 32;
		
		private var jumpTimer:int = 0;
	
		public function Ghost() 
		{
			type = Globals.OBJTYPE_GHOST;
			direction = Globals.FACING_RIGHT;
			width= Bmps.ghostBmpdata.height;
			height= Bmps.ghostBmpdata.height;
			leftBound = 6;
			rightBound = 24;
			upBound = 0;
			downBound = 30;
			onScreen = false;
			direction = Globals.FACING_LEFT;
			x = -4000;
			scorePoints = 200;
			health = 150;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			if (direction == 0) xp = -4;
			if (direction == 1) xp = 4;
			Reg.particles.spawnParticles(15, ctrX + xp, ctrY, "Yellow", 4, 6);
			onScreen = false;
			x = -4000;
			dirX = 0;
		}
		
		override public function update():void
		{	
			super.update();
			//if (!onScreen) return;
			//if (x < 0 || y < 0 || x > maxX - 16 || y > maxY - 16) onScreen = false;
			x += dirX;
			y += dirY;
			
			if (jumpTimer > 0) jumpTimer--;
			if (jumpTimer == 0)
			{
				if (!jumping)// && !pressingJump && !jumpedOnce) // jump
				{
					if (onGround == 1)
					{
						jumpedOnce=true;
						//dirY = -JUMP_SPEED;
						jumping=true;
						pressingJump=true;
					}
				}	
				jumpTimer = Math.random() * 60;
			}
			
			if (onGround == 0) dirY += GRAVITY_SPEED;
			
			if (dirY >= MAX_FALL_SPEED)
			{ dirY = MAX_FALL_SPEED; }
			
			walkTime++;   
			if(walkTime>8) // adjusts animation speed
			{
				walkTime=0;				 
			}	
			
			//else {
				if (direction == Globals.FACING_RIGHT)
				{
					dirX = 1;
					if (walkTime == 0) walkFrame++; 
					if(walkFrame>3)
					{
						walkFrame=0;
					}
					animFrame=walkFrame;
				}
				else
				{
					dirX = -1;
					if (walkTime == 0) walkFrame++; 	
					if(walkFrame>3)
					{
						walkFrame=0;
					}
					animFrame = walkFrame + 4;
				}
			//}
			if (flashing && flashTimer % 2 == 0) { animFrame += 8; } //trace("animframe=" + animFrame); }
			

			bmd = Bmps.ghostBmpdataArray2[animFrame];
			
			
		}

	}

}