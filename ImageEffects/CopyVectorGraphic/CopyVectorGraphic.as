package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	[SWF (backgroundColor = 0x000000, width = 1000, height = 800)]
	
	public class CopyVectorGraphic extends Sprite {
		private var _shapeHolder:Sprite;
		private var _segments:Vector.<Shape>;
		private var _color:uint;
		private static const INIT_SEGMENT:Number = 10;
		private static const MAX_SEGMENT:Number = 15;
		private static const MIN_SEGMENT:Number = 4;
		private static const ROTATION_RATE:Number = 1;
		private static const LINE_THICK:Number = 1;
		
		public function CopyVectorGraphic():void {
			init();
		}
		
		private function init():void {
			_segments = new Vector.<Shape>();
			_shapeHolder = new Sprite();
			_shapeHolder.x = stage.stageWidth/2;
			_shapeHolder.y = stage.stageHeight/2;
			addChild(_shapeHolder);
			
			for (var i:int = 0; i< INIT_SEGMENT; i++) {
				createSegment();
			}
			
			placeSegment();
			filters = [new GlowFilter()];
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function createSegment():void {
			_color = Math.random() * 0xffffff;
			var shape:Shape = new Shape();
			if (_segments.length > 0) {
				shape.graphics.copyFrom(_segments[0].graphics);
			}
			else {
				shape.graphics.lineStyle(LINE_THICK, _color);				
			}
			_segments.push(shape);
			_shapeHolder.addChild(shape);
		}
		
		private function placeSegment():void {
			var shape:Shape = _segments[0] as Shape;
			var numSegments:int = _shapeHolder.numChildren;
			var angle:int = 360 / numSegments;
			for (var i:int = 0; i< numSegments; i++) {
				_segments[i].rotation = angle * i;
			}
		}
		
		private function drawSegments():void {
			var shape:Shape = _segments[0];
			shape.graphics.lineTo(shape.mouseX, shape.mouseY);
			for (var i:int = 1; i< _shapeHolder.numChildren; i++) {
				_segments[i].graphics.copyFrom(shape.graphics);
			}
		}
		
		private function removeSegment():void {
			var shape:Shape = _segments.pop();
			_shapeHolder.removeChild(shape);
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			var shape:Shape = _segments[0];
			shape.graphics.moveTo(shape.mouseX, shape.mouseY);
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onStartFrame(evt:Event):void {
			drawSegments();
			_shapeHolder.rotation += ROTATION_RATE;
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			stage.removeEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case Keyboard.DOWN:
				if (_shapeHolder.numChildren > MIN_SEGMENT) {
					removeSegment();
					placeSegment();
				}
				break;
				
				case Keyboard.UP:
				if (_shapeHolder.numChildren < MAX_SEGMENT) {
					createSegment();
					placeSegment();
				}
				break;
				
				default:
			}
		}
	}
}