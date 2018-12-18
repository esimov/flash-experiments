﻿package {		import flash.events.Event;	import flash.display.Sprite;	import flash.geom.Rectangle;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		public class BallCollision2 extends Sprite {		private var ball1:Ball;		private var ball2:Ball;		private var bounce:Number = -1;		private var friction:Number = 0.3;						public function BallCollision2():void {			init();		}				private function init():void {			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						ball1 = new Ball(60);			ball1.x = ball1.radius;			ball1.y = stage.stageHeight/2;			ball1.vx = Math.random() * 20 - 5;			ball1.vy = Math.random() * 20 - 5;			ball1.mass = 4;			addChild(ball1);						ball2 = new Ball(77);			ball2.x = stage.stageWidth - ball2.radius;			ball2.y = stage.stageHeight/2;			ball2.vx = Math.random() * 20 - 5;			ball2.vy = Math.random() * 20 - 5;			ball2.mass = 8;			addChild(ball2);						addEventListener(Event.ENTER_FRAME, onStart);		}				private function onStart(evt:Event):void {			ball1.x += ball1.vx;			ball1.y += ball1.vy;			ball2.x += ball2.vx;			ball2.y += ball2.vy;									checkBounds(ball1);			checkBounds(ball2);			checkCollision(ball1, ball2);		}				function checkCollision (ball0:Ball, ball1:Ball):void {			var dx:Number = ball1.x - ball0.x;			var dy:Number = ball1.y - ball0.y;			var dist:Number = Math.sqrt(dx*dx + dy*dy);						if (dist < ball0.radius + ball1.radius) {				var angle:Number = Math.atan2(dy, dx);				var cos:Number = Math.cos(angle);				var sin:Number = Math.sin(angle);								var x0:Number = 0;				var y0:Number = 0;				var x1:Number = dx * cos + dy * sin;				var y1:Number = dy * cos - dx * sin;								var vx0:Number = ball0.vx * cos + ball0.vy * sin;				var vy0:Number = ball0.vy * cos - ball0.vx * sin;				var vx1:Number = ball1.vx * cos + ball1.vy * sin;				var vy1:Number = ball1.vy * cos - ball1.vx * sin;								var vxTotal:Number = vx0 - vx1;				vx0 = ((ball0.mass - ball1.mass) * vx0 + 2 * ball1.mass * vx1) / (ball1.mass + ball0.mass);				vx1 = vxTotal + vx0;								x0 += vx0;				x1 += vx1;								var x0Final:Number = x0 * cos - y0 * sin;				var y0Final:Number = y0 * cos + x0 * sin;				var x1Final:Number = x1 * cos - y1 * sin;				var y1Final:Number = y1 * cos + x1 * sin;								ball0.x = ball0.x + x0Final;				ball0.y = ball0.y + y0Final;				ball1.x = ball0.x + x1Final;				ball1.y = ball0.y + y1Final;								ball0.vx = vx0 * cos - vy0 * sin;				ball0.vy = vy0 * cos + vx0 * sin;				ball1.vx = vx1 * cos - vy1 * sin;				ball1.vy = vy1 * cos + vy1 * sin;								var speed1:Number = Math.sqrt(vx0*vx0 + vy0*vy0);				var speed2:Number = Math.sqrt(vx1*vx1 + vy1*vy1);														if (speed1 > friction || speed2 > friction){					speed1 -= friction;					speed2 -= friction;				}					else {					speed1 = 0;					speed2 = 0;				}												vx0 = Math.cos(angle) * speed1;				vy0 = Math.sin(angle) * speed1;				vx0 = Math.cos(angle) * speed2;				vy1 = Math.sin(angle) * speed2;								ball1.x +=vx0;				ball1.y +=vy0;				ball2.x +=vx1;				ball2.y +=vy1;			}					}				function checkBounds(ball:Ball):void {			if (ball.x < ball.radius) {				ball.x = ball.radius;				ball.vx *= bounce;			}						if (ball.x > stage.stageWidth - ball.radius) {				ball.x = stage.stageWidth - ball.radius;				ball.vx *= bounce;			}						if (ball.y < ball.radius) {				ball.y = ball.radius;				ball.vy *= bounce;			}						if (ball.y > stage.stageHeight - ball.radius) {				ball.y = stage.stageHeight - ball.radius;				ball.vy *= bounce;			}		}	}}