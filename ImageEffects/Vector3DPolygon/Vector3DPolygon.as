package {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Vector3DPolygon extends Sprite {
		private static const COLOR:uint = 0x9900FF;
		private static const FRONT_LIGTH:Vector3D = new Vector3D(0,0,1);
		
		public function Vector3DPolygon():void {
			x = stage.stageWidth /2;
			y = stage.stageHeight /2;
			createPolygons();
		}
		
		private function createPolygons():void {
			var polygons:Vector.<Vector3D> = new Vector.<Vector3D>();
			polygons.push(new Vector3D(-250, -250, -10));
			polygons.push(new Vector3D(-100, -250, 10));
			polygons.push(new Vector3D(-100, -100, -100));
			polygons.push(new Vector3D(-250, -100, 0));
			drawPolygons(polygons);
			
			polygons = new Vector.<Vector3D>();
			polygons.push(new Vector3D(-50, -75, -50));
			polygons.push(new Vector3D(50, -75, 50));
			polygons.push(new Vector3D(50, 75, 50));
			polygons.push(new Vector3D(-50, 75, -50));
			drawPolygons(polygons);
			
			polygons = new Vector.<Vector3D>();
			polygons.push(new Vector3D(100, 160, 50));
			polygons.push(new Vector3D(250, 160, 50));
			polygons.push(new Vector3D(250, 180, -50));
			polygons.push(new Vector3D(100, 180, -50));
			drawPolygons(polygons);
			
		}
		
		private function drawPolygons(vectors:Vector.<Vector3D>):void {
			var color:uint = getPointColor(vectors);
			var points:Vector.<Point> = getPoints2D(vectors);
			//graphics.clear();
			graphics.beginFill(color);
			graphics.moveTo(points[0].x, points[0].y);
			for (var i:int = 1; i< points.length; i++) {
				graphics.lineTo(points[i].x, points[i].y);
			}
			graphics.lineTo(points[0].x, points[0].y);
			graphics.endFill();
		}
		
		private function getPointColor(vectors:Vector.<Vector3D>):uint {
			var face1:Vector3D = getEdge(vectors[1], vectors[0]);
			var face2:Vector3D = getEdge(vectors[1], vectors[2]);
			var crossProduct:Vector3D = face1.crossProduct(face2);
			var angle:Number = Vector3D.angleBetween(crossProduct, FRONT_LIGTH);
			var brightness:Number = angle / Math.PI;
			return darkenColor(COLOR, brightness);
		}
		
		private function getPoints2D (vectors:Vector.<Vector3D>):Vector.<Point> {
			var points:Vector.<Point> = new Vector.<Point>();
			var point:Point;
			for each (var vector:Vector3D in vectors) {
				point = local3DToGlobal(vector);
				points.push(globalToLocal(point));
			}
			
			return points;
		}
		
		private function getEdge(v1:Vector3D, v2:Vector3D):Vector3D {
			var x:Number = v1.x - v2.x;
			var y:Number = v1.y - v2.y;
			var z:Number = v1.z - v2.z;
			return new Vector3D(x,y,z);
		}
		
		private function darkenColor (color:uint, factor:Number): uint {
			var red:uint = color >> 16 & 0xFF;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			red *= factor;
			green *= factor;
			blue *= factor;
			return red << 16 | green << 8 | blue;
		}
	}
}