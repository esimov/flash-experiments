package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	import com.esimov.Boid;
	import com.esimov.TargetShape;
	import com.bit101.components.*;
	import net.hires.debug.Stats;

	[SWF(width="960", height="720", backgroundColor="#FFFFFF", frameRate="60")]
	
	public class AbstractDemo extends Sprite
	{
		private static const PANEL_HEIGHT:Number = 150;
		private static const OFFSET_Y:Number = 25;
		private var _boids:Vector.<Boid> = new Vector.<Boid>();
		private var _vehicle:Boid = new Boid();
		private var _randomBoid:Boid;
		private var _predators:Vector.<Boid> = new Vector.<Boid>();
		private var _targetShape:TargetShape = new TargetShape();
		private var _target:Vector3D = new Vector3D();
		
		private var _boid:Object = {	 maxWanderDist: 200.0,
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
		private var _predator:Object = { maxWanderDist: 80,
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
		private var _type:String;
		private var _tween:Tween;
		private var LABEL_X_CONST:Number = 100;
		private var LABEL_Y_CONST:Number = 20;
		
		private var _minForce:HUISlider;
		private var _maxForce:HUISlider;
		private var _minSpeed:HUISlider;
		private var _maxSpeed:HUISlider;
		private var _minWanderDist:HUISlider;
		private var _maxWanderDist:HUISlider;
		private var _minWanderRadius:HUISlider;
		private var _maxWanderRadius:HUISlider;
		private var _minWanderStep:HUISlider;
		private var _maxWanderStep:HUISlider;
		private var _maxBoids:HUISlider;
		private var _boundingRadius:HUISlider;
		private var _predMinForce:HUISlider;
		protected var _predMaxForce:HUISlider;
		private var _faceTarget:CheckBox;
		private var _restoreBtn:PushButton;
		
		private var _flockBt:RadioButton;
		private var _wanderBt:RadioButton;
		private var _seekBt:RadioButton;
		private var _chaseBt:RadioButton;
		private var _predatorBt:RadioButton;
		private var _mouseBt:RadioButton;
		private var _noneBt:RadioButton;
		
		private var _boidHolder:Sprite = new Sprite();
		private var _panelHolder:Sprite = new Sprite();
		private var _panelDesk:Panel;
		
		// Flock Demo type constants. Will be used to activate the specific demo type with readio buttons
		private static const FLOCK:String 	=	"flock";
		private static const WANDER:String	=	"wander";
		private static const SEEK:String 	= 	"seek";
		private static const CHASE:String 	= 	"chase";
		private static const PREDATOR:String = 	"predator";
		private static const NONE:String 	=	"none";
		private static const MOUSE:String 	=	"mouse";
		
		private static const EASE:Number = 0.1;
		
		public function AbstractDemo():void
		{
			_boidHolder = addChild(new Sprite()) as Sprite;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		/**************************************
		/*						CONTROL PANEL *
		/*************************************/
		
		private function createControlPanel():void
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
			_maxBoids.setSliderParams(10, _boid.numBoids, 60 );
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
									   function ():void { changeDemoType(FLOCK, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_wanderBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "WANDER", false, 
										function ():void { changeDemoType(WANDER, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_seekBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "SEEK", false,
									  function ():void { changeDemoType(SEEK, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_chaseBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "CHASE", false,
									   function ():void { changeDemoType(CHASE, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_predatorBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "PREDATOR", false,
										  function ():void { changeDemoType(PREDATOR, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_mouseBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "PREDATOR MOUSE", false,
									   function ():void { changeDemoType(MOUSE, _vehicle, 0) } );
			LABEL_Y_CONST = LABEL_Y_CONST + 15;
			_noneBt = new RadioButton(_panelDesk, _panelDesk.width - 120, _panelDesk.y + LABEL_Y_CONST, "NONE", false,
									  function ():void { changeDemoType(NONE, _vehicle, 0) } );
		}
		
		
		private function changeDemoType(type:String, boid:Boid, index:Number = 0):void
		{
			_type = type;
			switch (type)
			{
				case "flock":
				// Add some wander to keep things interesting
				boid.wander(0.3);
				// Add a mild attraction to the centre to keep them on screen
				boid.seek(boid.boundsCentre, 0.1);
				// Flock
				boid.flocking(_boids);
				boid.update();
				boid.render();
				break;
				
				case "wander":
				// Add some wander to keep things interesting
				boid.wander();
				//update the boid then render it
				boid.update();
				boid.render();
				break;
				
				case "chase":
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
				boid.update();
				boid.render();
				break;
				
				case "predator":
				if (_predators.length <= 4)
				{
					createPredator();
				}
				boid.wander(0.3);
				boid.seek(boid.boundsCentre, 0.15);
				boid.evade(_predators, 80, 0.3);
				boid.flocking(_boids);
				
				boid.update();
				boid.render();
				break;
				
				case "seek":
				_targetShape.mouseEnabled = false;
				addChild(_targetShape);
				addEventListener(Event.ENTER_FRAME, start);
				
				// Add some wander to keep things interesting
				boid.wander(0.5);
				boid.arrive(_target, 200, 0.4);
			
				//update the boid then render it
				boid.update();
				boid.render();
				break;
				
				case "mouse":
				_targetShape.mouseEnabled = false;
				addChild(_targetShape);
				addEventListener(Event.ENTER_FRAME, start);
				
				boid.wander(0.3);
				boid.seek(boid.boundsCentre, 0.15);
				boid.flee(_target, 100, 20);
				boid.evade(_predators, 80, 0.3);
				boid.flocking(_boids);
			
				boid.render();
				boid.update();
				break;
				
				case "none":
				boid.brake(0.05);
				
				boid.update();
				boid.render();
			}
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
		
		private function createBoid():Boid
		{
			var boid:Boid = new Boid();
			setBoidProperties(boid);
			boid.renderData = boid.createBoidShape(Math.random() * 0xffffff, random(6, 9));
			_boidHolder.addChild(boid.renderData);
			_boids.push(boid);
			
			return boid;
		}
			
		private function createPredator():Boid
		{
			var predator:Boid = new Boid();
			setPredatorProperties(predator);
			predator.renderData = predator.createPredatorShape(random(8, 10), 1);
			_boidHolder.addChild(predator.renderData);
			_predators.push(predator);
			
			return predator;
		}
		
		private function createBoids (count:int):void
		{
			for (var i:int = 0; i< _maxBoids.value; i++)
			{
				createBoid();
			}
		}
		
		private function createPredators (count:int):void
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
		
		private function random (min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min
				min = 0;
			}
			
			return Math.random() *( max- min ) + min;
		}
		
		private function updateBoids (boid:Boid, index:Number):void
		{
			if (_flockBt.selected) changeDemoType(FLOCK, boid, index);
			switch (_type)
			{
				case "flock": changeDemoType(FLOCK, boid, index);
				break;
				
				case "wander": changeDemoType(WANDER, boid, index);
				break;
				
				case "chase": changeDemoType(CHASE, boid, index);
				break;
				
				case "predator": changeDemoType(PREDATOR, boid, index);
				break;
				
				case "seek": changeDemoType(SEEK, boid, index);
				_targetShape.visible = true;
				if (mouseY > _panelHolder.y)
				{
					_targetShape.visible = false;
				}
				break;
				
				case "mouse": changeDemoType(MOUSE, boid, index);
				_targetShape.visible = true;
				if (mouseY > _panelHolder.y)
				{
					_targetShape.visible = false;
				}
				break;
				
				case "none": changeDemoType(NONE, boid, index);
				break;
			}
			
			setBoidProperties(boid); // Update the boid properties on runtime
		}
		
		private function updatePredators(predator:Boid, index:Number):void
		{
			if (_type == "predator")
			{
				var dist:Number = Vector3D.distance(predator.position, _randomBoid.position);
				if (predator.energy > 0)
				{
					predator.energy -= int(random(0, 5));
				}
				
				if (predator.energy < 0)
				{
					predator.energy = int(random(_predator.minEnergy, _predator.maxEnergy));
				}
				
				if (predator.energy < 20)
				{
					predator.arrive(_randomBoid.position, 50, 0.8);
					
					if (dist < _randomBoid.boundsRadius / 2)
					{
						predator.maxSpeed *= 0.999;
						predator.velocity.normalize();
						predator.velocity.scaleBy(predator.maxSpeed);
						predator.energy = int(random(_predator.minEnergy, _predator.maxEnergy));
					}		
				}
				else
				{
					if (_boids.length > 1)
					{
						_randomBoid = getRandomBoid(_boids); // seek for anathor boid if he reach the target
					}
					predator.velocity.normalize();
					predator.velocity.scaleBy(_predator.minEnergy);
				}
				
				predator.wander(0.1);
				
				predator.render();
				predator.update();
			}
			setPredatorProperties(predator); // Update the predator properties on runtime
		}
		
		
		/**
		 * Initialize the stage
		 */
				
		private function init():void
		{
			addChild(new Stats());
			createBoids(_boid.numBoids);
			_randomBoid = getRandomBoid(_boids);
		}
		
		
		private function start(e:Event):void
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
		
		/**
		 * Select a random boid from boids group. 
		 * This agent will be chased from predator.
		 */
		 
		public function getRandomBoid(boids:Vector.<Boid>):Boid
		{
			var maxLenght:uint = boids.length;
			var index:uint = random(0, maxLenght);
			return _boids[index] as Boid;
		}			
				
		private function onStart (e:Event = null):void
		{
			for (var i:int = 0; i< _boids.length; i++)
			{
				updateBoids(_boids[i] as Boid, i);
			}
			
			for (i = 0; i< _predators.length; i++)
			{
				updatePredators(_predators[i] as Boid, i);
			}
			
			//look if the _targetShape is on stage
			
			//if (stage.contains(_targetShape) && _type != "seek" ) removeChild(_targetShape);
			//if (stage.contains(_targetShape) && _type != "mouse" ) removeChild(_targetShape);
			
			if (_maxBoids.value > _boids.length) // Update the boids length
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