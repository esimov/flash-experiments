package com.esimov
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	public class Obstacle extends Sprite
	{
		private var _radius:Number;
		private var _color:uint;
		
		public function Obstacle(radius:Number, color:uint):void
		{
			_radius = radius;
			_color = color;
			graphics.clear();
			graphics.lineStyle(0, 0xff, 0);
			graphics.beginFill(color, 1);
			graphics.drawCircle(0,0, _radius);
			graphics.endFill();
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function get position():Vector2D
		{
			return new Vector2D(x, y);
		}
	}
}