package
{
	import flash.display.DisplayObject;
	import com.esimov.Boid;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	public class AbstractDemo extends Sprite
	{
		private static const PANEL_HEIGHT:Number = 150;
		private static const OFFSET_Y:Number = 25;
		protected var _boids:Vector.<Boid> = new Vector.<Boid>();
		protected var _predators:Vector.<Boid> = new Vector.<Boid>();
		
		protected var _boid:Object = {	 maxWanderDist: 200.0,
										 minWanderDist: 5.0,
										 minWanderRadius: 1.0,
										 maxWanderRadius: 100.0,
										 minWanderStep: 0.1,
										 maxWanderStep: 5.0,
										 numBoids: 100,
										 minForce: 0.1,
										 maxForce: 5.0,
										 minSpeed: 0.5,
										 maxSpeed: 20.0
										}
		protected var _predator:Object = { maxWanderDist: 80,
										 minWanderDist: 10,
										 minWanderRadius: 8.0,
										 maxWanderRadius: 25.0,
										 minWanderStep: 0.1,
										 maxWanderStep: 0.9,
										 boundsRadius: 120,
										 minForce: 1.0,
										 maxForce: 10.0,
										 minSpeed: 4.0,
										 maxSpeed: 24.0,
										 minEnergy: 9.0,
										 maxEnergy: 40.0
										}

		private var _mouseOver:Boolean = false;
		private var _lookAtTarget:Boolean = false;
		private var _tween:Tween;
		private var LABEL_X_CONST:Number = 100;
		private var LABEL_Y_CONST:Number = 20;
		
		protected var _minForce:HUISlider;
		protected var _maxForce:HUISlider;
		protected var _minSpeed:HUISlider;
		protected var _maxSpeed:HUISlider;
		protected var _minWanderDist:HUISlider;
		protected var _maxWanderDist:HUISlider;
		protected var _minWanderRadius:HUISlider;
		protected var _maxWanderRadius:HUISlider;
		protected var _minWanderStep:HUISlider;
		protected var _maxWanderStep:HUISlider;
		protected var _maxBoids:HUISlider;
		protected var _boundingRadius:HUISlider;
		protected var _predMinForce:HUISlider;
		protected var _predMaxForce:HUISlider;
		protected var _faceTarget:CheckBox;
		protected var _restoreBtn:PushButton;
		
		protected var _flockBt:RadioButton;
		protected var _wanderBt:RadioButton;
		protected var _seekBt:RadioButton;
		protected var _chaseBt:RadioButton;
		protected var _predatorBt:RadioButton;
		protected var _mouseBt:RadioButton;
		protected var _noneBt:RadioButton;
		
		protected var _boidHolder:Sprite = new Sprite();
		protected var _panelHolder:Sprite = new Sprite();
		protected var _panelDesk:Panel;
		
		// Flock Demo type constants. Will be used to activate the specific demo type with readio buttons
		public const FLOCK:Class = FlockDemo;
		public const WANDER:Class = WanderDemo;
		public const SEEK:Class = SeekDemo;
		public const CHASE:Class = ChaseDemo;
		public const PREDATOR:Class = PredatorDemo;
		public const NONE:Class = StillDemo;
		public const MOUSE:Class = PredatorMouse;
		
		public function AbstractDemo():void
		{
			_boidHolder = addChild(new Sprite()) as Sprite;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		/**************************************
		/*						CONTROL PANEL *
		/*************************************/
		
		protected function createControlPanel():void
		{
			//create the panels main area
			_panelHolder.x = 0;
			_panelHolder.y = stage.stageHeight - OFFSET_Y;
			_panelHolder.alpha = 0.9;
			
			addChild(_panelHolder);
			
			var panel:Panel = new Panel(_panelHolder, 0, 0);
			panel.setSize(stage.stageWidth, PANEL_HEIGHT);
			panel.color = 0xF5F3F3;
			_panelDesk = new Panel(panel, this.x + 3, this.y + 3);
			_panelDesk.color = 0x212121;
			_panelDesk.setSize(panel.width - 6, panel.height - 6);
			_panelDesk.gridColor = 0x000000;
			_panelDesk.shadow = true;
			
			
			// Create the right upper tab on the Panel
			var g:Sprite = new Sprite();
			g.graphics.beginFill(0xF5F3F3);
			g.graphics.lineStyle(0, 0x212121, 0);
			g.graphics.moveTo(panel.width - 100, panel.y);
			g.graphics.curveTo(panel.width - 105, panel.y + OFFSET_Y - 5, panel.width - 80, panel.y + OFFSET_Y - 5);
			g.graphics.lineTo(panel.width, panel.y + OFFSET_Y - 5);
			g.graphics.lineTo(panel.width, panel.y);
			g.graphics.lineTo(panel.width - 20, panel.y);
			g.graphics.endFill();
			panel.addChild(g);
			
			//Text Label for Control Panel
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Calibri";
			textFormat.size = 12.5;
			textFormat.bold = true
			var panelLabel:TextField = new TextField();
			panelLabel.defaultTextFormat = textFormat;
			panelLabel.text = "Options";
			panelLabel.textColor = 0x212121;
			panelLabel.selectable = false;
			panelLabel.x = panel.width - 50 + ((panel.width / panel.width - 50) + ((panelLabel.width * 0.5) * 0.75));
			panelLabel.y = panel.y + ((OFFSET_Y - 5) * .5) * .05;
			
			panel.addChild(panelLabel);
			
			
			//______________PANEL ELEMENTS______________
			
			
			_minForce = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST / 3, _panelDesk.y + LABEL_Y_CONST, "Min Force" );
			_minForce.setSliderParams(_boid.minForce, _boid.maxForce, 0.9);
			_minForce.useHandCursor = true;
			LABEL_Y_CONST += LABEL_Y_CONST;
			
			_maxForce = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST / 3, _panelDesk.y + LABEL_Y_CONST, "Max Force" );
			_maxForce.setSliderParams(_boid.minForce, _boid.maxForce, 2.0);
			_maxForce.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 40;
			
			_minSpeed = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST / 3, _panelDesk.y + LABEL_Y_CONST, "Min Speed" );
			_minSpeed.setSliderParams(_boid.minSpeed, _boid.maxSpeed, 6.0);
			_minSpeed.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 20;
			
			_maxSpeed = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST / 3, _panelDesk.y + LABEL_Y_CONST, "Max Speed" );
			_maxSpeed.setSliderParams(_boid.minSpeed, _boid.maxSpeed, 12.0);
			_maxSpeed.useHandCursor = true;
			LABEL_Y_CONST = 20;
			
			_minWanderDist = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 2.25, _panelDesk.y + LABEL_Y_CONST, "Min Wander Dist");
			_minWanderDist.setSliderParams(_boid.minWanderDist, _boid.maxWanderDist, 10.0);
			_minWanderDist.useHandCursor = true;
			LABEL_Y_CONST += LABEL_Y_CONST;
			
			_maxWanderDist = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 2.25, _panelDesk.y + LABEL_Y_CONST, "Max Wander Dist");
			_maxWanderDist.setSliderParams(_boid.minWanderDist, _boid.maxWanderDist, 80.0);
			_maxWanderDist.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 40;
			
			_minWanderRadius = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 2.25, _panelDesk.y + LABEL_Y_CONST, "Min Wander Radius");
			_minWanderRadius.setSliderParams(_boid.minWanderRadius, _boid.maxWanderRadius, 5.0);
			_minWanderRadius.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 20;
			
			_maxWanderRadius = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 2.25, _panelDesk.y + LABEL_Y_CONST, "Max Wander Radius");
			_maxWanderRadius.setSliderParams(_boid.minWanderRadius, _boid.maxWanderRadius, 20.0);
			_maxWanderRadius.useHandCursor = true;
			LABEL_Y_CONST = 20;
			
			_minWanderStep = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 4.25, _panelDesk.y + LABEL_Y_CONST, "Min Wander Step");
			_minWanderStep.setSliderParams(_boid.minWanderStep, _boid.maxWanderStep, 0.1);
			_minWanderStep.useHandCursor = true;
			LABEL_Y_CONST += LABEL_Y_CONST;
			
			_maxWanderStep = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 4.25, _panelDesk.y + LABEL_Y_CONST, "Max Wander Step");
			_maxWanderStep.setSliderParams(_boid.minWanderStep, _boid.maxWanderStep, 0.9);
			_maxWanderStep.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 40;
			
			_boundingRadius = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 4.25, _panelDesk.y + LABEL_Y_CONST, "Bounding Radius");
			_boundingRadius.setSliderParams(100, 500, stage.stageWidth * 0.4);
			_boundingRadius.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 20;
			
			_maxBoids = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 4.25, _panelDesk.y + LABEL_Y_CONST, "Number of Boids");
			_maxBoids.setSliderParams(10, _boid.numBoids, _boid.numBoids /2 );
			_maxBoids.useHandCursor = true;
			LABEL_Y_CONST = 20;
			
			_predMinForce = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 6.25, _panelDesk.y + LABEL_Y_CONST, "Predator Min Energy" );
			_predMinForce.setSliderParams(_predator.minForce, _predator.maxForce, random(_predator.minForce, _predator.maxForce));
			_predMinForce.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 20;
			
			_predMaxForce = new HUISlider(_panelDesk, _panelDesk.x + LABEL_X_CONST * 6.25, _panelDesk.y + LABEL_Y_CONST, "Predator Max Energy" );
			_predMaxForce.setSliderParams(_predator.minForce, _predator.maxForce, random(_predator.minForce, _predator.maxForce));
			_predMaxForce.useHandCursor = true;
			LABEL_Y_CONST = LABEL_Y_CONST + 40;
			
			// Set if the boids looks at the target or not
			_faceTarget = new CheckBox(_panelDesk, _panelDesk.x + LABEL_X_CONST * 6.25, _panelDesk.y + LABEL_Y_CONST, "Don't Look At Target",
									   function (e:Event):void { _lookAtTarget = _faceTarget.selected });
			LABEL_Y_CONST = LABEL_Y_CONST + 20;
			
			_restoreBtn = new PushButton(_panelDesk, _panelDesk.x + LABEL_X_CONST * 6.25, _panelDesk.y + LABEL_Y_CONST, "Restore Defaults", restoreDefaults);
			LABEL_Y_CONST = 20;
			
			_flockBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "FLOCK", true, 
									   function ():void { changeDemoType(FLOCK) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_wanderBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "WANDER", false, 
										function ():void { changeDemoType(WANDER) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_seekBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "SEEK", false,
									  function ():void { changeDemoType(SEEK) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_chaseBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "CHASE", false,
									   function ():void { changeDemoType(CHASE) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_predatorBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "PREDATOR", false,
										  function ():void { changeDemoType(PREDATOR) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_mouseBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "PREDATOR MOUSE", false,
									   function ():void { changeDemoType(MOUSE) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_noneBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "NONE", false,
									  function ():void { changeDemoType(NONE) } );
		}
		
		protected function changeDemoType(type:Class):void
		{
			var demoType:Class = Class(type); 
			addChild(new demoType());
		}
		
		private function restoreDefaults(e:Event):void
		{
			_minForce.setSliderParams(_boid.minForce, _boid.maxForce, 0.9);
			_maxForce.setSliderParams(_boid.minForce, _boid.maxForce, 2.0);
			_minSpeed.setSliderParams(_boid.minSpeed, _boid.maxSpeed, 6.0);
			_maxSpeed.setSliderParams(_boid.minSpeed, _boid.maxSpeed, 12.0);
			_minWanderDist.setSliderParams(_boid.minWanderDist, _boid.maxWanderDist, 10.0);
			_maxWanderRadius.setSliderParams(_boid.minWanderRadius, _boid.maxWanderRadius, 20.0);
			_minWanderRadius.setSliderParams(_boid.minWanderRadius, _boid.maxWanderRadius, 5.0);
			_maxWanderRadius.setSliderParams(_boid.minWanderRadius, _boid.maxWanderRadius, 20.0);
			_minWanderStep.setSliderParams(_boid.minWanderStep, _boid.maxWanderStep, 0.1);
			_maxWanderStep.setSliderParams(_boid.minWanderStep, _boid.maxWanderStep, 0.9);
			_boundingRadius.setSliderParams(100, 400, stage.stageWidth * 0.3);
			_predMinForce.setSliderParams(_predator.minForce, _predator.maxForce, random(_predator.minForce, _predator.maxForce));
			_predMaxForce.setSliderParams(_predator.minForce, _predator.maxForce, random(_predator.minForce, _predator.maxForce));
		}
		
		/**
		 * Create the boids and predators and sets their main behavior parameters
		 */
		
		protected function createBoid():Boid
		{
			var boid:Boid = new Boid();
			setBoidProperties(boid);
			boid.renderData = boid.createBoidShape(Math.random() * 0xffffff, random(6, 9));
			_boidHolder.addChild(boid.renderData);
			_boids.push(boid);
			
			return boid;
		}
			
		protected function createPredator():Boid
		{
			var predator:Boid = new Boid();
			setPredatorProperties(predator);
			predator.renderData = predator.createPredatorShape(random(8, 10), 1);
			_boidHolder.addChild(predator.renderData);
			_predators.push(predator);
			
			return predator;
		}
		
		protected function createBoids (count:int):void
		{
			for (var i:int = 0; i< _maxBoids.value; i++)
			{
				createBoid();
			}
		}
		
		protected function createPredators (count:int = 100):void
		{
			for (var i:int = 0; i< count; i++)
			{
				createPredator();
			}
		}
				
		private function setBoidProperties (boid:Boid):void
		{
			boid.edgeBehavior = Boid.EDGE_BOUNCE;
			
			//check if the boids lookAtTarget is true or false
			if (_lookAtTarget) boid.lookAtTarget = false;
			else boid.lookAtTarget = true;
			
			boid.maxSpeed = random(_minSpeed.value, _maxSpeed.value);
			boid.maxForce = random(_maxForce.value, _maxForce.value);
			boid.wanderDistance = random(_minWanderDist.value, _maxWanderDist.value);
			boid.wanderRadius = random(_minWanderRadius.value, _maxWanderRadius.value);
			boid.wanderStep = random(_minWanderStep.value, _maxWanderStep.value);
			boid.boundsRadius = _boundingRadius.value;
			boid.boundsCentre  = new Vector3D(stage.stageWidth >> 1, stage.stageHeight >> 1);
			
			if (boid.x == 0 && boid.y == 0)
			{
				boid.x = boid.boundsCentre.x + random(-100, 100);
				boid.y = boid.boundsCentre.y + random(-100, 100);
				boid.z = random(-50, 220);
				var vel:Vector3D = new Vector3D(random(-2, 2), random(-2, 2), random(-2,2));
				boid.velocity.incrementBy(vel);
			}
		}
		
		private function setPredatorProperties (predator:Boid):void
		{
			predator.edgeBehavior = Boid.EDGE_BOUNCE;
			if (_lookAtTarget) predator.lookAtTarget = false;
			else predator.lookAtTarget = true;
			predator.maxSpeed = random(_predator.minSpeed, _predator.maxSpeed);
			predator.maxForce = random(_predMinForce.value, _predMaxForce.value);
			predator.wanderDistance = random(_predator.minWanderDist, _predator.maxWanderDist);
			predator.wanderRadius = random(_predator.minWanderRadius, _predator.maxWanderRadius);
			predator.wanderStep = random(_predator.minWanderStep, _predator.maxWanderStep);
			predator.energy = int(random(_predator.minEnergy, _predator.maxEnergy));
			predator.boundsCentre  = new Vector3D(stage.stageWidth >> 1, stage.stageHeight >> 1);
			
			if (predator.x == 0 && predator.y == 0)
			{
				predator.x = predator.boundsCentre.x + random(-100, 100);
				predator.y = predator.boundsCentre.y + random(-100, 100);
				predator.z = random(-50, 220);
				var vel:Vector3D = new Vector3D(random(-2, 2), random(-2, 2), random(-2,2));
				predator.velocity.incrementBy(vel);
			}
		}
		
		protected function random (min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min
				min = 0;
			}
			
			return Math.random() *( max- min ) + min;
		}
		
		protected function init():void
		{
			// Override in main class
		}
		
		protected function updateBoids (boid:Boid, index:Number):void
		{
			// Override in main class
			setBoidProperties(boid); // Update the boid properties on runtime
		}
		protected function updatePredators(predator:Boid, index:Number):void
		{
			// Override in main class
			setPredatorProperties(predator); // Update the predator properties on runtime
		}
				
		protected function onStart (e:Event = null):void
		{
			for (var i:int = 0; i< _boids.length; i++)
			{
				updateBoids(_boids[i] as Boid, i);
			}
			
			for (i = 0; i< _predators.length; i++)
			{
				updatePredators(_predators[i] as Boid, i);
			}
			
			if (_maxBoids.value > _boids.length)
			{
				var boid:Boid = new Boid();
				setBoidProperties(boid);
				boid.renderData = boid.createBoidShape(Math.random() * 0xffffff, random(6, 9));
				_boidHolder.addChild(boid.renderData);
				_boids.push(boid);
			}
			
			if (_maxBoids.value < _boids.length)
			{
				var index:Number = _maxBoids.value;
				while (index < _boids.length)
				{
					_boidHolder.removeChild(Boid(_boids[index]).renderData);
					_boids.splice(_maxBoids.value, int(_boids.length - _maxBoids.value));
					index ++;
				}
			}
		}
		
		/**
		 * Activate the Control Panel if the mouse is over. 
		 * After activation set _mouseOver variable to true.
	 	 */
		
		private function onMouseOverPanel (e:MouseEvent):void
		{
			if (e.target is HUISlider && _panelHolder.y > _panelHolder.height - PANEL_HEIGHT)
			{
				e.stopPropagation();
				_panelHolder.mouseChildren = false;
			}
			_panelHolder.mouseChildren = true;
			_mouseOver = true;
			_panelHolder.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverPanel);
			_tween = new Tween(_panelHolder, "y", Regular.easeInOut, _panelHolder.y, stage.stageHeight - PANEL_HEIGHT, 1.1, true);
			_tween.start();
			_panelHolder.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutPanel, false, 0, true);
		}
		
		/**
		 * Activate the returning tween only in case the mouse is not over the Control Panel
		 * Set the _mouseOver to false
	 	 */
		
		private function onMouseOutPanel(e:MouseEvent):void
		{
			if (!_mouseOver)
			{
				_panelHolder.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutPanel);
				_tween = new Tween(_panelHolder, "y", Regular.easeInOut, _panelHolder.y, stage.stageHeight - OFFSET_Y, 0.9, true);
				_tween.start();
				_panelHolder.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverPanel, false, 0, true);
			}
			_mouseOver = false;
		}
		
		/**
		 * If mouse leave the stage activate the returning tween effect
		 * Set a listener for mouse in case it returns to stage
	 	 */
		
		private function onMouseLeave(e:Event):void
		{
			_mouseOver = false;
			_tween = new Tween(_panelHolder, "y", Regular.easeIn, _panelHolder.y, stage.stageHeight - OFFSET_Y, 1.2, true);
			_tween.start();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOn);
		}
		
		private function mouseOn(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseOn);
		}
				
		private function addedToStage (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addEventListener(Event.ENTER_FRAME, onStart);
			createControlPanel(); //Activate the control panel
			_panelHolder.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverPanel, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			init();
		}
	}
}