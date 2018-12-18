package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class ImageLoader extends Sprite {
		//private static const IMAGE_PATH:String = "assets/harbor.jpg";
		public var _image:BitmapData;
		
		public function ImageLoader(path:String):void {
			imageLoad(path);
		}
				
		private function imageLoad(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.load(new URLRequest(path));
		}
			
		private function onImageLoaded(evt:Event):void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			_image = bitmap.bitmapData;
			postImageManipulation();
		}
		
		protected function postImageManipulation():void {}
	}
}