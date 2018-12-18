package
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.display.BitmapDataChannel;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	[SWF(backgroundColor = "0x00", width = '480', height = '360')]
	
	public class WaterRipple extends Sprite
	{
		[Embed(source="../assets/image/ocean-life_small.jpg", mimeType="image/jpeg")]
		private var Image:Class;
		
		[Embed(source="../assets/pbj/WaterEffect.pbj", mimeType="application/octet-stream")]
		private var WaterShader:Class;
		
		private var _bmpData1:BitmapData;
		private var _bmpData2:BitmapData;
		private var _active:BitmapData;
		private var _temp:BitmapData;
		private var _image:Bitmap;
		
		private var _shader:Shader;
		private var _shaderFilter:ShaderFilter;
		private var _displacement:DisplacementMapFilter;
		
		public function WaterRipple():void
		{
			_image = Bitmap(new Image());
			addChild(_image);
			_bmpData1 = new BitmapData(_image.width, _image.height, false, 0);
			_bmpData2 = new BitmapData(_image.width, _image.height, false, 0);
			_active = _bmpData1;
			_temp = _bmpData2;
			initShaders();
			_displacement = new DisplacementMapFilter(_active, new Point(0,0), BitmapDataChannel.RED, BitmapDataChannel.RED, 40, 40, "clamp");
			
			addEventListener(Event.ENTER_FRAME, onStart);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			var timer:Timer = new Timer(1000/4, 0);
			timer.addEventListener(TimerEvent.TIMER, startTime);
			timer.start();
		}
		
		private function initShaders():void
		{
			_shader = new Shader(new WaterShader() as ByteArray);
			_shader.data.buffer1.input = _active;
			_shader.data.buffer2.input = _temp;
			_shader.data.damping.value = [1.052];
			_shaderFilter = new ShaderFilter(_shader);
		}
		
		private function update():void
		{
			_shader.data.buffer2.input = _active;
			_shader.data.buffer1.input = _temp;
			_active.applyFilter(_temp, _active.rect, new Point(), _shaderFilter);
		}
		
		private function startTime(event:TimerEvent):void
		{
			_active.fillRect(new Rectangle(randomPointX(), randomPointY(), Math.random() + 10 - 5, Math.random() + 10 - 5), 0xffffff);
		}
		
		private function onStart(event:Event):void
		{
			if (_active == _bmpData2)
			{
				_active = _bmpData1;
				_temp = _bmpData2;
			} else {
				_active = _bmpData2;
				_temp = _bmpData1;
			}
			_displacement.mapBitmap = _active;
			_image.filters = [_displacement];
			update();
		}
		
		private function randomPointX():int
		{
			var point:int = Math.random() * _image.width;
			return point;
		}
		
		private function randomPointY():int
		{
			var point:int = Math.random() * _image.height;
			return point;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			_active.fillRect(new Rectangle(mouseX, mouseY, 10, 10), 0xffffff);
		}
	}
}