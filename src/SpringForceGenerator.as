package  
{
	import fnc.Line;
	import fnc.vector;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class SpringForceGenerator extends Entity
	{
		static const TWOWAY:int = 0; 
		static const PUSH:int = 1;
		static const PULL:int = 2;
		
		public var mP1:Particle, mP2:Particle;
		public var eKoef:Number, dKoef:Number;
		public var restLenght:Number;
		public var workMode:int;
		
		public function SpringForceGenerator(p1:Particle, p2:Particle, rL:Number, eK:Number, dK:Number, wM:int = TWOWAY) 
		{
			mP1 = p1;
			mP2 = p2;
			restLenght = rL;
			eKoef = eK;
			dKoef = dK;
			workMode = wM;
		}
		
		public function Update(dT:Number)
		{
			var springVecToOther:Vector2D = vector.GetVectorFromAtoB(mP1.mCurrentEvalPosition, mP2.mCurrentEvalPosition);
			var currSpringLenght:Number = springVecToOther.length();
			springVecToOther.normalize();
			
			var springLenghtDiff:Number = currSpringLenght - restLenght;
			
			if((springLenghtDiff < 0) && workMode == PULL)
				return;
				
			var force:Vector2D = springVecToOther.GetScaled(eKoef * springLenghtDiff);
			
			
			var bearing:Line = new Line(mP1.mCurrentEvalPosition, mP2.mCurrentEvalPosition);
			
			var p1VelToLine:Vector2D = vector.GetVectorComponentToLine(bearing, mP1.mCurrentEvalVelocity);
			var p2VelToLine:Vector2D = vector.GetVectorComponentToLine(bearing, mP2.mCurrentEvalVelocity);
			
			var relativeVel:Vector2D = p1VelToLine.returnAddedTo(p2VelToLine.GetScaled( -1));
			
			var p1DampF:Vector2D = new Vector2D(0, 0);
			var p2DampF:Vector2D = new Vector2D(0, 0);
			
		//	if (force.dotP(p1VelToLine) > 0)
			p1DampF = relativeVel.GetScaled( 1).GetScaled(dKoef);
			
		//	if (force.GetScaled( -1).dotP(p2VelToLine) > 0)
			p2DampF = relativeVel.GetScaled(-1*dKoef);
			
			
		//	trace( "force: " + force.x  + "y: " + force.y);
			
			mP1.AddForce(force.returnAddedTo(p1DampF)); 
			mP2.AddForce(force.GetScaled( -1).returnAddedTo(p2DampF));
		}
	}

}