package com.esimov
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;

	public class Ball
	{
		public var v:Point = new Point();
		public var a:Point = new Point();
		public var pos:Point = new Point();
		public var hold:Point = new Point();
		public var holding:Boolean = false;
		
		public var mtx:Matrix = new Matrix();
		
		static public var bmp:BitmapData;
		static public var mouse:Point = new Point();
		static public const R:Number = 45; // RADIUS
		static public const G:Number = 1.7; // GRAVITY
		static public const S:Number = 0.023; // SPRING
		static public const R2:Number = 32 * 32; // HOLDING RADIUS
		static public const K:Number = 60; // NORMAL BALLS DISTANCE
		
		public function Ball():void
		{
			reset();
		}
		
		public function reset():void
		{
			pos.x = Math.random() * R + (240+R)>> 1;
			pos.y = Math.random() * R;
			v.x = 0; v.y = 0; a.x = 0; a.y = 0;
			holding = false;
		}
		
		public function gravity():void
		{
			a.x = 0; a.y = G; 
		}
		
		public function run():void
		{
			if (holding)
			{
				pos.x = mouse.x + hold.x;
				pos.y = mouse.y + hold.y;
			} else
			{
				pos.x += v.x + a.x * 0.5;
				pos.y += v.y + a.y * 0.5;
				v.x += a.x - v.x * 0.5;
				v.y += a.y - v.y * 0.5;
				if (pos.x > 480) { v.x = -v.x; pos.x = 480 - (pos.x - 480); }
				if (pos.y > 480) { v.y = -v.y; pos.y = 480 - (pos.y - 480); }
				if (pos.x < 0) { v.x = -v.y; pos.x = -pos.x; }
			}
			mtx.identity();
			mtx.translate(pos.x - R, pos.y - R);
		}
		
		public function draw(base:BitmapData):void
		{
			base.draw(bmp, mtx, null, "add");
		}
		
		public function interaction(ball:Ball):void
		{
			var dist_x:Number = ball.pos.x - pos.x;
			var dist_y:Number = ball.pos.y - pos.y;
			var dist:Number = Math.sqrt(dist_x * dist_x + dist_y * dist_y);
			var factor:Number = (K - dist) * S/dist;
			dist_x *= factor; dist_y *= factor;
			a.x -= dist_x; a.y -= dist_y;
			ball.a.x += dist_x; ball.a.y += dist_y;
		}
		
		public function checkHolding(x:Number, y:Number):void
		{
			hold.x = pos.x - x;
			hold.y = pos.y - y;
			holding = (hold.x * hold.x + hold.y * hold.y < R2);
		}
	}
}