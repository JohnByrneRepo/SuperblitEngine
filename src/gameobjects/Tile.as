package gameobjects 
{
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Tile
	{
		// Constant tile types
		public static const BACKGROUND		:int = 0;
		public static const SOLID			:int = 1;
		public static const JUMPTHROUGH		:int = 2;
		public static const LADDER			:int = 3;
		
		public var distanceFromSource1:int;
		public var distanceFromSource2:int;
		public var sources:int;
		public var lit:Boolean;
		public var lightIntensity:int;
		public var canSeePlayer:Boolean;
		public var canSeeSource1:Boolean;
		public var canSeeSource2:Boolean;
		public var col:int;
		public var row:int;
		public var type:int;
		
		public function Tile(c:int,r:int,t:int) 
		{
			type = t;
			col = c;
			row = r;
		}
		
		public function canSeeSource(x:int,y:int):Boolean
		{
			// Bressenham line algorithm
			// If tile can see source return true
			
			return true;
		}
		
		
		//public function 
		
	}

}