package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorOnLoad);
			loader.load(new URLRequest(path));
		}
		
		private function onLoadImage(evt:Event):void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			_loadedBitmap = loaderInfo.content as Bitmap;
			postImage();
		}
		
		private function errorOnLoad(evt:IOErrorEvent):void {
			throw new Error("Loading failed. Check the file existance!");
		}
		
		/**
		* Class with protected attribute
		
		* This should be overridden by concrete class
		*/
		
		protected function postImage():void { }
	}
}