﻿package {	import flash.display.Sprite;	import flash.events.Event;		public class TwoSegment extends Sprite {		private var segment1:Segment;		private var segment2:Segment;		private var slider1:SimpleSlider;		private var slider2:SimpleSlider;				public function TwoSegment():void {			init();		}				private function init():void {			segment1 = new Segment(100, 20);			segment1.x = 100;			segment1.y = 100;			addChild(segment1);						segment2 = new Segment(100, 20);			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;			addChild(segment2);						slider1 = new SimpleSlider(-90, 90, 0);			slider1.x = 400;			slider1.y = 100;			addChild(slider1);			slider1.addEventListener(Event.CHANGE, onSliderChange);						slider2 = new SimpleSlider (-90, 90, 0);			slider2.x = 420;			slider2.y = 100;			addChild(slider2);			slider2.addEventListener(Event.CHANGE, onSliderChange);		}				private function onSliderChange (evt:Event):void {			segment1.rotation = slider1.value;			segment2.rotation = segment1.rotation + slider2.value;			segment2.x = segment1.getPivot().x;			segment2.y = segment1.getPivot().y;		}	}}