package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.filters.ConvolutionFilter;
	
	import net.hires.debug.Stats;
	
	[SWF(backgroundColor = 0x00, width = "640", height = "512")]

	public class LightEffect extends Sprite
	{
		private static var URL:String = "assets/Render-2.png";
		
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _buffer:BitmapData;
		private var _cmf:ColorMatrixFilter;
		private var _cf:ConvolutionFilter;
		private var _stat:Stats;
		private var _statVis:Boolean = false;
		
		public function LightEffect():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			} else {
				removeEventListener(Event.ADDED_TO_STAGE, onStageAdd);
				init();
			}
		}
		
		private function onStageAdd(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			loadImage(URL);
		}
		
		private function loadImage(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			loader.load(new URLRequest(url), new LoaderContext(true));
		}
		
		private function onLoadComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var image:DisplayObject = loaderInfo.content as DisplayObject;
			_bitmapData = Bitmap(image).bitmapData;
			clearLoader(event.target as LoaderInfo);
			
			_cmf = new ColorMatrixFilter();
			_cf = new ConvolutionFilter(3, 3);
			_buffer = _bitmapData.clone();
			_bitmap = new Bitmap(_buffer, "auto", true);
			_bitmap.width = stage.stageWidth;
			_bitmap.height = stage.stageHeight;
			_cmf.matrix = [0.3086, 0.6094, 0.082, 0, 0, 
						   0.3086, 0.6094, 0.082, 0, 0, 
						   0.3086, 0.6094, 0.082, 0, 0,
						   0, 0, 0, 1, 0];
			_bitmap.filters = [_cmf];
			addChild(_bitmap);
			addChild(_stat = new Stats());
			_stat.visible = _statVis;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.CLICK, function togleVis(e:*) { _stat.visible = !_stat.visible } );
		}
		
		private function IOError (event:IOErrorEvent):void
		{
			throw new Error("Image not found");
			clearLoader(event.target as LoaderInfo);
		}
		
		private function clearLoader(event:LoaderInfo):void
		{
			event.removeEventListener(Event.COMPLETE, onLoadComplete);
			event.removeEventListener(IOErrorEvent.IO_ERROR, IOError);
		}
		
		private function onMouseMove (event:MouseEvent):void
		{
			var light:Vector3D = new Vector3D();
			(mouseX > stage.stageWidth /2) ? light.x = mouseX / stage.stageWidth * 2  - 1:
				light.x = 1 - mouseX / stage.stageWidth * 2;
			(mouseY > stage.stageHeight / 2) ? light.y = 1 - mouseY / stage.stageHeight * 2:
				light.y = mouseY / stage.stageHeight * 2 - 1;
				
			var pixelColor:uint = _bitmapData.getPixel(light.x, light.y);
			var r:uint = pixelColor >> 16 & 0xFF;
			var g:uint = pixelColor >> 8 & 0xFF;
			var b:uint = pixelColor >> 0 & 0xFF;
			var len:Number = light.length;
			(len > 1) ? light.z = 0 : light.z = Math.sin(Math.acos(len));
			light.normalize();
			_cmf.matrix = [Math.max(r * light.x >> 1, 2 * light.x), Math.max(r * light.y >> 1, 2 * light.y), 2 * light.z, 0, (light.x + light.y + light.z) ^ -0xFF,
						   Math.max(g * light.x >> 1, 2 * light.x), Math.max(g * light.y >> 1, 2 * light.y), 2 * light.z, 0, (light.x + light.y + light.z) ^ -0xFF,
						   Math.max(b * light.x >> 1, 2 * light.x), Math.max(b * light.y >> 1, 2 * light.y), 2 * light.z, 0, (light.x + light.y + light.z) ^ -0xFF,
						   0		  , 0		   , 0			, 1, 0];
			_buffer.applyFilter(_bitmapData, _bitmapData.rect, new Point(), _cmf);
			_cf.matrix = [ 0, -light.z,  0,
						  -light.z,  5 * light.z, -light.z,
						   0,  -light.z,  0];
			_cf.bias = 5.5;
			_buffer.applyFilter(_buffer, _buffer.rect, new Point(), _cf);
			event.updateAfterEvent();
		}
	}
}