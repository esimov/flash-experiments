package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	[SWF (backgroundColor = 0x000000, frameRate = 60, width = 1024, height = 720)]

	public class ExtrudeText extends Sprite {
		private static const DEPTH:Number = 30;
		private static const Z_DEPTH:Number = 6;
		
		public function ExtrudeText():void {
			for (var i:int = 0; i<= DEPTH; i++) {
				createText(i);
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function createText(index:Number):void {
			var textFl:TextField = new TextField();
			textFl.selectable = false;
			textFl.autoSize = TextFieldAutoSize.LEFT;
			textFl.defaultTextFormat = new TextFormat("Impact", 80, 0x66AAFF);
			textFl.text = "EXTRUDED TEXT";
			textFl.x = stage.stageWidth/2 - textFl.width * 0.5;
			textFl.y = stage.stageHeight/2 - textFl.height * 0.5;
			textFl.z = index * Z_DEPTH;
			
			if (index == 0) {
				textFl.filters = [new GlowFilter(0xFFFFFF, .5, 6, 6, 2, 1, true)];
			}
			else {
				textFl.filters = [new BlurFilter(0,0)];
				var darken:Number = .1 + (DEPTH-index)/DEPTH *.5;
				textFl.transform.colorTransform = new ColorTransform(darken, darken, darken);
			}
			addChildAt(textFl, 0);
		}
		
		private function onMouseMove (evt:MouseEvent):void {
			var x:Number = stage.mouseX;
			var y:Number = stage.mouseY;
			transform.perspectiveProjection.projectionCenter = new Point (x, y);
			evt.updateAfterEvent();
		}
		
		private function onMouseWheel(evt:MouseEvent):void {
			var projection:PerspectiveProjection = transform.perspectiveProjection;
			var fieldOfView:Number = projection.fieldOfView;
			if (evt.delta > 0 && fieldOfView < 179.9) {
				fieldOfView += Math.abs(evt.delta);
			}
			else if (evt.delta < 0 && fieldOfView > 0.1)
			{
				fieldOfView -= Math.abs(evt.delta);
			}
			projection.fieldOfView = Math.max(0.1, Math.min(179.9, fieldOfView));
			evt.updateAfterEvent();
		}
	}
}