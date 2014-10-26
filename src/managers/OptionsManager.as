package managers 
{
	/**
	 * @author
	 * Barnaby Byrne
	 */
	
	import kernel.*;
	
	public class OptionsManager
	{	
		public var cancelled:Boolean;
		public var quitPressed:Boolean;		
		public const SPRITEMODEMONO:int = 0;
		public const SPRITEMODESINGLE:int = 1;
		public const SPRITEMODEDUAL:int = 2;
		public var spriteColourMode:int = SPRITEMODESINGLE;		
		public var sliderGroup1ParticlesY:int;
		public var xoffImageSliderRight:int;
		public var particleSliderMousePos:int;
		public var lavaSliderMousePos:int;
		public var mouseInLeftPane:Boolean=false;			
		public const TABAUDIO:int = 0;
		public var optionsTabNumber:int = TABAUDIO;
		public var colSelected:int;		
		public var textAlignedLeftOffsetX:int=15;
		public var textAlignedTopOffsetY:int=29;
		public var verticalSpaceBetweenSubOptions:int=17;	
		public var xoffImageSliderLeft:int = 15;
		public var yoffImageSliderLeft:int = 63;
		public var xoffTextSliderLeft:int = 184;
		public var yoffTextSliderLeft:int = 63;
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
					
		public function OptionsManager() 
		{
			
		}
		
		public function clickedInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mseX  > x1 && mseX  < x2 && mseY  > y1 && mseY  < y2 && mseClik) return true;
			else return false;
		}
				
		public function mouseIsInRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			if (mseX  > x1 && mseX  < x2 && mseY  > y1 && mseY  < y2) return true;
			else return false;
		}		
		
		public function mouseIsInHorizRange(x1:int, x2:int):Boolean
		{
			if (mseX  > x1 && mseX  < x2) return true;
			else return false;
		}
				
		public function mouseIsInVertiRange(y1:int, y2:int):Boolean
		{
			if (mseY  > y1 && mseY  < y2) return true;
			else return false;
		}
		
		public function update(mouseX:int, mouseY:int, mousePressed:Boolean):void
		{
			//Reg.renderer.update();			
			mseX = mouseX;
			mseY = mouseY;
			mseClik = mousePressed;					
			var topLeftx:int = 5;
			var topLefty:int = 5;		
			Reg.renderer.mainCanvas.blitAtPoint(Bmps.optionsPaneBmpdata, (825 / 2) - 300 / 2, (490 / 2) - 200 / 2);		
			Reg.optionsAudio.update(mseX, mseY, mseClik);
			//Reg.renderer.mainCanvas.blitAtPoint(Bmps.cursorBmpdata, mouseX - 7, mouseY - 7);
		}		
	}
}