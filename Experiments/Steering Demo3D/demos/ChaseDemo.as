package
{
	import com.esimov.Boid;
	
	public class ChaseDemo extends AbstractDemo
	{
		override protected function init():void
		{
			createBoids(_boid.numBoids);
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			// if the index is greather than 0, than search the next boid
			if (index > 0)
			{
				boid.arrive(_boids[index - 1].position, 50, 0.9);
				
				if (index < _boids.length - 1)
				{
					boid.flee(_boids[index + 1].position, 60, 0.9);
				}
			}
			else
			{
				boid.arrive(boid.boundsCentre, 80);
			}
			boid.wander(0.2);
			boid.render();
			boid.update();
		}
	}
}