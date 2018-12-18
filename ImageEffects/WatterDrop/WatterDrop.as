package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Shape;
	
	[SWF (backgroundColor = 0x000000, width = 800, height = 600)]

	public class WatterDrop extends Sprite
	{
		private var _circles:Vector.<Shape>;
		private static const MAX:Number = 30;
		
		public function WatterDrop():void
		{
			init();
		}
		
		private function init():void
		{
			if (stage) { 
				addEventListener(Event.ADDED_TO_STAGE, initStage);
			}
			else
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				removeEventListener(Event.ADDED_TO_STAGE, initStage);
			}
		}
		
		private function initStage(event:Event):void
		{
			_circles = new Vector.<Shape>();
			for (var i:int = 0; i < MAX; i++)
			{
				var c:Shape = createCircle();
				c.x = stage.stageWidth/2;
				c.y = stage.stageHeight/2;
				c.scaleX = 1 + i/2;
				c.scaleY = 0.5 + i/4;
				addChild(c);
				_circles.push(c);
			}
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onStartFrame(event:Event):void
		{
			_circles[0].y += (mouseY - _circles[0].y) / 4;
			for (var i:int = 1; i< _circles.length; i++)
			{
				var c:Shape = _circles[i-1] as Shape;
				_circles[i].y += (c.y - _circles[i].y) / 4;
			}
		}
		
		private function createCircle():Shape 
		{
			var circle:Shape = new Shape();
			circle.graphics.lineStyle(1, 0x666666, 0.8);
			circle.graphics.drawCircle(0,0, 10);
			
			return circle;
		}
	}
}