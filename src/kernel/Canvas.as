package kernel 
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import gameobjects.Infopoint;	
	import flash.geom.Rectangle;
	import flash.geom.Point;	
	import gameobjects.GameObject;	
	import kernel.Globals;		
	import flash.filters.*;
	import flash.geom.*;

	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	
	public class Canvas
	{	
		public var cycleFont:String = "Red";
		public var cycleTime:int;
		public var dialogueLine:int;
		public var dialogueLines:int;
		public var dialogueOffset0:int;
		public var dialogueOffset1:int;
		public var dialogueOffset2:int;
		public var dialogueOffset3:int;
		public var dialogueIndex0:int;
		public var dialogueIndex1:int;
		public var dialogueIndex2:int;
		public var dialogueIndex3:int;
		public var dialogueTimer:int;
		public var dialogueActive:Boolean;
		public var dialogueText0:String;
		public var dialogueText1:String;
		public var dialogueText2:String;
		public var dialogueText3:String;
		
		public var offset:int;
		public var currentDialogueLine:int;
		
		public var upperCase:Array =
			[
				12, // A
				12, // B
				12, // C
				12, // D
				12, // E
				12, // F
				12, // G
				12, // H
				4,  // I
				12, // J
				12, // K
				12, // L
				12, // M
				12, // N
				12, // O
				12, // P
				12, // Q
				12, // R
				12, // S
				12, // T
				12, // U
				12, // V
				12, // W
				12, // X
				12, // Y
				12  // Z
			];
		
		
		public var lowerCase:Array =
			[
				12, // A
				12, // B
				12, // C
				12, // D
				12, // E
				12, // F
				12, // G
				12, // H
				4,  // I
				12, // J
				12, // K
				4, // L
				12, // M
				12, // N
				12, // O
				12, // P
				12, // Q
				12, // R
				12, // S
				6, // T
				12, // U
				12, // V
				12, // W
				12, // X
				12, // Y
				12  // Z
			];									
		
		public var digits:Array =
			[
				12, // 0
				6, // 1
				12, // 2
				12, // 3	
				12, // 4	
				12, // 5	
				12, // 6	
				10, // 7	
				12, // 8	
				12  // 9
			];	
		
		public var punctuation:Array =
			[
				12, 	// space
				6, 		// apostrophe
				4, 		// comma
				4, 		// full stop
				4, 		// exclamation mark
				12  	// question mark
			];
		
		//----------------------------------------------------------------------------------------
		// Misc
		
		private var i							:int;
		private var j							:int;
		private var k							:int;
		private var r							:int;
		private var c							:int;

		//----------------------------------------------------------------------------------------
		// colorPalette

		//private var colorPalette1				:uint=0x011631;
		//private var colorPalette1				:uint=0x0090f0;
		private	var colorPalette1				:uint=0xFFFFFF;
		//private var colorPalette1				:uint=0x1d1c2f;
		private	var colorPalette2				:uint=0x000000;
		private	var colorPalette3				:uint=0xb5a56b;
		private	var colorPalette4				:uint=0xe7d69c;
		private	var colorPalette5				:uint=0x393929;
		
		//----------------------------------------------------------------------------------------
		// canvas
		
		public var scale						:int; 	
		public var width						:int; 	
		public var height						:int; 	
		public var blurFilter					:BlurFilter; 	
		public var displaceBmp					:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		public var backBufferData				:BitmapData; 	
		public var filterBufferData				:BitmapData; 	
		public var backBuffer					:Bitmap;
		public var textBufferData				:BitmapData; 	
		public var textBuffer					:Bitmap;
		private var blitRect					:Rectangle = new Rectangle(0, 0, 0, 0);
		private var backgroundRect				:Rectangle;
		private var backgroundBD				:BitmapData;   
		private var backgroundPoint				:Point = new Point(0, 0);          
		public var blankCanvasBD				:BitmapData;	
		private var bufferWidth					:int;
		private var bufferHeight				:int;		
		public var bufferRect					:Rectangle;		
		public var bufferPoint					:Point;
		private var point						:Point = new Point(0, 0);
		private	var sourceX						:int=0;    
		private	var sourceY						:int=0;
		private	var destPoint					:Point=new Point();
		private	var sourceRect					:Rectangle = new Rectangle(sourceX, sourceY, 15, 15);			
		public var shakeoffsetx					:int=0;
		public var shakeoffsety					:int=0;					
		public var screenShake					:Boolean;
		public var screenShakeTimer				:int;
		public var glow							:GlowFilter;
		// Constructor
		public function Canvas() 
		{
			scale					=		Reg.player.SCREEN_SCALE;
			width					=		Globals.SCREEN_WIDTH/Reg.player.SCREEN_SCALE; 	
			height					=		Globals.SCREEN_HEIGHT/Reg.player.SCREEN_SCALE; 	
			bufferPoint 			=		new Point(0, 0);
			blankCanvasBD			=		new BitmapData(width, height, false, 0x00110000); //4455dd				
			bufferRect				=		new Rectangle(0,0,width, height);		
			backBufferData 			= 		new BitmapData(Globals.SCREEN_WIDTH / Reg.player.SCREEN_SCALE,
											Globals.SCREEN_HEIGHT / Reg.player.SCREEN_SCALE, false, 0x000000);
			//filterBufferData		= 		new BitmapData(Globals.SCREEN_WIDTH / Reg.player.SCREEN_SCALE,
			//								Globals.SCREEN_HEIGHT / Reg.player.SCREEN_SCALE, false, 0x000000);
			backBuffer 				= 		new Bitmap(backBufferData); 
			//textBufferData 			= 		new BitmapData(width, height, true, 0xffffff);
			//textBuffer 				= 		new Bitmap(textBufferData); 
			backBuffer.scaleX 		= 		Reg.player.SCREEN_SCALE;
			backBuffer.scaleY 		= 		Reg.player.SCREEN_SCALE;			
			backBuffer.y			=		0;		
			blitRect.x 				= 		0;
			blitRect.y 				= 		0;
		}		
		
		//----------------------------------------------------------------------------
		// Changes screen scale
		//----------------------------------------------------------------------------

		// Displaces the canvas
		public function changeScreenScale(newScale:int):void
		{			
			scale					=		newScale;
			width					=		Globals.SCREEN_WIDTH / newScale; 				
			height					=		Globals.SCREEN_HEIGHT / newScale; 
			backgroundBD			=		new BitmapData(width, height, true, colorPalette1)
			blankCanvasBD			=		new BitmapData(width, height, false, colorPalette2);			
			bufferRect				=		new Rectangle(0, 0, width, height);		
			backBufferData 			= 		new BitmapData(width, height, false,colorPalette1); 
			textBufferData 			= 		new BitmapData(width * 2, height * 2, true, 0xffffff); 
			backBuffer.scaleX 		= 		newScale;
			backBuffer.scaleY 		= 		newScale;				
			return;
		}			
		
		//----------------------------------------------------------------------------
		// Blit Functions
		//----------------------------------------------------------------------------

		// Clears the entire canvas		
		public function clear():void
		{
			blitRect.width = Globals.SCREEN_WIDTH/Reg.player.SCREEN_SCALE;
			blitRect.height = Globals.SCREEN_HEIGHT/Reg.player.SCREEN_SCALE;
			point.x = 0;
			point.y = 0;
			//backBufferData.copyPixels(blankCanvasBD, blitRect, point);			
			backBufferData.copyPixels(Reg.gradientBackground, blitRect, point);			
			return;		
		}
		
		// Draws a specified bitmapdata at a specific point				
		public function blitAtPoint(image:BitmapData,x:int,y:int):void
		{	
			blitRect.width = image.width;
			blitRect.height = image.height;
			point.x = x + shakeoffsetx;
			point.y = y + shakeoffsety;
			backBufferData.copyPixels(image, blitRect, point);
			return;				
		}		
		
		// Draws a specified bitmapdata at a specific point	WITHOUT screen shake			
		public function blitStatic(image:BitmapData,x:int,y:int):void
		{	
			blitRect.width = image.width;
			blitRect.height = image.height;
			point.x = x;
			point.y = y;
			backBufferData.copyPixels(image, blitRect, point);
			return;				
		}
					
		// Draws a level	
		public function blitLevel(bdata:BitmapData):void
		{	
			blitRect.width = bdata.width;
			blitRect.height = bdata.height;			
			point.x = 0 + shakeoffsetx;
			point.y = 0 + shakeoffsety;
			backBufferData.copyPixels(bdata, blitRect, point, null, null, true);
			return;				
		}		
		
		// Draws a game object	
		public function blit(blitObject:GameObject):void
		{	
			blitRect.width = blitObject.bmpData.width;
			blitRect.height = blitObject.bmpData.height;			
			point.x = blitObject.x + shakeoffsetx;
			point.y = blitObject.y + shakeoffsety;
			backBufferData.copyPixels(blitObject.bmpData, blitRect, point);
			return;				
		}
	
		// Sets dialogue text
		public function setDialogue(node:int):void
		{	
			if (Reg.player.level == 1)
			{
				//trace("Info point node number = " + node);
				if (node == 1)
				{
					dialogueText0 = "PRESS UP TO JUMP, AND HOLD UP FOR MORE POWER.  HOLD 'X'";
					dialogueText1 = "TO FIRE THE NANO CANNON.  TAP LEFT OR RIGHT TWICE TO RUN.";
					dialogueText2 = "STAY ALERT JACK, ENEMY NANOBOTS HAVE BEEN REPORTED IN";
					dialogueText3 = "THE AREA.";
				}				
				if (node == 0)
				{
					dialogueText0 = "ARE YOU ARE READY TO FACE THE NANOBOT HORDE?  STEP INTO";
					dialogueText1 = "THE PORTAL, AND ADVANCE TO LEVEL 2.  GOOD LUCK!";
					dialogueText2 = "";
					dialogueText3 = "";
				}
				if (node == 2)
				{
					dialogueText0 = "WELL DONE JACK.  YOU SURVIVED THE FIRST WAVE OF NANOBOTS!";
					dialogueText1 = "COLLECT THE HEALTH IF YOU NEED IT, AND ANY COINS YOU CAN";
					dialogueText2 = "FIND BEFORE EXITING THE TUTORIAL.  GREATER DANGERS LIE";
					dialogueText3 = "AHEAD, SO GET READY!"; // FOR BATTLE.";
				}
			}
			else if (Reg.player.level == 2)
			{
				if (node == 0)
				{
					dialogueText0 = "YOU HAVE FOUND A PAIR OF MAGIC NANO SHOES, COLLECT THE";
					dialogueText1 = "SHOES TO ACTIVATE YOUR LOW GRAVITY COMBAT SUIT.";
					dialogueText2 = "PRESS 'X' TO FIRE YOUR MECH CANNON, AND";
					dialogueText3 = "DOWN TO DROP YOUR SHOES AND RETURN TO NORMAL.";
				}
				/*if (node == 1)
				{
					dialogueText0 = "THERE ARE REPORTS OF UFOS IN THE VICINITY BE CAREFUL";
					dialogueText1 = " ";
					dialogueText2 = " ";
					dialogueText3 = " ";
				}*/
			}
			else if (Reg.player.level == 3)
			{
				if (node == 0)
				{
					dialogueText0 = "GUN TURRETS HAVE BEEN SIGHTED IN THE AREA.  PROCEED WITH";
					dialogueText1 = "CAUTION...";
					dialogueText2 = " ";
					dialogueText3 = " ";
				}								
				if (node == 1)
				{
					dialogueText0 = "WATCH OUT FOR THE LAVA PITS, ONE FALSE MOVE AND YOU'LL";
					dialogueText1 = "BE TOAST.";
					dialogueText2 = " ";
					dialogueText3 = " ";
				}
			}			
			
		}
		
		// Renders dialogue text
		
		public function renderDialogueTxt(c:String,a:String,xpos:int,ypos:int):void
		{
			if (a.length < 1) return;
			var divscale:int = 0;
			var letterSpacing:int = 0;								
			dialogueOffset0 = 0;								
			dialogueOffset1 = 0;								
			dialogueOffset2 = 0;								
			dialogueOffset3 = 0;								
			var val:int = 0;	
			var val2:int = 0;	
			var letterCase:int = 0;
			var lastletterCase:int = 0;
			
			divscale = 4;
			blitRect.width = blitRect.height = 32;
			
			
			var dialogueCurrentIndex:int = 0;
			if (dialogueLine == 0) dialogueCurrentIndex = dialogueIndex0;
			if (dialogueLine == 1) dialogueCurrentIndex = dialogueIndex1;
			if (dialogueLine == 2) dialogueCurrentIndex = dialogueIndex2;
			if (dialogueLine == 3) dialogueCurrentIndex = dialogueIndex3;
			
			for(i=0;i<dialogueCurrentIndex;i++)
			{
				var indx:int = a.charCodeAt(i);
				
				// current letter
				if (indx >= 97 && indx < (97 + 26))								// lower case	
				{val = indx - 97 + 26; letterCase = 0;}		
				else if (indx >= 65 && indx < (65 + 26))						// uppercase								
				{val = indx - 65; letterCase = 1;}	
				else if (indx >= 48 && indx < (48 + 10))						// digits								
				{val = indx - 48 + 58; letterCase = 2;}
					
				else if (indx == 32) {val = 52; letterCase = 3;}				// space				
				else if (indx == 39) {val = 53; letterCase = 3;}				// apostrophe				
				else if (indx == 44) {val = 54; letterCase = 3;}				// comma				
				else if (indx == 46) {val = 55; letterCase = 3;}				// full stop
				else if (indx == 33) {val = 56; letterCase = 3;}				// exclamation mark
				else if (indx == 63) {val = 57; letterCase = 3;}				// question mark	
				
				if (i > 0) var indx2:int = a.charCodeAt(i - 1);

				//previous letter
				if (indx2 >= 97 && indx2 < (97 + 26))							// lower case	
				{val2 = indx2 - 97 + 26; 		lastletterCase = 0;	}		
				else if (indx2 >= 65 && indx2 < (65 + 26))						// uppercase								
				{val2 = indx2 - 65;				lastletterCase = 1;	}	
				else if (indx2 >= 48 && indx2 < (48 + 10))						// digits								
				{val2 = indx2 - 48 + 58;		lastletterCase = 2;	}   					
				else if (indx2 == 32) {val2 = 52; lastletterCase = 3;}			// space				
				else if (indx2 == 39) {val2 = 53; lastletterCase = 3;}			// apostrophe				
				else if (indx2 == 44) {val2 = 54; lastletterCase = 3;}			// comma				
				else if (indx2 == 46) {val2 = 55; lastletterCase = 3;}			// full stop
				else if (indx2 == 33) {val2 = 56; lastletterCase = 3;}			// exclamation mark
				else if (indx2 == 63) {val2 = 57; lastletterCase = 3;}			// question mark							
				
				if (lastletterCase == 0) { letterSpacing = lowerCase[val2 - 26] / divscale; }
				if (letterCase == 0) { blitRect.width = lowerCase[val - 26] / divscale; }		
				
				if (lastletterCase == 1) { letterSpacing = upperCase[val2] / divscale; }
				if (letterCase == 1) { blitRect.width = upperCase[val] / divscale; }
				
				if (lastletterCase == 2) { letterSpacing = digits[val2 - 58] / divscale; }
				if (letterCase == 2) { blitRect.width = digits[val - 58] / divscale; }
				
				if (lastletterCase == 3) { letterSpacing = punctuation[val2 - 52] / divscale; }
				if (letterCase == 3) { blitRect.width = punctuation[val - 52] / divscale; }
				
				if (i == 0) letterSpacing = 0;	
				//if (size == 1) 
				letterSpacing *= 4;
				//if (size == 1) 
				blitRect.width *= 5;
				
				if (dialogueLine == 0) {dialogueOffset0 += letterSpacing; point.x = xpos+dialogueOffset0;}
				if (dialogueLine == 1) {dialogueOffset1 += letterSpacing; point.x = xpos+dialogueOffset1;}
				if (dialogueLine == 2) {dialogueOffset2 += letterSpacing; point.x = xpos+dialogueOffset2;}
				if (dialogueLine == 3) {dialogueOffset3 += letterSpacing; point.x = xpos+dialogueOffset3;}
			
				//point.x += 80;
				point.y = ypos;
				
				if (c == "White") backBufferData.copyPixels(Bmps.bitmapfontBmpDataArray[val], blitRect, point, null, null, true);	
				else backBufferData.copyPixels(Bmps.bitmapfontBmpDataArray[val], blitRect, point, null, null, true);		
			}
			
			
		}		
		
		// Renders text
		
		public function renderTxt(c:String,a:String,xpos:int,ypos:int,size:int,fade:int=0,cycleLetter:Boolean=false,cycleWord:Boolean=false):void
		{
			var divscale:int = 0;
			var letterSpacing:int = 0;								
			offset = 0;								
			var val:int = 0;	
			var val2:int = 0;	
			var letterCase:int = 0;
			var lastletterCase:int = 0;
			
			if (size == 1) {
				divscale = 4;
				blitRect.width = blitRect.height = 22;
			} else if (size == 2) {
				divscale = 2;
				blitRect.width = blitRect.height = 34;
			}
			
			/*
			blitRect.width = Bmps.bitmapfontBmpDataArray[0].height;
			blitRect.height = Bmps.bitmapfontBmpDataArray[0].height;
			*/
			if (cycleLetter) { cycleFontColour();  c = cycleFont; }
				
			for (i = 0; i < a.length; i++)
			{
				
				var indx:int = a.charCodeAt(i);
				
				// current letter
				if (indx >= 97 && indx < (97 + 26))								// lower case	
				{val = indx - 97 + 26; letterCase = 0;}		
				else if (indx >= 65 && indx < (65 + 26))						// uppercase								
				{val = indx - 65; letterCase = 1;}	
				else if (indx >= 48 && indx < (48 + 10))						// digits								
				{val = indx - 48 + 58; letterCase = 2;}
					
				else if (indx == 32) {val = 52; letterCase = 3;}				// space				
				else if (indx == 39) {val = 53; letterCase = 3;}				// apostrophe				
				else if (indx == 44) {val = 54; letterCase = 3;}				// comma				
				else if (indx == 46) {val = 55; letterCase = 3;}				// full stop
				else if (indx == 33) {val = 56; letterCase = 3;}				// exclamation mark
				else if (indx == 63) {val = 57; letterCase = 3;}				// question mark	
				
				if (i > 0) var indx2:int = a.charCodeAt(i - 1);

				//previous letter
				if (indx2 >= 97 && indx2 < (97 + 26))							// lower case	
				{val2 = indx2 - 97 + 26; 		lastletterCase = 0;	}		
				else if (indx2 >= 65 && indx2 < (65 + 26))						// uppercase								
				{val2 = indx2 - 65;				lastletterCase = 1;	}	
				else if (indx2 >= 48 && indx2 < (48 + 10))						// digits								
				{val2 = indx2 - 48 + 58;		lastletterCase = 2;	}   					
				else if (indx2 == 32) {val2 = 52; lastletterCase = 3;}			// space				
				else if (indx2 == 39) {val2 = 53; lastletterCase = 3;}			// apostrophe				
				else if (indx2 == 44) {val2 = 54; lastletterCase = 3;}			// comma				
				else if (indx2 == 46) {val2 = 55; lastletterCase = 3;}			// full stop
				else if (indx2 == 33) {val2 = 56; lastletterCase = 3;}			// exclamation mark
				else if (indx2 == 63) {val2 = 57; lastletterCase = 3;}			// question mark							
				
				if (lastletterCase == 0) { letterSpacing = lowerCase[val2 - 26] / divscale; }
				if (letterCase == 0) { blitRect.width = lowerCase[val - 26] / divscale; }		
				
				if (lastletterCase == 1) { letterSpacing = upperCase[val2] / divscale; }
				if (letterCase == 1) { blitRect.width = upperCase[val] / divscale; }
				
				if (lastletterCase == 2) { letterSpacing = digits[val2 - 58] / divscale; }
				if (letterCase == 2) { blitRect.width = digits[val - 58] / divscale; }
				
				if (lastletterCase == 3) { letterSpacing = punctuation[val2 - 52] / divscale; }
				if (letterCase == 3) { blitRect.width = punctuation[val - 52] / divscale; }
				
				if (i == 0) letterSpacing = 0;	
				letterSpacing *= 2;
				//if (size == 2) letterSpacing -= 1;
				blitRect.width *= 5;
				
				offset += letterSpacing;
				
				if (size == 1) point.x = xpos + offset * 2;
				if (size == 2) point.x = xpos + (offset * 2);
				if (c == "Info") point.x = xpos + (offset * 2);

				//point.x += 80;
				point.y = ypos;
				
				if (size == 0)
				{
					
				}
				if (size == 1)
				{
					if (c == "White") backBufferData.copyPixels(Bmps.bitmapfontBmpDataArray[val], blitRect, point, null, null, true);	
					if (c == "Continue") backBufferData.copyPixels(Bmps.bitmapfontContinueBmpDataArray[val], blitRect, point, null, null, true);	
					if (c == "Info") backBufferData.copyPixels(Bmps.bitmapfontBmpDataArray[val], blitRect, point, null, null, true);	
					if (c == "Fading") 
					{
						if (fade == 0) 
						  backBufferData.copyPixels(Bmps.bitmapfontmain1BmpDataArray[val], blitRect, point, null, null, true);		
						if (fade == 1) 
						  backBufferData.copyPixels(Bmps.bitmapfontmain2BmpDataArray[val], blitRect, point, null, null, true);		
						if (fade == 2) 
						  backBufferData.copyPixels(Bmps.bitmapfontmain3BmpDataArray[val], blitRect, point, null, null, true);		
						if (fade == 3) 
						  backBufferData.copyPixels(Bmps.bitmapfontmain4BmpDataArray[val], blitRect, point, null, null, true);		
						if (fade == 4) 
						  backBufferData.copyPixels(Bmps.bitmapfontmain5BmpDataArray[val], blitRect, point, null, null, true);		
					}
				}
				if (size == 2 && c == "White") backBufferData.copyPixels(Bmps.bitmapfontX2BmpDataArray[val], blitRect, point, null, null, true);		
				if (c == "Red") backBufferData.copyPixels(Bmps.bitmapfontmainbigBmpDataArray1[val], blitRect, point, null, null, true);		
				if (c == "Yellow") backBufferData.copyPixels(Bmps.bitmapfontmainbigBmpDataArray2[val], blitRect, point, null, null, true);		
				if (c == "Green") backBufferData.copyPixels(Bmps.bitmapfontmainbigBmpDataArray3[val], blitRect, point, null, null, true);		
				if (c == "Purple") backBufferData.copyPixels(Bmps.bitmapfontmainbigBmpDataArray4[val], blitRect, point, null, null, true);		
				if (c == "Blue") backBufferData.copyPixels(Bmps.bitmapfontmainbigBmpDataArray5[val], blitRect, point, null, null, true);		
				//if (size == 2)
				//{
				//	backBufferData.copyPixels(Bmps.bitmapfontX2BmpDataArray[val], blitRect, point, null, null, true);	
				//}
			}
		}	
		
		public function cycleFontColour():void {
			if (++cycleTime < 20) return;
			else cycleTime = 0;
			if (cycleFont == "Red") cycleFont = "Yellow";
			else if (cycleFont == "Yellow") cycleFont = "Green";
			else if (cycleFont == "Green") cycleFont = "Purple";
			else if (cycleFont == "Purple") cycleFont = "Blue";
			else if (cycleFont == "Blue") cycleFont = "Red";
		}
	}
}