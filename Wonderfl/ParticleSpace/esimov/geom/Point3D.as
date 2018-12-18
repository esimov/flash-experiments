package esimov.geom
{
	public class Point3D
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function clone():Point3D
		{
			var outPoint:Point3D = new Point3D();
			outPoint.x = this.x;
			outPoint.y = this.y;
			outPoint.z = this.z;
			return outPoint;
		}
	}
}