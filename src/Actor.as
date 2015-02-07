package  
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import fnc.Vector2D;
	
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Actor extends EventDispatcher 
	{
		var _costume:DisplayObject;
		var _destroy:Boolean = false;
		var _preDestroy:Boolean = false;
		var _visible:Boolean = false;
		var mPosition:Vector2D;
		var mAngle:Number = 0;
		
		public function Actor(myCostume:DisplayObject) 
		{
			_costume = myCostume;
		}
		
		public function childSpecificUpdating():void
		{
			updateCostumePositionAndRotation();
		}
		
		public function updateCostumePositionAndRotation():void 
		{
			_costume.x = mPosition.x;
			_costume.y = mPosition.y;
			_costume.rotation = mAngle;
		}
		
		public function update():void
		{
			childSpecificUpdating();
		}
	}

}