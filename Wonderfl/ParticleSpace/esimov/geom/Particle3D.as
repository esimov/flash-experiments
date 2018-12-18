package esimov.geom
{
	public class Particle3D extends Point3D
	{
		public var color:uint;
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public var alpha:uint;
		
		//Projection of the 3D particles to the 2D space
		public var projX:Number;
		public var projY:Number;
		public var onScreen:Boolean;
		
		//Maping the 2D image to the 3D space
		public var u:Number;
		public var v:Number;
		public var w:Number;
		
		public var next:Particle3D;
		
		public function Particle3D(color:uint = 0xffffffff):void
		{
			this.color = color;
			this.alpha = getAlpha();
			this.red = getRedColor();
			this.green = getGreenColor();
			this.blue = getBlueColor();
			this.onScreen = true;
		}
		
		private function getAlpha():uint
		{
			return (this.color >> 24) & 0xff;
		}
		
		private function getRedColor():uint
		{
			return (this.color >> 16) & 0xff;
		}
		
		private function getGreenColor():uint
		{
			return (this.color >> 08) & 0xff;
		}
		
		private function getBlueColor():uint
		{
			return (this.color >> 00) & 0xff;
		}
	}
}