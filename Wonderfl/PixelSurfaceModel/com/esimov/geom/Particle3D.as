package com.esimov.geom
{
	public class Particle3D extends Point3D
	{
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public var color:uint;
		
		public var projX:Number;
		public var projY:Number;
		
		public var u:Number;
		public var v:Number;
		public var w:Number;
		
		public var next:Particle3D;
		public var onScreen:Boolean;
		
		public function Particle3D(color:uint = 0xFFFFFF):void
		{
			this.color = color;
			this.red = getRed(color);
			this.green = getGreen(color);
			this.blue = getBlue(color);
		}
		
		public function getRed(c:uint):uint
		{
			return c >> 16 & 0xff;
		}
		
		public function getGreen(c:uint):uint
		{
			return c >> 08 & 0xff;
		}
		
		public function getBlue(c:uint):uint
		{
			return c >> 00 & 0xff;
		}
	}
}