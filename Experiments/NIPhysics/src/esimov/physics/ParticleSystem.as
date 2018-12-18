package esimov.physics
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	
	public class ParticleSystem
	{
		internal var particles:Vector.<Particle>;
		internal var springs:Vector.<Spring>;
		internal var attractors:Vector.<Attraction>;
		
		private var integrator:Integrator;
		private var gravity:Vector3D;
		private var drag:Number;
		private var restLength:Number = 2;
		
		public static const RK:String = "RUNGE_KUTTA";
		public static const EULER:String = "MODIFIED_EULER";
		public static const VERLET:String = "VERLET";
		
		public function ParticleSystem(gravity:Vector3D = null, drag:Number = 0.001):void
		{
			particles = new Vector.<Particle>();
			springs = new Vector.<Spring>();
			attractors = new Vector.<Attraction>();
			
			this.integrator = new RKIntegrator(this);
			this.gravity = (gravity) ? gravity : new Vector3D();
			this.drag = drag;
		}
		
		public final function setIntegrator(integrator:String):void
		{
			switch (integrator)
			{
				case RK: 
					this.integrator = new RKIntegrator(this);
					break;
				
				case EULER: 
					this.integrator = new EulerIntegrator(this);
					break;
				
				case VERLET: 
					this.integrator = new VerletIntegrator(this);
					break;
			}
		}
		
		public final function getIntegrator():Integrator
		{
			return this.integrator;
		}
		
		public final function applyIntegrator(t:Number = 1):void
		{
			integrator.apply(t);
		}
		
		public final function setGravity(value:Number):void
		{
			this.gravity.scaleBy(value);
		}
		
		public final function getGravity():Vector3D
		{
			return this.gravity;
		}
		
		public final function setDrag(value:Number):void
		{
			this.drag = value;
		}
		
		public final function getDrag():Number
		{
			return drag;
		}
		
		public final function makeParticle(mass:Number = 1, position:Vector3D = null):Particle
		{
			var particle:Particle = new Particle(mass, position);
			particle.isDragging = false;
			particles.push(particle);
			return particle;
		}
		
		public final function makeSpring(p1:Particle, p2:Particle, damping:Number, restLenght:Number, springConst:Number):Spring
		{
			var spring:Spring = new Spring(p1, p2, damping, restLenght, springConst);
			springs.push(spring);
			return spring;
		}
		
		public final function makeAttractors(p1:Particle, p2:Particle, strength:Number, minDist:Number):Attraction
		{
			var attraction:Attraction = new Attraction(p1, p2, strength, minDist);
			attractors.push(attraction);
			return attraction;
		}
		
		public function getParticlesLength():Number
		{
			return particles.length;
		}
		
		public function getSpringsLength():Number
		{
			return springs.length;
		}
		
		public function getAttractorsLength():Number
		{
			return attractors.length;
		}
		
		public final function applyForces():void
		{
			var i:int;
			
			if (gravity.x != 0 || gravity.y != 0 || gravity.z != 0)
			{
				for (i = 0; i < getParticlesLength(); i++)
				{
					var particle:Particle = Particle(particles[i]);
					
					if (!particle.isDragging)
					{
						particle.force = particle.force.add(gravity);
					}
					else
					{
						particle.force = new Vector3D();
					}
				}
			}
			
			for (i = 0; i < getParticlesLength(); i++)
			{
				particle = Particle(particles[i]);
				if (!particle.isDragging)
				{
					var vel:Vector3D = particle.velocity.clone();
					vel.scaleBy(-drag);
					particle.force = particle.force.add(vel);
				}
				else
				{
					particle.velocity = new Vector3D();
				}
			}
			
			for (i = 0; i < getSpringsLength(); i++)
			{
				var spring:Spring = Spring(springs[i]);
				spring.update();
			}
			
			for (i = 0; i < getAttractorsLength(); i++)
			{
				var attractor:Attraction = Attraction(attractors[i]);
				attractor.update();
			}
		}
		
		public final function clear():void
		{
			var i:int;
			for (i = 0; i <= getParticlesLength(); i++)
				particles[i] = null;
			
			for (i = 0; i <= getAttractorsLength(); i++)
				attractors[i] = null;
			
			for (i = 0; i <= getSpringsLength(); i++)
				springs[i] = null;
			
			particles = new Vector.<Particle>();
			attractors = new Vector.<Attraction>();
			springs = new Vector.<Spring>();
		}
		
		public final function clearForces():void
		{
			for (var i:int = i; i < getParticlesLength(); i++)
			{
				Particle(particles[i]).force.x = 0;
				Particle(particles[i]).force.y = 0;
				Particle(particles[i]).force.z = 0;
			}
		}
		
		public final function getParticle(index:Number):Particle
		{
			return particles[index];
		}
		
		public final function getAttractor(index:Number):Attraction
		{
			return attractors[index];
		}
		
		public final function getSpring(index:Number):Spring
		{
			return springs[index];
		}
		
		public final function removeParticle(n:int):void
		{
			particles[n] = null;
			particles.splice(n, 1);
		}
		
		public final function removeSprings(n:int):void
		{
			springs[n] = null;
			springs.splice(n, 1);
		}
		
		public final function removeAttractors(n:int):void
		{
			attractors[n] = null;
			attractors.splice(n, 1);
		}
		
		public final function removeParticleByIndex(p:Particle):Boolean
		{
			var i:int;
			var n:Number = -1;
			for (i = 0; i <= getParticlesLength(); i++)
			{
				if (particles[i] == p)
				{
					n = i;
					break;
				}
			}
			if (n != -1)
			{
				particles[n] = null;
				particles.splice(n, 1);
				return true;
			}
			else
				return false;
		}
		
		public final function removeSpringByIndex(s:Spring):Boolean
		{
			var i:int;
			var n:Number = -1;
			for (i = 0; i <= getParticlesLength(); i++)
			{
				if (springs[i] == s)
				{
					n = i;
					break;
				}
			}
			if (n != -1)
			{
				springs[n] = null;
				springs.splice(n, 1);
				return true;
			}
			else
				return false;
		}
		
		public final function removeAttractorByIndex(a:Attraction):Boolean
		{
			var i:int;
			var n:Number = -1;
			for (i = 0; i <= getParticlesLength(); i++)
			{
				if (attractors[i] == a)
				{
					n = i;
					break;
				}
			}
			if (n != -1)
			{
				attractors[n] = null;
				attractors.splice(n, 1);
				return true;
			}
			else
				return false;
		}
		
		public function constraintSolve():void
		{
			for (var i:int = 0; i < getParticlesLength() - 1; i++)
			{
				var p1:Particle = particles[i];
				var p2:Particle = particles[i + 1];
				
				var dx:Number = p2.position.x - p1.position.x;
				var dy:Number = p2.position.y - p1.position.y;
				var delta:Number = Math.sqrt(dx * dx + dy * dy);
				var diff:Number = restLength - delta;
				var offsetX:Number = (diff * dx / delta) * 0.2;
				var offsetY:Number = (diff * dy / delta) * 0.2;
				p1.position.x -= offsetX;
				p1.position.y -= offsetY;
				p2.position.x += offsetX;
				p2.position.y += offsetY;
			}
		}
	}
}