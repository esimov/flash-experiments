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
	import flash.filters.BlurFilter;
	
	import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.HUISlider;
	
	//[SWF (background = 0x00, width = "800", height = "800")]

	public class AbstractShader1 extends Sprite
	{
		private var _shaderURL:String;
		private var _shaderJob:ShaderJob;
		private var _shaderLoader:URLLoader;
		private var _bmpData:BitmapData;
		public var _bmp:Bitmap;
			
		public var _shader:Shader;
		public var _window:Window;
		public var _red:HUISlider;
		public var _green:HUISlider
		public var _blue:HUISlider;
		public var _xOff:HUISlider;
		public var _yOff:HUISlider;
		
		protected var time:Number = getTimer() * 0.0001;
		protected var offsetX:Number = 0;
		protected var offsetY:Number = 0;
		
		public const WIDTH:Number = stage.stageWidth;
		public const HEIGTH:Number = stage.stageHeight;
		public var centerX:Number = WIDTH/2;
		public var centerY:Number = HEIGTH/2;
		
		public function AbstractShader1(shaderURL:String = ""):void
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
			
			//controlPanel();
		
			_shaderLoader = new URLLoader();
			_shaderLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_shaderLoader.addEventListener(IOErrorEvent.IO_ERROR, shaderLoadError);
			_shaderLoader.addEventListener(Event.COMPLETE, onLoadShader);
			_shaderLoader.load(new URLRequest(_shaderURL));
			
			_bmpData = new BitmapData(WIDTH, HEIGTH, false, 0x00);
			_bmp = new Bitmap(_bmpData);
			_bmp.smoothing = false;
			_bmp.scaleX = _bmp.scaleY = 1;
			_bmp.filters = [new BlurFilter(2,2)];
			addChild(_bmp);
		}
		
		//Create the control panel. Should be overrided on the main class
		
		protected function controlPanel():void
		{		
			Style.setStyle(Style.DARK);
			_window = new Window(this, WIDTH - 100, 0, "Effect adjuster");
			_window.draggable = true;
			_window.hasMinimizeButton = true;
			_window.width = 120;
			_window.height = 130;
			addChild(_window);
			
			var redLabel:Label = new Label(_window, 1, 10, "R: ");
			var greenLabel:Label = new Label(_window, 1, 30, "G: ");
			var blueLabel:Label = new Label(_window, 1, 50, "B: ");
			_red = new HUISlider(_window, 8, 10,null);
			_red.width = _window.width;
			_red.tick = 0.01;
			_red.setSliderParams(0.0, 5.0, 0.8);
			_green = new HUISlider(_window, 8, 30,null);
			_green.width = _window.width;
			_green.tick = 0.01;
			_green.setSliderParams(0.0, 5.0, 0.5);
			_blue = new HUISlider(_window, 8, 50,null);
			_blue.width = _window.width;
			_blue.tick = 0.01;
			_blue.setSliderParams(0.0, 5.0, 0.1);
		}
		
		private function shaderLoadError(event:IOErrorEvent):void
		{
			throw new Error("Shader loading has failed");
			_shaderLoader.removeEventListener(IOErrorEvent.IO_ERROR, shaderLoadError);
		}
				
		protected function onLoadShader(event:Event):void
		{
			_shaderLoader.removeEventListener(Event.COMPLETE, onLoadShader);
			_shader = new Shader(event.currentTarget.data as ByteArray);
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		protected function loop(event:Event):void
		{
			_shaderJob = new ShaderJob(_shader, _bmpData);
			_shaderJob.start();
		}
	}
}

