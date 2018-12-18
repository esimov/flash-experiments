package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	[SWF (backgroundColor = 0xffffff, width = 600, height = 600)]
	
	public class MatrixInterpolate extends Sprite {
		private static const INTERPOLATION:Number = 100;
		
		public function MatrixInterpolate():void {
			var startColor:uint = 0xff0000;
			var endColor:uint = 0xffcc00;
			
			rotationX = 30;
			
			var startShape:Shape = createShape(startColor);
			var matrix0:Matrix3D = new Matrix3D();
			matrix0.appendRotation(-45, Vector3D.X_AXIS);
			matrix0.appendRotation(-90, Vector3D.Y_AXIS);
			matrix0.appendTranslation(0, 200, 0);
			startShape.transform.matrix3D = matrix0;
			
			var endShape:Shape = createShape(endColor);
			var matrix1:Matrix3D = matrix0.clone();
			matrix1.appendTranslation(0, -200, 0);
			matrix1.appendRotation(45, Vector3D.X_AXIS);
			matrix1.appendRotation(90, Vector3D.Y_AXIS);
			endShape.transform.matrix3D = matrix1;

			for (var i:int = 0; i< INTERPOLATION; i++) {
				var shape:Shape = createShape(getColor(startColor, endColor, i));
				shape.transform.matrix3D = Matrix3D.interpolate(matrix0, matrix1, getPercent(i));
			}
			addChild(endShape);
		}
		
		private function getColor (startColor:uint, endColor:uint, index:Number):uint {
			var percent:Number = getPercent(index);
			var startRed:uint = startColor >> 16 & 0xFF;
			var startGreen:uint = startColor >> 8 & 0xFF;
			var startBlue:uint = startColor & 0xFF;
			var endRed:uint = endColor >> 16 & 0xFF;
			var endGreen:uint = endColor >> 8 & 0xFF;
			var endBlue:uint = endColor & 0xFF;
			var red:uint = (endRed - startRed) * percent + startRed;
			var green:uint = (endGreen - startGreen) * percent + startGreen;
			var blue:uint = (endBlue - startBlue) * percent + startBlue;
			return (red << 16 | green << 8 | blue);
		}
		
		private function getPercent(index:Number):Number {
			return (index +1) / (INTERPOLATION + 1);
		}
		
		private function createShape(color:uint):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(-100, -100, 200, 200);
			shape.graphics.endFill();
			addChild(shape);
			return shape;
		}
	}
}