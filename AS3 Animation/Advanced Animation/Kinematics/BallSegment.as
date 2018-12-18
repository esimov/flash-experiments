﻿package {	import flash.display.StageScaleMode;	import flash.display.StageAlign;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	[SWF (backgroundColor = 0x000011)]		public class BallSegment extends Sprite {		private var segments:Array;		private var segment:Segment;		private var segmentNr:Number = 10;		private var gravity:Number = 0.9;		private var bounce:Number = -1;		var ball:Ball;				public function BallSegment():void {			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			init();		}				private function init():void {			ball = new Ball(20);			ball.x = Math.random() * stage.stageWidth;			ball.vx = 10;			addChild(ball);			segments = new Array();			for (var i:uint = 0; i< segmentNr; i++) {				segment = new Segment(75,15);				addChild(segment);				segments.push(segment);			}						segment.x = stage.stageWidth/2;			segment.y = stage.stageHeight/2;			stage.addEventListener(Event.ENTER_FRAME, onStart);		}				private function onStart(evt:Event):void {			moveBall();			var tg:Point = reachSegment(segments[0], ball.x, ball.y);			for (var i:uint = 1; i< segments.length; i++) {				var segment:Segment = segments[i] as Segment;				tg = reachSegment(segment, tg.x, tg.y);			}						for (i = segments.length - 1; i> 0; i--) {				var segmentA:Segment = segments[i];				var segmentB:Segment = segments[i-1];				positionSegment(segmentB, segmentA);			}		}				private function reachSegment(segment:Segment, xPos:Number, yPos:Number):Point {			var dx:Number = xPos - segment.x;			var dy:Number = yPos - segment.y;			var angle:Number = Math.atan2(dy, dx);			segment.rotation = angle * 180 / Math.PI;						var segW:Number = segment.getPivot().x - segment.x;			var segH:Number = segment.getPivot().y - segment.y;						var tx:Number = xPos - segW;			var ty:Number = yPos - segH;			return new Point(tx,ty);					}				private function positionSegment(segmentA:Segment, segmentB:Segment):void {			segmentA.x = segmentB.getPivot().x;			segmentA.y = segmentB.getPivot().y;		}				private function moveBall():void {			ball.vy += gravity;			ball.x += ball.vx;			ball.y += ball.vy;			if (ball.y + ball.radius > stage.stageHeight) {				ball.vy *= bounce;			}						if (ball.y - ball.radius < 0) {				ball.vy *= bounce;			}						if (ball.x + ball.radius > stage.stageWidth) {				ball.vx *= bounce;			}						if (ball.x - ball.radius < 0) {				ball.vx *= bounce;			}		}	}}