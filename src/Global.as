package  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Global 
	{
		public static var GAME:SpiderBall;
		public static var TIME:int = 0;
		public static var gameCanvas:MovieClip;
		public static var screenWidth:Number = 640;
		public static var screenHeight:Number = 480;
		public static var stage:Stage;
		public static var currentLevel:Level;
		public static var cLvlPArr:Array;
		public static var cLvlSFGArr:Array;
		
		public function Global() 
		{

		}
		
	}

}