package managers
{
	import flash.display.*;
	import flash.system.*;		
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.filters.*;	
	import flash.text.*;	
	import flash.system.*;	
	import flash.media.*;	
	import flash.ui.Mouse;
	import kernel.*;
	
	public class SoundEffectsManager
	{
		private var i:int;
		private var j:int;
		private var k:int;
		private var r:int;
		private var c:int;
		
		static public var transformSoundFx:SoundTransform = new SoundTransform(1, 0); // volume, pan
		static public var transformMusic:SoundTransform = new SoundTransform(1, 0); // volume, pan
		public var channel:SoundChannel;
		public var channel1:SoundChannel;
		public var channel2:SoundChannel;
		public var channel3:SoundChannel;
		public var channel4:SoundChannel;
		public var cooloff:int;
		public var currentChannel:int;
		public var channelArrays:Array = [channel1,channel2,channel3,channel4];

		//----------------------------------------------------------------------------------------
		// sfx
		//----------------------------------------------------------------------------------------

		[Embed(source="../audio/combo.mp3")] static public var scombo:Class;			
		static public var sndCombo:Sound = new scombo() as Sound; 

		[Embed(source="../audio/saucershoot.mp3")] static public var ssaucershoot:Class;			
		static public var sndSaucerShoot:Sound = new ssaucershoot() as Sound; 

		[Embed(source="../audio/turretshoot.mp3")] static public var sturretshoot:Class;			
		static public var sndTurretShoot:Sound = new sturretshoot() as Sound; 

		[Embed(source="../audio/soldiershoot.mp3")] static public var ssoldiershoot:Class;			
		static public var sndSoldierShoot:Sound = new ssoldiershoot() as Sound; 

		[Embed(source="../audio/levelstart.mp3")] static public var slstart:Class;			
		static public var sndLevelStart:Sound = new slstart() as Sound; 

		[Embed(source="../audio/sndrebound.mp3")] static public var sWC:Class;			
		static public var sndPistolWall:Sound = new sWC() as Sound; 
		
		[Embed(source="../audio/jump.mp3")] static public var sJ:Class;			
		static public var sndJump:Sound = new sJ() as Sound; 
		
		[Embed(source="../audio/bonustimer.mp3")] static public var sbtimer:Class;			
		static public var sndBonusTimer:Sound = new sbtimer() as Sound; 
		
		[Embed(source="../audio/bonustimerFinal.mp3")] static public var sbtimerAdd:Class;			
		static public var sndBonusTimerAdd:Sound = new sbtimerAdd() as Sound; 

		[Embed(source="../audio/collectShoes.mp3")] static public var sCollectShoes:Class;			
		static public var sndCollectShoes:Sound = new sCollectShoes() as Sound; 
			
		[Embed(source="../audio/suitDefense.mp3")] static public var sSuitDefense:Class;			
		static public var sndSuitDefense:Sound = new sSuitDefense() as Sound; 
		
		[Embed(source="../audio/suitHurt.mp3")] static public var sSuitHurt:Class;			
		static public var sndSuitHurt:Sound = new sSuitHurt() as Sound; 
			
		[Embed(source="../audio/runNormal.mp3")] static public var sRunNormal:Class;			
		static public var sndRunNormal:Sound = new sRunNormal() as Sound; 
			
		[Embed(source="../audio/runSuit.mp3")] static public var sRunSuit:Class;			
		static public var sndRunSuit:Sound = new sRunSuit() as Sound; 
	
		[Embed(source="../audio/hitExit.mp3")] static public var sHitExit:Class;			
		static public var sndHitExit:Sound = new sHitExit() as Sound; 
		
		[Embed(source="../audio/pressedContinue.mp3")] static public var sPressedContinue:Class;			
		static public var sndPressedContinue:Sound = new sPressedContinue() as Sound; 
		
		//[Embed(source="../audio/sndshoot.mp3")] static public var sL:Class;			
		[Embed(source="../audio/lazer.mp3")] static public var sL:Class;			
		static public var sndLaser:Sound = new sL() as Sound; 
		
		[Embed(source="../audio/bigLaser1.mp3")] static public var sLaserBig1:Class;			
		static public var sndBigLaser1:Sound = new sLaserBig1() as Sound; 
		[Embed(source="../audio/bigLaser2.mp3")] static public var sLaserBig2:Class;			
		static public var sndBigLaser2:Sound = new sLaserBig2() as Sound; 
		[Embed(source="../audio/bigLaser3.mp3")] static public var sLaserBig3:Class;			
		static public var sndBigLaser3:Sound = new sLaserBig3() as Sound; 
		[Embed(source="../audio/bigLaser4.mp3")] static public var sLaserBig4:Class;			
		static public var sndBigLaser4:Sound = new sLaserBig4() as Sound; 
		
		static public var bigLaserSounds:Array = [sndBigLaser1, sndBigLaser2, sndBigLaser3, sndBigLaser4];

		[Embed(source="../audio/powerup.mp3")] static public var sndPowerup:Class;			
		static public var sndPowerUp:Sound = new sndPowerup() as Sound; 
		
		[Embed(source="../audio/coin.mp3")] static public var sC:Class;			
		static public var sndCoin:Sound = new sC() as Sound; 

		[Embed(source="../audio/kill.mp3")] static public var sEp:Class;			
		static public var sndExplode:Sound = new sEp() as Sound; 
	
		[Embed(source="../audio/saucerkill.mp3")] static public var ssaucerkill:Class;			
		static public var sndExplodeSaucer:Sound = new ssaucerkill() as Sound; 
		
		[Embed(source="../audio/typing.mp3")] static public var stype:Class;			
		static public var sndType:Sound = new stype() as Sound; 
		
		[Embed(source="../audio/snakekill.mp3")] static public var ssnakekill:Class;			
		static public var sndExplodeSnake:Sound = new ssnakekill() as Sound; 
		
		[Embed(source="../audio/turretkill.mp3")] static public var sturretkill:Class;			
		static public var sndExplodeTurret:Sound = new sturretkill() as Sound; 
		
		[Embed(source="../audio/soldierkill.mp3")] static public var ssoldierkill:Class;			
		static public var sndExplodeSoldier:Sound = new ssoldierkill() as Sound; 

		[Embed(source="../audio/checkpoint.mp3")] static public var sCp:Class;			
		static public var sndCheckpoint:Sound = new sCp() as Sound; 
	
		[Embed(source="../audio/death.mp3")] static public var sDth:Class;			
		static public var sndDeath:Sound = new sDth() as Sound; 

		[Embed(source="../audio/hurt.mp3")] static public var sHurt:Class;			
		static public var sndHurt:Sound = new sHurt() as Sound; 
		
		[Embed(source="../audio/keycard.mp3")] static public var skeycard:Class;			
		static public var sndKeycard:Sound = new skeycard() as Sound; 
		
		[Embed(source="../audio/accessdenied.mp3")] static public var saccessdenied:Class;			
		static public var sndAccessdenied:Sound = new saccessdenied() as Sound; 
	
		[Embed(source="../audio/heartpickup.mp3")] static public var sHeart:Class;			
		static public var sndHeartpickup:Sound = new sHeart() as Sound; 

		[Embed(source="../audio/land.mp3")] static public var sLand:Class;			
		static public var sndLand:Sound = new sLand() as Sound; 

		[Embed(source="../audio/exit.mp3")] static public var sExit:Class;			
		static public var sndExit:Sound = new sExit() as Sound; 

		[Embed(source="../audio/grenade.mp3")] static public var sGrenade:Class;			
		static public var sndGrenade:Sound = new sGrenade() as Sound; 

		[Embed(source="../audio/grenadetoss.mp3")] static public var sGrenadetoss:Class;			
		static public var sndGrenadetoss:Sound = new sGrenadetoss() as Sound; 

		[Embed(source="../audio/grenadebounce.mp3")] static public var sGrenadebounce:Class;			
		static public var sndGrenadebounce:Sound = new sGrenadebounce() as Sound; 

		[Embed(source="../audio/walljump.mp3")] static public var sWalljump:Class;			
		static public var sndWalljump:Sound = new sWalljump() as Sound; 

		[Embed(source="../audio/wallslide.mp3")] static public var sWallslide:Class;			
		static public var sndWallslide:Sound = new sWallslide() as Sound; 

		[Embed(source="../audio/jumpSuit.mp3")] static public var sJumpsuit:Class;			
		static public var sndJumpSuit:Sound = new sJumpsuit() as Sound; 

		[Embed(source="../audio/landSuit.mp3")] static public var sLandsuit:Class;			
		static public var sndLandSuit:Sound = new sLandsuit() as Sound; 

		[Embed(source="../audio/bleep3.mp3")] static public var sBleep:Class;			
		static public var sndBleep:Sound = new sBleep() as Sound; 

		[Embed(source="../audio/spawnerExplode.mp3")] static public var sSpawnerExplode:Class;			
		static public var sndDestroySpawner:Sound = new sSpawnerExplode() as Sound; 

		[Embed(source="../audio/particleCollision.mp3")] static public var sParticleCollision:Class;			
		static public var sndParticleCollision:Sound = new sParticleCollision() as Sound; 

		
		// Themes
		
		//[Embed(source="../audio/introTheme.mp3")] static public var mIntro:Class;			
		//static public var musicIntro:Sound = new mIntro() as Sound; 		
			
		[Embed(source="../audio/nanoloop1.mp3")] static public var mNanoloop1:Class;			
		static public var musicNanoloop1:Sound = new mNanoloop1() as Sound; 		
			
		[Embed(source="../audio/nanoloop2.mp3")] static public var mNanoloop2:Class;			
		static public var musicNanoloop2:Sound = new mNanoloop2() as Sound; 		
		
		
		// Themes
		
		//[Embed(source="../audio/introTheme.mp3")] static public var mIntro:Class;			
		//static public var musicIntro:Sound = new mIntro() as Sound; 		
			
		//[Embed(source="../audio/gameTheme1.mp3")] static public var mLvl1:Class;			
		//static public var musicLevel1:Sound = new mLvl1() as Sound; 		
		
		public function SoundEffectsManager():void
		{						
			transformSoundFx.volume = 0.1;
			transformMusic.volume = 0.8;
			//Reg.sfxVol = Reg.musicVol = 1;
		}
		
		public function changeSfxVolume():void
		{
			transformSoundFx.volume = Reg.sfxVol;
			if (channelArrays[currentChannel] != null)
			{ 
				channelArrays[currentChannel].soundTransform = transformSoundFx; 
			}
		}		
		
		public function changeMusicVolume():void
		{
			transformMusic.volume = Reg.musicVol;
			//var transformMusic:SoundTransform=new SoundTransform(myVolume); 
			if (channel4 != null)
			{ 
				channel4.soundTransform = transformMusic; 
			}
   		}
		
		public function play(noiseToPlay:Sound):void
		{			
			currentChannel++;
			if (currentChannel > 3) currentChannel = 0;
			//if (cooloff == 0)
			//{
				//cooloff = 5;
				channelArrays[currentChannel] = noiseToPlay.play(45, 1, transformSoundFx); 
			//}
		}		
		
		public function playTheme(noiseToPlay:Sound):void
		{
			//channel4.stop();
			channel4 = noiseToPlay.play(45, 1000, transformMusic); 
		}
	}
}