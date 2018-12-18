package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	[SWF (backgroundColor = 0xfffff, width = 800, height = 600, frameRate = 60)]

	public class Carousel extends Sprite {
		private static const CAROUSEL_ITEMS:Number = 20;
		private static const RADIAL:Number = 200;
		private static const ITEM_ANGLE:Number = 360/CAROUSEL_ITEMS * Math.PI / 180;
		private var _fraction:Number = 0.9;
		private var _carousels:Array;
		private var _carousel:Sprite;
		
		public function Carousel():void {
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
			rotationX = 20;
			createCarousel();
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function createCarousel():void {
			_carousel = new Sprite();
			var rectangle:Shape;
			_carousels = new Array();
			for (var i:int = 0; i< CAROUSEL_ITEMS; i++) {
				rectangle = createRectangles(i);
				_carousel.addChild(rectangle);
				_carousels.push({shape:rectangle, z:0});
			}
			
			addChild(_carousel);			
		}
		
		private function createRectangles(index:Number):Shape {
			var shape:Shape = createRectangle();
			shape.x = Math.cos(ITEM_ANGLE * index) * RADIAL;
			shape.z = Math.sin(ITEM_ANGLE * index) * RADIAL;
			return shape;
		}
		
		private function createRectangle():Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(Math.random() * 0xff);
			shape.graphics.drawRect(-20, -20, 40, 80);
			shape.graphics.endFill();
			return shape;
		}
		
		private function redrawCarousel():void {
			var matrix:Matrix3D;
			for each (var rectangle:Object in _carousels) {
				matrix = rectangle.shape.transform.getRelativeMatrix3D(root);
				rectangle.z = matrix.position.z;
			}
			
			_carousels.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			
			for each (rectangle in _carousels) {
				_carousel.addChild(rectangle.shape);
			}
		}
		
		private function onStartFrame(e:Event):void {
			var xValue:Number = (mouseX / stage.stageWidth * _fraction) * 5;
			var yValue:Number = (mouseY / stage.stageHeight * _fraction) * 5;
			var line:Shape = new Shape();
			var linePos:Vector3D = new Vector3D(line.x, line.y, line.z);
			line.x = stage.stageHeight/2;
			_carousel.rotationX += yValue;
			_carousel.rotationY -= xValue;
			for each (var rect:Object in _carousels) {
				rect.shape.rotationY += xValue;
				rect.shape.transform.matrix3D.pointAt(linePos, Vector3D.Z_AXIS, Vector3D.Y_AXIS);
			}
			redrawCarousel();
		}
	}
}