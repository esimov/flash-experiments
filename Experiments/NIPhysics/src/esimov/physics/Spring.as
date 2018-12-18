package esimov.physics
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	public class Spring
	{
		private var p1:Particle;
		private var p2:Particle;
		private var springConst:Number;
		private var on:Boolean;
		
		private var damping:Number;
		private var restLength:Number;
		
		public function Spring(p1:Particle, p2:Particle, springConst:Number, damping:Number, restLength:Number):void
		{
			this.p1 = p1;
			this.p2 = p2;
			this.damping = damping;
			this.restLength = restLength;
			this.springConst = springConst;
			
			this.on = true;
		}
		
		public final function turnOn():void
		{
			on = true;
		}
		
		public final function turnOff():void
		{
			on = false;
		}
		
		public final function isOn():Boolean
		{
			return on;
		}
		
		public final function isOff():Boolean
		{
			return !on;
		}
		
		public final function getDistance(p1:Particle, p2:Particle):Number
		{
			return Vector3D.distance(p1.position, p2.position);
		}
		
		public final function setDamping(value:Number):void
		{
			this.damping = value;
		}
		
		public final function getDamping():Number
		{
			return damping;
		}
		
		public final function setRestLength(value:Number):void
		{
			this.restLength = value;
		}
		
		public final function getRestLength():Number
		{
			return this.restLength;
		}
		
		public function update():void
		{
			if (on && (!p1.fixed || !p2.fixed))
			{
				var distX:Number = p2.position.x - p1.position.x;
				var distY:Number = p2.position.y - p1.position.y;
				var distZ:Number = p2.position.z - p1.position.z;
				
				var distSq:Number = Math.sqrt(distX * distX + distY * distY + distZ * distZ);
				if (distSq == 0)
				{
					distX = 0;
					distY = 0;
					distZ = 0;
				}
				distX /= distSq;
				distY /= distSq;
				distZ /= distSq;
				
				var springForce:Number = -(distSq - restLength) * springConst;
				var velX:Number = p2.velocity.x - p1.velocity.x;
				var velY:Number = p2.velocity.y - p1.velocity.y;
				var velZ:Number = p2.velocity.z - p1.velocity.z;
				
				var dampingForce:Number = -damping * (distX * velX + distY * velY + distZ * velZ);
				var aggregateForce:Number = springForce + dampingForce;
				distX *= aggregateForce;
				distY *= aggregateForce;
				distZ *= aggregateForce;
				
				if (!p1.fixed)
				{
					// p1.force = p1.force.add(new Vector3D(-distX, -distY, -distZ)); 
					p1.force.x -= distX;
					p1.force.y -= distY;
					p1.force.z -= distZ;
				}
				if (!p2.fixed)
				{
					// p2.force = p2.force.add(new Vector3D(distX, distY, distZ)); 
					p2.force.x += distX;
					p2.force.y += distY;
					p2.force.z += distZ;
				}
			}
		}
	}
}