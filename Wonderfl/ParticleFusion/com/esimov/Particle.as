package com.esimov
{
	import flash.geom.Point;

	public class Particle extends Point
	{
		// Velocity and acceleration values of particles
		public var vel:Point = new Point();
		public var acc:Point = new Point();
		
		// Initial particle positions
		public var initX:Number;
		public var initY:Number;
		
		// Color attributes
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public var color:uint;
		public var alpha:uint;
		public var next:Particle;
		
		public function Particle(color:uint = 0xffffffff):void
		{
			this.color = color;
			alpha	= (color >> 32) & 0xff;
			red		= (color >> 16) & 0xff;
			green 	= (color >> 08) & 0xff;
			blue 	= (color >> 00) & 0xff;
		}
	}
}