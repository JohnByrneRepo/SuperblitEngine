package kernel 
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameobjects.Tile;	
	import kernel.Globals;
		
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	 
	public class Tilemap
	{		
		public var depth:int = 0;
		public var startDir:int = 0;
		
		public var auto							:Boolean;
		public var tmpGrid						:Array = [];
		public var grid							:Array = [];
		public var gr							:Array = [];
		public var pixels						:BitmapData=new BitmapData(Globals.SCREEN_WIDTH,Globals.SCREEN_HEIGHT, true, 0x00000000);   
		private var blitRect					:Rectangle=new Rectangle(0,0,0,0);				
		private var point						:Point = new Point(0, 0);
		public var tileSize						:int=40;
		public var widthInTiles					:int;
		public var heightInTiles				:int;
		public var maxX							:int;
		public var maxY							:int;
		public var level						:int;
		public var tilesArray					:Array = [];
		public var foreGround					:Boolean;
		
		//
		public var centerTile					:Tile=new Tile(0,0,0);
		public var adjacentTiles				:Array=[];
		public var adjacentTiles2				:Array=[];
		public var adjacentTiles3				:Array=[];
		public var adjacentTiles4				:Array=[];
		public var adjacentTiles5				:Array=[];
		public var adjacentTiles6				:Array=[];

		// Counters
		private var i							:int;
		private var j							:int;
		private var k							:int;
		private var r							:int;
		private var c							:int;
			
		// Waypoint actions
		public const MIRRORX:int=0;
		public const MIRRORY:int=1;
		public const CW:int=2;
		public const ACW:int=3;

		//
		public var plyrCol:int;
		public var plyrRow:int;
		public var startCol:int;
		public var startRow:int;
		public var lev:String;
		public var startX:int;
		public var startY:int;
		public var exitX:int;
		public var exitY:int;
		public var keycardX:int;
		public var keycardY:int;
		
		public var touched:Array = [];

		public function Tilemap() 
		{

		}
		
		/////////////////////////////////////////////
		
		public function loadMap(lvl:String):void 
		{		
			lev = lvl;
			tileSize = Globals.TILE_SIZE;

			var cols:Array = [];
			var rows:Array = [];
			
			tmpGrid = [];
			grid = [];

			rows=lvl.split("\n");
			heightInTiles = rows.length;
			cols = rows[0].split(",");
			widthInTiles = cols.length;
				
			maxX = widthInTiles * tileSize;
			maxY = (heightInTiles-1) * tileSize;
			
			// ARRAY POPULATION			
			grid = new Array(widthInTiles); 
			for(var arrCreationCount:int = 0; arrCreationCount < grid.length; arrCreationCount++) 
			{    
			 grid[arrCreationCount] = new Array(heightInTiles); 
			}			
			
			// ARRAY POPULATION			
			tmpGrid = new Array(widthInTiles); 
			for(arrCreationCount = 0; arrCreationCount < tmpGrid.length; arrCreationCount++) 
			{    
			 tmpGrid[arrCreationCount] = new Array(heightInTiles); 
			}
					
			for(r = 0; r < heightInTiles; r++)
			{	
				cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{	
					var id:int = uint(cols[c]);
					var typ:int;
					
					//if(id>=40 && id<50)//jump through platform
					//tmpGrid[c][r] = 1000;
					
					//if(id>=50 && id<=60)
					 //typ = Globals.TILETYPE_LADDER;
					if(id>=1)
					 typ = Globals.TILETYPE_SOLID;	
					if(id==14 || id==9)
					 typ = Globals.TILETYPE_JUMPTHROUGH;	
					if (id == 0)
					 typ = Globals.TILETYPE_VOID;
					 
					if (id == 17 || id == 19 || id == 21) {
						Reg.flashingBlockPool[Reg.currentFlashingBlock].x = c * Globals.TILE_SIZE;
						Reg.flashingBlockPool[Reg.currentFlashingBlock].y = r * Globals.TILE_SIZE;
						if (++Reg.currentFlashingBlock > Globals.MAX_EXPLOSIONS - 1) Reg.currentFlashingBlock = 0;
						//trace("Added flashing block");
						//trace("x and y = " + String(c * Globals.TILE_SIZE) + ", " + r * Globals.TILE_SIZE);
					}
					
					tmpGrid[c][r] = typ;
				}
			}					
			
			for(r = 0; r < heightInTiles; r++)
			{
				cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{
					grid[c][r] = uint(cols[c]);
				}
			}				
		}			
		
		/////////////////////////////////////////////
		
		public function autoTileGrid(lvl:String):void 
		{		
			lev = lvl;
			tileSize = Globals.TILE_SIZE;
			
			var cols:Array = [];
			var rows:Array = [];

			grid = [];
			tmpGrid = [];

			rows=lev.split("\n");
			heightInTiles = rows.length;
			cols = rows[0].split(",");
			widthInTiles = cols.length;
				
			maxX = widthInTiles * tileSize;
			maxY = (heightInTiles-1) * tileSize;
			
			// ARRAY POPULATION			
			grid = new Array(widthInTiles); 
			for(var arrCreationCount:int = 0; arrCreationCount < grid.length; arrCreationCount++) 
			{    
			 grid[arrCreationCount] = new Array(heightInTiles); 
			}			
			
			// ARRAY POPULATION			
			tmpGrid = new Array(widthInTiles); 
			for(arrCreationCount = 0; arrCreationCount < tmpGrid.length; arrCreationCount++) 
			{    
			 tmpGrid[arrCreationCount] = new Array(heightInTiles); 
			}
					
			// ARRAY POPULATION			
			gr = new Array(widthInTiles); 
			for(arrCreationCount = 0; arrCreationCount < gr.length; arrCreationCount++) 
			{    
			 gr[arrCreationCount] = new Array(heightInTiles); 
			}
		
			for(r = 0; r < heightInTiles; r++)
			{
				cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{
					gr[c][r] = uint(cols[c]);
					if (uint(cols[c]) > 0) 
					{
						tmpGrid[c][r] = Globals.TILETYPE_SOLID;
					} else
					{
						tmpGrid[c][r] = 0;
					}
					//grid[c][r] = 1;
				}
			}	
		
			for(r = 0; r < heightInTiles; r++)
			{
				//cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{
					//var val:int = mp.grid[c][r];
					var val:int = gr[c][r];
					grid[c][r] = 0;
					if (val == 1)
					{
					
						if (c == 0)
						{
							if (gr[c+1][r] == 0) grid[c][r] = 6;
							if (gr[c][r-1] == 0) grid[c][r] = 8;
						}							
						if (c == widthInTiles - 1)
						{
							if (gr[c-1][r] == 0) grid[c][r] = 5;
						}					
						if (r == 0)
						{
							if (gr[c][r + 1] == 0) grid[c][r] = 9;
							if (c < widthInTiles - 1 && gr[c + 1][r] == 0 && gr[c][r + 1] == 1) grid[c][r] = 6;
							if (c < widthInTiles - 1 && gr[c + 1][r] == 0 && gr[c][r + 1] == 0) grid[c][r] = 1;
							if (c > 0 && gr[c - 1][r] == 0 && gr[c][r + 1] == 1) grid[c][r] = 5;
							if (c > 0 && gr[c - 1][r] == 0 && gr[c][r + 1] == 0) grid[c][r] = 3;
						}							
						if (r == heightInTiles - 2)
						{
							if (gr[c][r-1] == 0) grid[c][r] = 8;
							if (c < widthInTiles - 1 && gr[c + 1][r] == 0 && gr[c][r -1] == 1) grid[c][r] = 6;
							if (c < widthInTiles - 1 && gr[c + 1][r] == 0 && gr[c][r -1] == 0) grid[c][r] = 12;
							if (c > 0 && gr[c - 1][r] == 0 && gr[c][r - 1] == 1) grid[c][r] = 5;
							if (c > 0 && gr[c - 1][r] == 0 && gr[c][r - 1] == 0) grid[c][r] = 11;
						}
						
						if (r > 0 && c > 0 && r < heightInTiles-2 && c < widthInTiles-1)
						{	
							var lf:int = gr[c-1][r];
							var rg:int = gr[c+1][r];
							var up:int = gr[c][r-1];
							var dn:int = gr[c][r+1];			
							
							var upleft:int = gr[c-1][r-1];
							var upright:int = gr[c+1][r-1];
							var downleft:int = gr[c-1][r+1];
							var downright:int = gr[c+1][r+1];
												
							//if (c > 0 && c < widthInTiles - 1)
							//{
								// right
								if (lf == 1 && rg == 0) grid[c][r] = 6;
								// left
								if (lf == 0 && rg == 1) grid[c][r] = 5;
							//}
							
							//if (r > 0 && r < heightInTiles - 1)
							//{
								// up
								if (up == 0 && dn == 1) grid[c][r] = 8;
								// down
								if (up == 1 && dn == 0) grid[c][r] = 9;
							//}
							
							// corners
							
							// top right
							if (dn==1 && lf==1 && up==0 && rg==0) grid[c][r] = 12;
							// top left
							if (dn==1 && rg==1 && up==0 && lf==0) grid[c][r] = 11;
							// bottom left
							if (dn==0 && lf==0 && up==1 && rg==1) grid[c][r] = 3;
							//bottom right
							if (dn == 0 && lf == 1 && up == 1 && rg == 0) grid[c][r] = 1;

							//inset
							if (dn == 1 && lf == 1 && up == 1 && rg == 1) grid[c][r] = 59;
							
							// double bars
							if (dn == 0 && lf == 1 && up == 0 && rg == 1) grid[c][r] = 18;
							if (dn == 1 && lf == 0 && up == 1 && rg == 0) grid[c][r] = 16;
							// end caps
							if (dn == 0 && lf == 1 && up == 0 && rg == 0) grid[c][r] = 25;
							if (dn == 0 && lf == 0 && up == 0 && rg == 1) grid[c][r] = 27;
													
							if (dn == 1 && lf == 0 && up == 0 && rg == 0) grid[c][r] = 23;
							if (dn == 0 && lf == 0 && up == 1 && rg == 0) grid[c][r] = 21;	
							
							// inside edges
							if (upleft == 0 && up == 1 && lf == 1 && dn == 1) grid[c][r] = 34; // tl is filled in
							if (upright == 0 && up == 1 && rg == 1 && dn == 1) grid[c][r] = 32; // tr is filled in
							//if (downleft == 0 && lf == 1 && dn == 1) grid[c][r] = 30; // bl is filled in
							//if (downleft == 0 && up == 1 && rg == 1 && dn == 1) grid[c][r] = 28; // br is filled in
							
							
							
						}
					}
				}
			}
		}
		
		/////////////////////////////////////////////
		
		public function loadSprites(lvl:String):void 
		{		
			tileSize = Globals.TILE_SIZE;

			var cols:Array = [];
			var rows:Array = [];
			
			tmpGrid = [];
			grid = [];

			rows=lvl.split("\n");
			heightInTiles = rows.length;
			cols = rows[0].split(",");
			widthInTiles = cols.length;
				
			maxX = widthInTiles * tileSize;
			maxY = (heightInTiles-1) * tileSize;
			
			// ARRAY POPULATION			
			grid = new Array(widthInTiles); 
			for(var arrCreationCount:int = 0; arrCreationCount < grid.length; arrCreationCount++) 
			{    
			 grid[arrCreationCount] = new Array(heightInTiles); 
			}			
			
			// ARRAY POPULATION			
			tmpGrid = new Array(widthInTiles); 
			for(arrCreationCount = 0; arrCreationCount < tmpGrid.length; arrCreationCount++) 
			{    
			 tmpGrid[arrCreationCount] = new Array(heightInTiles); 
			}
			
			Reg.currentCoin = 0;
			Reg.currentGhost = 0;
			Reg.currentCheckpoint = 0;
			Reg.currentInfopoint = 0;
			Reg.currentWaypoint = 0;
			Reg.currentLavablock = 0;
			Reg.currentSaucer = 0;
			Reg.currentSnake = 0;
			Reg.currentSoldier = 0;
			Reg.currentTurret = 0;
			Reg.currentHeart = 0;
			Reg.currentSpike = 0;
			
			for(r = 0; r < heightInTiles; r++)
			{
				cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{
					var id:int = uint(cols[c]);
					var typ:int;
					
					if (id == 1)
					{
					 typ = Globals.TILETYPE_VOID;
					 startX = c * tileSize + 20;
					 startY = r * tileSize;
					 startY = -300;
					 startDir = 1;
					 Reg.player.direction = Globals.FACING_RIGHT;
					}
					if (id == 2)
					{
					 typ = Globals.TILETYPE_VOID;
					 startX = c * tileSize;
					 startY = r * tileSize;
					 startDir = 0;
					 Reg.player.direction = Globals.FACING_LEFT;
					}
					
					/*if (id == 27)
					{
					 Reg.slopePool[Reg.currentSlope].x = (c * tileSize);
					 Reg.slopePool[Reg.currentSlope].y = (r * tileSize);
					 Reg.slopePool[Reg.currentSlope].maxX = maxX;
					 Reg.slopePool[Reg.currentSlope].maxY = maxY;
					 Reg.slopePool[Reg.currentSlope].onScreen = true;
					 Reg.slopePool[Reg.currentSlope].currentstep = 0;
					 Reg.slopePool[Reg.currentSlope].timeSinceShot = 0;
					 Reg.slopePool[Reg.currentSlope].health = 200;
					 Reg.slopePool[Reg.currentSlope].slopeType = "TOPLEFT_BOTTOMRIGHT";
					 Reg.currentSlope++;
					 trace("added slope");
					}					
					if (id == 29)
					{
					 Reg.slopePool[Reg.currentSlope].x = (c * tileSize);
					 Reg.slopePool[Reg.currentSlope].y = (r * tileSize);
					 Reg.slopePool[Reg.currentSlope].maxX = maxX;
					 Reg.slopePool[Reg.currentSlope].maxY = maxY;
					 Reg.slopePool[Reg.currentSlope].onScreen = true;
					 Reg.slopePool[Reg.currentSlope].currentstep = 0;
					 Reg.slopePool[Reg.currentSlope].timeSinceShot = 0;
					 Reg.slopePool[Reg.currentSlope].health = 200;
					 Reg.slopePool[Reg.currentSlope].slopeType = "BOTTOMLEFT_TOPRIGHT";
					 Reg.currentSlope++;
					 trace("added slope");
					}		*/				
					if (id == 16)
					{
					 Reg.saucerPool[Reg.currentSaucer].x = (c * tileSize) + 30;
					 Reg.saucerPool[Reg.currentSaucer].y = (r * tileSize) + 0;
					 Reg.saucerPool[Reg.currentSaucer].maxX = maxX;
					 Reg.saucerPool[Reg.currentSaucer].maxY = maxY;
					 Reg.saucerPool[Reg.currentSaucer].onScreen = true;
					 Reg.saucerPool[Reg.currentSaucer].currentstep = 0;
					 Reg.saucerPool[Reg.currentSaucer].timeSinceShot = 0;
					 Reg.saucerPool[Reg.currentSaucer].health = 200;
					 Reg.currentSaucer++;
					}						
					if (id == 25)
					{
					 Reg.spawnerPool[Reg.currentSpawner].xpos = (c * tileSize);
					 Reg.spawnerPool[Reg.currentSpawner].ypos = (r * tileSize) + 0;
					 Reg.spawnerPool[Reg.currentSpawner].x = (c * tileSize);
					 Reg.spawnerPool[Reg.currentSpawner].y = (r * tileSize) + 0;
					 Reg.spawnerPool[Reg.currentSpawner].maxX = maxX;
					 Reg.spawnerPool[Reg.currentSpawner].maxY = maxY;
					 Reg.spawnerPool[Reg.currentSpawner].onScreen = true;
					 Reg.spawnerPool[Reg.currentSpawner].currentstep = 0;
					 Reg.spawnerPool[Reg.currentSpawner].timeSinceShot = 0;
					 Reg.spawnerPool[Reg.currentSpawner].health = 400;
					 Reg.spawnerPool[Reg.currentSpawner].spawnType = "DumbEnemy";
					 if (Reg.player.x < c * tileSize) Reg.spawnerPool[Reg.currentSpawner].direction = Globals.FACING_LEFT;
					 else if (Reg.player.x >= c * tileSize) Reg.spawnerPool[Reg.currentSpawner].direction = Globals.FACING_RIGHT;
					 Reg.currentSpawner++;
					}					
					if (id == 26)
					{
					 Reg.spawnerPool[Reg.currentSpawner].xpos = (c * tileSize);
					 Reg.spawnerPool[Reg.currentSpawner].ypos = (r * tileSize) + 0;
					 Reg.spawnerPool[Reg.currentSpawner].x = (c * tileSize);
					 Reg.spawnerPool[Reg.currentSpawner].y = (r * tileSize) + 0;
					 Reg.spawnerPool[Reg.currentSpawner].maxX = maxX;
					 Reg.spawnerPool[Reg.currentSpawner].maxY = maxY;
					 Reg.spawnerPool[Reg.currentSpawner].onScreen = true;
					 Reg.spawnerPool[Reg.currentSpawner].currentstep = 0;
					 Reg.spawnerPool[Reg.currentSpawner].timeSinceShot = 0;
					 Reg.spawnerPool[Reg.currentSpawner].health = 400;
					 Reg.spawnerPool[Reg.currentSpawner].spawnType = "ShootingEnemy";
					 if (Reg.player.x < c * tileSize) Reg.spawnerPool[Reg.currentSpawner].direction = Globals.FACING_LEFT;
					 else if (Reg.player.x >= c * tileSize) Reg.spawnerPool[Reg.currentSpawner].direction = Globals.FACING_RIGHT;
					 Reg.currentSpawner++;
					}	
					if (id == 17)
					{
					 Reg.soldierPool[Reg.currentSoldier].x = (c * tileSize);
					 Reg.soldierPool[Reg.currentSoldier].y = (r * tileSize);
					 Reg.soldierPool[Reg.currentSoldier].maxX = maxX;
					 Reg.soldierPool[Reg.currentSoldier].maxY = maxY;
					 Reg.soldierPool[Reg.currentSoldier].onScreen = true;
					 Reg.soldierPool[Reg.currentSoldier].currentstep = 0;
					 Reg.soldierPool[Reg.currentSoldier].timeSinceShot = 0;
					 Reg.soldierPool[Reg.currentSoldier].health = 120;
					 Reg.currentSoldier++;
					}
					if (id == 3)
					{
					 Reg.lavablockPool[Reg.currentLavablock].x = c * tileSize;
					 Reg.lavablockPool[Reg.currentLavablock].y = r * tileSize;
					 Reg.lavablockPool[Reg.currentLavablock].onScreen = true;
					 Reg.lavablockPool[Reg.currentLavablock].animType = 1;
					 Reg.lavablockPool[Reg.currentLavablock].type = 9999;
					 Reg.currentLavablock++;
					}					
					if (id == 7)
					{
					 Reg.lavablockPool[Reg.currentLavablock].x = c * tileSize;
					 Reg.lavablockPool[Reg.currentLavablock].y = r * tileSize;
					 Reg.lavablockPool[Reg.currentLavablock].onScreen = true;
					 Reg.lavablockPool[Reg.currentLavablock].animType = 0;
					 Reg.currentLavablock++;
					}	
					if (id == 12)
					{
					 Reg.coinsPool[Reg.currentCoin].x = c * tileSize + 3;
					 Reg.coinsPool[Reg.currentCoin].y = r * tileSize;
					 Reg.coinsPool[Reg.currentCoin].onScreen = true;
					 Reg.currentCoin++;
					}	
					if (id >= 18 && id<=21)
					{
					 Reg.turretPool[Reg.currentTurret].x = c * tileSize;
					 Reg.turretPool[Reg.currentTurret].y = r * tileSize;
					 Reg.turretPool[Reg.currentTurret].maxX = maxX;
					 Reg.turretPool[Reg.currentTurret].maxY = maxY;
					 Reg.turretPool[Reg.currentTurret].onScreen = true;
					 if (id == 18) Reg.turretPool[Reg.currentTurret].direction = Globals.FACING_DOWN;
					 if (id == 19) Reg.turretPool[Reg.currentTurret].direction = Globals.FACING_UP;
					 if (id == 20) Reg.turretPool[Reg.currentTurret].direction = Globals.FACING_RIGHT;
					 if (id == 21) Reg.turretPool[Reg.currentTurret].direction = Globals.FACING_LEFT;
					 Reg.currentTurret++;
					}	
					if (id >= 23 && id<=24)
					{
					 Reg.spikesPool[Reg.currentSpike].x = c * tileSize;
					 Reg.spikesPool[Reg.currentSpike].y = r * tileSize;
					 Reg.spikesPool[Reg.currentSpike].onScreen = true;
					 Reg.spikesPool[Reg.currentSpike].direction = id-23;
					 Reg.currentSpike++;
					}
					if (id == 9)
					{
					 Reg.heartPool[Reg.currentHeart].x = c * tileSize;
					 Reg.heartPool[Reg.currentHeart].y = r * tileSize;
					 Reg.heartPool[Reg.currentHeart].onScreen = true;
					 Reg.currentHeart++;
					}					
					if (id == 4)
					{
					 Reg.ghostPool[Reg.currentGhost].x = c * tileSize;
					 Reg.ghostPool[Reg.currentGhost].y = r * tileSize;
					 Reg.ghostPool[Reg.currentGhost].maxX = maxX;
					 Reg.ghostPool[Reg.currentGhost].maxY = maxY;
					 Reg.ghostPool[Reg.currentGhost].health = 50;
					 Reg.ghostPool[Reg.currentGhost].onScreen = true;
					 Reg.ghostPool[Reg.currentGhost].active = true;
					 Reg.currentGhost++;
					}				
					if (id == 5)
					{
					 Reg.checkpointPool[Reg.currentCheckpoint].x = c * tileSize;
					 Reg.checkpointPool[Reg.currentCheckpoint].y = (r * tileSize) - 5;
					 Reg.checkpointPool[Reg.currentCheckpoint].visited = false;
					 Reg.checkpointPool[Reg.currentCheckpoint].onScreen = true;
					 Reg.checkpointPool[Reg.currentCheckpoint].active = true;
					 Reg.currentCheckpoint++;
					}				
					if (id == 6)
					{
					 Reg.infopointPool[Reg.currentInfopoint].x = c * tileSize;
					 Reg.infopointPool[Reg.currentInfopoint].y = r * tileSize;
					 Reg.infopointPool[Reg.currentInfopoint].onScreen = true;
					 Reg.infopointPool[Reg.currentInfopoint].active = true;
					 Reg.infopointPool[Reg.currentInfopoint].nodeID = Reg.currentInfopoint;
					 Reg.currentInfopoint++;
					}					
					if (id == 10)
					{
					 Reg.waypointPool[Reg.currentWaypoint].x = c * tileSize;
					 Reg.waypointPool[Reg.currentWaypoint].y = r * tileSize;
					 Reg.waypointPool[Reg.currentWaypoint].onScreen = true;
					 Reg.waypointPool[Reg.currentWaypoint].active = true;
					 Reg.waypointPool[Reg.currentWaypoint].action = MIRRORX;
					 Reg.currentWaypoint++;
					}	
					if (id == 8)
					{
					 Reg.nanoShoes.x = c * tileSize;
					 Reg.nanoShoes.y = r * tileSize;
					 Reg.nanoShoes.onScreen = true;
					}	
					if (id == 13)
					{
					 Reg.exit.x = (c * tileSize) - 4;
					 Reg.exit.y = (r * tileSize) - 8;
					}

					tmpGrid[c][r] = typ;
				}
			}					
			
			for(r = 0; r < heightInTiles; r++)
			{
				cols = rows[r].split(",");
				for(c = 0; c < widthInTiles; c++)
				{
					grid[c][r] = uint(cols[c]);
				}
			}				
		}				
	}
}