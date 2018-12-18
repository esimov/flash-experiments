package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	/**
	* Abstract class to load a custom image
	*/
	
	public class AbstractImageLoader extends Sprite {
		public var _loadedBitmap:Bitmap;
		
		/** The constructor class witch will be overriden by the concrete class
		* @param path The image to load
		*/
		public function AbstractImageLoader(path:String):void {
			loadImage(path);
		}
		
		/**
		* The loader class
		* @param path The path to image to load
		*/
		private function loadImage(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
			loader.load(new URLRequest(path));
		}
		
		private function onLoadImage(evt:Event):void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			_loadedBitmap = loaderInfo.content as Bitmap;
			postImage();
		}
		
		/**
		* Class with protected attribute
		
		* This should be overridden by concrete class
		*/
		
		protected function postImage():void { }
	}
}