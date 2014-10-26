package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Barnaby Byrne
	 * SuperBlit Engine v0.1
	 */

	//[SWF(width = "640", height = "480", backgroundColor = "0x000000", frameRate = "60", Stage.scaleMode = "scale", quality = "low")]	 
	[SWF(width = "825", height = "490", backgroundColor = "0x000000", frameRate = "30", quality = "low")]//Stage.scaleMode = "noScale", 	 
	 
	public class Main extends Sprite 
	{
		public var game:Game;
		
		public function Main():void 
		{
			if (stage) 
				init(); 
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			game = new Game();
			addChild(game);
		}
		private function keyDownListener(e:KeyboardEvent):void {game.aKeyPress[e.keyCode]=true;}   
		private function keyUpListener(e:KeyboardEvent):void {game.aKeyPress[e.keyCode]=false;} 	
	}	
}