package com.esimov
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.BlendMode;
	
	public class TargetShape extends Sprite
	{
		private var g:Shape = new Shape();
		private var _color:uint;
		private var _radius:Number;
		private var _vx:Number;
		private var _vy:Number;
		
		public function TargetShape(color:uint = 0x999999, radius:Number = 15):void
		{
			this._color = color;
			this._radius = radius;
			init();
		}
		
		private function init():void
		{
			with (g)
			{
				graphics.beginFill(_color);
				graphics.drawCircle(0, 0, _radius);
				graphics.endFill();
				graphics.beginFill(0xffffff);
				graphics.drawCircle(_radius - _radius >> 1, _radius - _radius >> 1, _radius >> 1);
				graphics.endFill();
			}
			g.blendMode = BlendMode.MULTIPLY;
			addChild(g);
		}
		
		public function set vx (value: Number):void
		{
			_vx = value;
		}
		
		public function get vx():Number
		{
			return _vx;
		}
		
		public function set vy (value: Number):void
		{
			_vy = value;
		}
		
		public function get vy():Number
		{
			return _vy;
		}
	}
}