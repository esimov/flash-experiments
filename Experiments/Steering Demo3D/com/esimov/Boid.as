package com.esimov
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import flash.geom.Matrix;
	import flash.system.LoaderContext;

	public class Boid
	{
		//______________PUBLIC CONST______________
		
		public static const EDGE_BOUNCE:String = "bounce";
		public static const EDGE_WRAP:String = "wrap";
		public static const EDGE_NONE:String = "none";
		public static const ZERO:Vector3D = new Vector3D(0, 0, 0);
		
		
		//______________PRIVATE VARS_____________
		
		private var _maxSpeed:Number;
		private var _maxSpeedSQ:Number;
		private var _maxForce:Number;
		private var _maxForceSQ:Number;
		private var _matrix:Matrix3D;
		private var _distance:Number;
		private var _wanderStep:Number = 0.12;
		private var _wanderDistance:Number = 20;
		private var _wanderRadius:Number = 10;
		private var _boundsCentre:Vector3D = new Vector3D();
		private var _boundsRadius:Number;
		private var _radius:Number;
		private var _position:Vector3D;
		private var _oldPosition:Vector3D;
		private var _velocity:Vector3D;
		private var _renderData:DisplayObject;
		private var _screenCoord:Point;
		private var _lookAtTarget:Boolean;
		private var _acceleration:Vector3D;
		private var _steeringForce:Vector3D;
		private var _edgeBehavior:String;
		private var _drawScale:Number;
		private var _wanderTheta:Number = 0;
		private var _bitmapData:BitmapData;
		private var _energy:Number;
		
		/*************************************
		/*					SETTERS, GETTERS *
		/*************************************
		
		
		/**
		 * Position of the boid in 3D Space
		*/
		
		public function get position():Vector3D
		{
			return _position;
		}
		
		public function set position(value:Vector3D):void
		{
			_position = value;
		}
		
		/**
		 * Velocity of the boid in 3D Space
		*/
		
		public function get velocity():Vector3D
		{
			return _velocity;
		}
		
		public function set velocity (value:Vector3D):void
		{
			_velocity = value;
		}
		
		/**
		 * The position of the Boid along the x axis
		 */

		public function get x() : Number
		{
			return _position.x;
		}

		public function set x( value : Number ) : void
		{
			_position.x = value;
		}

		/**
		 * The position of the Boid along the y axis
		 */

		public function get y() : Number
		{
			return _position.y;
		}

		public function set y( value : Number ) : void
		{
			_position.y = value;
		}

		/**
		 * The position of the Boid along the z axis
		 */

		public function get z() : Number
		{
			return _position.z;
		}

		public function set z( value : Number ) : void
		{
			_position.z = value;
		}
		
		/**
		 * Set and gets the maximum speed that the boid can travel with in 3D Space
		*/
		
		public function set maxSpeed (value:Number):void
		{
			if (value < 0)
			{
				value = 0;
			}
			_maxSpeed = value;
			_maxSpeedSQ = value * value;
		}
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		/**
		 * Set and gets the maximum force available to the boid 
		 * after the steering force has been applied
		*/
		
		public function set maxForce (value:Number):void
		{
			if (value < 0)
			{
				value = 0;
			}
			
			_maxForce = value;
			_maxForceSQ = value * value;
		}
		
		public function get maxForce():Number
		{
			return _maxForce;
		}
		
		/**
		 * Set and gets the maximum energy for predators 
		 * in pursue of boids
		*/
		
		public function set energy (value: int):void
		{
			_energy = value;
		}
		
		public function get energy ():int
		{
			return _energy;
		}
		
		/**
		 * Return the screen cordinates in 2D Space 
		 * after the transformation has been applied
		*/
		
		public function get screenCoord():Point
		{
			transformScreenCoord();
			return _screenCoord;
		}
		
		/**
		 * The centre point of the bounds.
		 * If the boid move further than the center point plus radius
		 * from this point the specified edge behavoir will take place
		*/
		
		public function set boundsCentre (value:Vector3D):void
		{
			_boundsCentre = value;
		}
		
		public function get boundsCentre():Vector3D
		{
			return _boundsCentre;
		}
		
		/**
		 * Tha maximum radius the boid can travel
		*/
		
		public function set boundsRadius (value:Number):void
		{
			_boundsRadius = value
		}
		
		public function get boundsRadius ():Number
		{
			return _boundsRadius;
		}
		
		public function set wanderDistance (value:Number):void
		{
			_wanderDistance = value;
		}
		
		public function get wanderDistance():Number
		{
			return _wanderDistance;
		}
		
		public function set wanderRadius (value:Number):void
		{
			_wanderRadius = value;
		}
				
		public function set wanderStep (value:Number):void
		{
			_wanderStep = value;
		}
		
		public function get wanderStep():Number
		{
			return _wanderStep;
		}
		
		/**
		 * Sets and gets the edge behavior of the boid 
		 * after reach the boundaries of the stage
		*/
		
		public function set edgeBehavior (value : String):void
		{
			if (value != EDGE_WRAP && value != EDGE_BOUNCE && value != EDGE_NONE)
			{
				_edgeBehavior = EDGE_NONE
			}
			else
			{
				_edgeBehavior = value;
			}
		}
		
		public function get edgeBehavior():String
		{
			return _edgeBehavior;
		}
		
		
		/**
		 * The DisplayObject to render the boid
		*/
		
		public function set renderData (value:DisplayObject):void
		{
			_renderData = value;
			
			if (_renderData.width > _renderData.height)
			{
				_radius = _renderData.width;
			}
			else
			{
				_radius = _renderData.height;
			}
			
			if (!_matrix)
			{
				_matrix = new Matrix3D();
			}
		}
		
		public function get renderData ():DisplayObject
		{
			return _renderData;
		}
		
		/**
		 * If the @param value is true, the boid head 
		 * will face the direction in which is traveling
		*/
		
		public function set lookAtTarget (value:Boolean):void
		{
			_lookAtTarget = value;
		}
		
		public function get lookAtTarget():Boolean
		{
			return _lookAtTarget;
		}
		
		
		
		/*************************************
		/*						  CONTRUCTOR *
		/************************************/
		
		public function Boid (maxForce:Number = 4, maxSpeed:Number = 10, edgeBehavior:String = Boid.EDGE_BOUNCE):void
		{
			this.maxForce = maxForce;
			this.maxSpeed = maxSpeed;
			this.edgeBehavior = edgeBehavior;
			
			reset();
		}
		
		
		/*************************************
		/*							 METHODS *
		/************************************/
		
		public function createBoidShape(color:uint = 0x00, size:Number = 8, scale:Number = 1.0):Shape
		{
			_drawScale = 1 / scale;
			var shape:Shape = new Shape();
			var w:Number = size * scale;
			var h:Number = w * 0.55;
			
			shape.graphics.beginFill(color, 1);
			shape.graphics.moveTo(-w, -h);
			shape.graphics.lineTo(w, 0);
			shape.graphics.lineTo(-w, h);
			shape.graphics.lineTo(-w, -h);
			shape.graphics.endFill();
			
			return shape;
		}
		
		public function createPredatorShape(size:Number = 10, scale:Number = 1.0):Shape
		{
			_bitmapData = new BitmapData(100, 100, true, 0x00);
			loadBmp("assets/camouflage.png");
			var matrix:Matrix = new Matrix();
			var scaleFactorX:Number = 0;
			var scaleFactorY:Number = 0;
			
			var shape:Shape = new Shape();
			_drawScale = 1 / scale;
			var w:Number = size * scale;
			var h:Number = w * 0.42;
			var g:Graphics = shape.graphics;
			
			if (scale < _bitmapData.width)
			{
				scaleFactorX = Math.abs(scale / _bitmapData.width);
			}
			
			else
			{
				scaleFactorX = Math.abs (_bitmapData.width / scale);
			}
			
			if (scale < _bitmapData.height)
			{
				scaleFactorY = Math.abs(scale / _bitmapData.height);
			}
			
			else
			{
				scaleFactorY = Math.abs (_bitmapData.height / scale);
			}
			
			matrix.scale(scaleFactorX, scaleFactorY);
			
			//shape.graphics.beginBitmapFill(_bitmapData, matrix);
			shape.graphics.beginFill(0x00);
			shape.graphics.moveTo(-w, -h);
			shape.graphics.lineTo(w, 0);
			shape.graphics.lineTo(-w, h);
			shape.graphics.lineTo(-w, -h);
			shape.graphics.endFill();
			
			return shape;
		}
		
		private function loadBmp(url:String = null):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteEvent);
			loader.load(new URLRequest(url), new LoaderContext(true));
		}
		
		private function onCompleteEvent (e:Event):void
		{
			var content: DisplayObject = (e.target as LoaderInfo).content;
			_bitmapData = (content as Bitmap).bitmapData;
			clearLoader(e.target as LoaderInfo);
		}
		
		private function IOErrorHandler (e:IOErrorEvent):void
		{
			clearLoader(e.target as LoaderInfo);
		}
		
		private function clearLoader (loaderInfo:LoaderInfo):void
		{
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			loaderInfo.removeEventListener(Event.COMPLETE, onCompleteEvent);
		}
		
		/**
		 * Updates the DisplayObject used as the Boid's renderData 
		 * by setting the Matrix3D of it's transform property. If 
		 * lookAtTarget is set to true, the DisplayObject will also 
		 * be rotated in order to face the Boids velocity vector
		 */
		 
		public function render(): void
		{
			if (!_renderData || !_renderData.stage  || !_renderData.visible)
			{
				return;
			}
			
			_matrix.identity();
			
			if (_drawScale != 1.0)
			{
				_matrix.appendScale(_drawScale, _drawScale, _drawScale);
			}
			
			if (_lookAtTarget)
			{
				_matrix.pointAt(velocity, Vector3D.X_AXIS, Vector3D.Y_AXIS);
			}
			_matrix.appendTranslation(_position.x, _position.y, _position.z);
			_renderData.transform.matrix3D = _matrix;
		}
		
		/**
		 * Updates the position of the boid
		 */
		
		public function update():void
		{
			_oldPosition.x = _position.x;
			_oldPosition.y = _position.y;
			_oldPosition.z = _position.z;
			
			_velocity.incrementBy(_acceleration);
			
			if (_velocity.lengthSquared > _maxSpeedSQ)
			{
				_velocity.normalize();
				_velocity.scaleBy(_maxSpeed);
			}
			
			_position.incrementBy(_velocity);
			
			_acceleration.x = 0;
			_acceleration.y = 0;
			_acceleration.z = 0;
			
			if (!_oldPosition.equals(_position))
			{
				var distance:Number = Vector3D.distance(_position, _boundsCentre);
				if (distance > _boundsRadius + _radius)
				{
					switch (_edgeBehavior)
					{
						case EDGE_BOUNCE:
							_position.decrementBy(_boundsCentre);
							_position.normalize();
							_position.scaleBy(_boundsRadius + _radius);
							
							_velocity.scaleBy(-1);
							_position.incrementBy(_velocity);
							_position.incrementBy(_boundsCentre);

							break;
						
						case EDGE_WRAP:
							_position.decrementBy(_boundsCentre);
							_position.negate();
							_position.incrementBy(_boundsCentre);
							
							break;
						
						case EDGE_NONE:
							break;
					}
				}
			}
		}
		
		/**
		 * Reset the boids parameters
		*/
		
		public function reset():void
		{
			_position = new Vector3D();
			_velocity = new Vector3D();
			_oldPosition = new Vector3D();
			_acceleration = new Vector3D();
			_steeringForce = new Vector3D();
			_screenCoord = new Point();
		}
		
		public function constrainToRect (rect:Rectangle, behavior:String = EDGE_BOUNCE, zMin:Number = NaN, zMax:Number = NaN):void
		{
			if (!_renderData || !_renderData.stage || _renderData.visible)
			{
				return;
			}
			
			transformScreenCoord();
			
			if (_screenCoord.x > rect.right - _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_screenCoord.x = rect.right;
						_renderData.transform.matrix3D.identity();
						_position.x = _renderData.globalToLocal(_screenCoord).x;
						_velocity.x *= -1;
						
						break;
					
					case EDGE_WRAP:
						_screenCoord.x = rect.left;
						_renderData.transform.matrix3D.identity();
						_position.x = _renderData.globalToLocal(_screenCoord).x;
						
						break;
						
					case EDGE_NONE:
						break;
				}
			}
			
			if (_screenCoord.x < rect.left + _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_screenCoord.x = rect.left;
						_renderData.transform.matrix3D.identity();
						_position.x = _renderData.globalToLocal(_screenCoord).x;
						_velocity.x *= -1;
						
						break;
					
					case EDGE_WRAP:
						_screenCoord.x = rect.right;
						_renderData.transform.matrix3D.identity();
						_position.x = _renderData.globalToLocal(_screenCoord).x;
						
						break;
						
					case EDGE_NONE:
						break;
				}
			}
			
			if (_screenCoord.y > rect.bottom - _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_screenCoord.y = rect.bottom;
						_renderData.transform.matrix3D.identity();
						_position.y = _renderData.globalToLocal(_screenCoord).y;
						_velocity.y *= -1;
						
						break;
					
					case EDGE_WRAP:
						_screenCoord.y = rect.top;
						_renderData.transform.matrix3D.identity();
						_position.y = _renderData.globalToLocal(_screenCoord).y;
						
						break;
						
					case EDGE_NONE:
						break;
				}
			}
			
			if (_screenCoord.y < rect.top + _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_screenCoord.y = rect.top;
						_renderData.transform.matrix3D.identity();
						_position.y = _renderData.globalToLocal(_screenCoord).y;
						_velocity.y *= -1;
						
						break;
					
					case EDGE_WRAP:
						_screenCoord.y = rect.bottom;
						_renderData.transform.matrix3D.identity();
						_position.y = _renderData.globalToLocal(_screenCoord).y;
						
						break;
						
					case EDGE_NONE:
						break;
				}
			}
			
			if (isNaN(zMin) || isNaN(zMax))
			{
				return;
			}
			
			if (_position.z < zMin + _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_position.z = zMin;
						_velocity.z *= -1;
						
						break;
					
					case EDGE_WRAP:
						_position.z = zMax;
						break;
				}
			}
			
			if (_position.z > zMax + _radius)
			{
				switch (behavior)
				{
					case EDGE_BOUNCE:
						_position.z = zMax;
						_velocity.z *= -1;
						
						break;
					
					case EDGE_WRAP:
						_position.z = zMin;
						break;
				}
			}
		}
		
		/**
		 * Adjust the steering behavior of the boid in corelation with 
		 * the easing parameter.
		 *
		 * @param	target 
		 * The target vector the steering force is applied for
		 *
		 * @param ease
		 * If set to true the boid will ease it's velocity within the easeDistance
		 *
		 * @param easeDistance
		 * The distance within the boid will reduce it's velocity
		 */
		
		public function steer (target:Vector3D, easing:Boolean = false, easeDistance:Number = 100):Vector3D
		{
			_steeringForce = target.clone();
			_steeringForce.decrementBy(_position); 
			_distance = _steeringForce.normalize();
			
			if (_distance > 0.0001)
			{
				if (_distance < easeDistance && easing)
				{
					_steeringForce.scaleBy(_maxSpeed * (_distance / easeDistance));
				}
				else
				{
					_steeringForce.scaleBy(_maxSpeed);
				}
				
				_steeringForce.decrementBy(_velocity);
				
				if (_steeringForce.lengthSquared > _maxSpeedSQ)
				{
					_steeringForce.normalize();
					_steeringForce.scaleBy(_maxForce);
				}
			}
			
			return _steeringForce;
		}
		
		/**
		 * Apply the braking force to the boid
		 *
		 * @param	brakingForce 
		 * If the brakingForce = 0, no braking force will be applied.
		 */
		 
		public function brake (brakingForce:Number = 0.01):void
		{
			_velocity.scaleBy(1 - brakingForce);
		}
		
		/**
		 * Seek the Boid toward the specified target
		 *
		 * @param	multiplier
		 * By multiplying the force generated by the boid a more or less
		 * force will be applied to the target. A multiplier > 1.0 will cause
		 * a much aggresive steering force, and a multiplier < 1.0 will cause
		 * a less agressive sterring force
		 */
		 
		public function seek (target:Vector3D, multiplier:Number = 1.0):void
		{
			_steeringForce = steer(target, false);
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		/**
		 * Seeks the Boid towards the specified target and 
		 * applies a deceleration force as the Boid arrives
		 */
		
		public function arrive (target:Vector3D, easeDistance:Number = 100, multiplier:Number = 1.0):void
		{
			_steeringForce = steer(target, true, easeDistance);
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		/**
		 * If distance is within a certain range the boid
		 * will try to change it's path to avoid a collision
		 * with it's neighbor.
		 *
		 * @param	target
		 * The target for the boid to avoid
		 *
		 * @param	minDistance
		 * If the distance between the Boid and the target position 
		 * is greater than this value, the Boid will ignore the 
		 * target and it's steering force will be unchanged
		 */
		
		public function flee (target:Vector3D, minDistance:Number = 100, multiplier:Number = 1.0):void
		{
			_distance = Vector3D.distance(target, _position);
			
			if (_distance < minDistance)
			{
				_steeringForce = steer(target, true, -minDistance);
			}
			else
			{
				return;
			}
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_steeringForce.negate();
			_acceleration.incrementBy(_steeringForce);
		}
		
		
		/**
		 * If boids are within a certain range from predators,
		 * they try to escape
		 *
		 * @param	target
		 * The target for the boid to avoid
		 *
		 * @param	minDistance
		 * If the distance between the Boid and the target position 
		 * is greater than this value, the Boid will ignore the 
		 * target and it's steering force will be unchanged
		 */
		 
		public function evade (predators:Vector.<Boid>, minDistance:Number = 100, multiplier:Number = 1.0):void
		{
			for (var i:int = 0; i < predators.length; i++)
			{
				_distance = Vector3D.distance(_position, predators[i].position);
				
				if (_distance < minDistance)
				{
					_steeringForce = steer(predators[i].position, true, 80);
				}
				
				if (multiplier != 1.0)
				{
					_steeringForce.scaleBy(multiplier);
				}
				
				_steeringForce.negate();
				_acceleration.incrementBy(_steeringForce);
			}
		}
		
		/**
		 * Generates a random wandering force for the Boid. 
		 * The results of this method can be controlled by the 
		 * _wanderDistance, _wanderStep and _wanderRadius parameters
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */
		
		public function wander (multiplier:Number = 1.0):void
		{
			_wanderTheta += Math.random() * _wanderStep;
			
			if ( Math.random() < 0.5 )
			{
				_wanderTheta = -_wanderTheta;
			}
			
			var wanderPos:Vector3D = _velocity.clone();
			wanderPos.normalize();
			wanderPos.scaleBy(_wanderDistance);
			wanderPos.incrementBy(_position);
			
			var offset:Vector3D = new Vector3D();
			offset.x = Math.cos(_wanderTheta) * _wanderRadius;
			offset.y = Math.sin(_wanderTheta) * _wanderRadius;
			offset.z = Math.tan(_wanderTheta) * _wanderRadius;
			
			_steeringForce = steer(wanderPos.add(offset));
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		/**
		 * Use this method to simulate flocking movement in a 
		 * group of Boids. Flock will combine the separate, 
		 * align and cohesion steering behaviors to produce 
		 * the flocking effect. Adjusting the weighting of each 
		 * behavior, as well as the distance values for each 
		 * can produce distinctly different flocking behaviors 
		 */
		 
		public function flocking (boids:Vector.<Boid>, sepDist:Number = 60, sepWeight:Number = 0.45, 
								  cohesionDist:Number = 50, cohesionWeight:Number = 0.22, 
								  alignDist:Number = 50, alignWeight:Number = 0.5, multiplier:Number = 1.0):void
		{
			separation (boids, sepDist, sepWeight);
			cohesion (boids, cohesionDist, cohesionWeight);
			alignment (boids, alignDist, alignWeight);
		}
		
		//_________________________________Separation
		
		public function separation (boids:Vector.<Boid>, separationDist:Number = 50, multiplier:Number = 1.0):void
		{
			_steeringForce = getSeparation(boids, separationDist);
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		//_________________________________Cohesion
		
		public function cohesion (boids:Vector.<Boid>, cohesionDist:Number = 10, multiplier:Number = 1.0):void
		{
			_steeringForce = getCohesion(boids, cohesionDist);
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		//_________________________________Alignment
		
		public function alignment (boids:Vector.<Boid>, alignDist:Number = 20, multiplier:Number = 1.0):void
		{
			_steeringForce = getAlignment(boids, alignDist);
			
			if (multiplier != 1.0)
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}
		
		
		
		public function getSeparation (boids:Vector.<Boid>, separationDist:Number = 25):Vector3D
		{
			var force:Vector3D = new Vector3D();
			var difference:Vector3D;
			var dist:Number;
			var boid: Boid;
			var count:Number = 0;
			
			for (var i:int = 0; i< boids.length; i++)
			{
				boid = boids[i];
				dist = Vector3D.distance(_position, boid.position);
				// subtract the position of the actual boid form postion of the neighbor boid
				if (dist > 0 && dist < separationDist)
				{
					difference = _position.subtract(boid.position);
					difference.normalize();
					// get the avarage position of the actual boid in relation with the neighbors
					difference.scaleBy(1 / dist);
					
					force.incrementBy(difference);
					
					count ++;
				}
			}
			
			if (count > 0)
			{
				force.scaleBy( 1 / count);
			}
			
			return force;
		}
		
		public function getCohesion (boids:Vector.<Boid>, cohesionDist:Number = 10):Vector3D
		{
			var boid: Boid;
			var dist:Number;
			var force:Vector3D = new Vector3D();
			var count:Number = 0;
			
			for (var i:int = 0; i < boids.length; i++)
			{
				boid = boids[i];
				dist = Vector3D.distance(_position, boid.position);
				
				if (dist > 0 && dist < cohesionDist)
				{
					force.incrementBy(boid.position);
					count ++;
				}
			}
			
			if (count > 0)
			{
				force.scaleBy(1 / count);
				force = steer(force);
			}
			
			return force;
		}
		
		public function getAlignment (boids:Vector.<Boid>, alignmentDist:Number = 10):Vector3D
		{
			var boid: Boid;
			var force:Vector3D = new Vector3D;
			var count:Number = 0;
			var dist:Number;
			
			for (var i:int = 0; i< boids.length; i++)
			{
				boid = boids[i];
				dist = Vector3D.distance(_position, boid.position);
				
				if (dist > 0 && dist < alignmentDist)
				{
					force.incrementBy(boid.velocity);
				}
				count ++;
			}
			
			if (count > 0)
			{
				force.scaleBy(1 / count);
				
				if (force.lengthSquared > _maxForceSQ)
				{
					force.normalize();
					force.scaleBy(_maxForce);
				}
			}
			
			return force;
		}
		
		/**
		 * Transform the 3D coordinate space to the 
		 * screen 2D coordinate space
		 */
		
		private function transformScreenCoord():void
		{
			if (!_oldPosition.equals(_position))
			{
				_screenCoord = _renderData.local3DToGlobal(ZERO);
			}
		}
	}
}