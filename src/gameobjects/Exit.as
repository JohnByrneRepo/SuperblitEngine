package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Exit extends GameObject
	{		

		public function Exit() 
		{
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_EXIT;
			x = -1000;
			onScreen = true;
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			Reg.particles.spawnParticles(15, ctrX, ctrY, "Yellow", 4, 6);
		}
		
		override public function update():void
		{
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 24) animFrame = 0;
			}
			if (cooloff > 0) cooloff--;
		}	

	}

}