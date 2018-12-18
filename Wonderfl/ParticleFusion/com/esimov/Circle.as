package com.esimov
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;

	public class Circle extends Sprite
	{
		private var _radius:Number;
		private var _color:uint;
		private var _thickness:Number;
		private var _matrix:Matrix;
		
		public var vx:Number;
		public var vy:Number;
		
		public function Circle(radius:Number = 10, thickness:Number = 4, color:uint = 0x00)
		{
			this._color = color;
			this._radius = radius;
			this._thickness = thickness;
			
			_matrix = new Matrix();
			_matrix.createGradientBox(2*_radius, 2*_radius, 0);
			var circle:Sprite = new Sprite();
			circle.cacheAsBitmap = true;
			var g:Graphics = circle.graphics;
			g.beginGradientFill("radial", [0xCB0000, 0xE28A09], [1, 1], [120, 129], _matrix, "reflect", "rgb", -0.9);
			g.lineStyle(_thickness, _color, .8, true, "none");
			g.drawCircle(0, 0, _radius);
			g.endFill();
			circle.filters = [new BlurFilter(4, 4)];
			addChild(circle);
		}
		
		public function get color():uint
		{
			return this._color;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
	}
}