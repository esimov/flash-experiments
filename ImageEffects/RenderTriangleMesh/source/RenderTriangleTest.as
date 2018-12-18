package {
	import flash.geom.Matrix3D;
	import flash.display.TriangleCulling;
	import flash.geom.Vector3D;
	import flash.events.Event;

	public class RenderTriangleTest extends AbstractImageLoader {
		private var _matrix:Matrix3D;
		private var _model:Mesh3D;
			
		public function RenderTriangleTest():void {
			x = stage.stageWidth/2;
			y = stage.stageHeight/2;
			_model = new PyramidMesh(this);
			_matrix = new Matrix3D();
			super("assets/bricks.png");
		}
		
		override protected function postImage():void {
			render();
			addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function render():void {
			_model.applyTransformation(_matrix);
			graphics.clear();
			graphics.beginBitmapFill(_loadedBitmap.bitmapData);
			graphics.drawTriangles(_model.vertices, _model.sides, _model.uvtData, TriangleCulling.NEGATIVE);
			graphics.endFill();
		}
		
		private function onStartFrame(e:Event):void {
			_matrix.appendRotation(4, Vector3D.Y_AXIS);
			render();
		}
	}
}