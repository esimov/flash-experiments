package {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	[SWF (width = 1000, height = 800)]
	
	public class DrawGradientLine extends Sprite {
		private var _color:uint;
		private var _startPoint:Point;
		private var _currentPoint:Point;
		private var _dotLine:Shape;
				
		public function DrawGradientLine():void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function drawLine():void {
			var thickness:Number = 40;
			var matrix:Matrix = new Matrix();
			_currentPoint = new Point(stage.mouseX, stage.mouseY);
			var distX:Number = _currentPoint.x - _startPoint.x;
			var distY:Number = _currentPoint.y - _startPoint.y;
			var angle:Number = Math.atan2(distY, distX);
			matrix.createGradientBox(thickness, thickness, angle);
			var colors:Array = [_color, _color];
			var alpha:Array = [1, 0];
			var ratios:Array = [127, 127];
			_dotLine.graphics.clear();
			_dotLine.graphics.lineStyle(thickness, 0, 1, false, null, CapsStyle.SQUARE);
			_dotLine.graphics.lineGradientStyle(GradientType.LINEAR, colors, alpha, ratios, matrix, SpreadMethod.REPEAT);
			_dotLine.graphics.moveTo(_startPoint.x, _startPoint.y);
			_dotLine.graphics.lineTo(_currentPoint.x, _currentPoint.y);
		}
				
		private function onMouseDown(evt:MouseEvent):void {
			_color = Math.random() * 0xffffff;
			_startPoint = new Point(evt.localX, evt.localY);
			_dotLine = new Shape();
			//_dotLine.buttonMode = true;
			addChild(_dotLine);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			drawLine();
			evt.updateAfterEvent();
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
	}
}