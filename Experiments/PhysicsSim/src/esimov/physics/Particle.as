package esimov.physics 
{
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Simo Endre
	 */
	public class Particle
	{
		public var position:Vector3D;
		public var velocity:Vector3D;
		public var force:Vector3D;
		
		public var mass:Number;
		public var maxVel:Number;
		public var fixed:Boolean;
		public var isDragging:Boolean;
		
		private var radius:Number;
		
		public static const BOUNCE:String = "bounce";
		public static const WRAP:String = "wrap";
		
		public function Particle(mass:Number, position:Vector3D):void 
		{
			this.position = (position) ? position : new Vector3D();
			this.velocity = new Vector3D;
			this.force = new Vector3D;
			this.mass = mass;
			
			isDragging = false; 
			fixed = false;
		}
		
		public final function distanceBetween(p:Particle):Number
		{
			return Vector3D.distance(this.position, p.position);
		}
		
		public final function makeFree():void
		{
			fixed = false;
		}
		
		public final function makeFix():void
		{
			fixed = true;
			this.velocity.x = 0; this.velocity.y = 0; this.velocity.z = 0;
		}
		
		public final function isFree():Boolean
		{
			return !fixed;
		}
		
		public final function isFixed():Boolean
		{
			return fixed;
		}
		
		public function setMass(value:Number):void
		{
			this.mass = value;
		}
		
		public function set maxVelocity(value:Number):void
		{
			 maxVel =  value;
		}
		
		public function get maxVelocity():Number
		{
			return maxVel;
		}

		public function reset():void
		{
			this.position.x = 0; this.position.y = 0; this.position.z = 0;
			this.velocity.y = 0; this.velocity.y = 0; this.velocity.z = 0;
			this.force.x = 0; this.force.y = 0; this.force.z = 0;
			this.mass = 1;
		}

		public function boundCheck(type:String, left:Number, right:Number, top:Number, bottom:Number) : void
		{
			switch (type)
			{
				case Particle.BOUNCE:
				
				if (this.position.x < left)
				{
					position.x = left + (left - position.x);
					velocity.x *= -1;
				}
				
				if (this.position.x > right)
				{
					position.x = right - (position.x - right);
					velocity.x *= -1;
				}
				
				if (this.position.y < top)
				{
					position.y = top + (top - position.y);
					velocity.y *= -1;
				}
				
				if (this.position.y > bottom)
				{
					position.y = bottom - (position.y - bottom);
					velocity.y *= -1;
				}
				break;
				
				case Particle.WRAP:
				break;
			}
		}
	}
}