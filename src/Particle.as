package  
{
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	
	public class Particle extends Entity
	{
		public var mPosition:Vector2D;
		public var mVelocity:Vector2D;
		public var mAcceleration:Vector2D;
		public var mCompoundForce:Vector2D;
		public var mMass:Number;
		public var mPreviousPos:Vector2D;
		
		public var mPosition2:Vector2D;
		public var mVelocity2:Vector2D;
		public var mAcceleration2:Vector2D;
		
		public var mCurrentEvalPosition:Vector2D;
		public var mCurrentEvalVelocity:Vector2D;
		public var mPerFrameDamping:Number;

		public function Particle(position:Vector2D, mass:Number ) 
		{
			mPerFrameDamping = 0.98;
			mPosition = position;
			mMass = mass;
			mVelocity = new Vector2D(0, 0);
			mAcceleration = new Vector2D(0, 0);
			mCompoundForce = new Vector2D(0, 0);
			
			mCurrentEvalPosition = mPosition;
			mCurrentEvalVelocity = mVelocity;
		}
		
		public function AddForce(force:Vector2D)
		{
			mCompoundForce.add(force);
		}
		
		public function Update1(dT:Number)
		{
			if (mMass == 0)
				return;
		
				
			mPreviousPos = mPosition.getCopy();
				
			mAcceleration.x = 0;
			mAcceleration.y = 600;
			
			mAcceleration.add(mCompoundForce.GetScaled(1 / mMass));
			mVelocity2 = mVelocity.returnAddedTo(mAcceleration.GetScaled(dT));
			mPosition2 = mPosition.returnAddedTo(mVelocity2.GetScaled(dT));
			
			mCompoundForce.Clear();
			
			mCurrentEvalPosition = mPosition2;
			mCurrentEvalVelocity = mVelocity2;
		}
		
		public function Update2(dT:Number)
		{
			if (mMass == 0)
				return;
				
			mAcceleration2 = new Vector2D(0, 600);
			mAcceleration2.add(mCompoundForce.GetScaled(1 / mMass));
			
	//		trace("A2: " + mCompoundForce.x + " " + mCompoundForce.y);
//			trace("pos1: " + mVelocity.x + " y: " + mVelocity.y);
	//		trace("pos2: " + mVelocity2.x + " y: " + mVelocity2.y);
			
//			var velocity3:Vector2D = mVelocity2.returnAddedTo(mAcceleration2.GetScaled(dT));
			
			mVelocity.add( mAcceleration.returnAddedTo(mAcceleration2).GetScaled(0.5 * dT));
			mVelocity.scale(mPerFrameDamping);
			//mPosition.add( mVelocity.GetScaled(dT));
			mCompoundForce.Clear();
			
			mCurrentEvalPosition = mPosition;
			mCurrentEvalVelocity = mVelocity;
			mVelocity.scale(0.99);
		}
	}

}