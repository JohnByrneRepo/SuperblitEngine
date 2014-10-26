package managers 
{
	/**
	 * Barnaby Byrne
	 */
	
	import kernel.*;
	
	public class AudioOptionsManager
	{	
		public var sfxSlider:Slider;
		public var musicSlider:Slider;
		
		public var soundCooloff:int;
		public var musicCooloff:int;
		public var cancelled:Boolean;
		public var quitPressed:Boolean;			
		public var sliderGroup1Y:int;
		public var musicLevelSliderMousePos:int;
		public var sfxLevelSliderMousePos:int;
		public var mouseInLeftPane:Boolean=false;
		public var colorChangeTimer:int;		
		public var spritesScratchTimer:int;				
		
		public var optionsTabNumber:int = 1;		

		public var colSelected:int;		
		
		//public var musicSlider.x:int = 600;
		//public var sfxSlider.x:int = 700;
		public var yoffImageSliderLeft:int = 40;
		public var yspaceSliderLeft:int = 17;
		
		public var column:int = 0;		
		public var mseX:int;
		public var mseY:int;
		public var mseClik:Boolean;		
		public var tabTitlesOffsetX:int = 8;
		public var tabTitlesOffsetY:int = 8;	
		public var i:int;
		public var j:int;
		public var k:int;
					
		public function AudioOptionsManager() 
		{
			sfxSlider = new Slider(368, 225);
			musicSlider = new Slider(368, 250);					
		}
				
		public function clickedInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mseX > x1 && mseX < x2 && mseY > y1 && mseY < y2 && mseClik) return true;
			else return false;
		}
				
		public function mouseIsInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mseX > x1 && mseX < x2 && mseY > y1 && mseY < y2) return true;
			else return false;
		}		
		
		public function mouseIsInHorizRange(x1:int, x2:int):Boolean
		{
			if (mseX > x1 && mseX < x2) return true;
			else return false;
		}
				
		public function mouseIsInVertiRange(y1:int, y2:int):Boolean
		{
			if (mseY > y1 && mseY < y2) return true;
			else return false;
		}
		
		public function update(mouseX:int, mouseY:int, mousePressed:Boolean):void
		{			
			mseX = mouseX;
			mseY = mouseY;
			mseClik = mousePressed;
	
			// Draw sliders
			Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderBarBmpdata, musicSlider.x, musicSlider.y);
			Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderBarBmpdata, sfxSlider.x, sfxSlider.y);
			// Draw icons
			Reg.renderer.mainCanvas.blitAtPoint(Bmps.iconMusicBmpdata, musicSlider.x - 20, musicSlider.y - 5);
			Reg.renderer.mainCanvas.blitAtPoint(Bmps.iconSfxBmpdata, sfxSlider.x - 20, sfxSlider.y - 5);		
			
			checkMusicLevelSliderHorizontal();
							
			// MusicLevel
			if (mseClik && mouseIsInVertiRange(musicSlider.y - 4, musicSlider.y + 18)) { 
				checkMusicLevelSliderHorizontal();
				Reg.musicVol = (musicLevelSliderMousePos / 10) * 2;
				Reg.sfx.changeMusicVolume();
				musicCooloff = 30;
				if (mseX > musicSlider.x + (20 * 5)) mseX = musicSlider.x + (20 * 5);
				if (mseX < musicSlider.x) mseX = musicSlider.x;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderArrowBmpdata, mseX, musicSlider.y);
			} else { 
				checkMusicLevelSliderHorizontal();
				var musicLvlPos:Number = ((Reg.musicVol / 2) * 10) * 20;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderArrowBmpdata, musicSlider.x + musicLvlPos, musicSlider.y);
			}
			checkSfxLevelSliderHorizontal();

			// SfxLevel
			if (mseClik && mouseIsInVertiRange(sfxSlider.y - 4, sfxSlider.y + 18)) { 
				checkSfxLevelSliderHorizontal();
				Reg.sfxVol = sfxLevelSliderMousePos / 10; 
				Reg.sfx.changeSfxVolume();
				soundCooloff = 30;
				if (mseX > sfxSlider.x + (20 * 5)) mseX = sfxSlider.x + (20 * 5);
				if (mseX < sfxSlider.x) mseX = sfxSlider.x;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderArrowBmpdata, mseX, sfxSlider.y);
			} else { 
				checkSfxLevelSliderHorizontal();
				var sfxLvlPos:Number = (Reg.sfxVol * 10) * 20;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.sliderArrowBmpdata, sfxSlider.x + sfxLvlPos, sfxSlider.y);
			}
			
			if (musicCooloff > 0) musicCooloff--;
			if (soundCooloff > 0) soundCooloff--;
			if (soundCooloff == 25) Reg.sfx.play(SoundEffectsManager.sndExplode);
		}
	
		public function checkMusicLevelSliderHorizontal():void
		{
			if (mouseIsInHorizRange(musicSlider.x,
			musicSlider.x + 11)) 		{ musicLevelSliderMousePos = 0; mouseInLeftPane = true; }
			if (mouseIsInHorizRange(musicSlider.x + 20 - 9,
			musicSlider.x + 20 + 11))  	{ musicLevelSliderMousePos = 1; mouseInLeftPane = true; }
			if (mouseIsInHorizRange(musicSlider.x + 40 - 9,		
			musicSlider.x + 40 + 11))  	{ musicLevelSliderMousePos = 2; mouseInLeftPane = true; }
			if (mouseIsInHorizRange(musicSlider.x + 60 - 9,		
			musicSlider.x + 60 + 11))  	{ musicLevelSliderMousePos = 3; mouseInLeftPane = true; }
			if (mouseIsInHorizRange(musicSlider.x + 80 - 9,		
			musicSlider.x + 80 + 11))  	{ musicLevelSliderMousePos = 4; mouseInLeftPane = true; }
			if (mouseIsInHorizRange(musicSlider.x + 100 - 9,	
			musicSlider.x + 100 + 11)) 	{ musicLevelSliderMousePos = 5; mouseInLeftPane = true; }
			
			if (mseClik && mseX > musicSlider.x + 100) musicLevelSliderMousePos = 5;
			if (mseClik && mseX < musicSlider.x) musicLevelSliderMousePos = 0;
		}				
				
		public function checkSfxLevelSliderHorizontal():void
		{
			if (mouseIsInHorizRange(sfxSlider.x,			
			sfxSlider.x + 10)) 		{ sfxLevelSliderMousePos = 0; }
			if (mouseIsInHorizRange(sfxSlider.x + 20 - 10,		
			sfxSlider.x + 20 + 10))  	{ sfxLevelSliderMousePos = 1; }
			if (mouseIsInHorizRange(sfxSlider.x + 40 - 10,		
			sfxSlider.x + 40 + 10))  	{ sfxLevelSliderMousePos = 2; }
			if (mouseIsInHorizRange(sfxSlider.x + 60 - 10,		
			sfxSlider.x + 60 + 10))  	{ sfxLevelSliderMousePos = 3; }
			if (mouseIsInHorizRange(sfxSlider.x + 80 - 10,		
			sfxSlider.x + 80 + 10))  	{ sfxLevelSliderMousePos = 4; }
			if (mouseIsInHorizRange(sfxSlider.x + 100 - 10,	
			sfxSlider.x + 100 + 10)) 	{ sfxLevelSliderMousePos = 5; }
				
			if (mseClik && mseX > sfxSlider.x + 100) sfxLevelSliderMousePos = 5;
			if (mseClik && mseX < sfxSlider.x) sfxLevelSliderMousePos = 0;
		}				
			
		//--------------------------------------------------------------------
		// ctrTxt
		
		public function ctrTxt(c:String,value:String,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c,value, -2000, y, 1);
			Reg.renderer.mainCanvas.renderTxt(c, value, 160 - ((Reg.renderer.mainCanvas.offset + 14) / 2), y, 1);
		}
		
		//--------------------------------------------------------------------
		// printTxt
		
		public function printTxt(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c,value, x, y, 1);
		}			
		
		//--------------------------------------------------------------------
		// ctrTxtBig
		
		public function ctrTxtBig(c:String,value:String,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c,value, -2000, y, 2);
			Reg.renderer.mainCanvas.renderTxt(c,value, 160-((Reg.renderer.mainCanvas.offset+7)), y, 2);
		}	
			
		//--------------------------------------------------------------------
		// printTxtBig
		
		public function printTxtBig(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c,value, x, y, 2);
		}	
				
	}

}