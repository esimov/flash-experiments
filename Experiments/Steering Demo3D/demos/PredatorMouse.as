package
{
	import com.esimov.Boid;
	import flash.geom.Vector3D;
	import com.esimov.TargetShape;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PredatorMouse extends AbstractDemo
	{
		private var _target:Vector3D = new Vector3D();
		private var _targetShape:TargetShape = new TargetShape();
		private var _atTarget:Boolean = false;
		
		private static const EASE:Number = 0.2;
		override protected function init():void
		{
			_targetShape.x = 300;
			_targetShape.y = 300;
			addChild(_targetShape);
			createBoids(100);
			
			addEventListener(Event.ENTER_FRAME, start);
		}
		
		private function start(e:Event):void
		{
			_targetShape.visible = true;
			easeTarget();
			if (mouseY > _panelHolder.y)
			{
				_targetShape.visible = false;
			}
		}
			
		override protected function updateBoids (boid:Boid, index:Number):void
		{
			boid.wander(0.3);
			boid.seek(boid.boundsCentre, 0.15);
			boid.flee(_target, 100, 20);
			boid.evade(_predators, 80, 0.3);
			boid.flocking(_boids);
			
			boid.render();
			boid.update();
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
			//_target.z = _targetShape.globalToLocal3D(new Point(this.x, this.y)).z;
		}
	}
}