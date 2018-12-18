package com.esimov
{
	import flash.display.Sprite;
	
	public class Vehicle extends Sprite
	{
		protected var _edgeBehavior:String = BOUNCE;
		protected var _velocity:Vector2D;
		protected var _position:Vector2D;
		protected var _maxSpeed:Number = 20;
		protected var _mass:Number = 1;
		
		private static const WRAP:String = "wrap";
		private static const BOUNCE:String = "bounce";
		
		public function Vehicle():void
		{
			_position = new Vector2D();
			_velocity = new Vector2D();
			draw();
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.beginFill(0x999999, 1);
			graphics.lineStyle(1, 0x00);
			graphics.moveTo(8, 0);
			graphics.lineTo(-8, 4);
			graphics.lineTo(-8, -4);
			graphics.lineTo(8, 0);
			graphics.endFill();
		}
		
		public function update():void
		{
			_position = _position.add(_velocity);
			if (_edgeBehavior == WRAP)
			{
				wrap();
			} else if (_edgeBehavior == BOUNCE)
				bounce();
			x = position.x;
			y = position.y;
			rotation = _velocity.angle * 180/Math.PI;
		}
		
		private function wrap():void
		{
			if (stage != null)
			{
				if (position.x > stage.stageWidth) position.x = 0;
				if (position.x < 0) position.x = stage.stageWidth;
				if (position.y > stage.stageWidth) position.y = 0;
				if (position.y < 0) position.y = stage.stageWidth;
			}
		}
		
		private function bounce():void
		{
			if (stage != null)
			{
				if (position.x > stage.stageWidth)
				{
					position.x = stage.stageWidth;
					velocity.x *= -1;
				}
				if (position.y > stage.stageHeight)
				{
					position.y = stage.stageHeight;
					velocity.y *= -1;
				}
				if (position.x < 0)
				{
					position.x = 0;
					velocity.x *= -1;
				}
				if (position.y < 0)
				{
					position.y = 0;
					velocity.y *= -1;
				}
			}
		}
		
		public function set edgeBehavior(value:String):void
		{
			_edgeBehavior = value;
		}
		
		public function get edgeBehavior():String
		{
			return _edgeBehavior;
		}
		
		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
		}
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set position(value:Vector2D):void
		{
			_position = value;
			x = _position.x;
			y = _position.y;
		}
		
		public function get position():Vector2D
		{
			return _position;
		}
		
		public function set velocity(value:Vector2D):void
		{
			_velocity = value;
			x = _velocity.x;
			y = _velocity.y;
		}
		
		public function get velocity():Vector2D
		{
			return _velocity;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			_position.x = x;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			_position.y = y;
		}
	}
}