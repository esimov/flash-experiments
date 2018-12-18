package {
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;

	public class PyramidMesh extends Mesh3D {
		public function PyramidMesh(canvas:DisplayObject):void {
			super(canvas);
		}
		
		override protected function createMesh():void {
			_vectors = new Vector.<Vector3D>();
			_vectors.push(new Vector3D(0, -100, 0));
			_vectors.push(new Vector3D(130, 100, 130));
			_vectors.push(new Vector3D(130, 100, -130));
			_vectors.push(new Vector3D(-130, 100, -130));
			_vectors.push(new Vector3D(-130, 100, 130));
			
			_sides = new Vector.<int>();
			_sides.push(0, 1, 2);
			_sides.push(0, 2, 3);
			_sides.push(0, 3, 4);
			_sides.push(0, 4, 1);
			
			_uvtData = new Vector.<Number>();
			_uvtData.push(0.5, 0.5);
			_uvtData.push(0, 1);
			_uvtData.push(0, 0);
			_uvtData.push(1, 0);
			_uvtData.push(1, 1);
		}
	}
}