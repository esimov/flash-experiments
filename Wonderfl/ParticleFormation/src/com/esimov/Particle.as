package com.esimov
{
	public class Particle
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var next:Particle;
		
		public function Particle(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			vx = vy = 0;
		}
	}
}