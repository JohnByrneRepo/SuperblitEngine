package managers 
{
	import flash.display.BitmapData;
	import gameobjects.*;
	import kernel.*;
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class ParticleManager
	{
		public var cooloff:int;
		public var currentParticle:int;
		public var maxX:int;
		public var maxY:int;
		
		public var tiles:Tilemap;
		public var sfx:SoundEffectsManager;
		public var heightForHorizontalTest:int = 0;
		
		// Misc
		private var i:int;
		private var j:int;
		private var k:int;
		private var r:int;
		private var c:int;
		
		// For object to object collisions
		private var o1x1:int;
		private var o1x2:int;
		private var o1y1:int;
		private var o1y2:int;
		private var o2x1:int;
		private var o2x2:int;
		private var o2y1:int;
		private var o2y2:int;
				
		// For object to tilemap collisions
		private var x1:int;
		private var x2:int;
		private var x3:int;
		private var y1:int;
		private var y2:int;
		private var y3:int;
		private var y4:int;
	
		private var lBound:int;
		private var rBound:int;
		private var uBound:int;
		private var dBound:int;
	
		public var rend:Renderer = new Renderer();
		
		public function ParticleManager() 
		{
		}
		
		public function shimmer():void 
		{
			for (i = 0; i < 30; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES - 1) currentParticle = 0;				
				//Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].type = Globals.OBJTYPE_PARTICLEBEAM;
				Reg.particlesPool[currentParticle].shimmerCount = 0;
				Reg.particlesPool[currentParticle].x = Reg.player.ctrX + (Math.random()*40 - 20) + 20;
				Reg.particlesPool[currentParticle].y = Reg.player.ctrY + (Math.random()*50 - 25) - 20;
				Reg.particlesPool[currentParticle].dirX = 0;			
				Reg.particlesPool[currentParticle].xv = 0;
				Reg.particlesPool[currentParticle].yv = -1;
				Reg.particlesPool[currentParticle].maxX = maxX;
				Reg.particlesPool[currentParticle].maxY = maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 150 + 40;
				Reg.particlesPool[currentParticle].onScreen = true;
				//createVerticalColumn(Reg.particlesPool[currentParticle].x, Reg.particlesPool[currentParticle].y);
			}			
		}		
		
		/*public function scoreBreakdownBackground():void 
		{
			for (i = 0; i < 150; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES - 1) currentParticle = 0;				
				//Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].type = Globals.OBJTYPE_SCOREBREAKDOWN;
				Reg.particlesPool[currentParticle].shimmerCount = 0;
				var lvlCompleteBackgroundX:int = (825 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2);
				var lvlCompleteBackgroundY:int = (490 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2);
				var lvlCompleteBackgroundSize:int = Bmps.lvlcompletePaneBmpdata.width;
				Reg.particlesPool[currentParticle].x = 500;// lvlCompleteBackgroundX + Math.random() * lvlCompleteBackgroundSize;
				Reg.particlesPool[currentParticle].y = 200;// lvlCompleteBackgroundY + Math.random() * lvlCompleteBackgroundSize;
				Reg.particlesPool[currentParticle].dirX = 0;			
				Reg.particlesPool[currentParticle].xv = 0;
				Reg.particlesPool[currentParticle].yv = -1;
				Reg.particlesPool[currentParticle].maxX = maxX;
				Reg.particlesPool[currentParticle].maxY = maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 150 + 40;
				Reg.particlesPool[currentParticle].onScreen = true;
				//createVerticalColumn(Reg.particlesPool[currentParticle].x, Reg.particlesPool[currentParticle].y);
			}			
		}*/
		
		public function scoreBreakdownBackground():void 
		{
			for (i = 0; i < 150; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES - 1) currentParticle = 0;				
				//Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].type = Globals.OBJTYPE_SCOREBREAKDOWN;
				Reg.particlesPool[currentParticle].shimmerCount = 0;
				var lvlCompleteBackgroundX:int = (825 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2);
				var lvlCompleteBackgroundY:int = (490 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2);
				var lvlCompleteBackgroundSize:int = Bmps.lvlcompletePaneBmpdata.width;
				//Reg.particlesPool[currentParticle].x = Reg.player.ctrX + 3 + (Math.random()*360 - 180);
				Reg.particlesPool[currentParticle].x = lvlCompleteBackgroundX + Math.random() * (lvlCompleteBackgroundSize - 20);
				//Reg.particlesPool[currentParticle].y = Reg.player.ctrY + (Math.random()*280 - 140);
				Reg.particlesPool[currentParticle].y = lvlCompleteBackgroundY + Math.random() * (lvlCompleteBackgroundSize - 5);
				Reg.particlesPool[currentParticle].dirX = 0;			
				Reg.particlesPool[currentParticle].xv = 0;
				Reg.particlesPool[currentParticle].yv = -1 - (Math.random() * 6);
				Reg.particlesPool[currentParticle].maxX = maxX;
				Reg.particlesPool[currentParticle].maxY = maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 150 + 40;
				Reg.particlesPool[currentParticle].onScreen = true;
				//createVerticalColumn(Reg.particlesPool[currentParticle].x, Reg.particlesPool[currentParticle].y);
			}			
		}
		
		
		/*
		public function createVerticalColumn(x:int, y:int):void {
			for (i = 0; i < 10; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES - 1) currentParticle = 0;				
				//Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].type = Globals.OBJTYPE_PARTICLEBEAM;
				Reg.particlesPool[currentParticle].shimmerCount = 0;
				Reg.particlesPool[currentParticle].x = x;
				Reg.particlesPool[currentParticle].y = y - i;
				Reg.particlesPool[currentParticle].dirX = 0;			
				Reg.particlesPool[currentParticle].xv = 0;
				Reg.particlesPool[currentParticle].yv = -1;
				Reg.particlesPool[currentParticle].maxX = maxX;
				Reg.particlesPool[currentParticle].maxY = maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 150 + 40;
				Reg.particlesPool[currentParticle].onScreen = true;
			}			
		}
		*/
		public function spawnParticles(parts:int,xpos:int,ypos:int,colr:String, xv:int, yv:int, dir:int=0):void 
		{
			// SpawnParticles
			//for (i = 0; i < parts; i++)
			for (i = 0; i < 100; i++)
			{
				currentParticle++;
				if (currentParticle > Globals.MAX_PARTICLES - 1) currentParticle = 0;				
				Reg.particlesPool[currentParticle].color = colr;
				Reg.particlesPool[currentParticle].type = Globals.OBJTYPE_PARTICLE;
				Reg.particlesPool[currentParticle].x = xpos;
				Reg.particlesPool[currentParticle].y = ypos;
				Reg.particlesPool[currentParticle].MAX_FALL_SPEED = Math.random() * 25 + 3;
				Reg.particlesPool[currentParticle].dirX = Math.random() * xv - (xv/2);
				if(dir==1) Reg.particlesPool[currentParticle].dirX = Math.random() * xv;
				if(dir==2) Reg.particlesPool[currentParticle].dirX = Math.random() * -xv;
				Reg.particlesPool[currentParticle].dirX = Math.random() * 20 - 10;
				Reg.particlesPool[currentParticle].dirY = Math.random() * 20 - 10;				
				Reg.particlesPool[currentParticle].xv = Math.random() * 20 - 10;
				Reg.particlesPool[currentParticle].yv = Math.random() * 20 - 10;
				Reg.particlesPool[currentParticle].bounceCount = Math.random() * 8;
				//Reg.particlesPool[currentParticle].bounceForce = Math.random()*yv;
				Reg.particlesPool[currentParticle].bounceForce = Math.random()*20 + 5;
				Reg.particlesPool[currentParticle].maxX = maxX;
				Reg.particlesPool[currentParticle].maxY = maxY;
				Reg.particlesPool[currentParticle].animFrame = 0;
				Reg.particlesPool[currentParticle].lifeTime = Math.random() * 150 + 40;
				Reg.particlesPool[currentParticle].onScreen = true;
				Reg.particlesPool[currentParticle].bounce();
			}
		}
	}
}