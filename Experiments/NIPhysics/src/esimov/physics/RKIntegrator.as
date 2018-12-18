package esimov.physics
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	public class RKIntegrator implements Integrator
	{
		private var s:Number;
		private var intVel:Vector3D = new Vector3D;
		private var intForce:Vector3D = new Vector3D;
		private var k2VelInt:Vector3D = new Vector3D;
		private var k3VelInt:Vector3D = new Vector3D;
		private var k2ForceInt:Vector3D = new Vector3D;
		private var k3ForceInt:Vector3D = new Vector3D;
		
		private var originalPosV:Vector.<Vector3D>;
		private var originalVelV:Vector.<Vector3D>;
		private var k1VelV:Vector.<Vector3D>;
		private var k1ForceV:Vector.<Vector3D>;
		private var k2VelV:Vector.<Vector3D>;
		private var k2ForceV:Vector.<Vector3D>;
		private var k3VelV:Vector.<Vector3D>;
		private var k3ForceV:Vector.<Vector3D>;
		private var k4VelV:Vector.<Vector3D>;
		private var k4ForceV:Vector.<Vector3D>;
		
		private var p:Particle;
		
		private var particleSystem:ParticleSystem;
		
		public function RKIntegrator(particleSystem:ParticleSystem):void
		{
			this.particleSystem = particleSystem;
			
			originalPosV = new Vector.<Vector3D>();
			originalVelV = new Vector.<Vector3D>();
			k1VelV = new Vector.<Vector3D>();
			k1ForceV = new Vector.<Vector3D>();
			k2VelV = new Vector.<Vector3D>();
			k2ForceV = new Vector.<Vector3D>();
			k3VelV = new Vector.<Vector3D>();
			k3ForceV = new Vector.<Vector3D>();
			k4VelV = new Vector.<Vector3D>();
			k4ForceV = new Vector.<Vector3D>();
		}
		
		/* INTERFACE esimov.physics.Integrator */
		
		private function createParticles():void
		{
			while (particleSystem.particles.length > originalPosV.length)
			{
				originalPosV.push(new Vector3D());
				originalVelV.push(new Vector3D());
				k1VelV.push(new Vector3D());
				k1ForceV.push(new Vector3D());
				k2VelV.push(new Vector3D());
				k2ForceV.push(new Vector3D());
				k3VelV.push(new Vector3D());
				k3ForceV.push(new Vector3D());
				k4VelV.push(new Vector3D());
				k4ForceV.push(new Vector3D());
			}
		}
		
		public function apply(t:Number):void
		{
			createParticles();
			
			var numPart:Number = particleSystem.particles.length;
			var particles:Vector.<Particle> = particleSystem.particles;
			var i:int;
			
			var originalPos:Vector3D;
			var originalVel:Vector3D;
			var k1Vel:Vector3D;
			var k1Force:Vector3D;
			var k2Vel:Vector3D;
			var k2Force:Vector3D;
			var k3Vel:Vector3D;
			var k3Force:Vector3D;
			var k4Vel:Vector3D;
			var k4Force:Vector3D;
			
			/**
			 * Get initial position and velocity,
			 * apply forces and velocity, the result is K1
			 */
			
			for (i = 0; i < numPart; i++)
			{
				if (!Particle(particles[i]).fixed)
				{
					originalPosV[i].x = Particle(particles[i]).position.x;
					originalPosV[i].y = Particle(particles[i]).position.y;
					originalPosV[i].z = Particle(particles[i]).position.z;
					originalVelV[i].x = Particle(particles[i]).velocity.x;
					originalVelV[i].y = Particle(particles[i]).velocity.y;
					originalVelV[i].z = Particle(particles[i]).velocity.z;
				}
				
				Particle(particles[i]).force.x = 0;
				Particle(particles[i]).force.y = 0;
				Particle(particles[i]).force.z = 0;
			}
			
			particleSystem.applyForces();
			
			for (i = 0; i < numPart; i++)
			{
				if (!Particle(particles[i]).fixed)
				{
					k1ForceV[i].x = Particle(particles[i]).force.x;
					k1ForceV[i].y = Particle(particles[i]).force.y;
					k1ForceV[i].z = Particle(particles[i]).force.z;
					k1VelV[i].x = Particle(particles[i]).velocity.x;
					k1VelV[i].y = Particle(particles[i]).velocity.y;
					k1VelV[i].z = Particle(particles[i]).velocity.z;
				}
				
				Particle(particles[i]).force.x = 0;
				Particle(particles[i]).force.y = 0;
				Particle(particles[i]).force.z = 0;
			}
			
			/**
			 * Get initial position, K1 velocity
			 * apply forces and velocity, the result is K2
			 */
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					originalPos = originalPosV[i];
					k1Vel = k1VelV[i];
					
					s = (0.5 * t);
					k1Vel.x *= s;
					k1Vel.y *= s;
					k1Vel.z *= s;
					p.position.x = originalPos.x + k1Vel.x;
					p.position.y = originalPos.y + k1Vel.y;
					p.position.z = originalPos.z + k1Vel.z;
					
					originalVel = originalVelV[i];
					k1Force = k1ForceV[i];
					
					s = (0.5 * t / p.mass);
					k1Force.x *= s;
					k1Force.y *= s;
					k1Force.z *= s;
					p.velocity.x = originalVel.x + k1Force.x;
					p.velocity.y = originalVel.y + k1Force.y;
					p.velocity.z = originalVel.z + k1Force.z;
				}
			}
			
			particleSystem.applyForces();
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					k2ForceV[i].x = p.force.x;
					k2ForceV[i].y = p.force.y;
					k2ForceV[i].z = p.force.z;
					k2VelV[i].x = p.velocity.x;
					k2VelV[i].y = p.velocity.y;
					k2VelV[i].z = p.velocity.z;
				}
				
				p.force.x = 0;
				p.force.y = 0;
				p.force.z = 0;
			}
			
			/**
			 * Get initial position, K2 velocity
			 * apply forces and velocity, the result is K3
			 */
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					originalPos = originalPosV[i];
					k2Vel = k2VelV[i];
					
					s = (0.5 * t);
					k2Vel.x *= s;
					k2Vel.y *= s;
					k2Vel.z *= s;
					p.position.x = originalPos.x + k2Vel.x;
					p.position.y = originalPos.y + k2Vel.y;
					p.position.z = originalPos.z + k2Vel.z;
					
					originalVel = originalVelV[i];
					k2Force = k2ForceV[i];
					
					s = (0.5 * t / p.mass);
					k2Force.x *= s;
					k2Force.y *= s;
					k2Force.z *= s;
					p.velocity.x = originalVel.x + k2Force.x;
					p.velocity.y = originalVel.y + k2Force.y;
					p.velocity.z = originalVel.z + k2Force.z;
				}
			}
			
			particleSystem.applyForces();
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					k3ForceV[i].x = p.force.x;
					k3ForceV[i].y = p.force.y;
					k3ForceV[i].z = p.force.z;
					k3VelV[i].x = p.velocity.x;
					k3VelV[i].y = p.velocity.y;
					k3VelV[i].z = p.velocity.z;
				}
				
				p.force.x = 0;
				p.force.y = 0;
				p.force.z = 0;
			}
			
			/**
			 * Get initial position, K3 velocity
			 * apply forces and velocity, the result is K4
			 */
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					originalPos = originalPosV[i];
					k3Vel = k3VelV[i];
					
					s = (0.5 * t);
					k3Vel.x *= s;
					k3Vel.y *= s;
					k3Vel.z *= s;
					p.position.x = originalPos.x + k2Vel.x;
					p.position.y = originalPos.y + k2Vel.y;
					p.position.z = originalPos.z + k2Vel.z;
					
					originalVel = originalVelV[i];
					k3Force = k3ForceV[i];
					
					s = (0.5 * t / p.mass);
					k3Force.x *= s;
					k3Force.y *= s;
					k3Force.z *= s;
					p.velocity.x = originalVel.x + k3Force.x;
					p.velocity.y = originalVel.y + k3Force.y;
					p.velocity.z = originalVel.z + k3Force.z;
				}
			}
			
			particleSystem.applyForces();
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					k4ForceV[i].x = p.force.x;
					k4ForceV[i].y = p.force.y;
					k4ForceV[i].z = p.force.z;
					k4VelV[i].x = p.velocity.x;
					k4VelV[i].y = p.velocity.y;
					k4VelV[i].z = p.velocity.z;
				}
				
				p.force.x = 0;
				p.force.y = 0;
				p.force.z = 0;
			}
			
			/**
			 * Update initial position and velocity based on intermediate values
			 */
			
			for (i = 0; i < numPart; i++)
			{
				p = particles[i];
				
				if (!p.fixed)
				{
					//position
					
					originalPos = originalPosV[i];
					k1Vel = k1VelV[i];
					k2Vel = k2VelV[i];
					k3Vel = k3VelV[i];
					k4Vel = k4VelV[i];
					
//                var k2VelInt : Vector3D = k2Vel.clone();
					k2VelInt.x = k2Vel.x;
					k2VelInt.y = k2Vel.y;
					k2VelInt.z = k2Vel.z;
					s = (2);
					k2VelInt.x *= s;
					k2VelInt.y *= s;
					k2VelInt.z *= s;
//                var k3VelInt : Vector3D = k3Vel.clone();
					k3VelInt.x = k3Vel.x;
					k3VelInt.y = k3Vel.y;
					k3VelInt.z = k3Vel.z;
					s = (2);
					k3VelInt.x *= s;
					k3VelInt.y *= s;
					k3VelInt.z *= s;
					//var intVel : Vector3D = k1Vel.add(k2VelInt).add(k3VelInt).add(k4Vel);
					intVel.x = k1Vel.x + k2Vel.x + k3Vel.x + k4Vel.x;
					intVel.y = k1Vel.y + k2Vel.y + k3Vel.y + k4Vel.y;
					intVel.z = k1Vel.z + k2Vel.z + k3Vel.z + k4Vel.z;
					s = (t / 6);
					intVel.x *= s;
					intVel.y *= s;
					intVel.z *= s;
					p.position.x = originalPos.x + intVel.x;
					p.position.y = originalPos.y + intVel.y;
					p.position.z = originalPos.z + intVel.z;
					
					// velocity
					
					originalVel = originalVelV[i];
					k1Force = k1ForceV[i];
					k2Force = k2ForceV[i];
					k3Force = k3ForceV[i];
					k4Force = k4ForceV[i];
					
//                var k2ForceInt : Vector3D = k2Force.clone();
					k2ForceInt.x = k2Force.x;
					k2ForceInt.y = k2Force.y;
					k2ForceInt.z = k2Force.z;
					s = (2);
					k2ForceInt.x *= s;
					k2ForceInt.y *= s;
					k2ForceInt.z *= s;
//                var k3ForceInt : Vector3D = k3Force.clone();
					k3ForceInt.x = k3Force.x;
					k3ForceInt.y = k3Force.y;
					k3ForceInt.z = k3Force.z;
					s = (2);
					k3ForceInt.x *= s;
					k3ForceInt.y *= s;
					k3ForceInt.z *= s;
					//var intForce : Vector3D = k1Force.add(k2ForceInt).add(k3ForceInt).add(k4Force);
					intForce.x = k1Force.x + k2Force.x + k3Force.x + k4Force.x;
					intForce.y = k1Force.y + k2Force.y + k3Force.y + k4Force.y;
					intForce.z = k1Force.z + k2Force.z + k3Force.z + k4Force.z;
					s = (t / 6 * p.mass);
					intForce.x *= s;
					intForce.y *= s;
					intForce.z *= s;
					p.velocity.x = originalVel.x + intForce.x;
					p.velocity.y = originalVel.y + intForce.y;
					p.velocity.z = originalVel.z + intForce.z;
				}
			}
		}
	}
}