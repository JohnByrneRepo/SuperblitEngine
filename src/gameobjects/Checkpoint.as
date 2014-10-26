package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Checkpoint extends GameObject
	{		

		public function Checkpoint() 
		{
			width 				= 16;
			height 				= 16;
			leftBound			= 0;
			rightBound			= 16;
			upBound				= 0;
			downBound			= 16;
			type				= Globals.OBJTYPE_CHECKPOINT;
			x = -1000;
			bmd = new BitmapData(width, height, true, 0x00000000);			
		}
		
		override public function spawnParticles():void
		{	
			var xp:int;
			Reg.particles.spawnParticles(15, ctrX, ctrY - 10, "Yellow", 4, 6);
		}
		
		override public function update():void
		{
			bmd = Bmps.checkpointBmpdata;
			super.update();
		}	

	}

}