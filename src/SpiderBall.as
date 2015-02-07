package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class SpiderBall extends MovieClip {
		
		var currentState:State;
		var nextStateClass:Class = MainMenu;
		var changeState:Boolean = false;
		
		
		public function SpiderBall() {
			
			
			addEventListener(Event.ENTER_FRAME, Update);
			currentState = new MainMenu(this);
			Global.GAME = this;
			// constructor code
		}
		
		private function Update(e:Event):void 
		{
			Global.TIME++;

			currentState.logic();
				
			if (changeState)
			{
				changeState = false;
				
				currentState.destroy();
				currentState = null;
				currentState = new nextStateClass(this);
				stage.focus = stage;
			}
			
		}
	}
	
}
