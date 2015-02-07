package  
{
	import fnc.LineSegment;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class DynamicLS extends LineSegment
	{
		public var oldA:Vector2D;
		public var oldB:Vector2D;
		
		public function DynamicLS(_a:Vector2D, _b:Vector2D) 
		{
			super(_a, _b);
			oldA = a;
			oldB = b;
		}
		
		
		public function UpdateBB():void
		{
			BBox.SetFromVecs(a, b);
		}
		
		public function Update(_a:Vector2D, _b:Vector2D)
		{
			oldA = a.getCopy();
			oldB = b.getCopy();
			Set(_a, _b);
		}
		
	}

}