package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DrawingCurves extends Sprite 
	{
		private var _anchor0:Sprite;
		private var _anchor1:Sprite;
		private var _controlPoint:Sprite;
		
		public function DrawingCurves():void 
		{
			_anchor0 = drawControlPoint(100, 300);
			_anchor1 = drawControlPoint(400, 300);
			_controlPoint = drawControlPoint(250, 100);
			drawCurve();
		}
		
		private function drawControlPoint(x:Number, y:Number):Sprite {
			var controlPoint:Sprite = new Sprite();
			controlPoint.graphics.lineStyle(20);
			controlPoint.graphics.moveTo(0,0);
			controlPoint.graphics.lineTo(1,0);
			controlPoint.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			controlPoint.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			controlPoint.x = x;
			controlPoint.y = y;
			addChild(controlPoint);
			return controlPoint;
		}
		
		private function drawCurve():void {
			graphics.clear();
			graphics.lineStyle(5, 0xff0000);
			graphics.moveTo(_anchor0.x, _anchor0.y);
			graphics.curveTo(_controlPoint.x, _controlPoint.y, _anchor1.x, _anchor1.y);
			graphics.lineStyle(0, 0, 0.5);
			graphics.moveTo(_anchor0.x, _anchor0.y);
			graphics.lineTo(_controlPoint.x, _controlPoint.y);
			graphics.lineTo(_anchor1.x, _anchor1.y);
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			Sprite(evt.target).startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			evt.updateAfterEvent();
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			Sprite (evt.target).stopDrag();
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			evt.updateAfterEvent();
			drawCurve();
		}
	}
}