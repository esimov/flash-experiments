package  
{

	/**
	 * @author simoe
	 */ 
	 
	public class Node
	{
		public var x:Number;
		public var y:Number;
		public var u:Number;
		public var v:Number;
		public var dx:Number;
		public var dy:Number;
		
		public function Node(x:Number, y:Number, u:Number, v:Number):void
		{
			this.x = x;
			this.y = y;
			this.u = u;
			this.v = v;
			this.dx = 0;
			this.dy = 0; 
		}
	}
}
