package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	[SWF(width=1200, height=600, backgroundColor=0x000000)]
	
	public class CopyPixels extends DisplayLoader {
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		
		override protected function afterImageLoad():void {
			var width:Number = _imageData1.width;
			var height:Number = _imageData1.height;
			var newBitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			var rectangle:Rectangle = new Rectangle(0, 0, width, 1);
			var bytes:ByteArray;
			
			for (var i:uint = 0; i< height; i++) {
				_bitmapData = (i % 2) == 0 ? _imageData1 : _imageData2;
				rectangle.y = i;
				bytes = _bitmapData.getPixels(rectangle);
				bytes.position = 0;
				newBitmapData.setPixels(rectangle,bytes);
			}
			_bitmap = new Bitmap(newBitmapData);
			_bitmap.bitmapData = newBitmapData;
			_bitmap.x = _image1.x + width;
			addChild(_bitmap);
		}
	}
}