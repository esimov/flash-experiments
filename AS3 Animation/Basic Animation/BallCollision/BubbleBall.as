package {
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class BubbleBall extends Sprite {
		private var ball:Ball;
		private var balls:Array;
		protected var bounce:Number = -0.8;
		protected var spring:Number = 0.1;
		protected var numBalls:Number = 25;
		private static var gravity:Number = 0.4;
		
		public function BubbleBall():void {
			init();
		}
		
		private function init():void {
			balls = new Array();
			for (var i:uint = 0; i< numBalls; i++) {
				ball = new Ball(Math.random()*28 + 20, Math.random()*0xffffff);
				ball.x = Math.random() * stage.stageWidth;
				ball.y = Math.random() * stage.stageHeight;
				ball.vx = Math.random() * 10 - 2;
				ball.vy = Math.random() * 10 - 2;
				addChild(ball);
				balls.push(ball);
			}
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onStart(evt:Event):void {
			for (var i:uint = 0; i< numBalls - 1; i++) {
				var ballA:Ball = Ball(balls[i]);
					for (var j:uint = i+1; j< numBalls; j++) {
						var ballB:Ball = Ball(balls[j]);
						var dx:Number = ballB.x - ballA.x;
						var dy:Number = ballB.y - ballA.y;
						var dist:Number = Math.sqrt(dx*dx + dy*dy);
						var angle:Number = Math.atan2(dy,dx);
						var minDist:Number = ballB.radius + ballA.radius;
						if (dist < minDist) {
							var targetX:Number = ballA.x + dx/dist * minDist;
							var targetY:Number = ballA.y + dy/dist * minDist;
							var ax:Number = (targetX - ballB.x) * spring;
							var ay:Number = (targetY - ballB.y) * spring;
							ballA.vx -= ax;
							ballA.vy -= ay;
							ballB.vx += ax;
							ballB.vy += ay;
						}
					}
			}
			for (i = 0; i< numBalls; i++) {
				var ball:Ball = balls[i] as Ball;
				moveBall(ball);
			}
		}
		
		private function moveBall(ball:Ball):void {
			ball.x += ball.vx;
			ball.y += ball.vy;
			ball.y += BubbleBall.gravity;
			
			if (ball.x - ball.radius < 0) {
				ball.x = 0 + ball.radius;
				ball.vx *= bounce;
			}
			if (ball.x + ball.radius > stage.stageWidth) {
				ball.x = stage.stageWidth - ball.radius;
				ball.vx *= bounce;
			}
			if (ball.y - ball.radius < 0) {
				ball.y = 0 + ball.radius;
				ball.vy *= bounce;
			}
			if (ball.y + ball.radius > stage.stageHeight) {
				ball.y = stage.stageHeight - ball.radius;
				ball.vy *= bounce;
			}
		}
	}
}