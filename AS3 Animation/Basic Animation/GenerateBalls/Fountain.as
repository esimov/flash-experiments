﻿package {	import flash.display.Sprite;	import flash.events.Event;	import flash.filters.BlurFilter;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		public class Fountain extends Sprite {		private var count:Number = 100;		private var gravity:Number = 0.7;		private var wind:Number = 0.08;		private var ball:Ball;		private var bin:Array;					public function Fountain():void {				bin = new Array();			for (var i:Number = 0; i<count; i++) {				ball = new Ball(2.5, Math.random() * 0xffffff);				ball.x = stage.stageWidth * 0.5;				ball.y = stage.stageHeight;				ball.vx = Math.random() * 1.5 - .5;				ball.vy = Math.random() * -15 - 2;				addChild(ball);				bin.push(ball);			}						stage.scaleMode = StageScaleMode.EXACT_FIT;			stage.align = StageAlign.LEFT;			stage.addEventListener(Event.ENTER_FRAME, startEnterFrame);		}				private function startEnterFrame(evt:Event):void {			for (var i:Number = bin.length - 1; i>0; i--) {				var ball:Ball = Ball(bin[i]);				ball.vy += gravity;				ball.vx += wind;				ball.x += ball.vx;				ball.y += ball.vy;				if (ball.x - ball.radius < 0 || ball.x - ball.radius > stage.stageWidth ||					ball.y - ball.radius < 0 || ball.y - ball.radius > stage.stageHeight) {						ball.x = stage.stageWidth * 0.5;						ball.y = stage.stageHeight;						ball.vx = Math.random() * 2 - 1.5;						ball.vy = Math.random() * -15 - 5;				}			}		}			}}