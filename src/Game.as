package  
{	
	/**
	 * @author Barnaby Byrne
	 */
	
	// GAME
	// Declares and initialises all game objects and managers.  Updates the objects, renderer, and collision manager
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.external.*;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.geom.*;
	import flash.filters.*;
	import flash.utils.Timer;
		
	import gameobjects.*;
	import kernel.*;
	import managers.*;	
 
	public class Game extends MovieClip
	{	
		public var spawnSmokeTimer:int;
		public var spawnBirdsTimer:int;
		public var runSoundCooloff:int;
		public var suitArmourActive:Boolean; // Suit takes 2 hits per energy block
		public var doubleTapTimer:int;
		public var dualityOp:int;
		public var previousMusicVolume:Number;
		public var previousSfxVolume:Number;
		public var quitButtonsX:int;
		public var quitButtonsY1:int;
		public var quitButtonsY2:int;
		public var currentTheme:int;
		public var currentExplosion:int;
		public var noKilled:int=0;
		public var bonus:int=0;
		public var thread:int=0
		public var STATE:int;
		public const MENUMAIN:int = 0;
		public const MENUCREDITS:int = 1;
		public const MAINLOOP:int = 2;
		public const MAININTRO:int = 3;
		public const MAINCOMPLETE:int = 4;
		public var statecooloff:int;		
		public var infoNo:int;
		public var fadeOutTimer:int = 10;
		public var fadeOutMax:int = 20;
		public var fadingOut:Boolean;
		public var playerDeath:Boolean;
		public var dialogueTimer:int;
		public var dialogueIndex:int;
		public var dialogueActive:Boolean;
		public const MIRRORX:int=0;
		public const MIRRORY:int=1;
		public var lvlStartTimer:int=100;
		public var deathTimer:int;		
		public var restartX:int;
		public var restartY:int;
		public var restartDir:int;
		private var parallaxtileMap:Tilemap;
		private var tileMap:Tilemap;
		private var tileMap2:Tilemap;
		private var bgtileMap:Tilemap;
		private var spritetileMap:Tilemap;
		private var tileMaps:Array = [];
		private var currentScoreSprite:int;
		private var fps:Number;
		private var last:uint = getTimer();
		private var ticks:uint = 0;	
		private var gameState:int = 0;
		private var keypressedTime:int = 0;
		public var aKeyPress:Array = [];
		private var difficulty:int;				
		private var paused:Boolean; 
		private var quitActive:Boolean; 
		private var pausedTimer:int; 
		private var i:int;
		private var j:int;
		private var k:int;
		public var myTimer:Timer = new Timer(1000);
		
		public function Game() 
		{	
			quitButtonsX = 367;
			quitButtonsY1 = 217;
			quitButtonsY2 = 272;
			//Mouse.hide();
			Reg.init();
			Reg.sfxVol = 0.1; 
			Reg.sfx.changeSfxVolume();
			Reg.musicVol = 0.2; 
			Reg.sfx.changeMusicVolume();
			//Reg.sfx.playTheme(SoundEffectsManager.musicNanoloop1);
			addChild(Reg.renderer);
			parallaxtileMap = new Tilemap();
			bgtileMap = new Tilemap();
			tileMap = new Tilemap();
			spritetileMap = new Tilemap();
			Reg.renderer.foregroundTiles = tileMap;
			Reg.renderer.tileMaps = tileMaps;
			tileMaps.push(parallaxtileMap);
			tileMaps.push(bgtileMap);			
			tileMaps.push(tileMap);
			Reg.MAP_WIDTH = tileMap.widthInTiles * Globals.TILE_SIZE;
			reloadLevel();			
			Reg.collisions.tiles = tileMap;
			Reg.player.tiles = tileMap;		
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			myTimer.start();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseIsDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseIsReleased);
			addEventListener(Event.DEACTIVATE, onFocusLost);
			addEventListener(Event.ACTIVATE, onFocus);		
			addEventListener(Event.ENTER_FRAME, Mainloop);
		}
		
		public function clickedInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2 && Reg.mousePressed) return true;
			else return false;
		}
				
		public function mouseIsInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2) return true;
			else return false;
		}			

		//--------------------------------------------------------------------
		// loadLevel
	
		public function reloadLevel():void
		{	
			Reg.player.score += Reg.bonusCalc;
			Reg.bonusCalc = 0;
			Reg.playerScore = 0;
			Reg.totalBonus = 0;
			Reg.elapsedTime = 0;
			Reg.timeMinutes = 0;
			Reg.timeSeconds = 0;
			Reg.enemiesKilled = 0;
			Reg.playerDeaths = 0;
			playerDeath = false;
			Reg.player.keyCollected = false;
			Reg.player.onLava = false;
			Reg.leavingLevel = false;
			lvlStartTimer = 10;
			Reg.renderer.screenWipeTimer = 20;
			clearSprites();
			Reg.player.level++;
			if (Reg.player.level >= 4) {
				STATE = MAINCOMPLETE;
				statecooloff = 0;
			} else {
				parallaxtileMap.loadMap(Reg.maps.parallaxMapsArray[Reg.player.level-1]);
				tileMap.loadMap(Reg.maps.mapsArray[Reg.player.level-1]);
				spritetileMap.loadSprites(Reg.maps.mapsArray2[Reg.player.level-1]);
				bgtileMap.loadMap(Reg.maps.mapsArray3[Reg.player.level-1]);
				Reg.player.x = restartX = spritetileMap.startX;
				Reg.player.y = restartY = spritetileMap.startY - 20;
			}
			restartDir = spritetileMap.startDir;
			Reg.player.exiting = false;			
			Reg.player.health = 5;
			Reg.player.keyCollected = false;
			Reg.collisions.maxX = Reg.player.maxX = tileMap.maxX;
			Reg.collisions.maxY = Reg.player.maxY = tileMap.maxY;			
			Reg.particles.maxX = Reg.player.maxX = tileMap.maxX;
			Reg.particles.maxY = Reg.player.maxY = tileMap.maxY;			
			Reg.collisions.tiles = tileMap;
			fadingOut = false;
			infoNo = 0;
			Reg.dialogue.keyboardEnableTimer = 0;
			Reg.leavingLevel = false;
			if (Reg.player.level == 1) {
				Reg.dialogue.dialogueActive = true;
				Reg.dialogue.messageNumber = 0;
				Reg.player.x = -2000;
			} else Reg.dialogue.dialogueActive = false;
			if (++currentTheme > 1) currentTheme = 0;
			//Reg.sfx.channel4.stop();
			/*switch (currentTheme) {
				case 0:
					Reg.sfx.playTheme(SoundEffectsManager.musicNanoloop1);
					break;
				case 1:
					Reg.sfx.playTheme(SoundEffectsManager.musicNanoloop2);
					break;
			}*/
			Reg.player.shoesCollected = false;
			Reg.player.suitActivated = false;
			Reg.player.jumping = false;
			Reg.player.pressingJump = false;
			Reg.player.onGround == 1;
			if (Reg.player.level == 1) Reg.gradientBackground = Bmps.gradientBackgroundBmpdata;
			else if (Reg.player.level == 2) Reg.gradientBackground = Bmps.gradientBackground2Bmpdata;
			else if (Reg.player.level == 3) Reg.gradientBackground = Bmps.gradientBackground3Bmpdata;
			trace("Finished reloading level");
		}
			
		//--------------------------------------------------------------------
		// clearSprites
	
		public function clearSprites():void
		{	
			for (i = 0; i < Reg.pooledGameObjects.length; i++)
			{
				for (j = 0; j < Reg.pooledGameObjects[i].length; j++)
				{
					if (Reg.pooledGameObjects[i][j].type == Globals.OBJTYPE_CLOUD) {
						Reg.pooledGameObjects[i][j].x = 825;
						Reg.pooledGameObjects[i][j].onScreen = true;
					}
					else {
						Reg.pooledGameObjects[i][j].x = -2000;
						Reg.pooledGameObjects[i][j].xpos = -2000;
						Reg.pooledGameObjects[i][j].onScreen = false;
						Reg.pooledGameObjects[i][j].animFrame = 0;
						Reg.pooledGameObjects[i][j].health = 100;
						Reg.pooledGameObjects[i][j].step = 0;
						Reg.pooledGameObjects[i][j].currentstep = 0;
						Reg.pooledGameObjects[i][j].distancethisstep = 0;
						Reg.pooledGameObjects[i][j].mvctr = 0;
						Reg.pooledGameObjects[i][j].flashing = false;
						Reg.pooledGameObjects[i][j].flashTimer = 0;
					}
				}
			}			
			for (i = 0; i < Reg.ghostPool.length; i++)
			{
				Reg.ghostPool[i].direction = Globals.FACING_LEFT;
				Reg.ghostPool[i].health = 250;	
			}			
			for (i = 0; i < Reg.soldierPool.length; i++)
			{
				Reg.soldierPool[i].direction = Globals.FACING_LEFT;
			}
			for (i = 0; i < Reg.enemyBulletPool.length; i++)
			{
				var e:EnemyBullet = Reg.enemyBulletPool[i];
				e.onScreen = false;
				e.x = -2000;
			}				
			for (i = 0; i < Reg.spikesPool.length; i++)
			{
				var s:Spikes = Reg.spikesPool[i];
				s.onScreen = false;
				s.x = -2000;
			}			
			for (i = 0; i < Reg.smokePool.length; i++)
			{
				var sm:Smoke = Reg.smokePool[i];
				sm.onScreen = true;
				sm.reset();
			}				
			for (i = 0; i < Reg.birdPool.length; i++)
			{
				var b:Bird = Reg.birdPool[i];
				b.onScreen = true;
				b.reset();
			}	
			for (i = 0; i < Reg.flashingBlockPool.length; i++) { Reg.flashingBlockPool[i].onScreen = true; }	
			for (i = 0; i < Reg.parallaxLayer1Pool.length; i++) { Reg.parallaxLayer1Pool[i].onScreen = true; }	
			for (i = 0; i < Reg.slopePool.length; i++) { Reg.slopePool[i].onScreen = false; Reg.slopePool[i].x = -2000; }	
			Reg.parallaxLayer1Pool[0].x = 0;
			Reg.parallaxLayer1Pool[1].x = 415;
			Reg.parallaxLayer1Pool[2].x = 415*2;
			Reg.parallaxLayer1Pool[3].x = 415*3;
		}

		//--------------------------------------------------------------------
		// Mainloop
	
		public function Mainloop(e:Event):void
		{
			Reg.renderer.mainCanvas.clear();
			if (statecooloff > 0) statecooloff--;
			
			if (STATE == MENUMAIN && statecooloff == 0)
			{
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.titleBmpdata, 0, 0);
				//Reg.renderer.updateStars();
				//Reg.renderer.renderStars();
				
				if (Reg.mousePressed)
				{
					//STATE = MAININTRO;
					STATE = MAINLOOP;
					Reg.player.level = 0;
					reloadLevel();
					update();
					statecooloff = 20;
				}
				//Reg.renderer.mainCanvas.blitAtPoint(Bmps.cursorBmpdata, mouseX + 15, mouseY);

			}
			else if (STATE == MAININTRO && statecooloff == 0)
			{	
				
			}
			else if (STATE == MAINLOOP && statecooloff == 0)
			{
				Reg.renderer.update();
				if (!Reg.paused && !quitActive)
				{
					//trace("Dialogue active ? " + Reg.dialogue.dialogueActive);
					if (Reg.dialogue.keyboardEnableTimer > 0) Reg.dialogue.keyboardEnableTimer--;
					if (Reg.dialogue.dialogueActive) showDialogue();
					else if (Reg.dialogue.keyboardEnableTimer == 0) { keyboardMove(); update(); }
				}
				else if (Reg.paused && !quitActive)
				{
					//Reg.renderer.update();
					Reg.options.update(mouseX, mouseY, Reg.mousePressed);
					pausedTimer++;
					fadeAlphaToMax(Reg.renderer.mainCanvas.backBufferData, 200, 50, 0);	
					ctrTxt("White", "...PAUSED...", 200);
				}
				
				// FPS counter
				if (lvlStartTimer > 0) ctrTxtBig("Any",  "LEVEL " + String(Reg.player.level), 100);
				if (lvlStartTimer > 0)
				{
					lvlStartTimer--;
					Reg.renderer.screenWipeTimer--;
				}	
				if (Reg.renderer.screenWipeTimer > 0) Reg.renderer.screenWipeTimer--;
				if (keypressedTime > 0) keypressedTime--;
				if (aKeyPress[Globals.PAUSE] && keypressedTime == 0) { Reg.paused = !Reg.paused; keypressedTime = 20; }
				if (aKeyPress[Globals.KEYQUIT] && keypressedTime == 0) { quitActive = !quitActive; keypressedTime = 20; Reg.quitPressed = true; }
					
				if (quitActive)
				{			
					fadeAlphaToMax(Reg.renderer.mainCanvas.backBufferData, 200, 50, 0);	
					
					Reg.renderer.mainCanvas.blitAtPoint(Bmps.optionsButtonUnpressedSmallBmpdata, quitButtonsX, quitButtonsY1);
					Reg.renderer.mainCanvas.blitAtPoint(Bmps.optionsButtonUnpressedSmallBmpdata, quitButtonsX, quitButtonsY2);
					
					if (mouseIsInRect(quitButtonsX - 10, quitButtonsY1, quitButtonsX + 92 - 10, quitButtonsY1 + 34)) {		
						Reg.renderer.mainCanvas.blitAtPoint(Bmps.optionsButtonPressedSmallBmpdata, quitButtonsX, quitButtonsY1);
						//ctrTxt("Options", "QUIT", quitButtonsY1 + 5);
						if (Reg.mousePressed) { 
							Reg.player.level = 0;
							Reg.paused = false; quitActive = false; STATE = MENUMAIN; statecooloff = 20; Reg.dialogue.dialogueActive = true;
						}
					} else if (mouseIsInRect(quitButtonsX - 10, quitButtonsY2, quitButtonsX + 92 - 10, quitButtonsY2 + 34)) {
						Reg.renderer.mainCanvas.blitAtPoint(Bmps.optionsButtonPressedSmallBmpdata, quitButtonsX, quitButtonsY2);
						//ctrTxt("Options", "CANCEL", quitButtonsY2 + 5);
						if (Reg.mousePressed) { quitActive = false; }
					}
					printTxt("White", "QUIT", quitButtonsX + 23, quitButtonsY1 + 10);
					printTxt("White", "CANCEL", quitButtonsX + 10, quitButtonsY2 + 10);

					//Reg.renderer.mainCanvas.blitAtPoint(Bmps.cursorBmpdata, mouseX, mouseY);
				}
				//printTxt("White", String(int(fps)) + " FPS", 750, 6);
				//var st:String = String(int(System.totalMemory / 1024));
				//st = st.substring(0, 2);
				//printTxt("White", st + " MB", 750, 38);
				if (!Reg.leavingLevel) ctrTxtBig("White", String(int(Reg.player.score)), 6);
			}
			else if (STATE == MAINCOMPLETE && statecooloff == 0)
			{
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.lvlCompleteBmpdata, 0, 0);
				printTxtCycle("Cycle", "CONGRATULATIONS!", 380, 100);
				printTxtBig("Green", "YOU HAVE SAVED", 390, 140);
				printTxtBig("Blue", "THE GALAXY!", 423, 170);
				printTxtBig("Yellow", "FOR MORE INFORMATION", 336, 200);
				printTxtBig("Purple", "VISIT WWW.CLARKS.CO.UK", 325, 230);
				printTxtBig("Red", "FINAL SCORE " + Reg.player.score, 380, 270);
				if (Reg.mousePressed) { statecooloff = 20; Reg.player.score = 0; STATE = MENUMAIN; }
			}
		}
				
		//--------------------------------------------------------------------
		// showDialogue
		
		public function showDialogue():void
		{	
			if (Reg.player.level > 1) return;
			Reg.dialogue.showDialogue(Reg.player.level, aKeyPress);
		}
			
		//--------------------------------------------------------------------
		// timerListener
		
		public function timerListener(e:TimerEvent):void
		{
			if(!Reg.leavingLevel && !Reg.paused) Reg.elapsedTime++;
		}
		
		//--------------------------------------------------------------------
		// update
		
		public function update():void
		{
			if (++spawnBirdsTimer > 200) {
				var sideOfScreen:int = Math.random() * 20;
				var yOff:int = Math.random() * 20;
				for (i = 0; i < 5; i++) {
					if (++Reg.currentBird > Globals.MAX_EXPLOSIONS - 5) Reg.currentBird = 0;
					var b:Bird = Reg.birdPool[Reg.currentBird + i];
					b.animFrame = Math.random() * 3;
					b.onScreen = true;
					if (sideOfScreen < 10) {
						// Horizontal flock spacing
						if (i == 0 || i == 1) b.x = 840;
						else if (i == 2 || i == 3) b.x = 850;
						else if (i == 4) b.x = 860;
						// Vertical flocking spacing
						b.y = yOff + 20 + (i * 10);
						b.xv = -1;
					} else if (sideOfScreen >= 10) {
						// Horizontal flock spacing
						if (i == 0 || i == 1) b.x = -40;
						else if (i == 2 || i == 3) b.x = -50;
						else if (i == 4) b.x = -60;
						// Vertical flocking spacing
						b.y = yOff + 20 + (i * 10);
						b.xv = 1;
					}
				}
				spawnBirdsTimer = 0 + Math.random() * 180;
			}			
			if (++spawnSmokeTimer > 200) {
				yOff = 400;
				var xOff:int = 200;// Math.random() * Globals.SCREEN_WIDTH;
				for (i = 0; i < 10; i++) {
					if (++Reg.currentSmoke > Globals.MAX_EXPLOSIONS - 10) Reg.currentSmoke = 0;
					var s:Smoke = Reg.smokePool[Reg.currentSmoke + i];
					s.animFrame = Math.random() * 3;
					s.x = xOff + Math.random() * 10 - 5;
					s.y = yOff + (i * (25 + Math.random() * 10 - 5));
					s.onScreen = true;
					s.yv = -0.4;
				}
				spawnSmokeTimer = 0 + Math.random() * 100;
			}
			doCollisions();
			if (Reg.renderer.mainCanvas.dialogueActive == true) { Reg.renderer.renderDialogue(); }		
			else { Reg.renderer.resetDialogue(); }	
			if (Reg.sfx.cooloff > 0) Reg.sfx.cooloff--;
			tick();
			Reg.player.update();
			//Reg.player.update();
			Reg.player.onScreen = true;
			screenShake();
			if (fadingOut)
			{
				if (fadeOutTimer < fadeOutMax) fadeOutTimer++;
				fadeAlphaToMax(Reg.renderer.mainCanvas.backBufferData, fadeOutMax, fadeOutTimer, 0);
				if (fadeOutTimer == 2 && Reg.player.exiting == false)
				{
					var xp:int = Reg.player.ctrX;
					var yp:int = Reg.player.ctrY;
					Reg.player.spawnParticles();	
				}
				else if (fadeOutTimer == fadeOutMax)
				{
					if (playerDeath)
					{		
						Reg.player.dying = false;
						Reg.player.x = restartX;
						Reg.player.y = restartY - 20;
						if (Reg.player.suitActivated) Reg.player.y -= 40;
						//Reg.player.direction = restartDir;
						fadingOut = false;
						lvlStartTimer = 10;
						Reg.renderer.screenWipeTimer = 10;
						playerDeath = false;
						Reg.player.onGround = 0;
						Reg.player.yv = 3;
						Reg.player.health = 5;
						return;
					}	
					reloadLevel();
				}
			}
			//trace("Leaving level? " + Reg.leavingLevel);
			if (Reg.leavingLevel) 
			{
				Reg.bonustimer += 2;
				if (Reg.bonustimer <10) Reg.particles.scoreBreakdownBackground();
				var paneloffst:int = 70;				
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.lvlcompletePaneBmpdata, (825 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2),  (490 / 2) - (Bmps.lvlcompletePaneBmpdata.width / 2));
				printTxtBig("Green", "STAGE CLEAR", 275, paneloffst + 4);
				if (Reg.bonustimer >= 150 && Reg.bonustimer % 20 > 10) printTxt("White", "PRESS X OR CLICK TO CONTINUE", 252, 412);		
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.clarkslogoBmpdata, (825 / 2) - (Bmps.clarkslogoBmpdata.width / 2), 328 - 40);		
				var yoff:int = paneloffst + 45;
				var xoffa:int = 260;
				var xoffb:int = 430;				
				
				if (Reg.enemiesKilled > 0)
				{
					if (Reg.bonustimer > 150 && Reg.bonustimer % 5 == 0)
					{
						if (Reg.enemiesKilled == 1) Reg.sfx.play(SoundEffectsManager.sndBonusTimerAdd);
						Reg.sfx.play(SoundEffectsManager.sndBonusTimer);
						Reg.enemiesKilled --;
						Reg.totalBonus += 100;
					}
				}					
				else if (Reg.timeMinutes > 0 || Reg.timeSeconds > 0)
				{
					if (Reg.bonustimer > 250 && Reg.bonustimer % 3 == 0)
					{
						Reg.sfx.play(SoundEffectsManager.sndBonusTimer);
						Reg.totalBonus -= 10;
						if (Reg.totalBonus < 0) Reg.totalBonus = 0;
						Reg.timeSeconds --;
						if (Reg.timeMinutes == 0 && Reg.timeSeconds == 1) Reg.sfx.play(SoundEffectsManager.sndBonusTimerAdd);
						if (Reg.timeSeconds < 0)
						{
							if (Reg.timeMinutes > 0)
							{Reg.timeMinutes--;
							Reg.timeSeconds = 60;}
						}
					}
				}				
				else if (Reg.playerDeaths > 0)
				{
					if (Reg.bonustimer>350 && Reg.bonustimer%10==0) 
					{
						Reg.sfx.play(SoundEffectsManager.sndBonusTimer);
						if (Reg.playerDeaths == 1) Reg.sfx.play(SoundEffectsManager.sndBonusTimerAdd);
						if (Reg.playerDeaths > 0)
						{
							Reg.playerDeaths --;
							Reg.totalBonus -= 1000;
							if (Reg.totalBonus < 0) Reg.totalBonus = 0;
						}
					}
				}				
				else if (Reg.totalBonus > 0)
				{
					if (Reg.bonustimer>450 && Reg.bonustimer%2==0) 
					{
						Reg.sfx.play(SoundEffectsManager.sndBonusTimer);
						Reg.playerScore += 10;
						Reg.totalBonus -= 10;
						if (Reg.totalBonus <= 0) Reg.sfx.play(SoundEffectsManager.sndBonusTimerAdd);
						if (Reg.totalBonus < 0) { Reg.playerScore-= Reg.totalBonus; Reg.totalBonus = 0; }
					}
				}			
				if (Reg.totalBonus < 0) Reg.totalBonus = 0;				
				if (Reg.player.score < 0) Reg.player.score = 0;
				if (Reg.playerScore < 0) Reg.playerScore = 0;

				Reg.renderer.mainCanvas.dialogueActive = false;
				
				//Reg.canvas.font1 = 0;
				printTxtBig("Blue",  "KILLS", xoffa, yoff); // , 2);
				if (Reg.enemiesKilled > -1) printTxtBig("Blue",  String(Reg.enemiesKilled), xoffb, yoff); // , 2);

				//Reg.canvas.font1 = 1;
				printTxtBig("Red", "TIME", xoffa, yoff + 30); // , 2);						
				if (Reg.timeSeconds < 10  && Reg.timeSeconds > -1) printTxtBig("Red", String(Reg.timeMinutes) + ".0" + String(Reg.timeSeconds), xoffb, yoff + 30); // , 2);
				if (Reg.timeSeconds >= 10) printTxtBig("Red", String(Reg.timeMinutes) + "." + String(Reg.timeSeconds), xoffb, yoff + 30); // , 2);
										
				//Reg.canvas.font1 = 4;
				printTxtBig("Yellow", "DEATHS", xoffa, yoff + 60); // , 2);						
				if (Reg.playerDeaths > -1) printTxtBig("Yellow", String(Reg.playerDeaths), xoffb, yoff + 60); // , 2);
				
			
				//Reg.canvas.font1 = 3;
				printTxtBig("Purple", "BONUS", xoffa, yoff + 90); // , 2);						
				if (Reg.totalBonus > -1) printTxtBig("Purple", String(Reg.totalBonus), xoffb, yoff + 90); // , 2);
				
				//Reg.canvas.font1 = 2;
				printTxtBig("Green", "SCORE", xoffa, yoff + 128); // , 2);						
				if (Reg.playerScore > 0 - 1) printTxtBig("Green", String(Reg.playerScore), xoffb, yoff + 128); // , 2);
			}

			if (Reg.player.shimmering) {
				Reg.player.shimmeringTimer++;
				Reg.particles.shimmer();
				if (Reg.player.shimmeringTimer > 5) {
					Reg.player.shimmeringTimer = 0;
					Reg.player.shimmering = false;
				}
			}
			
			// Update single game objects
			Reg.nanoShoes.update();
			Reg.exit.update();
			
			// Update pooled game objects
			for (i = 0; i < Reg.pooledGameObjects.length; i++)
			{
				for (j = 0; j < Reg.pooledGameObjects[i].length; j++)
				{
					if (Reg.pooledGameObjects[i][j].onScreen) { Reg.pooledGameObjects[i][j].update(); }
					if (Reg.pooledGameObjects[i][j].onScreen) { Reg.pooledGameObjects[i][j].update(); }
				}
			}
			
			for (i = 0; i < Reg.cloudPool.length; i++) {
				Reg.cloudPool[i].update();
			}
		}	
		
		//--------------------------------------------------------------------
		// fadeAlphaToMax
		
		private function fadeAlphaToMax(bmd:BitmapData,max:int,current:int,al:int):void 
		{	
			var matrix:Array = new Array();
			matrix=matrix.concat([1,0,0,0,0]);// red
			matrix=matrix.concat([0,1,0,0,0]);// green
			matrix=matrix.concat([0,0,1,0,0]);// blue
			matrix=matrix.concat([0,0,0,0.8*((max-current)/max),al]);// alpha						
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			bmd.applyFilter
			(bmd, bmd.rect, new Point(), my_filter);
		}		

		//--------------------------------------------------------------------
		// screenShake
		
		private function screenShake():void 
		{	
			if(Reg.renderer.mainCanvas.screenShake)
			{
				Reg.renderer.mainCanvas.screenShakeTimer--;
				if (Reg.renderer.mainCanvas.screenShakeTimer == 0)
				{
					Reg.renderer.mainCanvas.shakeoffsetx = 0;
					Reg.renderer.mainCanvas.shakeoffsety = 0;
					Reg.renderer.mainCanvas.screenShake = false;
				}				
				else if (Reg.renderer.mainCanvas.screenShakeTimer % 2 == 0)
				{
					Reg.renderer.mainCanvas.shakeoffsetx = Math.random()*10-5;
					Reg.renderer.mainCanvas.shakeoffsety = Math.random()*10-5;
				}
			} else return;
		}
		
		//--------------------------------------------------------------------
		// Reg.collisions
		
		private function doCollisions():void 
		{
			// FALL OFF SCREEN
			if (Reg.player.y > tileMap.maxY - 16)
			{
				Reg.player.y = tileMap.maxY - 16;
				Reg.player.health = 0;
				killPlayer();
			}

			Reg.player.onGround = 0;
			//collideSlopes(Reg.player, Reg.slopePool);
			Reg.collisions.tilemapCollisions(Reg.player);
			collide(Reg.soldierPool);
			collide(Reg.ghostPool);
			collide(Reg.particlesPool);
			collide(Reg.playerBulletsPool);
			collide(Reg.playerGrenadePool);
			collide(Reg.enemyBulletPool);
			collide(Reg.turretBulletPool);
			collide(Reg.soldierBulletPool);
	
			// SPRITE Reg.collisions
			overlapsRange(Reg.waypointPool, Reg.ghostPool, 5, 5);
			overlapsRange(Reg.waypointPool, Reg.soldierPool, 5, 5);			
			overlapsRange(Reg.playerBulletsPool, Reg.ghostPool, 5, 5);
			overlapsRange(Reg.playerBulletsPool, Reg.soldierPool, 5, 5);
			overlapsRange(Reg.playerBulletsPool, Reg.spawnerPool, 5, 5);
			overlapsRange(Reg.playerGrenadePool, Reg.soldierPool, 5, 5);
			overlapsRange(Reg.playerBulletsPool, Reg.saucerPool, 5, 5);
			overlapsRange(Reg.playerGrenadePool, Reg.saucerPool, 5, 5);
		
			if (!playerDeath && !fadingOut && !Reg.player.dying)
			{
				Reg.renderer.mainCanvas.dialogueActive = false;
				overlapRange(Reg.player, Reg.enemyBulletPool,  20, 20);
				overlapRange(Reg.player, Reg.soldierBulletPool, 20, 20);
				overlapRange(Reg.player, Reg.turretBulletPool, 20, 20);
				overlapRange(Reg.player, Reg.soldierPool, 8, 8);
				overlapRange(Reg.player, Reg.ghostPool, 8, 8);
				overlapRange(Reg.player, Reg.lavablockPool, 0, 0);
				overlapRange(Reg.player, Reg.spikesPool, 8, 8);
				Reg.player.onInfoPoint = false;
				overlapRange(Reg.player, Reg.infopointPool, 12, 12);		
				if (!Reg.player.suitActivated) overlapRange(Reg.player, Reg.checkpointPool, Reg.player.width/4, Reg.player.height/4);				
				else if (Reg.player.suitActivated) overlapRange(Reg.player, Reg.checkpointPool, Reg.player.width/2, Reg.player.height/2);				
				overlapRange(Reg.player, Reg.coinsPool, Reg.player.width/4, Reg.player.height/4);
				overlapRange(Reg.player, Reg.heartPool, Reg.player.width/4, Reg.player.height/4);		
				if (dialogueActive == false) dialogueIndex = 0;
				var exitHolder:Array = [Reg.exit];       	
				overlapRange(Reg.player, exitHolder, Reg.player.width, Reg.player.width);
				var keyHolder:Array =  [Reg.nanoShoes];    	
				overlapRange(Reg.player, keyHolder, 8, 8);				
				//overlapRange(Reg.player, Reg.slopePool, 2, 2);
			}		
		}
			
		//--------------------------------------------------------------------
		// collide slopes
			
		private function collideSlopes(player:Player, slopePool:Array):void 
		{
			//return;
			Reg.player.onSlope = false;
			for (i = 0; i < slopePool.length; i++) {
				
				var dx:int = Math.abs(Reg.player.ctrX - slopePool[i].ctrX);
				var dy:int = Reg.player.y + Reg.player.downBound - slopePool[i].y;

				if (
				/*dx < 22
				&&
				dy > 0
				&& dy < */
				
				Math.abs(Reg.player.ctrX - slopePool[i].ctrX) < 35
				&&				
				Math.abs(Reg.player.ctrY - slopePool[i].ctrY) < 80
				/*
				&&
				Math.abs(Reg.player.y + Reg.player.downBound - slopePool[i].y) > 0
				&&
				Math.abs(Reg.player.y + Reg.player.downBound - slopePool[i].y) < 40
				*/
				)				
				{
					if (slopePool[i].slopeType == "TOPLEFT_BOTTOMRIGHT") {
						Reg.player.y = (((Reg.player.ctrX - slopePool[i].x) / 40) * 40) + slopePool[i].y;
					}
					if (slopePool[i].slopeType == "BOTTOMLEFT_TOPRIGHT") {
						Reg.player.y = ((40 - (((Reg.player.ctrX - slopePool[i].x) / 40) * 40))) + slopePool[i].y;
					}
					Reg.player.onGround = 1;
					Reg.player.y -= 60;
					Reg.player.jumping = false;
					Reg.player.jumpTime = 0;
					Reg.player.onSlope = true;

				}
			}
			
		}
			
		//--------------------------------------------------------------------
		// collide
	
		private function collide(objs:Array):void 
		{		
			for (i = 0; i < objs.length; i++)
			{
				objs[i].onGround = 0;
				Reg.collisions.tilemapCollisions(objs[i]);
			}				
		}	
					
		//--------------------------------------------------------------------
		// overlap
	
		private function overlapRange(obj1:GameObject, obj2:Array, xRange:int, yRange:int):void
		{		
			// SPRITE Reg.collisions
			if (obj1.onScreen == false) return;
			for (i = 0; i < obj2.length; i++)
			{
				if
				(
					obj2[i].onScreen
					&&
					(
					(((obj1.x + obj1.dirX + obj1.leftBound) > (obj2[i].x + obj2[i].dirX + obj2[i].leftBound - xRange)) && ((obj1.x + obj1.dirX + obj1.leftBound) < (xRange + obj2[i].x + obj2[i].dirX + obj2[i].rightBound)))
					||		
					(((obj1.x + obj1.dirX + obj1.rightBound) > (obj2[i].x + obj2[i].dirX + obj2[i].leftBound - xRange)) && ((obj1.x + obj1.dirX + obj1.rightBound) < (xRange + obj2[i].x + obj2[i].dirX + obj2[i].rightBound)))
					)
					&&
					(
					(((obj1.y + obj1.dirY + obj1.upBound) > (obj2[i].y + obj2[i].dirY + obj2[i].upBound - yRange)) && ((obj1.y + obj1.dirY + obj1.upBound) < (yRange + obj2[i].y + obj2[i].dirY + obj2[i].downBound)))
					||		
					(((obj1.y + obj1.dirY + obj1.downBound) > (obj2[i].y + obj2[i].dirY + obj2[i].upBound - yRange)) && ((obj1.y + obj1.dirY + obj1.downBound) < (yRange + obj2[i].y + obj2[i].dirY + obj2[i].downBound)))
				    )
				)
				{
					if (obj1.type == Globals.OBJTYPE_PLAYER && !fadingOut && !Reg.player.flashing)
					{					
						if (obj2[i].type == Globals.OBJTYPE_GHOST) killPlayer();
						if (obj2[i].type == Globals.OBJTYPE_SAUCER) killPlayer();
						if (obj2[i].type == Globals.OBJTYPE_SPIKE) killPlayer();
						if (obj2[i].type == Globals.OBJTYPE_SOLDIER) killPlayer();
						if (obj2[i].type == Globals.OBJTYPE_SLOPE)
						{
							if (obj2[i].slopeType == "TOPLEFT_BOTTOMRIGHT") {
								Reg.player.y = (((Reg.player.ctrX - obj2[i].x) / 40) * 40) + obj2[i].y;
							}
							if (obj2[i].slopeType == "BOTTOMLEFT_TOPRIGHT") {
								Reg.player.y = ((40 - ((Reg.player.ctrX - obj2[i].x) / 40) * 40)) + obj2[i].y;
								//Reg.player.y -= 42;
							}
						}						
						if (obj2[i].type == Globals.OBJTYPE_COIN)
						{
							var xp:int=obj2[i].ctrX;
							var yp:int=obj2[i].ctrY;
							obj2[i].x = -1000;
							obj2[i].onScreen = false;
							Reg.scorePool[currentScoreSprite].x = xp - 82;
							Reg.scorePool[currentScoreSprite].y = yp - 6;
							Reg.scorePool[currentScoreSprite].fadeAmount = 0;
							Reg.scorePool[currentScoreSprite].fadeTimer = 0;
							Reg.scorePool[currentScoreSprite].onScreen = true;
							Reg.scorePool[currentScoreSprite].scoreString = String(50);
							Reg.scorePool[currentScoreSprite].size = 1;
							Reg.scorePool[currentScoreSprite].yv = -3;
							Reg.scorePool[currentScoreSprite].lifeTime = 0;
							currentScoreSprite++;
							if (currentScoreSprite > Globals.MAX_SCORES-1) currentScoreSprite = 0;
							Reg.player.score += 50;
							Reg.sfx.play(SoundEffectsManager.sndCoin);						
							obj2[i].spawnParticles();
						}					
						if 
						(
						(
						obj2[i].type == Globals.OBJTYPE_ENEMYBULLET
						||
						obj2[i].type == Globals.OBJTYPE_TURRETBULLET
						||
						obj2[i].type == Globals.OBJTYPE_SOLDIERBULLET
						)
						&& !fadingOut && !Reg.player.flashing
						)
						{
							obj2[i].x = 2000;
							//obj2[i].onScreen = false;
							Reg.player.health--;
							killPlayer();
							if (Reg.player.direction == Globals.FACING_LEFT) Reg.player.x += 5;
							if (Reg.player.direction == Globals.FACING_RIGHT) Reg.player.x -= 5;
							Reg.player.dirY = -2;
						}							
						if (obj2[i].type == Globals.OBJTYPE_HEART && !fadingOut)
						{
							if (Reg.player.health < 5) 
							{
								Reg.player.health++;
								Reg.sfx.play(SoundEffectsManager.sndHeartpickup);
								xp = obj2[i].x + (obj1.width / 2);
								yp = obj2[i].y + (obj1.height / 2);
								obj2[i].x = -2000;
								obj2[i].onScreen = false;
								obj2[i].spawnParticles();
							}
						}					
						if (obj2[i].type == Globals.OBJTYPE_CHECKPOINT)
						{
							restartX = obj2[i].x + 3;
							restartY = obj2[i].y;
							restartDir = obj1.direction;
							if (obj2[i].visited == false) {
								Reg.sfx.play(SoundEffectsManager.sndCheckpoint);
								//Reg.particles.shimmer();
								//Reg.player.shimmering = true;
								obj2[i].spawnParticles();
							}
							obj2[i].visited = true;
						}				
						if (obj2[i].type == Globals.OBJTYPE_EXIT && !Reg.leavingLevel)
						{
							if (Math.abs(obj1.ctrX - obj2[i].ctrX) < 25
							&&  Math.abs(obj1.y + obj1.downBound - obj2[i].ctrY) < 45) {
								Reg.sfx.play(SoundEffectsManager.sndHitExit);
								Reg.loadNewLevel = true;
								Reg.player.dirX = 0;
								Reg.player.dirY = 0;
								Reg.player.exiting = true;
								fadeOutTimer = 0;
								//fadingOut = true;
								Reg.leavingLevel = true;
								Reg.timeMinutes = int(Reg.elapsedTime / 60);
								Reg.timeSeconds = int(Reg.elapsedTime % 60);
								Reg.playerScore = Reg.player.score;
								Reg.totalBonus = 0;
								Reg.bonustimer = 0;
								Reg.bonusCalc = (Reg.enemiesKilled * 100);
								Reg.bonusCalc -= Reg.elapsedTime* 10;
								Reg.bonusCalc -= Reg.playerDeaths * 1000;
								if (Reg.bonusCalc < 0) Reg.bonusCalc = 0;
								return;	
							}
						}		
						if (obj2[i].type == Globals.OBJTYPE_NANOSHOES)
						{
							//Reg.sfx.play(SoundEffectsManager.sndCollectShoes);
							Reg.sfx.play(SoundEffectsManager.sndPowerUp);
							obj2[i].x = -2000;
							obj2[i].onScreen = false;
							Reg.player.keyCollected = true;
							//Reg.player.shoesCollected = true;
							Reg.player.suitActivated = true;
							Reg.player.y -= 50;
							Reg.player.shimmering = true;
							return;
						}			
						if (obj2[i].type == Globals.OBJTYPE_WAYPOINT)
						{
						}						
						if (obj2[i].type == Globals.OBJTYPE_LAVA && !fadingOut && !Reg.player.onLava)
						{
							Reg.player.dirX = 0;
							Reg.player.dirY = 0;
							Reg.player.health = 0;
							killPlayer();							
						}							
						if (obj2[i].type == Globals.OBJTYPE_INFOPOINT)
						{
							Reg.renderer.mainCanvas.blitAtPoint(Bmps.dialogueOverlayBmpdata, 5, Globals.DIALOGUE_OVERLAY_Y);
							Reg.renderer.mainCanvas.dialogueActive = true;
							Reg.player.onInfoPoint = true;
							var id:int = obj2[i].nodeID;
							Reg.renderer.mainCanvas.setDialogue(id);
							//Reg.sfx.play(SoundEffectsManager.sndBleep);
						}	
					}								
				}	
			}	
		}		

		//--------------------------------------------------------------------
		// overlaps
	
		private function overlapsRange(obj1:Array,obj2:Array,xRange:int,yRange:int):void 
		{		
			// SPRITE Reg.collisions
			for (i = 0; i < obj1.length; i++)
			{
				noKilled = 0;
				for (j = 0; j < obj2.length; j++)
				{
					if (obj1[i] == null) continue;
					//noKilled = 0; bonus = 0;
					if
					(
					obj1[i].onScreen && obj2[j].onScreen &&
					(
					(obj1[i].x+obj1[i].leftBound > obj2[j].x+obj2[j].leftBound-xRange && obj1[i].x+obj1[i].leftBound < xRange+obj2[j].x+obj2[j].rightBound)
					||		
					(obj1[i].x+obj1[i].rightBound > obj2[j].x+obj2[j].leftBound-xRange && obj1[i].x+obj1[i].rightBound < xRange+obj2[j].x+obj2[j].rightBound)
					)
					&&
					(
					(obj1[i].y+obj1[i].upBound > obj2[j].y+obj2[j].upBound-yRange && obj1[i].y+obj1[i].upBound < yRange+obj2[j].y+obj2[j].downBound)
					||		
					(obj1[i].y+obj1[i].downBound > obj2[j].y+obj2[j].upBound-yRange && obj1[i].y+obj1[i].downBound < yRange+obj2[j].y+obj2[j].downBound)
					)
					)
					{
						if (obj1[i].type == Globals.OBJTYPE_WAYPOINT)
						{
							if (obj1[i].cooloff == 0)
							{
								if (obj1[i].action == MIRRORX) { obj2[j].direction = 1 - obj2[j].direction; }
								obj1[i].cooloff = 15;
							}
						}						
						if (obj1[i].type == Globals.OBJTYPE_PLAYERBULLET)						
						{
							damageObjectRemoveProjectile(40, obj2[j], obj1[i]);				
						}
					}
				}	
			}
		}

		//--------------------------------------------------------------------
		// damageObjectRemoveProjectile
	
		private function damageObjectRemoveProjectile(damage:int, obj:GameObject, proj:GameObject):void
		{
			obj.health -= damage;
			if (obj.health < 0) killObject(obj);
			else {
				obj.flashing = true;
				obj.flashTimer = 0;
			}
			proj.onScreen = false;
			proj.x = -2000;
			proj.dirX = 0;
		}
		
		//--------------------------------------------------------------------
		// killPlayer
	
		private function killPlayer():void 
		{	
			if (Reg.leavingLevel) return;
			if (Reg.player.health > -1 && Reg.player.cooloff == 0)
			{
				suitArmourActive = !suitArmourActive;
				if (!Reg.player.suitActivated) {
					Reg.player.health--;
					Reg.sfx.play(SoundEffectsManager.sndHurt);
				} else if (Reg.player.suitActivated && !suitArmourActive) {
					Reg.player.health--;
					Reg.sfx.play(SoundEffectsManager.sndSuitHurt);
				} else if (Reg.player.suitActivated && suitArmourActive) {
					Reg.player.health++;
					Reg.sfx.play(SoundEffectsManager.sndSuitDefense);
				}
				
				Reg.player.flashing = true;
				Reg.player.flashTimer = 0;
				Reg.player.cooloff = 40;
			}
			if (Reg.player.health < 0)
			{
				Reg.playerDeaths++;
				Reg.player.health = 5;
				//trace("Player health = " + Reg.player.health);
				if (Reg.player.dying) return;
				Reg.sfx.play(SoundEffectsManager.sndDeath);
				fadeOutTimer = 0;
				fadingOut = true;
				playerDeath = true;
				Reg.player.dirX = 0;
				Reg.player.dirY = 0;
				Reg.player.dying = true;
				Reg.player.direction = restartDir;
				Reg.player.cancelGrenade();
			}
		}

		//--------------------------------------------------------------------
		// killObject
	
		private function killObject(obj:GameObject,bonus:int=0):void 
		{	
			
			var xp:int = obj.ctrX;
			var yp:int = obj.ctrY;
			Reg.renderer.mainCanvas.screenShake = true;
			Reg.renderer.mainCanvas.screenShakeTimer = 15;
			//trace("set screen shake timer to " + Reg.renderer.mainCanvas.screenShakeTimer);
			// Prevents the player from spamming score points (only awarded for destroying spawners, not spawn)
			if (obj.type == Globals.OBJTYPE_SPAWNER) {
				Reg.scorePool[currentScoreSprite].x = xp - 100;
				Reg.scorePool[currentScoreSprite].y = yp - 6;
				Reg.scorePool[currentScoreSprite].fadeAmount = 0;
				Reg.scorePool[currentScoreSprite].fadeTimer = 0;
				Reg.scorePool[currentScoreSprite].onScreen = true;
				Reg.scorePool[currentScoreSprite].scoreString = String(obj.scorePoints);
				Reg.player.score += obj.scorePoints;
				Reg.scorePool[currentScoreSprite].size = 1;
				Reg.scorePool[currentScoreSprite].yv = -3;
				Reg.scorePool[currentScoreSprite].lifeTime = 0;
				currentScoreSprite++;
				if (currentScoreSprite > Globals.MAX_SCORES - 1) currentScoreSprite = 0;
			}
			obj.x = -1000;
			obj.onScreen = false;
			createExplosions(xp, yp, obj, 1);
			Reg.enemiesKilled++;
			if (obj.type == Globals.OBJTYPE_SPAWNER) { createExplosions(xp, yp, obj, 3); createExplosions(xp, yp, obj, 5); }
			Reg.player.score += (obj.scorePoints * bonus);
			//trace("Object type =" + obj.type);
			if (obj.type == Globals.OBJTYPE_GHOST)   	  Reg.sfx.play(SoundEffectsManager.sndExplode);
			else if (obj.type == Globals.OBJTYPE_SAUCER)  Reg.sfx.play(SoundEffectsManager.sndExplodeSaucer);
			else if (obj.type == Globals.OBJTYPE_SNAKE)   Reg.sfx.play(SoundEffectsManager.sndExplodeSnake);
			else if (obj.type == Globals.OBJTYPE_SOLDIER) Reg.sfx.play(SoundEffectsManager.sndExplodeSoldier);
			else if (obj.type == Globals.OBJTYPE_TURRET)  Reg.sfx.play(SoundEffectsManager.sndExplodeTurret);
			else if (obj.type == Globals.OBJTYPE_SPAWNER) Reg.sfx.play(SoundEffectsManager.sndDestroySpawner);
			obj.spawnParticles();
		}
		
		private function createExplosions(xp:int, yp:int, obj:GameObject, speedCoefficient:int):void 
		{
			Reg.explosionPool[currentExplosion].x = obj.ctrX - (Bmps.explosionBmpdata.height / 2);
			Reg.explosionPool[currentExplosion].y = obj.ctrY - (Bmps.explosionBmpdata.height / 2);
			Reg.explosionPool[currentExplosion].xv = 0;
			Reg.explosionPool[currentExplosion].yv = 0;
			Reg.explosionPool[currentExplosion].animFrame = 0;
			Reg.explosionPool[currentExplosion].onScreen = true;		
			Reg.explosionPool[currentExplosion].size = "Normal";		
			if (++currentExplosion > Globals.MAX_EXPLOSIONS - 1) currentExplosion = 0;	
			for (i = 0; i < 40; i++) {
				Reg.explosionPool[currentExplosion].x = (xp - (Math.random() * 60 - 30)) - (Bmps.explosionBmpdata.height / 2);
				Reg.explosionPool[currentExplosion].y = (yp - (Math.random() * 60 - 30)) - (Bmps.explosionBmpdata.height / 2);
				var dx:Number = (Reg.explosionPool[currentExplosion].x - xp);
				var dy:Number = (Reg.explosionPool[currentExplosion].y - yp);
				var distance:Number = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
				Reg.explosionPool[currentExplosion].xv = ((Reg.explosionPool[currentExplosion].x - xp) / distance) * speedCoefficient;
				Reg.explosionPool[currentExplosion].yv = ((Reg.explosionPool[currentExplosion].y - yp) / distance) * speedCoefficient;
				Reg.explosionPool[currentExplosion].animFrame = Math.random()*4;
				Reg.explosionPool[currentExplosion].onScreen = true;
				Reg.explosionPool[currentExplosion].size = "Small";
				if (++currentExplosion > Globals.MAX_EXPLOSIONS - 1) currentExplosion = 0;					
			}
		}

		//--------------------------------------------------------------------

		public function mouseIsDown(e:Event):void { if(!Reg.mousePressed) Reg.mousePressed = true; }
		public function mouseIsReleased(e:Event):void { Reg.mousePressed = false; }
		public function onFocusLost(e:Event):void { Reg.paused = true; }
		public function onFocus(e:Event):void { Reg.paused = false; }
		
		//--------------------------------------------------------------------
		// ctrTxt
		
		public function ctrTxt(c:String,value:String,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, -2000, y, 1);
			Reg.renderer.mainCanvas.renderTxt(c, value, (Globals.SCREEN_WIDTH / 2) - ((Reg.renderer.mainCanvas.offset + 36) / 2), y, 1);
		}
		
		//--------------------------------------------------------------------
		// ctrTxtBig
		
		public function ctrTxtBig(c:String,value:String,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, -2000, y, 2);
			Reg.renderer.mainCanvas.renderTxt(c, value, (Globals.SCREEN_WIDTH / 2) - ((Reg.renderer.mainCanvas.offset + 14)), y, 2);
		}	
		
		//--------------------------------------------------------------------
		// printTxt
		
		public function printTxt(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, x, y, 1);
		}			
			
		//--------------------------------------------------------------------
		// printTxtBig
		
		public function printTxtBig(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, x, y, 2);
		}	
				
		//--------------------------------------------------------------------
		// printTxtCycle
		
		public function printTxtCycle(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, x, y, 2, 0, true);
		}	
					
		//--------------------------------------------------------------------
		// printXY
		
		public function printXY(obj:GameObject,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt("White",String(obj.x), x, y, 2);
			Reg.renderer.mainCanvas.renderTxt("White",", ", x+5, y, 2);
			Reg.renderer.mainCanvas.renderTxt("White",String(obj.y), x+10, y, 2);
		}	

		//--------------------------------------------------------------------
		// tick
		
		public function tick():void 
		{
			ticks++; var now:uint = getTimer(); var delta:uint = now - last;
			if (delta >= 1000) { fps = ticks / delta * 1000; ticks = 0; last = now; }
		}
		
		//--------------------------------------------------------------------
		// keyboardMove
	
		private function keyboardMove():void 
		{	
			Reg.player.running = false;
				
			if (Reg.mousePressed || aKeyPress[Globals.KEYGUN])
			{	
				if (Reg.leavingLevel && fadingOut == false)
				{
					if (Reg.bonustimer < 150) return;
					fadingOut = true;
					fadeOutTimer = 0;
					Reg.sfx.play(SoundEffectsManager.sndPressedContinue);
				}
			}
			if (Reg.leavingLevel) return;
			if (aKeyPress[Globals.KEYUP] || aKeyPress[Globals.KEYUP2]) {  
				if ((!Reg.player.jumping && Reg.player.onGround) || Reg.player.onSlope) { // && Reg.player.dirY <= 1) {
					Reg.player.jumpTime = 0;
					Reg.player.dirY = -5;
					Reg.player.jumping = true;
				}
				Reg.player.jump();
			}
			if (aKeyPress[Globals.KEYMUTE] && keypressedTime == 0) {
				if (Reg.sfxVol > 0.0) {
					previousSfxVolume = Reg.sfxVol;
					Reg.sfxVol = 0.0;
				} else Reg.sfxVol = previousSfxVolume;
				if (Reg.musicVol > 0.0) {
					previousMusicVolume = Reg.musicVol;
					Reg.musicVol = 0.0;
				} else Reg.musicVol = previousMusicVolume;
				Reg.sfx.changeSfxVolume();
				Reg.sfx.changeMusicVolume();
				trace("music volume set to: " + Reg.musicVol);
				keypressedTime = 5;
			}			
			if (aKeyPress[Globals.KEYLEFT]) {
				if (!Reg.player.leftOnce) {
					Reg.player.leftOnce = true;
					doubleTapTimer = 0;
				} else {
					if (doubleTapTimer > 0 && doubleTapTimer < 8 && Reg.player.leftOnce) {
						Reg.player.leftTwice = true;
						if (runSoundCooloff == 0) {
							if (Reg.player.suitActivated) Reg.sfx.play(SoundEffectsManager.sndRunSuit);
							else Reg.sfx.play(SoundEffectsManager.sndRunNormal);
							runSoundCooloff = 10;
						}					
						Reg.player.running = true;
					}
				}
				Reg.player.walk(Globals.KEYLEFT);			
			}			
			else if (aKeyPress[Globals.KEYRIGHT]) {
				if (!Reg.player.rightOnce) {
					Reg.player.rightOnce = true;
					doubleTapTimer = 0;
				} else {
					if (doubleTapTimer > 0 && doubleTapTimer < 8 && Reg.player.rightOnce) {
						Reg.player.rightTwice = true;
						if (runSoundCooloff == 0) {
							if (Reg.player.suitActivated) Reg.sfx.play(SoundEffectsManager.sndRunSuit);
							else Reg.sfx.play(SoundEffectsManager.sndRunNormal);
							runSoundCooloff = 10;
						}
						Reg.player.running = true;
					}
				}
				Reg.player.walk(Globals.KEYRIGHT);				
			} else {
				if (Reg.player.dirX > 0) Reg.player.dirX -= 2.2;
				if (Reg.player.dirX < 0) Reg.player.dirX += 2.2;
				if (Reg.player.dirX > -2.4 && Reg.player.dirX < 2.4) Reg.player.dirX = 0;			
			}
			if (runSoundCooloff > 0 && !aKeyPress[Globals.KEYLEFT] && !aKeyPress[Globals.KEYRIGHT]) runSoundCooloff--;
			if (!aKeyPress[Globals.KEYRIGHT] && !aKeyPress[Globals.KEYLEFT]) {
				if (++doubleTapTimer > 10) {
					Reg.player.leftOnce = false;
					Reg.player.leftTwice = false;				
					Reg.player.rightOnce = false;
					Reg.player.rightTwice = false;
				}
			}
			if (Reg.player.exiting && Reg.bonustimer < 100) return;
			if (aKeyPress[Globals.KEYGUN] && !Reg.player.dying && Reg.player.timeSinceShot == 0 && !Reg.dialogue.dialogueActive && lvlStartTimer == 0) {
				//Reg.player.cancelGrenade();
				Reg.player.shoot();	
				var rndSound:int = Math.random() * 4;
				if (Reg.player.suitActivated) Reg.sfx.play(SoundEffectsManager.bigLaserSounds[rndSound]);
				else Reg.sfx.play(SoundEffectsManager.sndLaser);
			}		
			if (!aKeyPress[Globals.KEYUP] && !aKeyPress[Globals.KEYUP2]) {
				Reg.player.pressingJump = false;	
				Reg.player.onRoof = false;		
			}								
			//if (aKeyPress[Globals.KEYRUN])Reg.player.running = true;
			//else Reg.player.running = false;	
			if (aKeyPress[Globals.KEYRESTART] && keypressedTime == 0) {
				Reg.sfx.play(SoundEffectsManager.sndExit);
				Reg.player.dirX = 0;
				Reg.player.dirY = 0;
				Reg.player.exiting = true;
				fadeOutTimer = 0;
				fadingOut = true;
				Reg.leavingLevel = true;			
			}
		}			
	}
}