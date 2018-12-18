package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	[SWF (background = 0x00, width = "400", height = "400")]

	public class AbstractShader extends Sprite
	{
		private var _imageURL:String;
		private var _shaderURL:String;
		private var _shader:Shader;
		private var _shaderJob:ShaderJob;
		private var _imageLoader:Loader;
		private var _shaderLoader:URLLoader;
		private var _bmpData:BitmapData;
		private var _bmp:Bitmap;
	
		private var time:Number = 0;
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGTH:Number = stage.stageHeight;
		private var centerX:Number = WIDTH/2;
		private var centerY:Number = HEIGTH/2;
		
		public function AbstractShader(shaderURL:String = ""):void
		{
			_shaderURL = shaderURL;
			initStage();
		}
		
		private function initStage():void
		{
			if (stage) init(null);
			else
			{
				throw new Error("Stage not active");
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(event:*):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = "medium";
			stage.frameRate = 60;
			
			_bmpData = new BitmapData(WIDTH/2, HEIGTH/2, false, 0x00);
			_bmp = new Bitmap(_bmpData);
			_bmp.smoothing = false;
			_bmp.scaleX = _bmp.scaleY = 2;
			addChild(_bmp);
			
			_shaderLoader = new URLLoader();
			_shaderLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_shaderLoader.addEventListener(IOErrorEvent.IO_ERROR, shaderLoadError);
			_shaderLoader.addEventListener(Event.COMPLETE, onLoadShader);
			_shaderLoader.load(new URLRequest(_shaderURL));
		}
		
		private function shaderLoadError(event:IOErrorEvent):void
		{
			throw new Error("Shader loading has failed");
			_shaderLoader.removeEventListener(IOErrorEvent.IO_ERROR, shaderLoadError);
		}
				
		private function onLoadShader(event:Event):void
		{
			_shaderLoader.removeEventListener(Event.COMPLETE, onLoadShader);
			_shader = new Shader(event.currentTarget.data as ByteArray);
			_shader.data.resolution.value = [WIDTH/2, HEIGTH/2];
			_shader.data.offsetX.value = [centerX];
			_shader.data.offsetY.value = [offsetY];
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			_shaderJob = new ShaderJob(_shader, _bmpData);
			_shaderJob.start();
			
			offsetX += (mouseX - centerX) * 0.00012;
			offsetY += (mouseY - centerY) * 0.00012;
			
			time += 0.008;
			_shader.data.time.value = [time];
			_shader.data.offsetX.value = [offsetX];
			_shader.data.offsetY.value = [offsetY];
		}
	}
}

