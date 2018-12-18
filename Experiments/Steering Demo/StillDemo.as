package
{
	import com.esimov.Boid;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	
	public class StillDemo extends AbstractDemo
	{
		private var _stageClicked:Boolean = false;
		
		override protected function init():void
		{
			createBoids(_boid.numBoids);
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			if (_stageClicked)
			{
				if (boid.maxSpeed > 0.009)
				{
					boid.brake(0.99);
					//boid.velocity.);
				}
				else
				{
					return;
				}
					boid.render();
					boid.update();
			}
			else
			{
				boid.wander(0.2);
				boid.seek(boid.boundsCentre, 0.1);
				boid.flocking(_boids);
				boid.update();
				boid.render();
			}
				
				stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function get maxForce():Number
		{
			return _boid.maxForce;
		}
		
		private function get maxSpeed():Number
		{
			return _boid.maxSpeed;
		}
		
		private function get getValue():Number
		{
			var value:Number = getTimer();
			return value;
		}
		
		private function onStageClick (e:MouseEvent):void
		{
			_stageClicked = true;
		}
	}
}