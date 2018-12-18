package esimov.physics 
{
	import flash.geom.Vector3D;

	/**
	 * @author simoe
	 */
	public class VerletIntegrator implements Integrator
	{
		private var particleSystem:ParticleSystem;
		
		public function VerletIntegrator(particleSystem:ParticleSystem):void
		{
			this.particleSystem = particleSystem;
		}
		
		/* INTERFACE esimov.physics.Integrator */
		
		public function apply(t:Number):void
		{
			var velocity:Vector3D = new Vector3D();
			var lastPos:Vector3D = new Vector3D();
			
			var particles:Vector.<Particle> = particleSystem.particles;
			var numParticles:Number = particles.length;
			
			//particleSystem.clearForces();
			particleSystem.applyForces();
			
			for (var i:int = 0; i< numParticles; i++)
			{
				var particle:Particle = particles[i];
				
				if (! particle.fixed)
				{
					//get acceleration (F = ma);
					var ax:Number = particle.force.x / particle.mass;
					var ay:Number = particle.force.y / particle.mass;
					var az:Number = particle.force.z / particle.mass;
					
					lastPos = particle.position;
					velocity.x = particle.position.x - lastPos.x;
					velocity.y = particle.position.y - lastPos.y;
					velocity.z = particle.position.z - lastPos.z;
					
					particle.position.x += velocity.x + 0.5 * ax * t *t;
					particle.position.y += velocity.y + 0.5 * ay * t *t;
					particle.position.z += velocity.z + 0.5 * az * t *t;
					
					lastPos.x = particle.position.x;
					lastPos.y = particle.position.y;
					lastPos.z = particle.position.z;
				
				}
			}
		}
	}
}
