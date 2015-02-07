package  
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import fnc.BoundingBox;
	import fnc.Circle;
	import fnc.collision;
	import fnc.distance;
	import fnc.intersection;
	import fnc.Line;
	import fnc.LineSegment;
	import fnc.vector;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Level extends State 
	{
		public var _allActors:Array;
		public var mParticles:Array;
		public var mSFGs:Array;
		public var _pausePressed:Boolean = false;
		public var mPlayer:PlayerActor;
		public var mLineSegments:Array;
		public var mDynamicShapes:Array;

		
		public var previousTime:int;
		public var mWidth;
		
		public function Level(parent:DisplayObjectContainer) 
		{	
			super(parent);
			
			_allActors = [];
			mParticles = [];
			mLineSegments = [];
			mDynamicShapes = [];
			mSFGs = [];
			Global.stage = _canvas.stage;
			Global.gameCanvas = _canvas;
			Global.currentLevel = this;
			Global.cLvlPArr = mParticles;
			Global.cLvlSFGArr = mSFGs;
			

			
			previousTime = getTimer();
		}
		
		public function drawCircle(c:Circle)
		{
			_canvas.graphics.beginFill(0xFF0000);
			_canvas.graphics.drawEllipse(c.pos.x - c.r, c.pos.y - c.r, c.r*2, c.r*2);
			_canvas.graphics.endFill();
		}
		public function drawLine(p1:Vector2D, vec:Vector2D)
		{
			_canvas.graphics.lineStyle(2, 0x000000);
			_canvas.graphics.moveTo(p1.x, p1.y);
			_canvas.graphics.lineTo(vec.x, vec.y);
		}
		

		
		private function updateCamera()
		{
			var pX:int = mPlayer.mPosition.x;
			var xDiff:int = mPlayer.mPosition.x - Global.screenWidth / 2;
			
			if (xDiff > 0)
			_canvas.x = -xDiff;
			else
			_canvas.x = 0;
			
			if ( -_canvas.x > mWidth - Global.screenWidth )
			_canvas.x = -(mWidth - Global.screenWidth);
		}
		
		public function postConstruction()
		{

		}
		
		public function GetNearestLineSegmentIntersection( testLS:LineSegment, distRefVec:Vector2D, intersectionPoint:Vector2D, skipLS:LineSegment = null):LineSegment
		{
			var minDist:Number = 9999;
			var minDistCollisionVec:Vector2D = new Vector2D(0, 0);
			var minDistCollisionLS:LineSegment = null;
			
			for each(var ls:LineSegment in mLineSegments)
			{
				if (ls == skipLS)
					continue;
				
				if (!intersection.LineSegmentIntersection(testLS, ls, intersectionPoint))
					continue;
			
					
				var dist:Number = distance.GetDistance(distRefVec, intersectionPoint);
				
				if (dist < minDist)
				{
					minDistCollisionLS = ls;
					minDistCollisionVec.SetVec(intersectionPoint);
					minDist = dist;
				}
			}
			
			intersectionPoint.SetVec(minDistCollisionVec);
			return minDistCollisionLS;
		}
		
		public function GetLSReflectedPositionAndReturnCollidedLS(testLS:LineSegment, distRefVec:Vector2D, lineSegmentDirection:Vector2D, intersectionPoint:Vector2D, reflectedPosition:Vector2D, skipLS:LineSegment = null ):LineSegment
		{
			var collidedToLS:LineSegment = GetNearestLineSegmentIntersection(testLS, distRefVec, intersectionPoint, skipLS); 
			
			if (collidedToLS == null)
				return null;
				
	//		trace("djole");
			var line:Line = new Line(collidedToLS.a, collidedToLS.b);
			var distToIntersection:Number = distance.GetDistance(intersectionPoint, distRefVec);
			var reflectedDistance:Number = testLS.Length() - distToIntersection;
			var reflectedDisplacement:Vector2D = lineSegmentDirection.getCopy();
			vector.ReflectVectorRayFromLine( reflectedDisplacement, line);
			reflectedDisplacement.reScale(reflectedDistance*0.5);
			reflectedPosition.SetVec(intersectionPoint.returnAddedTo(reflectedDisplacement));
			
			return collidedToLS;
		}
		
		public function IsLineSegmentCollidingWithLevelLS(lsTest:LineSegment):Boolean
		{
			for each(var ls:LineSegment in mLineSegments)
			{
				if (intersection.LineSegmentIntersection(ls, lsTest))
				return true;
				
			}
			return false;
		}
	
		public function AvoidTunneling2(particle:Particle, dT:Number):void
		{
			if (!particle.mMass)
				return;
			
			var displacement:Vector2D = particle.mVelocity.GetScaled(dT);
			var tunnel:LineSegment = new LineSegment(particle.mPosition, particle.mPosition.returnAddedTo(displacement));
			var intersectionPoint:Vector2D = new Vector2D(0,0);
			var relfectionDamping:Number = 0.8;
			var reflectedPosition:Vector2D = new Vector2D(0, 0);
			
			var collidedToLS:LineSegment = GetLSReflectedPositionAndReturnCollidedLS(tunnel, particle.mPosition, particle.mVelocity, intersectionPoint, reflectedPosition);
			
			if (collidedToLS == null)
			{
				particle.mPosition.add(displacement);
				return;
			}
				
			var line:Line = new Line(collidedToLS.a, collidedToLS.b);
			
			vector.ReflectVectorRayFromLine( particle.mVelocity, line);
			particle.mVelocity.scale(relfectionDamping);
			
			var reflectedTunnel:LineSegment = new LineSegment(intersectionPoint.getCopy(), reflectedPosition);		
			var prevCollidedLS:LineSegment = collidedToLS;
			
			collidedToLS = null;
			
			var reflectedPosition2:Vector2D = new Vector2D(0, 0);
			collidedToLS = GetLSReflectedPositionAndReturnCollidedLS(reflectedTunnel, intersectionPoint.getCopy(), particle.mVelocity, intersectionPoint, reflectedPosition2, prevCollidedLS);
			
			if (collidedToLS == null)
			{
				particle.mPosition = reflectedPosition;
				return;
			}
			
			line.SetAsLs(collidedToLS);
			vector.ReflectVectorRayFromLine( particle.mVelocity, line);
			particle.mVelocity.scale(relfectionDamping);

			particle.mPosition = reflectedPosition2;
		}
		
		public function generateChainOfParticles()
		{
			var displacementVec:Vector2D = new Vector2D(20, 0);
			var startVec:Vector2D = new Vector2D(300, 30);
			var pNum:int =8;
			
			var lastAdded:Particle = null;
			
			var currentPosition:Vector2D = startVec;
			
			for (var i:int = 0; i < pNum; i++) 
			{
				var currentP:Particle = new Particle(currentPosition.getCopy(), 100);
				mParticles.push(currentP);
				currentPosition.add(displacementVec);
				
				if (lastAdded == null)
				{
					currentP.mMass = 0;
					lastAdded = currentP;
					continue;
				}
				
				if (i == pNum - 1)
				{
					currentP.mMass = 300;
					Global.currentLevel.mPlayer.mPosition.SetVec(currentP.mPosition.returnAddedTo(displacementVec.GetScaled(0.9)));
					currentP = Global.currentLevel.mPlayer.mParticle;
					currentP.mMass = 300;
					mParticles.pop();
				}
					
					
				mSFGs.push(new SpringForceGenerator(currentP, lastAdded, distance.GetDistance(currentP.mPosition, lastAdded.mPosition), 80000, 1400, SpringForceGenerator.PULL));
				lastAdded = currentP;
			}
		}
		
		

		
		
		
		public function playerGrounded():Boolean
		{
			var playerShell:Circle = new Circle(mPlayer.mPosition, mPlayer.mRadius + 8);
			var playerShellBB:BoundingBox = new BoundingBox(new Vector2D(0, 0), new Vector2D(0, 0));
			playerShellBB.SetFromCircle(playerShell);
			
			for (var i:int = 0; i < mLineSegments.length; i++) 
			{
				var ls:LineSegment = mLineSegments[i];
				
				if (!intersection.BBIntersection(ls.BBox, playerShellBB))
					continue;
					
				if (intersection.LineSegmentIntersectsCircle(ls, playerShell))
				return true;
			}
			
			return false;
		}
		
		public function playerToLevelCollision():void
		{
			var intersectionArr:Array = new Array();
			var singleLSColl:LineSegment = null;
			var prtkl:Particle = mPlayer.mParticle;
			var tempC:Circle = new Circle(prtkl.mPosition, mPlayer.mRadius);
			
			for (var i:int = 0; i < mLineSegments.length; i++) 
			{
				var ls:LineSegment = mLineSegments[i];
				
				if (!intersection.BBIntersection(ls.BBox, mPlayer.BBox))
					continue;
					
				var tempArr:Array = new Array();
				var interNum:int = intersection.GetLineSegmentCircleIntersection(ls, tempC, tempArr, true);
				
				if (!interNum)
				continue;
				
				if (interNum == 1)
				{					
					if (singleLSColl != null)
					{ 
						var prevPos:Vector2D = mPlayer.mParticle.mPreviousPos;
						var toFirstLS:LineSegment = new LineSegment(intersectionArr[0], prevPos);
						var toCurrentLS:LineSegment = new LineSegment(tempArr[0], prevPos);
						var firstClear:Boolean = !intersection.LineSegmentIntersection(toFirstLS, ls);
						var seccondClear:Boolean = !intersection.LineSegmentIntersection(toCurrentLS, singleLSColl);
						
						if (!firstClear && seccondClear)
						{
							singleLSColl = ls;
							intersectionArr[0] = tempArr[0];
						}
						else if (firstClear && seccondClear)
						{
							var prevPos2:Vector2D = mPlayer.mPosition.returnAddedTo(vector.GetVectorFromAtoB(mPlayer.mPosition, mPlayer.mParticle.mPreviousPos).getRescaled(tempC.r));
							
							var toCurrent:Number = distance.GetLineSegmentPointDistanceSq(ls, prevPos);
							var toFirst:Number = distance.GetLineSegmentPointDistanceSq(singleLSColl, prevPos);
							
							if (toCurrent < toFirst)
							{
								singleLSColl = ls;
								intersectionArr[0] = tempArr[0];
							}
						}
					}
					else
					{
						intersectionArr.push(tempArr[0]);
						singleLSColl = ls;
					}
				}
				else
				{
					intersectionArr = tempArr;
				}
				
				if (intersectionArr.length == 2)
				{
					var middleP:Vector2D = vector.GetVectorBetweenVectors(intersectionArr[0], intersectionArr[1]);
					var tempL:Line = new Line(intersectionArr[0], intersectionArr[1]);
					collision.BounceBallOfLine(tempC, tempL, prtkl.mVelocity, middleP);
					prtkl.mPosition.SetVec(tempC.pos);
					prtkl.mVelocity.scale(0.9);
				}
			}
			
			if(singleLSColl != null)
			if (intersectionArr.length == 1)
			{
				collision.LineSegmentBallEdgeCollisionResponse(tempC, singleLSColl, prtkl.mVelocity);
				prtkl.mPosition.SetVec(tempC.pos);
				prtkl.mVelocity.scale(0.9);
			}
		}
		
		
		
		
		override public function logic():void 
		{	
			_canvas.graphics.clear();
			var time:int = getTimer();
			var dT:Number = (time - previousTime) / 1000;
			previousTime = time;

			mPlayer.mGrounded = playerGrounded();
			
			trace(mPlayer.mGrounded);
			
			updateCamera();
			mPlayer.handleEvents();

			for each(var dsi:DynamicShape in mDynamicShapes)
				dsi.Update(dT);

			for (var i:int = 0; i < mSFGs.length; i++)
			{
				var sfg:SpringForceGenerator = mSFGs[i];
				
				if (sfg.mDestroy)
				{
					mSFGs.splice(i, 1);
					i--;
				}
				else
				sfg.Update(dT);
			}
			
			for (var i:int = 0; i < mParticles.length; i++)
			{
				var prtkl:Particle = mParticles[i];
				
				if (prtkl.mDestroy)
				{
					mParticles.splice(i, 1);
					i--;
				}
				else
				prtkl.Update1(dT);				
			}	
			
			mPlayer.handleEvents();
			
			if (mPlayer.jumped)
			mPlayer.timeAfterJump = 0;
			
			for each(var sfg:SpringForceGenerator in mSFGs)
				sfg.Update(dT);
			
			for each(var prtkl:Particle in mParticles)
				prtkl.Update2(dT);
				

			
			
			
			for (var i:int = 0; i < mParticles.length; i++) 
			{
				var prtkl:Particle = mParticles[i];
				
				//AvoidTunneling2(prtkl, dT);
				
				var displacement:Vector2D = prtkl.mVelocity.GetScaled(dT);
				prtkl.mPosition.add(displacement);
				
				drawCircle(new Circle(prtkl.mPosition, 3));
			}
			
			//mPlayer.update();
			
			
			
			
			for each(var sfg:SpringForceGenerator in mSFGs)
				drawLine(sfg.mP1.mPosition, sfg.mP2.mPosition);
			
			for each(var ls:LineSegment in mLineSegments)
				drawLine(ls.a, ls.b);
			
				
			mPlayer.UpdateBBox();
			playerToLevelCollision();
			
			mPlayer.update();
			
			
		//	drawCircle(new Circle(mPlayer.mPosition, mPlayer.mRadius));
		}
	}
}
