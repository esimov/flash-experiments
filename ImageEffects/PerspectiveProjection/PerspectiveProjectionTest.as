package {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.PerspectiveProjection;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	
	[SWF (backgroundColor = 0x000000, width = 1080, height = 720, frameRate = 60)]
	
	public class PerspectiveProjectionTest extends Sprite {
		private static const NUM_PLANES:Number = 40;
		private var projection:PerspectiveProjection = transform.perspectiveProjection;
		private var fieldOfView:Number = projection.fieldOfView;
		
		public function PerspectiveProjectionTest():void {
			transform.perspectiveProjection = new PerspectiveProjection();
			for (var i:int = 0; i< NUM_PLANES; i++) {
				var color:uint = Math.random() * 0xFFFF22;
				for (var j:int = 0; j< 4; j++) {
					var x:int = (j == 0 || j == 1) ? stage.stageWidth - 200 : 100;
					var y:int = (j == 1 || j == 2) ? stage.stageHeight - 200 : 100;
					createPlanes(x, y, (NUM_PLANES - i) * 100, color);
				}
			}
			
			setVanishingPoint(stage.mouseX, stage.mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function createPlanes(x:Number, y:Number, z:Number, color:uint):void {
			var plane:Shape = new Shape();
			plane.graphics.beginFill(color, 0.7);
			plane.graphics.drawRect(0, 0, 140, 140);
			plane.graphics.drawRect(20, 20, 100, 100);
			plane.graphics.endFill();
			plane.x = x;
			plane.y = y;
			plane.z = z;
			addChild(plane);																			   
		}
		
		private function setVanishingPoint (x:Number, y:Number): void {
			transform.perspectiveProjection.projectionCenter = new Point(x, y);
			graphics.clear();
			graphics.lineStyle(1, 0x333333, 0.5);
			graphics.moveTo(0, 0);
			graphics.lineTo(x, y);
			graphics.moveTo(0, stage.stageHeight);
			graphics.lineTo(x, y);
			graphics.moveTo(stage.stageWidth, stage.stageHeight);
			graphics.lineTo(x, y);
			graphics.moveTo(stage.stageWidth, 0);
			graphics.lineTo(x, y);
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			setVanishingPoint (stage.mouseX, stage.mouseY);
			evt.updateAfterEvent();
		}
		
		private function onMouseWheel(evt:MouseEvent):void {
			if (evt.delta > 0 && fieldOfView < 179.9) {
				fieldOfView += Math.abs(evt.delta);
				trace (evt.delta);
				trace (fieldOfView);
			}
			else if (evt.delta < 0 && fieldOfView > 0.1)
			{
				fieldOfView -= Math.abs(evt.delta);
				trace (evt.delta);
			}
			projection.fieldOfView = Math.max(0.1, Math.min(179.9, fieldOfView));
			evt.updateAfterEvent();
		}
		
		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case Keyboard.UP:
				fieldOfView += 2;
				break;
				
				case Keyboard.DOWN:
				fieldOfView -=2;
				break;
				
				default:
				break;
			}
			projection.fieldOfView = Math.max(0.1, Math.min(179.9, fieldOfView));
			evt.updateAfterEvent();
		}
	}
}

