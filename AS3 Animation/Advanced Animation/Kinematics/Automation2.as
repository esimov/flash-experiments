﻿package {	import flash.display.Sprite;	import flash.events.Event;		public class Automation2 extends Sprite {		private var segment1:Segment;		private var segment2:Segment;		private var segment3:Segment;		private var segment4:Segment;				private var slider1:SimpleSlider;		private var slider2:SimpleSlider;		private var angleV:Number = 0;		private var offset:Number = - Math.PI/2;				public function Automation2():void {			init();		}				private function init():void {			segment1 = new Segment(100, 30);			segment1.x = stage.stageWidth/2;			segment1.y = stage.stageHeight/2;			addChild(segment1);						segment2 = new Segment(100, 20);			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;			addChild(segment2);						segment3 = new Segment(100, 30);			segment3.x = stage.stageWidth/2;			segment3.y = stage.stageHeight/2;			addChild(segment3);						segment4 = new Segment(100, 20);			segment4.x = segment3.getPivot().x;			segment4.y = segment3.getPivot().y;			addChild(segment4);						addEventListener(Event.ENTER_FRAME, onSliderChange);					}				private function onSliderChange (evt:Event):void {			legs (segment1, segment2, angleV);			legs (segment3, segment4, angleV + Math.PI);			angleV +=0.5;		}				private function legs (segment1:Segment, segment2:Segment, angleV:Number):void {			var angle1:Number = Math.sin(angleV) * 45 + 90;			var angle2:Number = Math.sin(angleV + offset) * 45 + 45;			segment1.rotation = angle1;			segment2.rotation = segment1.rotation + angle2;			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;		}	}}