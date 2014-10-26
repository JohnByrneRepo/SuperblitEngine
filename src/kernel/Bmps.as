package kernel
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.filters.*;
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 */	

	// - Embeds all the game assets
	// - Caches animations for blitting

	public class Bmps
	{
		public var filtPronounced:GlowFilter = new GlowFilter(0x00d4a3, 0.3, 16, 16, 3, 1, false, false);
		public var filtMinimal:GlowFilter = new GlowFilter(0x00d4a3, 0.3, 4, 4, 3, 1, false, false);

		public var itemNo:int;
		// color palettes
		
		public const GREEN		:int = 0;
		public const RED		:int = 1;
		public const BLUE		:int = 2;
		public const YELLOW		:int = 3;
		public const ORANGE		:int = 4;
		public const PRUPLE		:int = 5;
		public const DARKGREY	:int = 6;
		public const LIGHTGREY	:int = 7;
	
		private var i:int;
		private var j:int;
		private var k:int;
		private var r:int;
		private var c:int;
		
		public var fadesArray:Array = [];
		public var fadeValue:int = 0;

		// smoke
		
		[Embed(source = "../images/smoke.png")] static public var imgSmoke:Class;
		static public var smokeBmpdata:BitmapData=new imgSmoke().bitmapData;						
		static public var smokeBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		// bird
		
		[Embed(source = "../images/bird.png")] static public var imgBird:Class;
		static public var birdBmpdata:BitmapData=new imgBird().bitmapData;						
		static public var birdBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		// clarks logo
		
		[Embed(source = "../images/logo.png")] static public var imgLogo:Class;
		static public var clarkslogoBmpdata:BitmapData=new imgLogo().bitmapData;						
	
		// Checkpoint
		
		[Embed(source = "../images/checkpoint.png")] static public var imgCheckpoint:Class;
		static public var checkpointBmpdata:BitmapData=new imgCheckpoint().bitmapData;						
		
		// parallaxImages
		
		[Embed(source = "../images/parallaxImage1.png")] static public var imgParallaxImage1:Class;
		static public var parallax1Bmpdata:BitmapData=new imgParallaxImage1().bitmapData;						
		
		[Embed(source = "../images/parallaxImage2.png")] static public var imgParallaxImage2:Class;
		static public var parallax2Bmpdata:BitmapData=new imgParallaxImage2().bitmapData;						
			
		// Gradient background
		
		[Embed(source = "../images/gradientBackground.png")] static public var imgGradientBackground:Class;
		static public var gradientBackgroundBmpdata:BitmapData=new imgGradientBackground().bitmapData;						
		[Embed(source = "../images/gradientBackground2.png")] static public var imgGradientBackground2:Class;
		static public var gradientBackground2Bmpdata:BitmapData=new imgGradientBackground2().bitmapData;						
		[Embed(source = "../images/gradientBackground3.png")] static public var imgGradientBackground3:Class;
		static public var gradientBackground3Bmpdata:BitmapData=new imgGradientBackground3().bitmapData;						
		
		// Icons
		
		[Embed(source = "../images/icon_music.png")] static public var imgIcon_Music:Class;
		static public var iconMusicBmpdata:BitmapData=new imgIcon_Music().bitmapData;						
		[Embed(source = "../images/icon_sfx.png")] static public var imgIcon_Sfx:Class;
		static public var iconSfxBmpdata:BitmapData=new imgIcon_Sfx().bitmapData;						

		// Button
		
		[Embed(source = "../images/buttonUnclicked.png")] static public var ibtn:Class;
		static public var optionsButtonUnpressedBmpdata:BitmapData=new ibtn().bitmapData;						
		
		[Embed(source = "../images/buttonClicked.png")] static public var ibtn2:Class;
		static public var optionsButtonPressedBmpdata:BitmapData=new ibtn2().bitmapData;						
			
		[Embed(source = "../images/buttonUnclickedSmall.png")] static public var ibtn3:Class;
		static public var optionsButtonUnpressedSmallBmpdata:BitmapData=new ibtn3().bitmapData;						
		
		[Embed(source = "../images/buttonClickedSmall.png")] static public var ibtn4:Class;
		static public var optionsButtonPressedSmallBmpdata:BitmapData=new ibtn4().bitmapData;						

		// .......................
		// DIALOGUE OVERLAY
		
		[Embed(source = "../images/dialogueOverlay.png")] static public var iDialog:Class;
		static public var dialogueOverlayBmpdata:BitmapData=new iDialog().bitmapData;						
		
		[Embed(source = "../images/dialogueOverlay2.png")] static public var iDialog2:Class;
		static public var dialogueOverlay2Bmpdata:BitmapData=new iDialog2().bitmapData;						

		// .......................
		// TITLE SCREEN LOGO
		
		//[Embed(source = "../images/titlelogo2.png")] static public var ititlelogo:Class;
		//[Embed(source = "../images/titleMain.png")] static public var ititlelogo:Class;
		[Embed(source = "../images/JackNanoTitle3.png")] static public var ititlelogo:Class;
		static public var titleBmpdata:BitmapData=new ititlelogo().bitmapData;						
		
		// Lvl complete
		
		[Embed(source = "../images/levelCompleteScreen.png")] static public var iLvlComplete:Class;
		static public var lvlCompleteBmpdata:BitmapData=new iLvlComplete().bitmapData;						
	
		[Embed(source = "../images/cursor.png")] static public var icursor:Class;
		static public var cursorBmpdata:BitmapData=new icursor().bitmapData;						

		[Embed(source = "../images/star.png")] static public var istar:Class;
		static public var starBmpdata:BitmapData=new istar().bitmapData;						
		static public var starBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// PAUSE MENU / COLOR PALETTE BOXES
		
		[Embed(source = "../images/paletteBoxes.png")] static public var ipaletteBoxes:Class;
		static public var paletteBoxesBmpdata:BitmapData=new ipaletteBoxes().bitmapData;						
		static public var paletteBoxesBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		// ......................
		// CUT SCENE / MENU ASSETS
		
		[Embed(source="../images/portraitlarge.png")] static public var iportlrg:Class;
		static public var portraitLrgBmpData:BitmapData=new iportlrg().bitmapData;	

		[Embed(source="../images/portrait1.png")] static public var iport1:Class;
		static public var portrait1BmpData:BitmapData=new iport1().bitmapData;	
		
		[Embed(source = "../images/levelcompletepanel.png")] static public var ilvlcompletepanel:Class;
		static public var lvlcompletePaneBmpdata:BitmapData=new ilvlcompletepanel().bitmapData;						

		// ......................
		//BITMAP FONTS
		
		[Embed(source="../images/textual/outlinefontx2.png")] static public var fntbig:Class;
		static public var bitmapfontX2BmpData:BitmapData=new fntbig().bitmapData;	
		static public var bitmapfontX2BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		[Embed(source="../images/textual/outlinefontbig.png")] static public var fnt:Class;
		static public var bitmapfontBmpData:BitmapData=new fnt().bitmapData;	
		static public var bitmapfontBmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		[Embed(source="../images/textual/outlinefontcontinue.png")] static public var fntContinue:Class;
		static public var bitmapfontContinueBmpData:BitmapData=new fntContinue().bitmapData;	
		static public var bitmapfontContinueBmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source="../images/textual/outlinefont.png")] static public var fntMain1:Class;
		static public var bitmapfontmain1BmpData:BitmapData=new fntMain1().bitmapData;	
		static public var bitmapfontmain1BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontfade1.png")] static public var fntMain2:Class;
		static public var bitmapfontmain2BmpData:BitmapData=new fntMain2().bitmapData;	
		static public var bitmapfontmain2BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontfade2.png")] static public var fntMain3:Class;
		static public var bitmapfontmain3BmpData:BitmapData=new fntMain3().bitmapData;	
		static public var bitmapfontmain3BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontfade3.png")] static public var fntMain4:Class;
		static public var bitmapfontmain4BmpData:BitmapData=new fntMain4().bitmapData;	
		static public var bitmapfontmain4BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontfade4.png")] static public var fntMain5:Class;
		static public var bitmapfontmain5BmpData:BitmapData=new fntMain5().bitmapData;	
		static public var bitmapfontmain5BmpDataArray:Vector.<BitmapData>=new Vector.<BitmapData>();


		[Embed(source="../images/textual/outlinefontbig1.png")] static public var fntMainbig1:Class;
		static public var bitmapfontmainbigBmpData1:BitmapData=new fntMainbig1().bitmapData;	
		static public var bitmapfontmainbigBmpDataArray1:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontbig2.png")] static public var fntMainbig2:Class;
		static public var bitmapfontmainbigBmpData2:BitmapData=new fntMainbig2().bitmapData;	
		static public var bitmapfontmainbigBmpDataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontbig3.png")] static public var fntMainbig3:Class;
		static public var bitmapfontmainbigBmpData3:BitmapData=new fntMainbig3().bitmapData;	
		static public var bitmapfontmainbigBmpDataArray3:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontbig4.png")] static public var fntMainbig4:Class;
		static public var bitmapfontmainbigBmpData4:BitmapData=new fntMainbig4().bitmapData;	
		static public var bitmapfontmainbigBmpDataArray4:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source="../images/textual/outlinefontbig5.png")] static public var fntMainbig5:Class;
		static public var bitmapfontmainbigBmpData5:BitmapData=new fntMainbig5().bitmapData;	
		static public var bitmapfontmainbigBmpDataArray5:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		// All customizable colours below
		
		//---------------------------------------------------------------------------------------
		
		//---------------------------------------------------------------------------------------
		
		//---------------------------------------------------------------------------------------
		
		// ......................
		// SPAWNER		

		[Embed(source = "../images/spawner.png")] static public var iSpawner:Class;
		static public var spawnerBmpdata:BitmapData=new iSpawner().bitmapData;			
		static public var spawnerBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		// ......................
		// ENEMYS		

		[Embed(source = "../images/soldier2.png")] static public var isold:Class;
		static public var soldierBmpdata:BitmapData=new isold().bitmapData;			
		static public var soldierBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var soldierBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/spikesBottom.png")] static public var ispikesbtm:Class;
		static public var spikesbottomBmpdata:BitmapData=new ispikesbtm().bitmapData;			
		static public var spikesbottomBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var spikesbottomBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/spikesTop.png")] static public var ispto:Class;
		static public var spikestopBmpdata:BitmapData=new ispto().bitmapData;			
		static public var spikestopBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var spikestopBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/enemyBullet.png")] static public var ienb:Class;
		static public var enemybulletBmpdata:BitmapData=new ienb().bitmapData;			
		static public var enemybulletBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var enemybulletBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/ghost.png")] static public var igho:Class;
		static public var ghostBmpdata:BitmapData=new igho().bitmapData;			
		static public var ghostBmpdata2:BitmapData=new igho().bitmapData;			
		static public var ghostBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var ghostBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/saucer.png")] static public var isaucer:Class;
		static public var saucerBmpdata:BitmapData=new isaucer().bitmapData;			
		static public var saucerBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var saucerBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/turretTop.png")] static public var it1:Class;
		static public var turrettopBmpdata:BitmapData=new it1().bitmapData;			
		static public var turrettopBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var turrettopBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/turretBottom.png")] static public var it2:Class;
		static public var turretbottomBmpdata:BitmapData=new it2().bitmapData;			
		static public var turretbottomBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var turretbottomBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/turretLeft.png")] static public var it3:Class;
		static public var turretleftBmpdata:BitmapData=new it3().bitmapData;			
		static public var turretleftBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var turretleftBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/turretRight.png")] static public var it4:Class;
		static public var turretrightBmpdata:BitmapData=new it4().bitmapData;			
		static public var turretrightBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var turretrightBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
	
		// ......................
		// PLAYER
		
		//[Embed(source = "../images/knight2.png")] static public var Imgplayer:Class;
		[Embed(source = "../images/sniperJoe.png")] static public var Imgjoe:Class;
		static public var sniperJoeBmpdata:BitmapData=new Imgjoe().bitmapData;			
		static public var sniperJoeBmpdataL:BitmapData=new Imgjoe().bitmapData;			
		static public var sniperJoeBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var sniperJoeBmpdataArrayL:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		[Embed(source = "../images/JackNano2.png")] static public var Imgplayer:Class;
		static public var playerBmpdata:BitmapData=new Imgplayer().bitmapData;			
		static public var playerBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var playerBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		static public var playerBmpdataL:BitmapData=new Imgplayer().bitmapData;			
		static public var playerBmpdataArrayL:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var playerBmpdataArrayL2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/JackNanoShoesCollected.png")] static public var Imgplayershoescollected:Class;
		static public var playerNanoShoesBmpdata:BitmapData=new Imgplayershoescollected().bitmapData;			
		static public var playerNanoShoesBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var playerNanoShoesBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		static public var playerNanoShoesBmpdataL:BitmapData=new Imgplayershoescollected().bitmapData;			
		static public var playerNanoShoesBmpdataArrayL:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var playerNanoShoesBmpdataArrayL2:Vector.<BitmapData>=new Vector.<BitmapData>();

		// ......................
		// TILES

		//[Embed(source = "../images/tiles/collisionTiles.png")] static public var ImgTls:Class;
		//[Embed(source = "../images/tiles/tiles.png")] static public var ImgTls:Class;
		[Embed(source = "../images/tiles/parallaxTiles.png")] static public var ImgParallaxTiles:Class;
		static public var parallaxTilesBmpdata:BitmapData=new ImgParallaxTiles().bitmapData;			
		static public var parallaxTilesBmpdataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var parallaxTilesBmpdataArray2:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		[Embed(source = "../images/tiles/parallaxTilesRed.png")] static public var ImgParallaxTilesRed:Class;
		static public var parallaxTilesRedBmpdata:BitmapData=new ImgParallaxTilesRed().bitmapData;			
		static public var parallaxTilesRedBmpdataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var parallaxTilesRedBmpdataArray2:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		//[Embed(source = "../images/tiles/autotiles.png")] static public var ImgTls:Class;
		[Embed(source = "../images/tiles/foregroundtiles.png")] static public var ImgTls:Class;
		static public var tlsBmpdata:BitmapData=new ImgTls().bitmapData;			
		static public var tlsBmpdataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var tlsBmpdataArray2:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		[Embed(source = "../images/tiles/foregroundtilesRed.png")] static public var ImgTlsRed:Class;
		static public var tlsRedBmpdata:BitmapData=new ImgTlsRed().bitmapData;			
		static public var tlsRedBmpdataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var tlsRedBmpdataArray2:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		[Embed(source = "../images/tiles/bgtls.png")] static public var ImgBGTls:Class;
		static public var bgtlsBmpdata:BitmapData=new ImgBGTls().bitmapData;			
		static public var bgtlsBmpdataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var bgtlsBmpdataArray2:Vector.<BitmapData> = new Vector.<BitmapData>();

		// ......................
		// BULLETS
		
		[Embed(source = "../images/bullet.png")] static public var Imgbul:Class;
		static public var bullBmpdata:BitmapData=new Imgbul().bitmapData;						
		static public var bullBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var bullBmpdataArrayL:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var bullBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		[Embed(source = "../images/bulletSuit.png")] static public var Imgbulsuit:Class;
		static public var bullSuitBmpdata:BitmapData=new Imgbulsuit().bitmapData;						
		static public var bullSuitBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var bullSuitBmpdataArrayL:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/bulletVert.png")] static public var Imgbulv:Class;
		static public var bullvertBmpdata:BitmapData=new Imgbulv().bitmapData;						
		static public var bullvertBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var bullvertBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		[Embed(source = "../images/grenade.png")] static public var Imggre:Class;
		static public var grenadeBmpdata:BitmapData=new Imggre().bitmapData;						
		static public var grenadeBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var grenadeBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();


		// .......................
		// SPRITE TILES
		
		[Embed(source = "../images/tiles/spritetiles.png")] static public var ispt:Class;
		static public var spritestripBmpdata:BitmapData=new ispt().bitmapData;						
		static public var spritestripBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var spritestripBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// PARTICLE
		
		[Embed(source = "../images/yellowparticle.png")] static public var iypt:Class;
		static public var yellowpartBmpdata:BitmapData=new iypt().bitmapData;						
		static public var yellowpartBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var yellowpartBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/particle.png")] static public var ipt:Class;
		static public var partBmpdata:BitmapData=new ipt().bitmapData;						
		static public var partBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var partBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();

		[Embed(source = "../images/particleBeam.png")] static public var iptbeam:Class;
		static public var particleBeamBmpdata:BitmapData=new iptbeam().bitmapData;						
		static public var particleBeamBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// CLOUDS
		
		[Embed(source = "../images/cloud.png")] static public var iCloud:Class;
		static public var cloudBmpdata:BitmapData=new iCloud().bitmapData;						
		[Embed(source = "../images/cloud2.png")] static public var iCloud2:Class;
		static public var cloud2Bmpdata:BitmapData=new iCloud2().bitmapData;						
		
		// .......................
		// LAVA
		
		[Embed(source = "../images/lava.png")] static public var ilava:Class;
		static public var lavaBmpdata:BitmapData=new ilava().bitmapData;						
		static public var lavaBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// EXPLOSIONS
		
		[Embed(source = "../images/explosion.png")] static public var iexplosion:Class;
		static public var explosionBmpdata:BitmapData=new iexplosion().bitmapData;						
		static public var explosionBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		[Embed(source = "../images/explosionSmall.png")] static public var iexplosionsmall:Class;
		static public var explosionSmallBmpdata:BitmapData=new iexplosionsmall().bitmapData;						
		static public var explosionSmallBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// FLASHING BLOCKS
		
		[Embed(source = "../images/flashingBlock.png")] static public var iflashingBlock:Class;
		static public var flashingBlockBmpdata:BitmapData=new iflashingBlock().bitmapData;						
		static public var flashingBlockBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// HEALTH
		
		[Embed(source = "../images/healthBarBg.png")] static public var imgHlthBar:Class;
		static public var healthBarBmpdata:BitmapData=new imgHlthBar().bitmapData;						
			
		[Embed(source = "../images/heart.png")] static public var imgHeart:Class;
		static public var heartBmpdata:BitmapData=new imgHeart().bitmapData;						
		
		[Embed(source = "../images/healthfirst.png")] static public var imgHlt1:Class;
		static public var healthfirstBmpdata:BitmapData=new imgHlt1().bitmapData;						
				
		[Embed(source = "../images/healthmid.png")] static public var imgHltmid:Class;
		static public var healthmidBmpdata:BitmapData=new imgHltmid().bitmapData;						
				
		[Embed(source = "../images/healthlast.png")] static public var imgHltlast:Class;
		static public var healthlastBmpdata:BitmapData=new imgHltlast().bitmapData;						
			
		// .......................
		// PICKUPS
		
		[Embed(source = "../images/keycard.png")] static public var ikeycard:Class;
		static public var keycardBmpdata:BitmapData=new ikeycard().bitmapData;						
		static public var keycardBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var keycardBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		[Embed(source = "../images/heartanim.png")] static public var iheartanim:Class;
		static public var heartanimBmpdata:BitmapData=new iheartanim().bitmapData;						
		static public var heartanimBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var heartanimBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		// .......................
		// COIN
		
		[Embed(source = "../images/coin.png")] static public var icn:Class;
		static public var coinBmpdata:BitmapData=new icn().bitmapData;						
		static public var coinBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var coinBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		[Embed(source = "../images/nanoshoe.png")] static public var ins:Class;
		static public var nanoshoeBmpdata:BitmapData=new ins().bitmapData;						
		static public var nanoshoeBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var nanoshoeBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
			
		// .......................
		// INFO POINT
		
		[Embed(source = "../images/computerterminal.png")] static public var icomlink:Class;
		static public var infoBmpdata:BitmapData=new icomlink().bitmapData;						
		static public var infoBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		static public var infoBmpdataArray2:Vector.<BitmapData>=new Vector.<BitmapData>();
		
		// .......................
		// AUDIO OPTIONS ON PAUSE - SLIDER etc.
		
		[Embed(source = "../images/sliderBar.png")] static public var islidbar:Class;
		static public var sliderBarBmpdata:BitmapData=new islidbar().bitmapData;						

		[Embed(source = "../images/sliderSelectedArrow.png")] static public var islidsel:Class;
		static public var sliderArrowBmpdata:BitmapData=new islidsel().bitmapData;						

		[Embed(source = "../images/optionsTabAudio.png")] static public var ioptionstab1:Class;
		static public var optionsTabAudioBmpdata:BitmapData=new ioptionstab1().bitmapData;						

		[Embed(source = "../images/optionspanel.png")] static public var ioptionspanel:Class;
		static public var optionsPaneBmpdata:BitmapData=new ioptionspanel().bitmapData;						

		//---------------------------------------------------------------------------------------
	
		// ......................
		// ground effects / textures
		
		[Embed(source = "../images/interlaceBlock.png")] static public var ImgInt:Class;
		static public var intblockBmpdata:BitmapData=new ImgInt().bitmapData;						

		[Embed(source = "../images/interlaceBlock2.png")] static public var ImgInt2:Class;
		static public var intblock2Bmpdata:BitmapData=new ImgInt2().bitmapData;						

		[Embed(source = "../images/interlace2.png")] static public var ImgInterlace:Class;
		static public var interlaceBmpdata:BitmapData=new ImgInterlace().bitmapData;						

		[Embed(source = "../images/wallFade1.png")] static public var iwf1:Class;
		static public var wallfade1Bmpdata:BitmapData=new iwf1().bitmapData;						
		static public var wallfade1BmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// WIPE BLOCK
		
		[Embed(source = "../images/wipeBlock1.png")] static public var iwblk1:Class;
		static public var wipe1Bmpdata:BitmapData=new iwblk1().bitmapData;						
		static public var wipe1BmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();

		// .......................
		// EXIT ANIM
		
		[Embed(source = "../images/exitanim.png")] static public var iexitanim:Class;
		static public var exitanimBmpdata:BitmapData=new iexitanim().bitmapData;						
		static public var exitanimBmpdataArray:Vector.<BitmapData>=new Vector.<BitmapData>();
		
	
		//----------------------------------------------------------------------------------------

		public function Bmps():void
		{	
			optionsButtonPressedSmallBmpdata.applyFilter(optionsButtonPressedSmallBmpdata, optionsButtonPressedSmallBmpdata.rect, new Point(0, 0), filtPronounced);
			optionsButtonUnpressedSmallBmpdata.applyFilter(optionsButtonUnpressedSmallBmpdata, optionsButtonUnpressedSmallBmpdata.rect, new Point(0, 0), filtPronounced);
			
			// SMOKE ANIMATION (PARALLAX LAYER)						
			cacheTileStrip(smokeBmpdata,smokeBmpdataArray);
						
			// BIRD ANIMATION (PARALLAX LAYER)						
			cacheTileStrip(birdBmpdata,birdBmpdataArray);
			
			// PAUSE MENU ASSETS							
			cacheTileStrip(paletteBoxesBmpdata,paletteBoxesBmpdataArray);
			
			// BITMAP FONT		
			cacheTileStrip(bitmapfontmainbigBmpData1,bitmapfontmainbigBmpDataArray1);
			cacheTileStrip(bitmapfontmainbigBmpData2,bitmapfontmainbigBmpDataArray2);
			cacheTileStrip(bitmapfontmainbigBmpData3,bitmapfontmainbigBmpDataArray3);
			cacheTileStrip(bitmapfontmainbigBmpData4,bitmapfontmainbigBmpDataArray4);
			cacheTileStrip(bitmapfontmainbigBmpData5,bitmapfontmainbigBmpDataArray5);
			
			cacheTileStrip(bitmapfontContinueBmpData,bitmapfontContinueBmpDataArray);
			cacheTileStrip(bitmapfontBmpData,bitmapfontBmpDataArray);
			cacheTileStrip(bitmapfontX2BmpData,bitmapfontX2BmpDataArray);
			cacheTileStrip(bitmapfontmain1BmpData,bitmapfontmain1BmpDataArray);
			cacheTileStrip(bitmapfontmain2BmpData,bitmapfontmain2BmpDataArray);
			cacheTileStrip(bitmapfontmain3BmpData,bitmapfontmain3BmpDataArray);
			cacheTileStrip(bitmapfontmain4BmpData,bitmapfontmain4BmpDataArray);
			cacheTileStrip(bitmapfontmain5BmpData,bitmapfontmain5BmpDataArray);
			
			// EXITANIM
			cacheTileStrip(exitanimBmpdata,exitanimBmpdataArray);
					
			// STAR
			cacheTileStrip(starBmpdata,starBmpdataArray);
			
			// WIPE BLOCK 1
			cacheTileStrip(wipe1Bmpdata,wipe1BmpdataArray);
					
			// PARTICLE
			partBmpdata.applyFilter(partBmpdata, partBmpdata.rect, new Point(0, 0), filtPronounced);
			yellowpartBmpdata.applyFilter(yellowpartBmpdata, yellowpartBmpdata.rect, new Point(0, 0), filtPronounced);
			particleBeamBmpdata.applyFilter(particleBeamBmpdata, particleBeamBmpdata.rect, new Point(0, 0), filtPronounced);
			
			cacheTileStrip(partBmpdata,partBmpdataArray);
			cacheTileStrip(yellowpartBmpdata,yellowpartBmpdataArray);
			cacheTileStrip(particleBeamBmpdata,particleBeamBmpdataArray);
				
			// bullets
			bullBmpdata.applyFilter(bullBmpdata, bullBmpdata.rect, new Point(0, 0), filtPronounced);
			//bullSuitBmpdata.applyFilter(bullSuitBmpdata, bullSuitBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(bullBmpdata, bullBmpdataArray);
			mirrorTileSegments(bullBmpdata,bullBmpdataArrayL);
			
			cacheTileStrip(bullSuitBmpdata, bullSuitBmpdataArray);
			mirrorTileSegments(bullSuitBmpdata,bullSuitBmpdataArrayL);
			
			cacheTileStrip(bullvertBmpdata, bullvertBmpdataArray);
			
			// PLAYER 
			//playerBmpdata.applyFilter(playerBmpdata, playerBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(playerBmpdata, playerBmpdataArray);
			generateFlash(playerBmpdata, playerBmpdataArray);
			
			mirrorTileSegments(playerBmpdata,playerBmpdataArrayL);
			generateFlashFromArray(playerBmpdataArrayL);
			
			// player with mech suit
			//sniperJoeBmpdata.applyFilter(sniperJoeBmpdata, sniperJoeBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(sniperJoeBmpdata, sniperJoeBmpdataArray);
			generateFlash(sniperJoeBmpdata, sniperJoeBmpdataArray);
			
			mirrorTileSegments(sniperJoeBmpdata,sniperJoeBmpdataArrayL);
			generateFlashFromArray(sniperJoeBmpdataArrayL);

			
			// Nano shoes collected
			playerNanoShoesBmpdata.applyFilter(playerNanoShoesBmpdata, playerNanoShoesBmpdata.rect, new Point(0, 0), filtPronounced);
			
			cacheTileStrip(playerNanoShoesBmpdata, playerNanoShoesBmpdataArray);
			generateFlash(playerNanoShoesBmpdata, playerNanoShoesBmpdataArray);
			
			mirrorTileSegments(playerNanoShoesBmpdata,playerNanoShoesBmpdataArrayL);
			generateFlashFromArray(playerNanoShoesBmpdataArrayL);
			

			// ENEMIES SPRITES AND TILES
			
			// Spawner
			cacheTileStrip(spawnerBmpdata,spawnerBmpdataArray);
			generateFlash(spawnerBmpdata,spawnerBmpdataArray);
			
			// Ememy bullets
			cacheTileStrip(enemybulletBmpdata,enemybulletBmpdataArray);
			
			// Soldier
			//soldierBmpdata.applyFilter(soldierBmpdata, soldierBmpdata.rect, new Point(0, 0), filtPronounced);

			soldierBmpdata=mirrorTileStrip(soldierBmpdata);
			cacheTileStrip(soldierBmpdata,soldierBmpdataArray);
			generateFlash(soldierBmpdata,soldierBmpdataArray);
				
			// Ghost
			//ghostBmpdata.applyFilter(ghostBmpdata, ghostBmpdata.rect, new Point(0, 0), filtPronounced);

			ghostBmpdata=mirrorTileStrip(ghostBmpdata);
			cacheTileStrip(ghostBmpdata,ghostBmpdataArray);
			generateFlash(ghostBmpdata,ghostBmpdataArray);
			ghostBmpdataArray2 = ghostBmpdataArray;
			
			// Saucer
			cacheTileStrip(saucerBmpdata,saucerBmpdataArray);
			generateFlash(saucerBmpdata,saucerBmpdataArray);
			
			// Spikes
			cacheTileStrip(spikesbottomBmpdata,spikesbottomBmpdataArray);		
			cacheTileStrip(spikestopBmpdata,spikestopBmpdataArray);		
			
			// Turrets
			cacheTileStrip(turrettopBmpdata,turrettopBmpdataArray);		
			cacheTileStrip(turretbottomBmpdata,turretbottomBmpdataArray);		
			cacheTileStrip(turretleftBmpdata,turretleftBmpdataArray);		
			cacheTileStrip(turretrightBmpdata,turretrightBmpdataArray);		
			
			// TILES
			//tlsBmpdata.applyFilter(tlsBmpdata, tlsBmpdata.rect, new Point(0, 0), filtMinimal);
			//bgtlsBmpdata.applyFilter(bgtlsBmpdata, bgtlsBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(parallaxTilesBmpdata,parallaxTilesBmpdataArray);
			cacheTileStrip(parallaxTilesRedBmpdata,parallaxTilesRedBmpdataArray);
			cacheTileStrip(tlsBmpdata,tlsBmpdataArray);
			cacheTileStrip(tlsRedBmpdata,tlsRedBmpdataArray);
			cacheTileStrip(bgtlsBmpdata,bgtlsBmpdataArray);		
			cacheTileStrip(spritestripBmpdata,spritestripBmpdataArray);

			// WALL FADE
			cacheTileStrip(wallfade1Bmpdata,wallfade1BmpdataArray);		

			// FLASHING BLOCKS
			cacheTileStrip(flashingBlockBmpdata,flashingBlockBmpdataArray);		

			// EXPLOSION
			explosionBmpdata.applyFilter(explosionBmpdata, explosionBmpdata.rect, new Point(0, 0), filtPronounced);
			explosionSmallBmpdata.applyFilter(explosionSmallBmpdata, explosionSmallBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(explosionBmpdata,explosionBmpdataArray);		
			cacheTileStrip(explosionSmallBmpdata,explosionSmallBmpdataArray);		

			// LAVA
			cacheTileStrip(lavaBmpdata,lavaBmpdataArray);		
			
			// INFO TERMINAL
			infoBmpdata.applyFilter(infoBmpdata, infoBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(infoBmpdata,infoBmpdataArray);		

			// PICKUPS
			
			// COINS
			coinBmpdata.applyFilter(coinBmpdata, coinBmpdata.rect, new Point(0, 0), filtPronounced);

			coinBmpdata = mirrorTileStrip(coinBmpdata);
			cacheTileStrip(coinBmpdata,coinBmpdataArray);		
					
			nanoshoeBmpdata = mirrorTileStrip(nanoshoeBmpdata);
			cacheTileStrip(nanoshoeBmpdata,nanoshoeBmpdataArray);		
			
			// KEYCARD
			//keycardBmpdata = mirrorTileStrip(keycardBmpdata);
			keycardBmpdata.applyFilter(keycardBmpdata, keycardBmpdata.rect, new Point(0, 0), filtPronounced);

			cacheTileStrip(keycardBmpdata,keycardBmpdataArray);		
			
			// HEARTANIM
			heartanimBmpdata.applyFilter(heartanimBmpdata, heartanimBmpdata.rect, new Point(0, 0), filtPronounced);

			heartanimBmpdata = mirrorTileStrip(heartanimBmpdata);
			cacheTileStrip(heartanimBmpdata,heartanimBmpdataArray);		

			// GUI AND TITLE SCREEN
			//cacheTileStrip(logoBmpdata,lavaBmpdataArray);		

			
		}
	
		//----------------------------------------------------------------------------------------
		// cacheBlitObject - rotates and caches
		//
		// Paramaters:
		// @bitmapDataToCache - the bitmap data to cache
		// @arrayToCacheTo - the array to store the bitmap data cache
		//----------------------------------------------------------------------------------------
		
		public function cacheBlitObject(bitmapDataToCache:BitmapData,arrayToCacheTo:Vector.<BitmapData>,widthOfEnemy:int):void
		{
			// caches 90 frames at 4 degrees each

			var sourceX:int=0;    
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,widthOfEnemy,widthOfEnemy);		
			var destPoint:Point=new Point(0,0); 

			for(i=0; i<91; i++)
			{
				arrayToCacheTo[i] = new BitmapData(widthOfEnemy, widthOfEnemy, true, 0x00000000);   	
				sourceX=0;    
				sourceY=0;
				sourceRect=new Rectangle(sourceX,sourceY,widthOfEnemy,widthOfEnemy);
				arrayToCacheTo[i].copyPixels(bitmapDataToCache,sourceRect,destPoint, null, null, true); 				
				arrayToCacheTo[i]=generateRotation(arrayToCacheTo[i],i*4);		
			}		
		}	
						
		//----------------------------------------------------------------------------------------
		// generateRotation
		//----------------------------------------------------------------------------------------
	
		private function generateRotation(DATA:BitmapData,ROTATETO:int):BitmapData   
		{ 
			var degrees:int=ROTATETO; 
			var angle_in_radians:Number = Math.PI * 2 * (ROTATETO / 360); 
			var rotationMatrix:Matrix = new Matrix(); 
			var width:int=DATA.width/2;
			rotationMatrix.translate(-width,-width); 
			rotationMatrix.rotate(angle_in_radians); 
			rotationMatrix.translate(width,width); 
			var matrixImage:BitmapData = new BitmapData(width*2,width*2, true, 0x00000000); 
			matrixImage.draw(DATA, rotationMatrix); 
			return matrixImage; 
		}	
		
		//----------------------------------------------------------------------------------------
		// cacheTileStrip - frame by frame caching
		//
		// Paramaters:
		// @bitmapDataToCache - the bitmap data to cache
		// @arrayToCacheTo - the array to store the bitmap data cache
		//----------------------------------------------------------------------------------------
		
		public function cacheTileStrip(bitmapDataToCache:BitmapData,arrayToCacheTo:Vector.<BitmapData>):void
		{
			var sourceX:int=0;    
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,bitmapDataToCache.height,bitmapDataToCache.height);		
			var destPoint:Point=new Point(0,0); 

			for(i=0; i<(bitmapDataToCache.width/bitmapDataToCache.height); i++)
			{
				arrayToCacheTo[i] = new BitmapData(bitmapDataToCache.height, bitmapDataToCache.height, true, 0x00000000);   	
				sourceX=i*bitmapDataToCache.height;    
				sourceY=0;
				sourceRect=new Rectangle(sourceX,sourceY,bitmapDataToCache.height,bitmapDataToCache.height);
				arrayToCacheTo[i].copyPixels(bitmapDataToCache,sourceRect,destPoint, null, null, true); 				
			}
		}
		
		//----------------------------------------------------------------------------------------
		// mirrorTileStrip - appends entire strip horizontally mirrored, order of chunks preserved
		//----------------------------------------------------------------------------------------
		
		public function mirrorTileSegments(bitmapDataToCache:BitmapData,arrayToCacheTo:Vector.<BitmapData>):void
		{
			var sourceX:int=0;    
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,bitmapDataToCache.height,bitmapDataToCache.height);		
			var destPoint:Point = new Point(0, 0);
			var tmpBD:BitmapData;

			for(i=0; i<(bitmapDataToCache.width/bitmapDataToCache.height); i++)
			{
				arrayToCacheTo[i] = new BitmapData(bitmapDataToCache.height, bitmapDataToCache.height, true, 0x00000000);   	
				tmpBD = new BitmapData(bitmapDataToCache.height, bitmapDataToCache.height, true, 0x00000000);   	
				sourceX=i*bitmapDataToCache.height;    
				sourceY=0;
				sourceRect=new Rectangle(sourceX,sourceY,bitmapDataToCache.height,bitmapDataToCache.height);
				tmpBD.copyPixels(bitmapDataToCache,sourceRect,destPoint, null, null, true); 				
				var mirrorMatrix : Matrix = new Matrix( -1, 0, 0, 1, bitmapDataToCache.height, 0 );
				var imageMirror : BitmapData = new BitmapData(bitmapDataToCache.height,bitmapDataToCache.height,true, 0x00000000)
				arrayToCacheTo[i].draw( tmpBD, mirrorMatrix );
				//bD.copyPixels( bitmapDataToMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( 0, 0 ), null, null, false);
				//bD.copyPixels( imageMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( bitmapDataToMirror.width, 0 ), null, null, false);

			}
		}		
				
		//----------------------------------------------------------------------------------------
		// mirrorTileStrip - appends entire strip horizontally mirrored in 1 chunk
		//----------------------------------------------------------------------------------------
		
		public function mirrorTileStrip(bitmapDataToMirror:BitmapData):BitmapData
		{
			var sourceX:int=0;
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,bitmapDataToMirror.width,bitmapDataToMirror.height);		
			var destPoint:Point=new Point(0,0);
			var bD:BitmapData = new BitmapData(bitmapDataToMirror.width*2,bitmapDataToMirror.height);
			
			var mirrorMatrix : Matrix = new Matrix( -1, 0, 0, 1, bitmapDataToMirror.width, 0 );
			var imageMirror : BitmapData = new BitmapData(bitmapDataToMirror.width,bitmapDataToMirror.height,true, 0x00000000)
			imageMirror.draw( bitmapDataToMirror, mirrorMatrix );
			bD.copyPixels( bitmapDataToMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( 0, 0 ), null, null, false);
			bD.copyPixels( imageMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( bitmapDataToMirror.width, 0 ), null, null, false);
			return bD;
		}		
		
		//----------------------------------------------------------------------------------------
		// mirroredTileStrip - mirrors just this section and returns it if set equal to the output
		//----------------------------------------------------------------------------------------
		
		public function mirroredTileStrip(bitmapDataToMirror:BitmapData):BitmapData
		{
			var sourceX:int=0;
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,bitmapDataToMirror.width,bitmapDataToMirror.height);		
			var destPoint:Point=new Point(0,0);
			var bD:BitmapData = new BitmapData(bitmapDataToMirror.width,bitmapDataToMirror.height);
			
			var mirrorMatrix : Matrix = new Matrix( -1, 0, 0, 1, bitmapDataToMirror.width, 0 );
			var imageMirror : BitmapData = new BitmapData(bitmapDataToMirror.width,bitmapDataToMirror.height,true, 0x00000000)
			imageMirror.draw( bitmapDataToMirror, mirrorMatrix );
			//bD.copyPixels( bitmapDataToMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( 0, 0 ), null, null, false);
			bD.copyPixels( imageMirror, new Rectangle( 0, 0, bitmapDataToMirror.width, bitmapDataToMirror.height ), new Point( 0, 0 ), null, null, false);
			return bD;
		}
		
		//----------------------------------------------------------------------------	
		// flash cache
		//----------------------------------------------------------------------------		
		private function generateFlash(bitmapDataToCache:BitmapData,arrayToCacheTo:Vector.<BitmapData>):void
		{ 
			itemNo++;
			//trace("Array length=" + arrayToCacheTo.length);
			var matrix:Array = new Array();
			matrix=matrix.concat([1,0,0,0,176]);// red
			matrix=matrix.concat([0,1,0,0,255]);// green
			matrix=matrix.concat([0,0,1,0,80]);// blue
			matrix=matrix.concat([0,0,0,0.8,0]);// alpha			
			var my_filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var sourceX:int=0;    
			var sourceY:int=0;
			var sourceRect:Rectangle = new Rectangle(sourceX, sourceY, bitmapDataToCache.height, bitmapDataToCache.height);
			var destPoint:Point = new Point(0, 0);
			//var length:int = bitmapDataToCache.width / bitmapDataToCache.height;
			var length:int = arrayToCacheTo.length;
			for(i=0; i<length; i++)
			{
				arrayToCacheTo[i+length] = new BitmapData(bitmapDataToCache.height, bitmapDataToCache.height, true, 0x00000000);   	
				sourceX=i*bitmapDataToCache.height;    
				sourceY=0;
				sourceRect=new Rectangle(sourceX,sourceY,bitmapDataToCache.height,bitmapDataToCache.height);
				arrayToCacheTo[i+length].copyPixels(bitmapDataToCache,sourceRect,destPoint, null, null, false); 				
				arrayToCacheTo[i+length].applyFilter
				(
					arrayToCacheTo[i+length], 
					arrayToCacheTo[i+length].rect, 
					new Point(), 
					my_filter
				);
				//Reg.renderer.mainCanvas.blitAtPoint(arrayToCacheTo[i + length], i * 30, 10 + (itemNo * 30));
			}
			
			//trace("Array length=" + arrayToCacheTo.length);
		}	
			
		//----------------------------------------------------------------------------	
		// flash cache
		//----------------------------------------------------------------------------		
		private function generateFlashFromArray(arrayToCacheTo:Vector.<BitmapData>):void
		{ 
			var matrix:Array = new Array();
			matrix=matrix.concat([1,0,0,0,176]);// red
			matrix=matrix.concat([0,1,0,0,255]);// green
			matrix=matrix.concat([0,0,1,0,80]);// blue
			matrix=matrix.concat([0,0,0,0.8,0]);// alpha			
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			var sourceX:int=0;    
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,arrayToCacheTo[0].height, arrayToCacheTo[0].height);		
			var destPoint:Point=new Point(0,0); 
			var length:int = arrayToCacheTo.length;
			for(i=0; i<length; i++)
			{
				arrayToCacheTo[i+length] = new BitmapData(arrayToCacheTo[0].height, arrayToCacheTo[0].height, true, 0x00000000);   	
				sourceX = 0;// i * bitmapDataToCache.height;    
				sourceY=0;
				sourceRect=new Rectangle(sourceX,sourceY,arrayToCacheTo[0].height,arrayToCacheTo[0].height);
				arrayToCacheTo[i+length].copyPixels(arrayToCacheTo[i],sourceRect,destPoint, null, null, true); 				
				arrayToCacheTo[i+length].applyFilter
				(
					arrayToCacheTo[i+length], 
					arrayToCacheTo[i+length].rect, 
					new Point(), 
					my_filter
				);
			}			
		}	
		
		//----------------------------------------------------------------------------
		// createFades
		//----------------------------------------------------------------------------	
		private function createFades(bitmapDataSource:BitmapData,arrayToCacheTo:Vector.<BitmapData>):void
		{			
			var sourceX:int=0;
			var sourceY:int=0;
			var sourceRect:Rectangle=new Rectangle(sourceX,sourceY,bitmapDataSource.height,bitmapDataSource.height);		
			var destPoint:Point=new Point(0,0);

			for(i=0; i<(11); i++)
			{
				arrayToCacheTo[i] = new BitmapData(bitmapDataSource.height, bitmapDataSource.height, true, 0x00000000);   	
				arrayToCacheTo[i].copyPixels(bitmapDataSource,sourceRect,destPoint, null, null, true); 				

				//var b:BitmapData = new BitmapData(bitmapDataSource.width, bitmapDataSource.height, true, 0x00000000); 
				//b.copyPixels(bitmapDataSource, bitmapDataSource.rect, new Point(), null, null, true); 	
				
				var matrix:Array = new Array();
				
				matrix=matrix.concat([1,0,0,0,0]); // red
				matrix=matrix.concat([0,1,0,0,0]); // green
				matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
				matrix = matrix.concat([0, 0, 0, 0.4, (i-10-1) * 100]); // alpha	
				// matrix = matrix.concat([0, 0, 0, 0.8, 0]); // alpha	
			 
				var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
				arrayToCacheTo[i].applyFilter
				(arrayToCacheTo[i], arrayToCacheTo[i].rect, new Point(), my_filter);
				
			}

		}			
		
		//----------------------------------------------------------------------------
		// filter
		//----------------------------------------------------------------------------	
		private function filter(effect:int,bmd:BitmapData):BitmapData
		{			
			var b:BitmapData = new BitmapData(bmd.width, bmd.height, true);
			b.copyPixels(bmd, bmd.rect, new Point());
			var matrix:Array = new Array();
			//if (effect == FLASH)
			//{
				matrix=matrix.concat([1,0,0,0,0]); // red
				matrix=matrix.concat([0,1,0,0,0]); // green
				matrix=matrix.concat([0,0,1,0,0]); // blue
				//matrix = matrix.concat([0, 0, 0, 0.4, (filterAmount / filterMax) * 100]); // alpha	
			//}	
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			b.applyFilter
			(b, b.rect, new Point(), my_filter);
			return b;
		}		
		
		
		//----------------------------------------------------------------------------
		// change array palette to
		//----------------------------------------------------------------------------	
		private function changeArrayPaletteTo(color:String, arraySrc:Vector.<BitmapData>, arrayDest:Vector.<BitmapData>):void
		{	
			var sourceX:int=0;    
			var sourceY:int=0;
			var destPoint:Point=new Point(0,0); 
			for (i = 0; i < arraySrc.length; i++)
			{
				arrayDest[i] = new BitmapData(arraySrc[0].height, arraySrc[0].height, true, 0x00000000);  
				var sourceRect:Rectangle=new Rectangle(0,0,arraySrc[0].height, arraySrc[0].height);		
				var sourceRect2:Rectangle=new Rectangle(0,0,1,1);		
				for (j = 0; j < arraySrc[0].height; j++)
				{
					for (k = 0; k < arraySrc[0].height; k++)
					{
						var colour:int = arraySrc[0].getPixel(j, k);
						var r1:int = colour >> 16;
						var g1:int = (colour >> 8) & 0xFF;
						var b1:int = colour & 0x00FF;
						
						var r2:int = (g1>255)? 255 : ((g1<0)?0:g1);
						var g2:int = (b1>255)? 255 : ((b1<0)?0:b1);
						var b2:int = (r1>255)? 255 : ((r1<0)?0:r1);
						
						var hexCol:int = (r2<<16)|(g2 << 8)|b2;
						
						var newPixel:BitmapData = new BitmapData(1, 1, true, hexCol);
						arrayDest[i].copyPixels(newPixel, sourceRect, new Point(j, k), null, null, true);
											
					}
				}
			}
		}
	
		
		
		
		
		
		
		
	//----------------------------------------------------------------------------
		// change array palette to
		//----------------------------------------------------------------------------	
/*var colorToReplace:uint = 0xffff0000; var newColor:uint = 0xff0000ff; var maskToUse:uint = 0xffffffff;  var rect:Rectangle = new Rectangle(0,0,bitmapData.width,bitmapData.height); var p:Point = new Point(0,0); bitmapData.threshold(bitmapData, rect, p, "==", colorToReplace,          newColor, maskToUse, true); */

		public function changeItemColorTo(item:String,palette:int):void
		{	
			return;
			var colorToReplace1:uint = 0xff3f4b08; // dark outline
			var colorToReplace2:uint = 0xff809617; // 2nd darkest
			var colorToReplace3:uint = 0xffd5e87a; // light
			var colorToReplace4:uint = 0xffadc43e; // 2nd lightest
			var colorToReplace5:uint = 0xff8f9064; // transparent?
			
			var maskToUse:uint = 0xffffffff;  
			var rect:Rectangle = new Rectangle(0, 0, ghostBmpdata.width, ghostBmpdata.height); 
			var p:Point = new Point(0, 0); 
					

			if (palette == RED)
			{
				var newColor1:uint = 0xffa80000; 
				var newColor2:uint = 0xffc83038; 
				var newColor3:uint = 0xffd59f93; 	
				var newColor4:uint = 0xffe89850;
				var newColor5:uint = 0xfff8d098;
			}			
			else if (palette == BLUE)
			{
				newColor1 = 0xff1e2e46; 
				newColor2 = 0xff508490; 
				newColor3 = 0xffb4c8ac; 	
				newColor4 = 0xff70c0c0;
				newColor5 = 0xfff0e8f0;
			}
			else if (palette == YELLOW)
			{
				newColor1 = 0xff6e481c; 
				newColor2 = 0xffb0e018; 
				newColor3 = 0xfff8e850; 
				newColor4 = 0xffc3e755;
				newColor5 = 0xfff8f8f8;
			}
		
			if (item == "Ghost")
			{
				if (palette == GREEN)
				{
					ghostBmpdata2.copyPixels(ghostBmpdata, ghostBmpdata.rect, new Point(), null, null, true);
					ghostBmpdata2=mirrorTileStrip(ghostBmpdata2);
					cacheTileStrip(ghostBmpdata2,ghostBmpdataArray2);
					generateFlash(ghostBmpdata2, ghostBmpdataArray2);
					return;
				}
				ghostBmpdata2.copyPixels(ghostBmpdata, ghostBmpdata.rect, new Point(), null, null, true);
				ghostBmpdata2.threshold(ghostBmpdata2, rect, p, "==", colorToReplace1, newColor1, maskToUse, true);
				ghostBmpdata2.threshold(ghostBmpdata2, rect, p, "==", colorToReplace2, newColor2, maskToUse, true);
				ghostBmpdata2.threshold(ghostBmpdata2, rect, p, "==", colorToReplace3, newColor3, maskToUse, true);
				ghostBmpdata2.threshold(ghostBmpdata2, rect, p, "==", colorToReplace4, newColor4, maskToUse, true);
				ghostBmpdata2.threshold(ghostBmpdata2, rect, p, "==", colorToReplace5, newColor5, maskToUse, true);
				ghostBmpdata2=mirrorTileStrip(ghostBmpdata2);
				cacheTileStrip(ghostBmpdata2,ghostBmpdataArray2);
				generateFlash(ghostBmpdata2,ghostBmpdataArray2);
			}		
		}		
		
		
		
		
		
		
		
		
		
		
	}
}