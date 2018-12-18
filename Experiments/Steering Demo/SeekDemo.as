package
{
	import com.esimov.Boid;
	import com.esimov.TargetShape;
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	public class SeekDemo extends AbstractDemo
	{
		private var _target:Vector3D = new Vector3D();
		private var _targetShape:TargetShape = new TargetShape();
		
		private static const EASE:Number = 0.1;
		
		override protected function init():void
		{
			_targetShape.x = 300;
			_targetShape.y = 300;
			addChild(_targetShape);
			createBoids(_boid.numBoids);
			addEventListener(Event.ENTER_FRAME, start);
		}
		
		private function start(e:Event):void
		{
			easeTarget();
		}
		
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			// Add some wander to keep things interesting
			boid.wander(0.5);
			boid.arrive(_target, 200, 0.4);
			
			//update the boid then render it
			boid.update();
			boid.render();
		}
		
		private function easeTarget():void
		{
			var dx:Number = mouseX - _targetShape.x;
			var dy:Number = mouseY - _targetShape.y;
			
			_targetShape.vx = dx * EASE;
			_targetShape.vy = dy * EASE;
			_targetShape.x += _targetShape.vx;
			_targetShape.y += _targetShape.vy;
			
			_target.x = _targetShape.x;
			_target.y = _targetShape.y;
			_target.z = _targetShape.z;
		}
	}
}