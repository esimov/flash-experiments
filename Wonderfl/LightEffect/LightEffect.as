package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filters.ColorMatrixFilter;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	
	[SWF (backgroundColor = 0x00, width = "512", height = "512")]

	public class LightEffect extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private static const URL:String = "assets/faceNormal.png";
		
		private var _bitmapData:BitmapData;
		private var _buffer:BitmapData;
		private var _bitmap:Bitmap;
		private var _cmf:ColorMatrixFilter;
		
		public function LightEffect():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			else {
				removeEventListener(Event.ADDED_TO_STAGE, onStage);
				init();
			}
		}
		
		private function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			load(URL);
			_cmf = new ColorMatrixFilter();
		}
			
		private function load(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErr);
			loader.load(new URLRequest(url), new LoaderContext(true));
		}
		
		private function onComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var imageCont:DisplayObject = loaderInfo.content as DisplayObject;
			try {
				_bitmapData = (imageCont as Bitmap).bitmapData;
			}
			catch (e:Error){
				var format:TextFormat = new TextFormat("Arial", 12, 0xffffff);
				var tf:TextField = new TextField();
				tf.defaultTextFormat = format;
				addChild(tf);
				tf.background = true;
				tf.selectable = false;
				tf.text = "" + e;
				return;
			}
			_buffer = _bitmapData.clone();
			_bitmap = new Bitmap(_buffer, "auto", true);
			_bitmap.width = WIDTH;
			_bitmap.height = HEIGHT;
			_cmf.matrix = [0.3086, 0.6094, 0.082, 0, 0, 
						   0.3086, 0.6094, 0.082, 0, 0, 
						   0.3086, 0.6094, 0.082, 0, 0,
						   0, 0, 0, 1, 0];
			_bitmap.filters = [_cmf];
			addChild(_bitmap);
			clearLoader(e.target as LoaderInfo);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		private function IOErr(e:IOErrorEvent):void
		{
			throw new Error("Image not Found");
			clearLoader(e.target as LoaderInfo);
		}
		
		private function clearLoader(e:LoaderInfo):void
		{
			e.removeEventListener(Event.COMPLETE, onComplete);
			e.removeEventListener(IOErrorEvent.IO_ERROR, IOErr);
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			var light:Vector3D = new Vector3D();
			light.x = mouseX / WIDTH * 2 - 1;
			light.y = 1 - mouseY / HEIGHT * 2;
			var len:Number = light.length;
			(len > 1) ? light.z = 0 : light.z = Math.sin(Math.acos(len));
			light.normalize();
			_cmf.matrix = [2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
						   2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
						   2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
						   0		  , 0		   , 0			, 1, 0];
			_buffer.applyFilter(_bitmapData, _bitmapData.rect, new Point(), _cmf);
			e.updateAfterEvent();
		}
	}
}
