package esimov.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author simoe
	 */
	public class AssetLoader extends Loader
	{
		private var loaderAssets:Object = {};
		private var url:String;
		private var loader:Loader;
		
		public var imageContent:DisplayObject;
		
		public final function AssetLoader(url:String):void
		{
			this.url = url;
		}
		
		public function loadAsset():void
		{
			if (loaderAssets[url])
			{
				imageContent = loaderAssets[url];			
				if (imageContent is Bitmap)
				{
					imageContent = new Bitmap(Bitmap(imageContent).bitmapData);
				}
				dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.COMPLETE, imageContent));
			}
			else
			{
				var urlRequest:URLRequest = new URLRequest(url);
				contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				load(urlRequest);
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			loader = e.target as Loader;
			loaderAssets[url] = loader.content;
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.COMPLETE, loader.content));
		}

		private function loadError(e:IOErrorEvent):void
		{
			throw new Error("Loading error: " + e);
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ERROR, e.target.loader.content));
		}
		
		public function get contentAsBitmap():Bitmap
		{
			if (! imageContent)
			{
				throw new Error("Cannot convert content to bitmap");
			}
			
			return  imageContent as Bitmap;
		}
		
		public function get contentAsBitmapData():BitmapData
		{
			if (! imageContent)
			{
				throw new Error("Cannot convert content to bitmapData");
			}
			
			return contentAsBitmap.bitmapData;
		}
	}
}
