package {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class PreserveGraphics extends Sprite {
		private var _lineStyle:GraphicsStroke;
		private var _path:GraphicsPath;
		private var _command:Vector.<IGraphicsData>;
		private var _isDrawing:Boolean = false;
		private var _thickness:uint;
		private var _color:uint;
		private var _bmpData:BitmapData = new BitmapData(100, 100);
		private static const INIT_VALUE:Number = 5;
		private static const MAX_VALUE:Number = 10;
		private static const MIN_VALUE:Number = 1;
		
		public function PreserveGraphics():void {
			_color = Math.random() * 0xffffff;
			_command = new Vector.<IGraphicsData>();
			_thickness = INIT_VALUE;
			graphics.lineStyle(_thickness, _color);
			_lineStyle = new GraphicsStroke(_thickness);
			_lineStyle.fill = new GraphicsSolidFill(_color);
			_command.push(_lineStyle);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function drawLine():void {
			graphics.clear();
			graphics.drawGraphicsData(_command);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void {
			if (!_isDrawing) {
				switch (evt.keyCode) {
					case Keyboard.DOWN:
					if (_thickness > MIN_VALUE) {
						_lineStyle.thickness -=_thickness;
						drawLine();
						break;
					}
					
					case Keyboard.UP:
					if (_thickness < MAX_VALUE) {
						_lineStyle.thickness += _thickness;
						drawLine();
						break;
					}
					
					case Keyboard.SPACE:
					_color = Math.random() * 0xffffff;
					_bmpData.perlinNoise(40, 40, Math.random() + 4 -2, Math.random()*4, true, false);
					_lineStyle.fill = new GraphicsBitmapFill(_bmpData);
					drawLine();
				}
			}
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			_isDrawing = true;
			_path = new GraphicsPath();
			_path.moveTo(evt.localX, evt.localY);
			graphics.moveTo(evt.localX, evt.localY);
			_command.push(_path);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			_path.lineTo(evt.localX, evt.localY);
			graphics.lineTo(evt.localX, evt.localY);
			//graphics.drawGraphicsData(_command);
			evt.updateAfterEvent();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			_isDrawing = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
	}
}