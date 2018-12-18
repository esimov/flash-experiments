package
{
	import com.esimov.Boid;
	import flash.geom.Vector3D;
	import com.esimov.TargetShape;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PredatorDemo extends AbstractDemo
	{
		private var _target:Vector3D = new Vector3D();
		private var _atTarget:Boolean = false;
		private var _randomBoid:Boid;
		
		private static const EASE:Number = 0.2;
		override protected function init():void
		{
			createBoids(_boid.numBoids);
			createPredators(4);
			_randomBoid = getRandomBoid(_boids);
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			boid.wander(0.3);
			boid.seek(boid.boundsCentre, 0.15);
			boid.evade(_predators, 80, 0.3);
			boid.flocking(_boids);
			
			boid.render();
			boid.update();
			super.updateBoids(boid, index); // Call the boid properties set in AbstractDemo
		}
		
		
		private function getRandomBoid(boids:Vector.<Boid>):Boid
		{
			var maxLenght:uint = boids.length;
			var index:uint = random(0, maxLenght);
			return _boids[index] as Boid;
		}
		
		
		override protected function updatePredators (predator:Boid, index:Number):void
		{
			var dist:Number = Vector3D.distance(predator.position, _randomBoid.position);
			
			if (predator.energy > 0)
			{
				predator.energy -= int(random(0, 5));
			}
			
			if (predator.energy < 0)
			{
				predator.energy = int(random(_predator.minEnergy, _predator.maxEnergy));
			}
			
			if (predator.energy < 20)
			{
				predator.arrive(_randomBoid.position, 50, 0.8);
				
				if (dist < _randomBoid.boundsRadius / 2)
				{
					predator.maxSpeed *= 0.999;
					predator.velocity.normalize();
					predator.velocity.scaleBy(predator.maxSpeed);
					predator.energy = int(random(_predator.minEnergy, _predator.maxEnergy));
				}		
			}
			else
			{
				if (_boids.length > 1)
				{
					_randomBoid = getRandomBoid(_boids); // seek for anathor boid if he reach the target
				}
				predator.velocity.normalize();
				predator.velocity.scaleBy(_predator.minEnergy);
			}
			
			predator.wander(0.1);
			
			predator.render();
			predator.update();
			super.updatePredators(predator, index); // Call the predator properties set in AbstractDemo
		}
	}
}