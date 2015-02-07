package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class MainMenu extends State 
	{
		
		var LvlSelectionBtn:SimpleButton;
		public function MainMenu(parent:DisplayObjectContainer) 
		{
			super(parent);
			Global.gameCanvas = _canvas;
			
			
			LvlSelectionBtn = new LevelSelectionBtn();
			
			LvlSelectionBtn.x = 320;
			LvlSelectionBtn.y = 400;
			_canvas.addChild(LvlSelectionBtn);
			
			LvlSelectionBtn.addEventListener(MouseEvent.MOUSE_DOWN, moseClickedLvlSlBtn);
		}
		
		private function moseClickedLvlSlBtn(e:Event):void 
		{
			Global.GAME.changeState = true;
			Global.GAME.nextStateClass = Level1;
		}
		
	}

}