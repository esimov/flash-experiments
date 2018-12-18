package
{
	import com.esimov.Boid;
	
	public class FlockDemo extends AbstractDemo
	{
		override protected function init():void
		{
			createBoids(_boid.numBoids);
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			// Add some wander to keep things interesting
			boid.wander(0.3);
			
			// Add a mild attraction to the centre to keep them on screen
			boid.seek(boid.boundsCentre, 0.1);
			
			// Flock
			boid.flocking(_boids);
			
			boid.update();
			boid.render();
			
			super.updateBoids(boid, index); // Call the boid properties set in AbstractDemo
		}
	}
}