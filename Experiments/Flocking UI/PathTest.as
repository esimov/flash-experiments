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
	
	public class PathTest extends Sprite
	{
		private static const NUM_VEHICLES:Number = 50;
		private var _vehicle:SteeredVehicle;
		private var _vehicles:Vector.<SteeredVehicle>;
		private var _path:Array;
		private var _clickIndex:Number = 0;
		
		public function PathTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicles = new Vector.<SteeredVehicle>();
			_path = new Array();
			
			for (var i:int = 0; i<= NUM_VEHICLES; i++)
			{
				_vehicle = new SteeredVehicle();
				_vehicle.position.x = Math.random() * stage.stageWidth;
				_vehicle.position.y = Math.random() * stage.stageHeight;
				
				addChild(_vehicle);
				_vehicles.push(_vehicle);
			}
			
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			graphics.lineStyle(0, 0, 0.1);
			if (_path.length == 0)
			{
				graphics.moveTo(mouseX, mouseY);
			}
			graphics.lineTo(mouseX, mouseY);
			graphics.drawCircle(mouseX,mouseY, 10);
			graphics.moveTo(mouseX, mouseY);
			_path.push(new Vector2D(mouseX, mouseY));
			_clickIndex++;
		}
		
		private function onEnterFrame(event:Event):void
		{
			//onStageClick(null);
			for each (var vehicle:SteeredVehicle in _vehicles)
			{
				if (_clickIndex != 0)
				{
					vehicle.pathFollow(_path, true);
					vehicle.update();
				} else 
				{
					vehicle.arrive(new Vector2D(mouseX, mouseY));
					vehicle.update();
				}
			}
		}
	}
}