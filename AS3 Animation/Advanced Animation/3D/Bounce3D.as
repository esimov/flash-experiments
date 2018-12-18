﻿package {	import flash.events.Event;	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		public class Bounce3D extends Sprite {		private var ball:Ball3D;		private var top:Number = -100;		private var bottom:Number = 100;		private var left:Number = -100;		private var right:Number = 100;		private var front:Number = 100;		private var back:Number = -100		private var friction:Number = .98;		private var fl:Number = 250;		private var totalBall:Number = 20;		private var vpX:Number = stage.stageWidth/2;		private var vpY:Number = stage.stageHeight/2;		private var balls:Array;				public function Bounce3D():void {			stage.align = StageAlign.TOP_RIGHT;			stage.scaleMode = StageScaleMode.NO_SCALE;			init();		}				private function init():void {					balls = new Array();						for (var i:uint = 0; i< totalBall; i++) {				ball = new Ball3D(25);				balls.push(ball);				ball.vx = Math.random() * 10 - 5;				ball.vy = Math.random() * 10 - 5;				ball.vz = Math.random() * 10 - 5;				addChild(ball);			}			stage.addEventListener(Event.ENTER_FRAME, onStart);		}				private function moveBall (ball:Ball3D):void {			var radius:Number = ball.radius;			ball.xPos += ball.vx;			ball.yPos += ball.vy;			ball.zPos += ball.vz;						if (ball.xPos + radius > right) {				ball.xPos = right - radius;				ball.vx *= -1;			}						if (ball.xPos - radius < left) {				ball.xPos = left + radius;				ball.vx *= -1;			}						if (ball.yPos + radius > bottom) {				ball.yPos = bottom - radius;				ball.vy *= -1;			}						if (ball.yPos - radius < top) {				ball.yPos = top + radius;				ball.vy *= -1;			}						if (ball.zPos + radius > front) {				ball.zPos = front - radius;				ball.vz *= -1;			}						if (ball.zPos + radius > back) {				ball.zPos = back + radius;				ball.vz *= -1;			}						if (ball.zPos > -fl) {				var scale:Number = fl / (fl + ball.zPos);				ball.scaleX = ball.scaleY = scale;				ball.x = vpX + ball.xPos * scale;				ball.y = vpY + ball.yPos * scale;				ball.visible = true;			}			else 			{				ball.visible = false;			}		}				private function onStart(evt:Event):void {			for (var i:uint = 0; i< balls.length; i++) {				var ball:Ball3D = Ball3D (balls[i]);				moveBall(ball);			}			//zSort();		}				private function zSort():void {			balls.sortOn("zPos", Array.DESCENDING | Array.NUMERIC);			for (var i:uint = 0; i< balls.length; i++) {				var ball:Ball3D = balls[i] as Ball3D;				setChildIndex(ball, i);			}		}	}}