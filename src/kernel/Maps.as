package kernel 
{

	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class Maps
	{
		// maps

		//level1
		[Embed(source = "../levels/mapCSV_Level1_ParallaxLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map1p:Class; static public var MapCsv1p:String = new Map1p;
		[Embed(source = "../levels/mapCSV_Level1_ForegroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map1a:Class; static public var MapCsv1a:String = new Map1a;
		[Embed(source = "../levels/mapCSV_Level1_SpriteLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map1b:Class; static public var MapCsv1b:String = new Map1b;
		[Embed(source = "../levels/mapCSV_Level1_BackgroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map1c:Class; static public var MapCsv1c:String = new Map1c;

		//level2
		[Embed(source = "../levels/mapCSV_Level2_ParallaxLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map2p:Class; static public var MapCsv2p:String = new Map2p;
		[Embed(source = "../levels/mapCSV_Level2_ForegroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map2a:Class; static public var MapCsv2a:String = new Map2a;
		[Embed(source = "../levels/mapCSV_Level2_SpriteLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map2b:Class; static public var MapCsv2b:String = new Map2b;
		[Embed(source = "../levels/mapCSV_Level2_BackgroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map2c:Class; static public var MapCsv2c:String = new Map2c;

		//level3
		[Embed(source = "../levels/mapCSV_Level3_ParallaxLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map3p:Class; static public var MapCsv3p:String = new Map3p;
		[Embed(source = "../levels/mapCSV_Level3_ForegroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map3a:Class; static public var MapCsv3a:String = new Map3a;
		[Embed(source = "../levels/mapCSV_Level3_SpriteLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map3b:Class; static public var MapCsv3b:String = new Map3b;
		[Embed(source = "../levels/mapCSV_Level3_BackgroundLayer.csv", mimeType = "application/octet-stream")] 
		static private var Map3c:Class; static public var MapCsv3c:String = new Map3c;
	
		public var parallaxMapsArray:Array=
		[
		MapCsv1p,
		MapCsv2p,	
		MapCsv3p	
		];		
			
		public var mapsArray:Array=
		[
		MapCsv1a,
		MapCsv2a,	
		MapCsv3a	
		];		
		
		public var mapsArray2:Array=
		[
		MapCsv1b,
		MapCsv2b,	
		MapCsv3b	
		];
		
		public var mapsArray3:Array=
		[
		MapCsv1c,
		MapCsv2c,	
		MapCsv3c
		];
		
	
		
		public function Maps() 
		{
	
		}
		
	}

}