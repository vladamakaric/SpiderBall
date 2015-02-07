package  
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import fnc.Circle;
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
	public class Level1 extends Level 
	{
		public function Level1(parent:DisplayObjectContainer) 
		{
			super(parent);
			mWidth = 2000;
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			
			mPlayer = new PlayerActor(new Vector2D(200, 100));
			_allActors.push(mPlayer);	
			
			mParticles.push(mPlayer.mParticle);
			mPlayer.mParticle.mPerFrameDamping = 1;
			
			mLineSegments.push(new LineSegment(new Vector2D(0, 400), new Vector2D(1000, 400)));

			
			//mLineSegments.push(new LineSegment(new Vector2D(200, 200), new Vector2D(300, 100)));
			//mLineSegments.push(new LineSegment(new Vector2D(300, 100), new Vector2D(350, 200)));
			//mLineSegments.push(new LineSegment(new Vector2D(350, 200), new Vector2D(200, 200)));	
			
			
			mDynamicShapes.push(new DynamicShape(new Array(new Vector2D(-209, -63), new Vector2D(-208, 29), new Vector2D(233, 29), 
new Vector2D(228, -74), new Vector2D(157, -72), new Vector2D(96, -36), 
new Vector2D( -110, -34), new Vector2D( -143, -62)),
new Vector2D(400, 300), 0.001));
			mDynamicShapes.push(new DynamicShape(new Array(new Vector2D(-100, 100), new Vector2D( 100, -100 ), new Vector2D(0, 100)), new Vector2D(300,300), 0.2 ));
			
		//	generateChainOfParticles();
		}

		private function mouseClick(e:MouseEvent):void 
		{
			//var lastAddedPrtkl:Particle = mParticles[mParticles.length - 1];
		//	var newPrtkl:Particle = new Particle(new Vector2D(e.stageX, e.stageY), 100);
		//	mParticles.push(newPrtkl);
			
		//	newPrtkl.mVelocity.Set(100, -100);
			
			mPlayer.mParticle.mPosition.SetVec(new Vector2D(e.stageX + (-_canvas.x), e.stageY));
			mPlayer.mParticle.mVelocity.Clear();
			
			//mSFGs.push(new SpringForceGenerator(lastAddedPrntkl, newPrtkl, distance.GetDistance(lastAddedPrtkl.mPosition, newPrtkl.mPosition), 10, 1, SpringForceGenerator.PULL));
			
	//		Particle(mParticles[0]).mPosition.Set(0, 480);
	//		Particle(mParticles[0]).mVelocity.Set(e.stageX, -(480 - e.stageY));
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
		//	mPlayer.mPosition.Set(e.stageX, e.stageY);
		}
		
		override public function logic():void 
		{
			super.logic();
			//_canvas.graphics.clear();
		}
	}
}

/*
 * 			var circ:Circle = new Circle(mPlayer.mPosition,  30);
			
			var bVec:Vector2D = new Vector2D(500, 45);
			
			_canvas.graphics.clear();
			drawLine(vec2, bVec);
			drawCircle(circ);
			
			var lineSeg2:LineSegment = new LineSegment(bVec, vec2);
			var lineSeg1:LineSegment = new LineSegment(new Vector2D(500, 400), mPlayer.mPosition);
			
			drawLine(lineSeg1.a, lineSeg1.b);
			
			
			var interCity:Vector2D = new Vector2D(0, 0);
			
			if (intersection.LineSegmentIntersection(lineSeg1, lineSeg2, interCity))
			{
			//trace("DJOLE!");
			drawCircle(new Circle(interCity, 10));
			}
			
			if (intersection.LineIntersectsCircle(new Line(lineSeg2.a, lineSeg2.b), circ))
			trace("djole!!!!");
			
			var interP:Array = new Array();
			var brojsranje:int = intersection.GetLineSegmentCircleIntersection(lineSeg2, circ, interP, true);
			if (brojsranje)
			{
				drawCircle(new Circle(interP[0],5));
			//	drawCircle(new Circle(interP[1], 5));
			}
			if (brojsranje==2)
			drawCircle(new Circle(interP[1],5));
			
			
			drawCircle(new Circle(Particle(mParticles[0]).mPosition, 10));
			
			trace(Particle(mParticles[0]).mPosition.x + " " + Particle(mParticles[0]).mPosition.y );
*/