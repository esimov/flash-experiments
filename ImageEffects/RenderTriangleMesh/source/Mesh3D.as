package {
	import flash.geom.Vector3D;
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Point;

	public class Mesh3D {
		private var _vertices:Vector.<Number>;
		private var _canvas:DisplayObject;
		
		protected var _vectors:Vector.<Vector3D>;
		protected var _sides:Vector.<int>;
		protected var _uvtData:Vector.<Number>;
		
		public function Mesh3D(canvas:DisplayObject):void {
			this._canvas = canvas;
			createMesh();
		}
		
		protected function createMesh():void { }
		
		public function applyTransformation(matrix:Matrix3D):void{
			var transformedVector:Vector3D;
			var point:Point;
			_vertices = new Vector.<Number>();
			for each (var vector:Vector3D in _vectors) {
				transformedVector = matrix.deltaTransformVector(vector);
				point = get2DPoint(transformedVector);
				_vertices.push(point.x, point.y);
			}
		}
		
		private function get2DPoint(vector:Vector3D):Point {
			 var point:Point = _canvas.local3DToGlobal(vector);
			 return _canvas.globalToLocal(point);
		}
		
		public function get vertices():Vector.<Number> {
			return _vertices;
		}
		
		public function get sides():Vector.<int> {
			return _sides;
		}
		
		public function get uvtData():Vector.<Number> {
			return _uvtData;
		}
	}
}