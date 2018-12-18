﻿package {	import flash.display.Sprite;	import flash.display.Graphics;	import flash.geom.Point;		public class Segment extends Sprite {		private var segmentWidth:Number;		private var segmentHeight:Number;		private var color:uint;		public var vx:Number = 1;		public var vy:Number = 1;				public function Segment(segmentWidth:Number, segmentHeight:Number, color:uint = 0xfffffff):void {			this.segmentWidth= segmentWidth;			this.segmentHeight = segmentHeight;			this.color = color;			init();					}				private function init():void {			graphics.lineStyle(1,0xd0d0d0);			graphics.beginFill(color);			graphics.drawRoundRect(-segmentHeight/2, -segmentHeight/2, segmentHeight + segmentWidth, segmentHeight, segmentHeight, segmentHeight);			graphics.endFill();						graphics.drawCircle(0, 0, 2);			graphics.drawCircle(segmentWidth, 0, 2);		}				public function getPivot():Point {			var radians:Number = this.rotation * Math.PI / 180;			var dx:Number = this.x + Math.cos(radians) * segmentWidth;			var dy:Number = this.y + Math.sin(radians) * segmentWidth;			return new Point(dx, dy);		}		}}