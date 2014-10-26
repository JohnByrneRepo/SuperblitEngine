package managers 
{
	import kernel.Bmps;
	import kernel.Globals;
	import kernel.Reg;
	
	/**
	 * @author
	 * Barnaby Byrne 
	 */
	
	public class DialogueManager 
	{
		public var dialogueActive:Boolean;		// Whether dialogue is currently active
		public var skipPressed:Boolean;			// If skip has been pressed (mouse click)
		public var lifeTime:int;				// Used to prevent the player from skipping out of the dialogue sequence too early
		public var messageNumber:int;			// The current message/page number
		public var lineNumber:int;				// Max 4 lines per message
		public var dialogueOffset:int;			// Horizontal offset of text in box, to accommodate portrait on left for example
		public var continueCooloff:int;			// To prevent progressing through messages too quickly
		public var keyboardEnableTimer:int;		// Prevents any other keyboard input (e.g. jumping, movement or shoot) during dialogue sequences
		
		public function DialogueManager() 
		{
			
		}
		
		public function showDialogue(level:int, keyPresses:Array):void {
			if (messageNumber < 2) {
				dialogueOffset = 100;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.dialogueOverlayBmpdata, 13, Globals.DIALOGUE_OVERLAY_Y);
			} else {
				dialogueOffset = 127;
				Reg.renderer.mainCanvas.blitAtPoint(Bmps.dialogueOverlay2Bmpdata, 13, Globals.DIALOGUE_OVERLAY_Y);
			}

			Reg.renderer.dialogueOffset = dialogueOffset;
			Reg.renderer.mainCanvas.dialogueActive = true;
			
			if (lifeTime < 400) lifeTime++;
			
			displayMessages(level);
				
			printTxt("Continue", "PRESS X TO CONTINUE OR MOUSE TO SKIP", 390, 465);
			Reg.renderer.renderDialogue();
			if (Reg.mousePressed && lifeTime > 20) { lifeTime = 0; messageNumber = 4; Reg.renderer.resetDialogue(); dialogueActive = false; }
			if (continueCooloff > 0) continueCooloff--;
			if (keyPresses[Globals.KEYGUN] && lifeTime > 20 && continueCooloff == 0)
			{ 
				continueCooloff = 25;
				if (Reg.renderer.mainCanvas.dialogueLine < 4) Reg.renderer.mainCanvas.dialogueLine = 4; 
				else { lifeTime = 0; messageNumber++; Reg.renderer.resetDialogue(); }
				//if (messageNumber != 3) sfx.play(SoundEffectsManager.sndLaser);
				//if (messageNumber == 1) {  }
			}
			
			if (messageNumber == 3) {
				Reg.player.x = 20; Reg.player.y = -20;
			}
			if (messageNumber == 4)
			{
				dialogueActive = false;
				keyboardEnableTimer = 20;
				dialogueOffset = 100;				
			}
		}
		
		private function displayMessages(level:int):void 
		{
			//trace("level=" + level);
			//trace("message number=" + messageNumber);
			switch (level) {
				case 1:
					switch (messageNumber) {
						case 0:
						{
							Reg.renderer.mainCanvas.dialogueText0 = "THE BATTLE WITH THE NANO HUNTER HAS ENTERED A NEW DIMENSION.";
							Reg.renderer.mainCanvas.dialogueText1 = "";
							Reg.renderer.mainCanvas.dialogueText2 = "";
							Reg.renderer.mainCanvas.dialogueText3 = "";
						}		
					break;
						case 1:
						{
							Reg.renderer.mainCanvas.dialogueText0 = "THE NANO HUNTER HAS DIGITIZED HIMSELF AND IS CAUSING CHAOS.";
							Reg.renderer.mainCanvas.dialogueText1 = "";
							Reg.renderer.mainCanvas.dialogueText2 = "";
							Reg.renderer.mainCanvas.dialogueText3 = " ";
						}
					break;
						case 2:
						{
							Reg.renderer.mainCanvas.dialogueText0 = "ONLY ONE BOY CAN SAVE US NOW... JACK NANO SAVES THE WORLD.";
							Reg.renderer.mainCanvas.dialogueText1 = "";
							Reg.renderer.mainCanvas.dialogueText2 = "";
							Reg.renderer.mainCanvas.dialogueText3 = " ";
						}
					break;
						case 3:
						{
							Reg.renderer.mainCanvas.dialogueText0 = "HAVE YOU GOT THE MOVES TO LOCATE THE MAGICAL NANO SHOE?";
							Reg.renderer.mainCanvas.dialogueText1 = "";
							Reg.renderer.mainCanvas.dialogueText2 = "";
							Reg.renderer.mainCanvas.dialogueText3 = "";
						}
					break;
					}
				break;
			}
		}
		
		//--------------------------------------------------------------------
		// printTxt
		
		public function printTxt(c:String,value:String,x:int,y:int):void
		{	
			Reg.renderer.mainCanvas.renderTxt(c, value, x, y, 1);
		}			
	}

}