package
{
	public final class Particle
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var next:Particle;
		public var t:Number = Math.random() * Math.random();
		
		public function Particle (x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			vx = vy = 0;
		}
	}
}