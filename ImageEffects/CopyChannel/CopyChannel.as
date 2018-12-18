package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.events.Event;
	
	[SWF (backgroundColor = 0x202020, width = 900, height = 600, frameRate = 60)]
	
	public class CopyChannel extends AbstractImageLoader {
		
		public function CopyChannel():void {
			// call the Abstract image loader class by it's super CLASS
			super("assets/image.jpg");
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageAdded(evt:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		* Override the postImage() protected function in the Abstract Image loader class
		*/
		
		override protected function postImage():void {
			var width:Number = stage.stageWidth;
			var height:Number = stage.stageHeight;
			var matrix:Matrix = new Matrix();
			var scaleX:Number = (_loadedBitmap.width / width)/2;
			var scaleY:Number = (_loadedBitmap.height / height)/2;
			var copiedBitmap:BitmapData = new BitmapData(width * scaleX, height * scaleY, true, 0x00000000);
			
			matrix.scale(scaleX, scaleY);
			copiedBitmap.draw(_loadedBitmap, matrix);
			var bitmap:Bitmap = new Bitmap(copiedBitmap);
			addChild(bitmap);
			
			var cloneBitmap:BitmapData = copiedBitmap.clone();
			//copiedBitmap.dispose();
			
			var scW:Number = cloneBitmap.width;
			var scH:Number = cloneBitmap.height;
			var shape:Shape = createShape(scW,scH);
			var shapeBitmap:BitmapData = new BitmapData(width * scaleX, height * scaleY, true, 0x00000000);
			shapeBitmap.draw(shape);
			cloneBitmap.copyChannel (shapeBitmap, shapeBitmap.rect, new Point(0,0), 
									  BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			var newBmp:Bitmap = new Bitmap(cloneBitmap);
			addChild(newBmp);
			newBmp.x = cloneBitmap.width;
		}
		
		private function createShape(width:Number, height:Number):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF, 1);
			shape.graphics.drawEllipse(20, 20, width - 45, height - 40);
			shape.graphics.endFill();
			var gradient:BlurFilter = new BlurFilter(20, 20);
			shape.filters = [gradient];
			return shape;
		}
	}
}