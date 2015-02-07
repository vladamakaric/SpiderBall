package  
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import fnc.BoundingBox;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class PlayerActor extends Actor 
	{
		public var mParticle:Particle;
		public var mRadius:Number = 25;
		public var mMaxForce:Number = 20;
		public var compoundEventForce:Vector2D;
		public var BBox:BoundingBox;
		public var mGrounded:Boolean;
		
		
		
		public var mRope:Rope = null;
		//public var ropeStatus:int;
		public var LEFT:Boolean = false;
		public var RIGHT:Boolean = false;
		public var JUMP:Boolean = false;
		public var ROPE:Boolean = false;
		public var horizForce:Number = 50000/3;
		public var timeAfterJump:int = 100;
		public var groundedTime:int = 100;
		public var jumped:Boolean = false;
		public var timeAfterRope:int = 100;
		
		
		
		
		public function PlayerActor(position:Vector2D) 
		{
			super(new SBall_mc());
			mGrounded = false;
			mParticle = new Particle(position, 30);
			mPosition = mParticle.mPosition;
			BBox = new BoundingBox(  mParticle.mPosition.returnAddedTo(new Vector2D( -mRadius, -mRadius))    , mParticle.mPosition.returnAddedTo(new Vector2D(mRadius, mRadius)));
			
			Global.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress );
			Global.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease );
			
			Global.gameCanvas.addChild(_costume);
		}
		
		public function handleEvents():void
		{
			var curHorizForce:Number = horizForce;
			jumped = false;
			
			if (ROPE && timeAfterRope>0)
			{
				
				timeAfterRope = 0;
				
				if (mRope != null)
				{
					mRope.clear();
					mRope = null;
				}
				else
				{
					trace("CHKA");
					
					var displacement:Number = 150;
					
					if (mParticle.mVelocity.x < 0)
					displacement *= -1;
					
					
					mRope = new Rope(mParticle, new Vector2D(mPosition.x + displacement, 0));
				}
			}
			
			if(!ROPE)
			timeAfterRope++;
			
			if (!mGrounded)
			curHorizForce /= 2;
			
			if (mGrounded)
			groundedTime++;
			else 
			groundedTime = 0;
		
		
			if (LEFT) mParticle.AddForce(new Vector2D( -curHorizForce, 0));
			if ( RIGHT) mParticle.AddForce(new Vector2D( curHorizForce, 0));
			
			
			if (JUMP && mGrounded && groundedTime>8 && timeAfterJump>40)
			{
				
				mParticle.AddForce(new Vector2D( 0, -1000000/3));
				jumped = true;
				//mParticle.mVelocity.add(new Vector2D( 0, -200));
				
			}
			
			timeAfterJump++;
		}
		
		private function onKeyRelease(keyboardEvent:KeyboardEvent):void 
		{
			if ( keyboardEvent.keyCode == Keyboard.LEFT)
				LEFT = false;

			if ( keyboardEvent.keyCode == Keyboard.RIGHT)
				RIGHT = false;
				
			if ( keyboardEvent.keyCode == Keyboard.SPACE)
				JUMP = false;
				
			if ( keyboardEvent.keyCode == Keyboard.X)	
				ROPE = false;
		}
		
		private function onKeyPress(keyboardEvent:KeyboardEvent):void 
		{
			if ( keyboardEvent.keyCode == Keyboard.LEFT)
				LEFT = true;

			if ( keyboardEvent.keyCode == Keyboard.RIGHT)
				RIGHT = true;
				
			if ( keyboardEvent.keyCode == Keyboard.SPACE)
				JUMP = true;
				
			if ( keyboardEvent.keyCode == Keyboard.X)	
				ROPE = true;
		}
		
		
		public function UpdateBBox()
		{
			BBox.SetTLBRVecs(  mParticle.mPosition.returnAddedTo(new Vector2D( -mRadius, -mRadius)),
							   mParticle.mPosition.returnAddedTo(new Vector2D(mRadius, mRadius)));
		}
		
		override public function update():void 
		{
//			mParticle.Update();
			


			//if (mParticle.mCompoundForce.length() > mMaxForce)
			//mParticle.mCompoundForce.reScale(mMaxForce);

			if(mRope != null)
			mRope.update();
			
			super.update();
			
			
		}
		
	}

}