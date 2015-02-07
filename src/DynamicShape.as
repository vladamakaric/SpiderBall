package  
{
	import fnc.Vector2D;
	
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	
	public class DynamicShape 
	{
		public var mCenterOfRotation:Vector2D;
		public var mPositionCOR:Vector2D;
		public var mAngularVelocity:Number = 0;
		public var mDLSArr:Array;
		
		
		public var currAngle:Number = 0;
		public var rotDir:Number = 1;
		public var maxAngle:Number;
		public var sameDirCounter:int = 0;
		
		public function DynamicShape(vecArr:Array, positionCOR:Vector2D, aV:Number, maxA:Number = 0.2) 
		{
			trace("djole");
			mDLSArr = new Array();
			mPositionCOR = positionCOR;
			mAngularVelocity = aV;
			maxAngle = maxA;
			
			for (var i:int; i < vecArr.length; i++)
			{
				
				
				var tempDLS:DynamicLS = new DynamicLS(Vector2D(vecArr[i]).returnAddedTo(mPositionCOR), Vector2D(vecArr[(i + 1) % vecArr.length]).returnAddedTo(mPositionCOR));
				
				Global.currentLevel.mLineSegments.push(tempDLS);
				mDLSArr.push(tempDLS); 
				
				if (vecArr.length == 2)
				return;
			}
		}
		
		public function Update(dT:Number)
		{
			
			
			currAngle += mAngularVelocity * dT * rotDir;
			
			if (Math.abs(currAngle) > maxAngle && sameDirCounter>1)
			{
				sameDirCounter = 0;
				rotDir *= -1;
			}
			
			for (var i:int; i < mDLSArr.length; i++)
			{
				DynamicLS(mDLSArr[i]).a.rotateAroundPoint(mAngularVelocity * dT * rotDir, mPositionCOR);
				DynamicLS(mDLSArr[i]).b.rotateAroundPoint(mAngularVelocity * dT * rotDir, mPositionCOR);
				
				DynamicLS(mDLSArr[i]).UpdateBB();
			}
			
			sameDirCounter++;
		}
	}
}