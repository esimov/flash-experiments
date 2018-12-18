package com.esimov
{
	import com.esimov.SteeredVehicle;
	import com.esimov.Vector2D;
	
	public class SteeredVehicle extends Vehicle
	{
		private var _maxForce:Number = 5;
		private var _stForce:Vector2D;
		private var _distTreshold:Number = 50;
		private var _closeDist:Number = 10;
		private var _wanderAngle:Number = 1;
		private var _wanderRange:Number = 1;
		private var _wanderRadius:Number = 3;
		private var _wanderDistance:Number = 4;
		private var _avoidDist:Number = 80;
		private var _offset:Number = 30;
		//private var _pathArray:Array = [];
		private var _pathIndex:Number = 0;
		private var _pathTreshold:Number = 10;
		private var _vehicleDist:Number = 20;
		private var _inSightDist:Number = 80;
		
		public function SteeredVehicle():void
		{
			_stForce = new Vector2D();
			super();
		}
		
		public function set maxForce(value:Number):void
		{
			_maxForce = value;
		}
		
		public function get maxForce():Number
		{
			return _maxForce;
		}
		
		public function set arriveTreshold(value:Number):void
		{
			_distTreshold = value;
		}
		
		public function get arriveTreshold():Number
		{
			return _distTreshold;
		}
		
		public function set wanderAngle(value:Number):void
		{
			_wanderAngle = value;
		}
		
		public function get wanderAngle():Number
		{
			return _wanderAngle;
		}
		
		public function set wanderRadius(value:Number):void
		{
			_wanderRadius = value;
		}
		
		public function get wanderRadius():Number
		{
			return _wanderRadius;
		}
		
		public function set wanderRange(value:Number):void
		{
			_wanderRange = value;
		}
		
		public function get wanderRange():Number
		{
			return _wanderRange;
		}
		
		public function set wanderDistance(value:Number):void
		{
			_wanderDistance = value;
		}
		
		public function get wanderDistance():Number
		{
			return _wanderDistance;
		}
		
		public function set closeDist(value:Number):void
		{
			_closeDist = value;
		}
		
		public function get closeDist():Number
		{
			return _closeDist;
		}
		
		
		override public function update():void
		{
			_stForce = _stForce.truncate(_maxForce);
			_stForce.normalize();
			_velocity = _velocity.add(_stForce);
			_stForce = new Vector2D();
			super.update();
		}
		
		public function seek(target:Vector2D):void
		{
			var desiredVelocity:Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			var force:Vector2D = desiredVelocity.subtract(_velocity);
			_stForce = _stForce.add(force);
		}
		
		public function flee(target:Vector2D):void
		{
			var desireVelocity:Vector2D = target.subtract(_position);
			desireVelocity.normalize();
			desireVelocity = desireVelocity.multiply(_maxSpeed);
			var force:Vector2D = desireVelocity.subtract(_velocity);
			_stForce = _stForce.subtract(force);
		}
		
		public function arrive(target:Vector2D):void
		{
			var desiredVelocity:Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			var dist:Number = _position.dist(target);
			if (dist > _distTreshold)
				desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			else
				desiredVelocity = desiredVelocity.multiply(_maxSpeed * dist / _distTreshold);
			var force:Vector2D = desiredVelocity.subtract(_velocity);
			_stForce = _stForce.add(force);
		}
		
		public function pursue(target:Vehicle):void
		{
			var timeAhead:Number = _position.dist(target.position) / _maxSpeed;
			var predict:Vector2D = target.position.add(target.velocity.multiply(timeAhead));
			this.seek(predict);
		}
		
		public function wander():void
		{
			var center:Vector2D = velocity.clone().normalize().multiply(_wanderDistance);
			var offset:Vector2D = new Vector2D();
			offset.angle = _wanderAngle;
			offset.length = _wanderRadius;
			_wanderAngle += _wanderRange - Math.random() * _wanderRange * 0.3;
			var force:Vector2D = center.add(offset);
			_stForce = _stForce.add(force);
		}
		
		public function avoid (objects:Array):void
		{
			for (var i:Number = 0; i < objects.length; i++)
			{
				var obj:Obstacle = objects[i] as Obstacle;
				var head:Vector2D = _velocity.clone().normalize();
				var diff:Vector2D = obj.position.subtract(_position);
				var dotProd:Number = diff.dotProd(head);
				
				if (dotProd > 0)
				{
					var feeler:Vector2D = head.multiply(_avoidDist);
					var projection:Vector2D = head.multiply(dotProd);
					var dist:Number = projection.subtract(diff).length;
					
					if (dist < obj.radius + _offset && projection.length < feeler.length)
					{
						var force:Vector2D = head.multiply(_maxSpeed);
						force.angle += diff.sign(_velocity) * Math.PI / 2;
						force = force.multiply(1.0 - projection.length / feeler.length);
						_stForce = _stForce.add(force);
						_velocity = _velocity.multiply(projection.length / feeler.length);
					}
				}
			}
		}
		
		public function pathFollow(_pathArray:Array, loop:Boolean = true):void
		{
			var point:Vector2D = _pathArray[_pathIndex] as Vector2D;
			if (_pathArray == null)
			return;
			if (_position.dist(point) < _pathTreshold)
			{
				if (_pathIndex >= _pathArray.length - 1)
				{
					if (loop)
					_pathIndex = 0;
				}
				else
				{
					_pathIndex ++;
				}
			}
			if (_pathIndex >= _pathArray.length - 1 && loop)
			{
				arrive(point);
			}
			else
				seek(point);
		}
		
		public function flock(vehicles:Array):void
		{
			var avgVelocity:Vector2D = _velocity.clone().normalize();
			var avgPosition:Vector2D = new Vector2D();
			var inSightCount:Number = 0;
			
			for (var i:Number = 0; i< vehicles.length; i++)
			{
				var vehicle:Vehicle = vehicles[i] as SteeredVehicle;
				if (vehicle != this && inSight(vehicle))
				{
					avgVelocity = avgVelocity.add(vehicle.velocity);
					avgPosition = avgPosition.add(vehicle.position);
					if (tooClose(vehicle)) flee(vehicle.position);
					inSightCount ++;
				}
			}
			
			if (inSightCount > 0)
			{
				avgVelocity = _velocity.divide(inSightCount);
				avgPosition = _position.divide(inSightCount);
				seek(avgPosition);
				_stForce.add(avgVelocity.subtract(_velocity));
			}
		}
		
		public function tooClose(vehicle:Vehicle):Boolean
		{
			return _position.dist(vehicle.position) < _vehicleDist;
		}
		
		private function inSight(vehicle:Vehicle):Boolean
		{
			if (_position.dist(vehicle.position) > _inSightDist) return false;
			var head:Vector2D = _velocity.clone().normalize();
			var diff:Vector2D = _velocity.subtract(head);
			var dotProd:Number = diff.dotProd(head);
			if (dotProd < 0) return false;
			return true;
		}
	}
}