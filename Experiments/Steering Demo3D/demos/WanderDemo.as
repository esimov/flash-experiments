package
{
	import com.esimov.Boid;
	
	public class WanderDemo extends AbstractDemo
	{
		override protected function init():void
		{
			createBoids(_boid.numBoids);
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			// Add some wander to keep things interesting
			boid.wander();
			
			//update the boid then render it
			boid.update();
			boid.render();
		}
	}
}