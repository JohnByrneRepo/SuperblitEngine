package gameobjects 
{
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	import kernel.*;
	import managers.*;
	
	import flash.display.BitmapData;	
	
	public class Saucer extends GameObject
	{
		public var temp:int=1;
		public var currentEnemyBullet:int=0;

		private const SCROLL_SPEED:int=4;
		private const PLAYER_SPEED:int=6;
		private const JUMP_SPEED:Number=6.3;
		private const GRAVITY_SPEED:Number=0.28;
		private const MAX_FALL_SPEED:int=4;
		private const MAX_PLAYER_SPEED:int = 32;
		
		private var jumpTimer:int = 0;
	
		public function Saucer(ROTATIONSX:Vector.<Number>,ROTATIONSY:Vector.<Number>) 
		{
			type = Globals.OBJTYPE_SAUCER;
			direction = Globals.FACING_RIGHT;
			width				= 25;
			height				= 25;
			leftBound			= 2;
			rightBound			= 22;
			upBound				= 8;
			downBound			= 16;
			onScreen = false;
			x = -2000;
			direction = Globals.FACING_LEFT;
			//x = -2000;
			_rotnCacheX=ROTATIONSX;
			_rotnCacheY=ROTATIONSY;
			targetlengths=[90,90,90,90];	
			targets=[10,11,12,13];		
			currentstep = 0;
			shotFrequency = 150;
			flashing = false;
			scorePoints = 2000;
			bmd = new BitmapData(width, height, true, 0x00000000);
		}			
		
		override public function spawnParticles():void
		{	
			var xp:int;
			if (direction == 0) xp = -4;
			if (direction == 1) xp = 4;
			Reg.particles.spawnParticles(15, ctrX + xp, ctrY, "Yellow", 4, 6);
			onScreen = false;
			x = -4000; y = -2000;
			dirX = 0;
		}
		
		override public function update():void
		{	
			if (x < 0 || y < 0) { onScreen = false; x = -6000; dirX = dirY = 0; }
			if( x > maxX - 25 || y > maxY - 25) { onScreen = false; x = -8000; dirX = dirY = 0; }
			if (!onScreen) return;
			
			bmd = Bmps.saucerBmpdataArray[animFrame];
			
			if (flashing)
			{
				if (++flashTimer > 40)
				{
					flashing = false;
				}
			}
			if (++timeSinceShot > shotFrequency)
			{
				if (++attackMode > 1) attackMode = 0;
				timeSinceShot = 0;
				shoot();
			}
			animTime++;
			if (animTime > 5)
			{
				animTime = 0;
				animFrame++;
				if (animFrame > 4) animFrame = 0;
			}
			if (flashing) animFrame += 5;
			if (animFrame > 9) animFrame-= 5;
			
			//if(xpos<0) return;
			mvctr+=1;
			distancethisstep++;		
			if(distancethisstep>=targetlengths[currentstep])
			{
				step=currentstep++;
				mvctr=distancethisstep=0;
			}
			temp=((distancethisstep/targetlengths[currentstep])*qucircle);
			if (currentstep > 3) currentstep = 0;
			if(targets[currentstep]==4)
			{
				xpos-=1;
				angle=0;
			}
			else if(targets[currentstep]==5)
			{
				xpos+=1;	
				angle=90;
			}
			else if(targets[currentstep]==6)
			{
				ypos+=2;						
				angle=180;
			}	
			else if(targets[currentstep]==7)
			{
				//ypos-=1;	
				angle=270;
			}					
		   else if(targets[currentstep]==10)// q1 clockwise
		   { 
			temp+=hacircle; //*qucircle for cached values; +1 for 1st frame
			xpos+=_rotnCacheY[temp]; ypos+=(_rotnCacheX[temp]*-1)/2;    
		   }				  
		   else if(targets[currentstep]==11) // q2 clockwise
		   { 
			temp+=tqcircle; //*qucircle for cached values; +1 for 1st frame and 9 for quadrant2
			xpos+=_rotnCacheY[temp]; ypos+=(_rotnCacheX[temp]*-1)/2;       
		   }			  
		   else if(targets[currentstep]==12) // q3 clockwise
		   { 
			temp+=0; //*qucircle for cached values; +1 for 1st frame
			xpos+=_rotnCacheY[temp]; ypos+=(_rotnCacheX[temp]*-1)/2;    
		   }			
		   else if(targets[currentstep]==13)   // q4 clockwise
		   { 
			temp+=qucircle; //*qucircle for cached values; +1 for 1st frame and 9 for quadrant2
			xpos+=_rotnCacheY[temp]; ypos+=(_rotnCacheX[temp]*-1)/2;    
		   } 			  
		   else if(targets[currentstep]==14) // q1 anticlockwise
		   { 
			temp+=0; //*qucircle for cached values; +1 for 1st frame
			xpos+=_rotnCacheY[temp]; ypos+=_rotnCacheX[temp];        
		   }			   
		   else if(targets[currentstep]==15)// q2 anticlockwise
		   { 
			temp+=qucircle; //*qucircle for cached values; +1 for 1st frame and 9 for quadrant2
			xpos+=_rotnCacheY[temp]; ypos+=_rotnCacheX[temp];     
		   } 			  
		   else if(targets[currentstep]==16) // q3 anticlockwise
		   { 
			temp+=hacircle; //*qucircle for cached values; +1 for 1st frame
			xpos+=_rotnCacheY[temp]; ypos+=_rotnCacheX[temp];   
		   }			   
		   else if(targets[currentstep]==17)// q4 anticlockwise
		   { 
			temp+=tqcircle; //*qucircle for cached values; +1 for 1st frame and 9 for quadrant2
			xpos+=_rotnCacheY[temp]; ypos+=_rotnCacheX[temp];   
		   }    			   
		   if ((targets[currentstep]==10) || (targets[currentstep]==11))   {angle=180+temp+qucircle;}   if(angle>(fucircle-1)){angle-=(fucircle-1);}
		   if ((targets[currentstep]==12) || (targets[currentstep]==13))   {angle=180+temp+qucircle;}   if(angle>(fucircle-1)){angle-=(fucircle-1);}
		   if ((targets[currentstep]==14) || (targets[currentstep]==15))   {angle=180+qucircle-temp;}   if(angle<0){angle+=(fucircle-1);}
		   if ((targets[currentstep]==16) || (targets[currentstep]==17))   {angle=180+qucircle-temp;}   if(angle<0){angle+=(fucircle-1);}
			if(angle>(fucircle-1)){angle-=(fucircle-1);}   
			if(angle<0)angle+=360;
			//if(angle>360)angle-=360;
			x = xpos;
			y = ypos;
			ctrX = xpos + ((rightBound - leftBound) / 2);
			ctrY = ypos + ((downBound - upBound) / 2);
		}
		
		public function shoot():void
		{
					if ((Math.abs(x - Reg.player.x) < 320) && (Math.abs(y - Reg.player.y) < 240)) 
				sfx.play(SoundEffectsManager.sndSaucerShoot);
			if (Math.abs(Reg.player.x - x) < 320 && Math.abs(Reg.player.y - y) < 240)
			{
				for (i = 0; i < 20; i++)
				{
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].x = ctrX-2;
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].y = ctrY-2;
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].onScreen = true;
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].dirX = Reg.rotnCacheX[i * 18];
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].dirY = Reg.rotnCacheY[i * 18];
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].maxX = maxX;
					Reg.enemyBulletPool[Reg.enemyBullets.currentEnemyBullet].maxY = maxY;
					Reg.enemyBullets.currentEnemyBullet++;
					if (Reg.enemyBullets.currentEnemyBullet > Reg.enemyBulletPool.length - 1) Reg.enemyBullets.currentEnemyBullet = 0;
				}
			}
		}
	}
}		