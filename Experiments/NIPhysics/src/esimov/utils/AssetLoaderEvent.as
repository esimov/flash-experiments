package esimov.utils 
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author simoe
	 */
	public class AssetLoaderEvent extends Event
	{
		private var content:DisplayObject;
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public final function AssetLoaderEvent(type:String, content:DisplayObject, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.content = content;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AssetLoaderEvent(type, content, bubbles, cancelable);
		}
	}
}
