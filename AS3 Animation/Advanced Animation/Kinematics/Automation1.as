﻿package {	import flash.display.Sprite;	import flash.events.Event;		public class Automation1 extends Sprite {		private var segment1:Segment;		private var segment2:Segment;		private var slider1:SimpleSlider;		private var slider2:SimpleSlider;		private var angleV:Number = 0;				public function Automation1():void {			init();		}				private function init():void {			segment1 = new Segment(100, 20);			segment1.x = stage.stageWidth/2;			segment1.y = stage.stageHeight/2;			addChild(segment1);						segment2 = new Segment(100, 20);			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;			addChild(segment2);						addEventListener(Event.ENTER_FRAME, onSliderChange);					}				private function onSliderChange (evt:Event):void {			angleV += 0.05;			var angle:Number = Math.sin(angleV) * 180;			segment1.rotation = angle;			segment2.rotation = segment1.rotation + angle;			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;		}	}}