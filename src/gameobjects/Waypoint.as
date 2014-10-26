package gameobjects 
{
	import gameobjects.GameObject;
	import kernel.*;	
	import flash.display.BitmapData;	
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Waypoint extends GameObject
	{		
		public const MIRRORX:int=0;
		public const MIRRORY:int=1;
		public const CW:int=2;
		public const ACW:int = 3;

		public function Waypoint() 
		{
			
			leftBound			= -2;
			rightBound			= 18;
			upBound				= -2;
			downBound			= 18;
			type				= Globals.OBJTYPE_WAYPOINT;
			cooloff = 0;
			x = -1000;
			//onScreen = true;
		}
		
		override public function update():void
		{
			if (cooloff > 0) cooloff--;
		}	
	}
}