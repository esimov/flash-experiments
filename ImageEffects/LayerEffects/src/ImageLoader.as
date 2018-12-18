package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class ImageLoader extends Sprite {
		protected var _bitmap:Bitmap;
		public function ImageLoader(path:String):void {
			loadImage(path);
		}
		
		private function loadImage(imagePath:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
			loader.load(new URLRequest(imagePath));
		}
		
		private function onLoadImage(evt:Event):void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			_bitmap = loaderInfo.content as Bitmap;
			afterImageLoad();
		}
		
		protected function afterImageLoad():void {
		}
	}
}