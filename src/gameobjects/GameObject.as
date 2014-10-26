package gameobjects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import managers.SoundEffectsManager;
	
	import kernel.*;
	import managers.*;
		
	/**
	 * ...
	 * @author Barnaby Byrne
	 */	

	// Base class for all game objects
	
	// Player
	// Bullet
	// Explosion
	// Particle
	// Enemy
	
	public class GameObject 
	{	
		public var slopeType:String;
		public var sfx:SoundEffectsManager = new SoundEffectsManager();
		public var released:int;
		public var noKilled:int;
		public var spawnedParticles:Boolean;
		public var bmd:BitmapData;
		public var bmdOriginal:BitmapData;
		public var i:int, j:int, k:int;
		public var searchTimer:int;
		public var distToPlayerX:int;
		public var distToPlayerY:int;
		public var nodeID:int;
		public var onExit:Boolean;
		public var scoreString:String;
		public var scorePoints:int;
		public var fadeAmount:int;
		public var fadeTimer:int;
		public var health:int=100;
		public var timeSinceJumped:int;
		public var timeSinceShot:int;
		public var attackMode:int;
		public var shotFrequency:int;
		public var targets:Array = [];
		public var targetlengths:Array = [];
		public var flashing:Boolean;		
		public var flashTimer:int;		
		public var init:Boolean;		
		public var xpos:Number=0;
		public var ypos:Number=0;
		public var distancethisstep:int=0;
		public var mvctr:int=0;
		public var graphic:int;		
		public var currentstep:int;		
		public var testedExplode:Boolean;
		public var playedExplode:Boolean;
		public var radians:Number;
		public var radius:Number=0.05;	
		// ROTATION MOVEMENT CACHING
		public var rotateframes:int=360;
		public var qucircle:int=rotateframes/4;
		public var hacircle:int=rotateframes/2;
		public var tqcircle:int=qucircle+hacircle;
		public var fucircle:int=rotateframes;
		public var step:int=0;
		public var rotinc:int=1;
		public var _rotnCacheX:Vector.<Number>=new Vector.<Number>();
		public var _rotnCacheY:Vector.<Number>=new Vector.<Number>();
		public var animTime:int = 0;
		public var onLava:Boolean;
		public var grenadePressed:Boolean;
		public var grenadeTime:Number;
		public var grenadeAnimTime:int = 0;
		public var throwingGrenade:Boolean;
		public var dying:Boolean;
		public var exiting:Boolean;
		//public var spawnParticles:Boolean;
		public var cooloff:int;
		public var bounceCount:int;
		public var wallBouncingTimer:int;
		public var onLeftWall:Boolean;
		public var onRightWall:Boolean;
		public var onRoof:Boolean;
		public var numParticles:int;
		public var action			:int = 0; // for waypoints
		public var walkTime			:int=0; 
		public var walkFrame		:int=0; 
		public var onLadder			:Boolean;
		public var state			:int = 0; 
		public var type				:int = 0; 
		public var direction		:int = 0; 
		public var dirX				:Number = 0;		
		public var dirY				:Number = 0;
		public var isColliding		:Boolean;
		public var onSlope			:Boolean; 
		public var onScreen			:Boolean=false;
		public var playerShooting	:Boolean;   
		public var jumpPressed		:Boolean;   
		public var pressingJump		:Boolean;   
		public var jumping			:Boolean;   
		public var jumpedOnce		:Boolean;   
		public var jumpedTwice		:Boolean;   
		public var blocked			:Boolean;   
		public var blockedUp			:Boolean;   
		public var blockedDown			:Boolean;   
		public var blockedLeft			:Boolean;   
		public var blockedRight			:Boolean;   
		public var jumpTime			:int=0;   
		public var gravity			:Number=8;
		public var jumpVelocity		:Number=0.0;
		public var onGround			:int = 1;
		public var animFrame		:int=0;
		public var canvasWidth		:int=0;
		public var canvasHeight		:int=0;
		public var width			:int=0;
		public var height			:int=0;
		public var leftBound		:int=0;
		public var rightBound		:int=0;		
		public var upBound			:int=0;
		public var downBound		:int=0;
		public var x				:Number=0;
		public var y				:Number=0;
		public var xv				:Number=0;
		public var yv				:Number=0;
		public var lifeTime			:int=0;	
		public var angle			:int=0;	
		public var objectType		:int=0;	
		public var active			:Boolean;	
		public var bmpData			:BitmapData;	
		public var bmpDataSheet		:Vector.<BitmapData>;	
		private var blitRect		:Rectangle=new Rectangle(0,0,0,0);
		private var point			:Point = new Point(0, 0);
		private	var sourceX			:int=0;    
		private	var sourceY			:int=0;
		public var ctrX:int=0;
		public var ctrY:int=0;
		public var color:String;
		public var visited:Boolean;
		//public var tilemap:Tilemap = new Tilemap();
		public var maxX:int=100000;
		public var maxY:int = 100000;
		public var spawnerOwnerId:int;
		
		public function GameObject():void
		{

		}		
		
		public function addAnimation(name:String, frames:Array):void
		{
					
		}
		
		public function collideLeft():void 
		{	
			
		}
		
		public function collideRight():void 
		{	
			
		}
		
		public function collideUp():void 
		{	
			
		}
		
		public function collideDown():void 
		{	
			
		}
		
		public function bounce():void 
		{		
			
		}
		
		public function shimmer():void 
		{		
			
		}	
		
		public function spawnParticles():void 
		{		
			x = -4000;
			onScreen = false;
		}		
		
		public function startParticles():void 
		{		
			x = -4000;
			onScreen = false;
		}
		
		public function explode():void
		{
		}
		
		public function update():void 
		{
			//if (!onScreen) return;
			ctrX = x + ((rightBound - leftBound) / 2);
			ctrY = y + ((downBound - upBound) / 2);
			//if (x < 0 || y < 0 || x > maxX || y > maxY)
			//{ x = -2000; onScreen = false; }
			if (flashing)
			{
				if (++flashTimer > 5)
				{
					flashing = false;
				}
			}	
		}
	}
}
