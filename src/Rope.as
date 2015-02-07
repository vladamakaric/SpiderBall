package  
{
	import fnc.distance;
	import fnc.LineSegment;
	import fnc.vector;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Rope 
	{
		public var mLs:LineSegment;
		public var mAToBLSRatio:Number;
		public var mPartArr:Array;
		public var mSfgArr:Array;
		public var mPlayerPartkl:Particle;
		public var mFirstPartkl:Particle;
		public var mPartDist:Number = 40;
		public var mGoalDist:Number = 34;
		public var mShrinkRate:Number = 1;
		public var mPartMass:Number = 10;
		
		public function Rope(playerPartkl:Particle, interP:Vector2D, lineS:LineSegment = null, abRatio:Number = 0) 
		{
			mPartArr = [];
			mSfgArr = [];

			mPlayerPartkl = playerPartkl;
			mLs = lineS; 
			mAToBLSRatio = abRatio;
			
			mFirstPartkl = new Particle(interP, 0);
			
			var lastAdded:Particle = mFirstPartkl;
			mPartArr.push(lastAdded);
			Global.cLvlPArr.push(lastAdded);
			
			var currentPartkl:Particle;
			var ropeLenght:Number = distance.GetDistance(interP, mPlayerPartkl.mPosition);
			var partkNum:int = (ropeLenght / mPartDist) -1;
			
			
			if (partkNum)
			{
				var newPartklDist:Number = ropeLenght / (partkNum +1);
				mGoalDist = (newPartklDist/mPartDist)*mGoalDist;
				mPartDist = newPartklDist;
				
				
				var displacement:Vector2D = vector.GetVectorFromAtoB(lastAdded.mPosition, mPlayerPartkl.mPosition).getRescaled(newPartklDist);
				
				
				var currentPosition:Vector2D = lastAdded.mPosition.returnAddedTo(displacement);
				
				for (var i:int = 0; i < partkNum; i++ )
				{
					currentPartkl = new Particle(currentPosition.getCopy(), mPartMass);
					mPartArr.push(currentPartkl);
					Global.cLvlPArr.push(currentPartkl);
					var currentSFG:SpringForceGenerator = new SpringForceGenerator(currentPartkl, lastAdded, mPartDist, 8000, 150, SpringForceGenerator.PULL);
					mSfgArr.push(currentSFG);
					Global.cLvlSFGArr.push(currentSFG);
					currentPosition.add(displacement);
					
					lastAdded = currentPartkl;
				}
				
				var lastSFG:SpringForceGenerator = new SpringForceGenerator(currentPartkl, mPlayerPartkl, mPartDist, 8000, 150, SpringForceGenerator.PULL);
				mSfgArr.push(lastSFG);
				Global.cLvlSFGArr.push(lastSFG);
				//Global.cLvlPArr.push(currentPartkl);
			}
			
			
		}
		
		
		public function clear()
		{
			SpringForceGenerator(mSfgArr.pop()).mDestroy = true;
		}
		
		public function update(dT:Number=0)
		{
			if (mPartDist > mGoalDist)
			{
				mPartDist -= mShrinkRate;
				
				for each(var sfg:SpringForceGenerator in mSfgArr)
					sfg.restLenght = mPartDist;
					
				trace("69");
				
				
			}
		}
		
	}

}