﻿package {	import flash.display.Sprite;	import flash.events.Event;	import flash.filters.BlurFilter;		public class MoveBalls extends Sprite {		private var count:Number = 30;		private var ball:Ball;		private var bin:Array;		private var filter:BlurFilter = new BlurFilter(10, 10, 1);				public function MoveBalls():void {			bin = new Array();			for (var i:Number = 0; i<count; i++) {				ball = new Ball(15);				ball.x = Math.random() * stage.stageWidth;				ball.y = Math.random() * stage.stageHeight;				ball.vx = Math.random() * 1.5 - .5;				ball.vy = Math.random() * 1.5 - .5;				addChild(ball);				//ball.cacheAsBitmap = true;				//ball.filters = [filter];				bin.push(ball);			}						stage.addEventListener(Event.ENTER_FRAME, startEnterFrame);		}				private function startEnterFrame(evt:Event):void {			for (var i:Number = bin.length - 1; i>0; i--) {				var ball:Ball = Ball(bin[i]);				ball.x += ball.vx;				ball.y += ball.vy;				if (ball.x - ball.radius < 0 || ball.x - ball.radius > stage.stageWidth ||					ball.y - ball.radius < 0 || ball.y - ball.radius > stage.stageHeight) {					removeChild(ball);					bin.splice(i,1);					if (bin.length<=0) {						stage.removeEventListener(Event.ENTER_FRAME, startEnterFrame);					}				}			}		}			}}