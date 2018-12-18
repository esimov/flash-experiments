package
{
	import com.esimov.Vector2D;
	import com.esimov.SteeredVehicle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.esimov.Obstacle;
	
	[SWF(width = 1000, height = 600, frameRate = 30)]
	
	public class FlockTest extends Sprite
	{
		private static const NUM_VEHICLES:Number = 50;
		private var _vehicle:SteeredVehicle;
		private var _vehicles:Array;
		private var _obstacles:Array;
		
		public function FlockTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicles = new Array();
			_obstacles = new Array();
			
			for (var i:int = 0; i<= NUM_VEHICLES; i++)
			{
				_vehicle = new SteeredVehicle();
				_vehicle.position.x = 200;
				_vehicle.position.y = 200;
				_vehicle.velocity = new Vector2D(Math.random() * 2 + 1, Math.random() * 2 + 1);
				_vehicle.edgeBehavior = "wrap";
				addChild(_vehicle);
				_vehicles.push(_vehicle);
			}
			
			for (i = 0; i < 15; i++)
			{
				var obj:Obstacle = new Obstacle(10, 0x999999);
				//addChild(obj);
				obj.x = Math.random() * stage.stageWidth;
				obj.y = Math.random() * stage.stageHeight;
				_obstacles.push(obj);
			}
			
			
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			_vehicle = new SteeredVehicle();
			_vehicle.position.x = stage.mouseX
			_vehicle.position.y = stage.mouseY;
			_vehicle.maxSpeed = Math.random() * 2 + 3;
			_vehicle.mass = 3 - Math.random() + 1;
			_vehicle.edgeBehavior = "wrap";
			addChild(_vehicle);
			_vehicles.unshift(_vehicle);
		}
		
		private function onEnterFrame(event:Event):void
		{
			for (var i:int = 0; i< _vehicles.length-1; i++)
			{
				var vehicle:SteeredVehicle = SteeredVehicle(_vehicles[i]);
				vehicle.flock(_vehicles);
				vehicle.update();
				//vehicle.avoid(_obstacles);
				//vehicle.update();
			}
		}
	}
}