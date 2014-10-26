package kernel 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.BitmapData;
	import gameobjects.*;
	import kernel.*;
	import managers.AudioOptionsManager;
	import managers.CollisionManager;
	import managers.DialogueManager;
	import managers.EnemyBulletManager;
	import managers.OptionsManager;
	import managers.ParticleManager;
	import managers.SoundEffectsManager;

	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	// The registry
	
	public class Reg
	{
		static public var MAP_WIDTH:int;
		
		static public var FIGHTING_BOSS:Boolean;
		static public var BOSSAPPEARS:Boolean;
		static public var BOSSTIMER:int;
		static public var enemiesKilled:int;
		static public var playerDeaths:int;
		static public var elapsedTime:int;
		static public var timeMinutes:int;
		static public var timeSeconds:int;
		static public var bonustimer:int;
		static public var totalBonus:int;
		static public var bonusCalc:int;
		static public var playerScore:int;
		static public var dialogueTimer:int;
		static public var dialogueIndex:int;
		static public var dialogueActive:Boolean;		
		static public var loadNewLevel:Boolean=true;		
		static public var leavingLevel:Boolean;		
	
		static public var gradientBackground:BitmapData;
		
		// Global volume control
		static public var musicVol:Number;
		static public var sfxVol:Number;
		
		// sprite pool counters
		static public var currentCoin:int = 0;
		static public var currentGhost:int = 0;
		static public var currentCheckpoint:int = 0;
		static public var currentInfopoint:int = 0;
		static public var currentWaypoint:int = 0;
		static public var currentLavablock:int = 0;
		static public var currentSaucer:int = 0;
		static public var currentSnake:int = 0;
		static public var currentSoldier:int = 0;
		static public var currentTurret:int = 0;
		static public var currentHeart:int = 0;
		static public var currentSpike:int = 0;
		static public var currentSpawner:int = 0;
		static public var currentSlope:int = 0;
		static public var currentCloud:int = 0;
		static public var currentSmoke:int = 0;
		static public var currentBird:int = 0;
		
		static public var mousePressed:Boolean;
		static public var quitPressed:Boolean;
		static public var currentFlashingBlock:int;
		static public var paused:Boolean;
		public var i:int;
		
		//----------------------------------------------------------------------------------------
		// Velocity caching

		static public var rotnCacheX				:Vector.<Number>=new Vector.<Number>();
		static public var rotnCacheY				:Vector.<Number>=new Vector.<Number>();
	
		//Single objects
		static public var player					:Player;	
		static public var exit						:Exit;	
		//static public var keycard					:Keycard;	
		static public var nanoShoes					:NanoShoes;	
		static public var particles					:ParticleManager;	
		static public var enemyBullets				:EnemyBulletManager;
		static public var renderer					:Renderer;
		static public var dialogue					:DialogueManager;
		static public  var maps						:Maps;
		static public  var reg						:Reg;
		static public  var sfx						:SoundEffectsManager;
		static public  var collisions				:CollisionManager;
		static public  var bitmaps					:Bmps;
		static public var options					:OptionsManager;
		static public var optionsAudio				:AudioOptionsManager;
		
		//Pools
		static public var playerBulletsPool			:Array=[];
		static public var ghostPool					:Array=[];
		static public var coinsPool					:Array=[];
		static public var particlesPool				:Array=[];
		static public var checkpointPool			:Array=[];
		static public var infopointPool				:Array=[];
		static public var waypointPool				:Array=[];
		static public var lavablockPool				:Array=[];
		static public var playerGrenadePool			:Array=[];
		static public var saucerPool				:Array=[];
		static public var enemyBulletPool			:Array=[]; // shot by saucers
		static public var soldierBulletPool			:Array=[]; // shot by soldiers
		static public var turretBulletPool			:Array=[]; // shot by turrets
		static public var heartPool					:Array=[];
		static public var scorePool					:Array=[];
		static public var turretPool				:Array=[];
		static public var spikesPool				:Array=[];
		static public var soldierPool				:Array=[];
		static public var explosionPool				:Array=[];
		static public var flashingBlockPool			:Array=[];
		static public var spawnerPool				:Array=[];
		static public var slopePool					:Array=[];
		static public var cloudPool					:Array=[];
		static public var parallaxLayer1Pool		:Array=[];
		static public var smokePool					:Array=[];
		static public var birdPool					:Array=[];
		
		//----------------------------------------------------------------------------------------
		// All data objects
	
		static public var singleGameObjects			:Array = [];
		static public var pooledGameObjects			:Array = [];
		static public var pooledGameTiles			:Array = [];
		static public var enemyGroup				:Array = [];
		static public var hudItems					:Array = [];
		
		public function Reg():void
		{
			
			
		}
		
		static public function init():void {
			
			player = new Player();	
			exit = new Exit();
			//keycard = new Keycard();
			nanoShoes = new NanoShoes();
			enemyBullets = new EnemyBulletManager();
			renderer = new Renderer();
			dialogue = new DialogueManager();
			maps = new Maps();
			sfx = new SoundEffectsManager();
			collisions = new CollisionManager();
			particles = new ParticleManager();
			bitmaps = new Bmps();
			options = new OptionsManager();
			optionsAudio = new AudioOptionsManager();
						
			// ROTATION MOVEMENT CACHING
			for (var ctr:int=0;ctr<361;ctr++) 
			{
				rotnCacheX.push(Math.cos(2.0*Math.PI*(ctr-90)/360.0));
				rotnCacheY.push(Math.sin(2.0*Math.PI*(ctr-90)/360.0));	
			}
			
			var i:int;
			
			for (i = 0; i < Globals.MAX_CHECKPOINTS; i++)		{ checkpointPool.push(new Checkpoint()); }
			for (i = 0; i < Globals.MAX_INFOPOINTS; i++)		{ infopointPool.push(new Infopoint()); }
			for (i = 0; i < Globals.MAX_WAYPOINTS; i++)			{ waypointPool.push(new Waypoint()); }
			
			for (i = 0; i < Globals.MAX_PLAYER_BULLETS; i++)	{ playerBulletsPool.push(new Bullet()); }
			for (i = 0; i < Globals.MAX_PLAYER_GRENADES; i++)	{ playerGrenadePool.push(new Grenade()); }

			for (i = 0; i < Globals.MAX_ENEMY_BULLETS; i++)		{ enemyBulletPool.push(new EnemyBullet());}
			for (i = 0; i < Globals.MAX_ENEMY_BULLETS; i++)		{ soldierBulletPool.push(new SoldierBullet());}
			for (i = 0; i < Globals.MAX_ENEMY_BULLETS; i++)		{ turretBulletPool.push(new TurretBullet()); }
			
			for (i = 0; i < Globals.MAX_COINS; i++)				{ coinsPool.push(new Coin()); }
			for (i = 0; i < Globals.MAX_HEARTS; i++)			{ heartPool.push(new Heart());}

			for (i = 0; i < Globals.MAX_PARTICLES; i++)			{ particlesPool.push(new Particle()); }
			for (i = 0; i < Globals.MAX_SCORES; i++)			{ scorePool.push(new Score());}

			for (i = 0; i < Globals.MAX_TURRETS; i++)			{ turretPool.push(new Turret());}
			for (i = 0; i < Globals.MAX_LAVABLOCKS; i++)		{ lavablockPool.push(new Lavablock()); }
			for (i = 0; i < Globals.MAX_SPIKES; i++)			{ spikesPool.push(new Spikes());}

			for (i = 0; i < Globals.MAX_ENEMYS; i++)			{ soldierPool.push(new Soldier());}
			for (i = 0; i < Globals.MAX_ENEMYS; i++)			{ saucerPool.push(new Saucer(rotnCacheX, rotnCacheY)); }
			for (i = 0; i < Globals.MAX_ENEMYS; i++)			{ ghostPool.push(new Ghost()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ explosionPool.push(new Explosion()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ flashingBlockPool.push(new FlashingBlock()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ spawnerPool.push(new Spawner()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ slopePool.push(new Slope()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ smokePool.push(new Smoke()); }
			for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ birdPool.push(new Bird()); }
			//for (i = 0; i < Globals.MAX_EXPLOSIONS; i++)		{ parallaxLayer1Pool.push(new ParallaxTile()); }
			
			parallaxLayer1Pool.push(new ParallaxTile(0, 0));
			parallaxLayer1Pool.push(new ParallaxTile(415, 0));
			parallaxLayer1Pool.push(new ParallaxTile(415*2, 0));
			parallaxLayer1Pool.push(new ParallaxTile(415*3, 0));
			
			cloudPool.push(new Cloud(1, 825, 30));
			cloudPool.push(new Cloud(2, 900, 60));
			cloudPool.push(new Cloud(1, 200, 90));
			cloudPool.push(new Cloud(2, 400, 120));
			cloudPool.push(new Cloud(1, 600, 150));
			cloudPool.push(new Cloud(2, 600, 180));
			cloudPool.push(new Cloud(1, 600, 210));
			cloudPool.push(new Cloud(2, 600, 240));

			singleGameObjects			=  [
											player,
											exit,
											nanoShoes
											];
											
			enemyGroup					=  [
											ghostPool,
											saucerPool,
											soldierPool
											];
		
			pooledGameObjects		 	=  [coinsPool,
											heartPool,
											scorePool,
											flashingBlockPool,
											particlesPool,
											checkpointPool,
											infopointPool,
											waypointPool,
											lavablockPool,
											turretPool,
											spikesPool,
											soldierPool,
											ghostPool,
											saucerPool,
											playerGrenadePool,
											playerBulletsPool,
											enemyBulletPool,
											soldierBulletPool,
											turretBulletPool,
											explosionPool,
											spawnerPool,
											slopePool,
											cloudPool,
											parallaxLayer1Pool,
											smokePool,
											birdPool
											];

		}		
	}
}