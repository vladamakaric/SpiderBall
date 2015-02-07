package  
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class LevelSelection extends State 
	{
		var levelFrameArr:Array;
		public function LevelSelection(parent:DisplayObjectContainer) 
		{
			super(parent);
			Global.gameCanvas = _canvas;
			Global.stage = _canvas.stage;
		}
		
	}

}