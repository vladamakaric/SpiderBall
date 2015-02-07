package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vladimir Makaric 2012
	 */
	public class State extends EventDispatcher
	{
		var _changeToStateAfterAd:Class = null;
		var _canvas:MovieClip;
		var _pause:Boolean = false;
		var _pauseCounter:int = 0;
		
		public function State(parent:DisplayObjectContainer) 
		{
			_canvas = new MovieClip();	
			parent.addChild(_canvas);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function pauseLogic():void
		{
			if (!_pauseCounter)
			startPauseLogic();
			
			_pauseCounter++;
		}
		
		public function endPauseLogic():void
		{
			
		}
		
		public function startPauseLogic():void
		{
			
		}
		
		public function logic():void { }
		public function handleEvents():void { }
		public function destroy():void 
		{ 
			_canvas.parent.removeChild(_canvas);
		}
	}

}