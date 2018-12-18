package esimov.physics
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	public class Attraction
	{
		private var p1:Particle;
		private var p2:Particle;
		private var minDistance:Number;
		private var minDistanceSq:Number;
		private var strength:Number;
		
		private var on:Boolean;
		
		public function Attraction(p1:Particle, p2:Particle, strength:Number, minDistance:Number):void
		{
			this.p1 = p1;
			this.p2 = p2;
			this.minDistance = minDistance;
			this.minDistanceSq = minDistance * minDistance;
			this.strength = strength;
			
			on = true;
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
		
		public final function setStrength(value:Number):void
		{
			this.strength = value;
		}
		
		public final function getStrength():Number
		{
			return this.strength;
		}
		
		public final function setDistance(value:Number):void
		{
			this.minDistance = value;
			this.minDistanceSq = value * value;
		}
		
		public final function getDistance():Number
		{
			return minDistance;
		}
		
		public function update():void
		{
			if (on && (!p1.fixed || !p2.fixed))
			{
				var distX:Number = p2.position.x - p1.position.x;
				var distY:Number = p2.position.y - p1.position.y;
				var distZ:Number = p2.position.z - p1.position.z;
				
				var distanceSq:Number = distX * distX + distY * distY + distZ * distZ;
				if (distanceSq < minDistanceSq)
				{
					distanceSq = minDistanceSq;
				}
				var invLength:Number = 1 / Math.sqrt(distanceSq);
				
				var force:Number = strength * (p1.mass * p2.mass) / distanceSq;
				
				distX *= invLength;
				distY *= invLength;
				distZ *= invLength;
				
				distX *= force;
				distY *= force;
				distZ *= force;
				
				if (!p1.fixed)
				{
					//p1.force = p1.force.add(new Vector3D(distX, distY, distZ)); 
					p1.force.x += distX;
					p1.force.y += distY;
					p1.force.z += distZ;
				}
				if (!p2.fixed)
				{
					//p2.force = p2.force.add(new Vector3D(-distX, -distY, -distZ)); 
					p2.force.x -= distX;
					p2.force.y -= distY;
					p2.force.z -= distZ;
				}
			}
		}
	}
}