package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	public class DisplayLoader extends Sprite {
		private static const IMAGE_1:String = "../assets/goat.jpg";
		private static const IMAGE_2:String = "../assets/harbor.jpg";
		
		protected var _image1:Bitmap;
		protected var _image2:Bitmap;
		protected var _imageData1:BitmapData;
		protected var _imageData2:BitmapData;
		
		public function DisplayLoader():void {
			loadImage(IMAGE_1);
		}
		
		private function loadImage(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
			loader.load(new URLRequest(path));
		}
		
		protected function afterImageLoad():void { }
		
		private function onLoadImage(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			addChild(bitmap);
			if (numChildren == 1) {
				_image2 = bitmap;
				_imageData2 = _image2.bitmapData;
				loadImage(IMAGE_2);
			} 
				else 
			{
				_image1 = bitmap;
				_imageData1 = _image1.bitmapData;
				_image1.x = _image1.width;
				afterImageLoad();
			}
		}
	}
}