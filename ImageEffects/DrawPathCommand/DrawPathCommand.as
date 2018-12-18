package {
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF (backgroundColor = 0xffffff, width = 1090, height = 800)]
	
	public class DrawPathCommand extends Sprite {
		private var _anchors:Vector.<Sprite>;
		private var _pathData:Vector.<Number>;
		private var _pathCommand:Vector.<int>;
		private var _anchor:Sprite;
		private var _anchorIndex:uint;
		
		public function DrawPathCommand():void {
			init();
		}
		
		private function init():void {
			_pathData = new Vector.<Number>();
			_pathCommand = new Vector.<int>();
			_anchors = new Vector.<Sprite>();
			graphics.lineStyle(1, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function addAnchorPoint(x:Number, y:Number):void {
			_anchor = new Sprite();
			_anchor.x = stage.mouseX;
			_anchor.y = stage.mouseY;
			_anchor.graphics.lineStyle(20,0);
			_anchor.graphics.lineTo(1,0);
			addChild(_anchor);
			_anchors.push(_anchor);
			_anchor.addEventListener(MouseEvent.MOUSE_DOWN, onAnchorMouseDown);
			_anchor.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_anchor.addEventListener(MouseEvent.MOUSE_OVER , onMouseOver);
		}
		
		private function redrawPath():void {
			graphics.clear();
			graphics.lineStyle(1, 0xff);
			graphics.drawPath(_pathCommand, _pathData);
			var pathLenght:int = _pathData.length;
			graphics.moveTo(_pathData[pathLenght -2], _pathData[pathLenght - 1]);
		}
		
		private function onMouseOver(evt:MouseEvent):void {
			evt.target.buttonMode = true;
		}
		
		private function onAnchorMouseDown(evt:MouseEvent):void {
			_anchor = evt.target as Sprite;
			_anchor.startDrag();
			_anchorIndex = _anchors.indexOf(_anchor);
			evt.stopPropagation();
			_anchor.addEventListener(MouseEvent.MOUSE_MOVE, onAnchorMouseMove);
		}
		
		private function onAnchorMouseMove(evt:MouseEvent):void {
			_pathData[_anchorIndex * 2] = _anchor.x;
			_pathData[_anchorIndex * 2+1] = _anchor.y;
			redrawPath();
			evt.updateAfterEvent();
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			if (_anchor) {
				_anchor.buttonMode = false;
				_anchor.stopDrag();
				_anchor.removeEventListener(MouseEvent.MOUSE_MOVE, onAnchorMouseMove);
				redrawPath();
			}
		}
		
		private function onStageMouseDown(evt:MouseEvent):void {
			var x:Number = evt.localX;
			var y:Number = evt.localY;
			
			addAnchorPoint(x, y);
			if (_pathCommand.length < 1) {
				_pathCommand.push(GraphicsPathCommand.MOVE_TO);
				graphics.moveTo(x, y);
			}
			else {
				_pathCommand.push(GraphicsPathCommand.LINE_TO);
				graphics.lineTo(x, y);
			}
			_pathData.push(x, y);
		}
	}
}