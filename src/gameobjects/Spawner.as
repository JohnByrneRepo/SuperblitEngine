package gameobjects 
{
	import kernel.Bmps;
	import kernel.Globals;
	import kernel.Reg;
	
	/**
	 * ...
	 * @author
	 * Barnaby Byrne
	 */
	
	public class Spawner extends GameObject
	{
		public var spawnFrequency:int;
		public var spawnTimer:int;
		public var spawnType:String;
		public var isSpawning:Boolean;
		public var maxedOut:Boolean;
		
		public function Spawner() {
			width = Bmps.spawnerBmpdata.height;
			height = Bmps.spawnerBmpdata.height;
			leftBound = upBound = 0;
			rightBound = downBound = Bmps.spawnerBmpdata.height;
			bmd = Bmps.spawnerBmpdataArray[0];
			spawnFrequency = 5;
			scorePoints = 5000;
			type = Globals.OBJTYPE_SPAWNER;
		}
		
		override public function spawnParticles():void{	
			Reg.particles.spawnParticles(15, ctrX, ctrY, "Yellow", 4, 6);
			onScreen = false;
			x = -4000;
		}
		
		override public function update():void {
			if (!onScreen ) return;
			spawnTimer++;
			animFrame = 0;
			if (spawnTimer >= spawnFrequency * 5 && spawnTimer < spawnFrequency * 6) animFrame = 1;
			else if (spawnTimer >= spawnFrequency * 6 && spawnTimer < spawnFrequency * 7) animFrame = 2;
			else if (spawnTimer >= spawnFrequency * 7 && spawnTimer < spawnFrequency * 8) animFrame = 3;
			else if (spawnTimer >= spawnFrequency * 8 && spawnTimer < spawnFrequency * 10) animFrame = 3;
			else if (spawnTimer > spawnFrequency * 10 && spawnTimer < spawnFrequency * 11) animFrame = 2;
			else if (spawnTimer > spawnFrequency * 11 && spawnTimer < spawnFrequency * 12) animFrame = 1;
			else if (spawnTimer > spawnFrequency * 12 && spawnTimer < spawnFrequency * 13) animFrame = 0;
			else if (spawnTimer > spawnFrequency * 20) spawnTimer = 0;
			if (spawnTimer == spawnFrequency * 9) spawn();
			if (flashing) animFrame += 4;
			if (maxedOut) animFrame = 0;
			bmd = Bmps.spawnerBmpdataArray[animFrame];
			super.update();
		}
		
		public function spawn():void {
			// Dont spawn if already 5 enemies in proximity
			var enemyCount:int = 0;
			maxedOut = false;
			for (i = 0; i < Reg.ghostPool.length; i++) {
				if (Math.abs(Reg.ghostPool[i].x - x) < 200 && Math.abs(Reg.ghostPool[i].y - y) < 200) {
					enemyCount++;
				}
			}
			for (j = 0; j < Reg.soldierPool.length; j++) {
				if (Math.abs(Reg.soldierPool[j].x - x) < 200 && Math.abs(Reg.soldierPool[j].y - y) < 200) {
					enemyCount++;
				}
			}
			if (enemyCount > 5) { maxedOut = true; return; }
			if (Math.abs(Reg.player.ctrX - ctrX) > 400 || Math.abs(Reg.player.ctrY - ctrY) > 300 ) return;
			if (spawnType == "DumbEnemy") {		
				var g:Ghost = Reg.ghostPool[Reg.currentGhost];
				g.x = ctrX - (g.width / 2);
				g.y = ctrY - (g.height / 2);
				if (Reg.player.x > x) g.direction = Globals.FACING_RIGHT;
				else if (Reg.player.x <= x) g.direction = Globals.FACING_LEFT;
				if (++Reg.currentGhost > Globals.MAX_ENEMYS - 1) Reg.currentGhost = 0;					 
				g.onScreen = true;
				g.currentstep = 0;
				g.timeSinceShot = 0;
				g.health = 50;
			} else if (spawnType == "ShootingEnemy") {		
				var s:Soldier = Reg.soldierPool[Reg.currentSoldier];
				s.x = ctrX - (s.width / 2);
				s.y = ctrY - (s.height / 2);
				if (Reg.player.x > x) s.direction = Globals.FACING_RIGHT;
				else if (Reg.player.x <= x) s.direction = Globals.FACING_LEFT;
				if (++Reg.currentSoldier > Globals.MAX_ENEMYS - 1) Reg.currentSoldier = 0;					 
				s.onScreen = true;
				s.currentstep = 0;
				s.timeSinceShot = 0;
				s.health = 50;
			} 
			//g.spawnerOwnerId = currentGhost;
		}
	}
}