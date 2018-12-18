package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.PixelSnapping;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.filters.ConvolutionFilter;
	import flash.filters.BlurFilter;
	
	[SWF (backgroundColor = 0x000000, width = 600, height = 780)]
	
	public class FillImage extends Sprite {
		private var _bitmapData:BitmapData;
		private var _newBmp:BitmapData;
		private var _matrix:Matrix;
		private var _palette:BitmapData;
		private var _currentColor:uint;
		private var _swatchSize:Number;
		private var _numColors:Number = 20;
			
		public function FillImage():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init();
		}
		
		private function init():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest("assets/castle.gif"));
		}
		
		private function onLoadComplete(evt:Event):void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			var filter:ConvolutionFilter = new ConvolutionFilter();
			var convolutionMatrix:Array = [1, 1, 1,
										   1, 5, 1,
										   1, 1, 1];
			_matrix = new Matrix();
			filter.matrixX = 3;
			filter.matrixY = 3;
			filter.divisor = 10;
			filter.bias = 10;
			filter.matrix = convolutionMatrix;
			if (bitmap.width > stage.stageWidth) {
				var scale:Number = Math.abs(bitmap.width / stage.stageWidth);
			} else {
				scale = Math.abs(stage.stageWidth / bitmap.width);
			}
			_bitmapData = bitmap.bitmapData;
			_matrix.scale(scale, scale);
			_newBmp = new BitmapData(bitmap.width * scale, bitmap.height * scale, true, 0x00ffffff);
			_newBmp.draw(_bitmapData, _matrix);
			var newBitmap:Bitmap = new Bitmap(_newBmp, PixelSnapping.AUTO, true);
			newBitmap.filters = [filter];
			addChild(newBitmap);
			drawSwatches();
		}
		
		private function drawSwatches():void {
			_swatchSize = Math.floor(stage.stageWidth / _numColors);
			_palette  = new BitmapData(stage.stageWidth, _swatchSize, false, 0xffffff);
			var rectangle:Rectangle = new Rectangle(0, 0, _swatchSize, _swatchSize);
			var lastSwatch:Number = _palette.width - _swatchSize;
			_currentColor = 0xffffffff;
			for (var i:uint = _swatchSize * 2; i<= lastSwatch; i+= _swatchSize) {
				var color:uint = Math.random() * 0xffffff;
				rectangle.x = i;
				color = 0xff << 24 | color;
				_palette.fillRect(rectangle, color);
			}
			
			var bitmap:Bitmap = new Bitmap(_palette);
			addChild(bitmap);
			bitmap.y = stage.stageHeight - _swatchSize;
			stage.addEventListener(MouseEvent.CLICK, onSelectColor);
		}
		
		private function onSelectColor(evt:MouseEvent):void {
			var x:Number = evt.localX;
			var y:Number = evt.localY;
			var selColRect:Rectangle = new Rectangle(0, 0, _swatchSize *2, _swatchSize);
			var getSwatch:Rectangle = _palette.rect;
			
			/*if (y > getSwatch.top && y < getSwatch.bottom) {
				_currentColor = _palette.getPixel32(x, y - _newBmp.height);
				_palette.fillRect(selColRect, _currentColor);
			}*/
			
			if (y > stage.stageHeight - _swatchSize) {
				_currentColor = _palette.getPixel32(x, y - (stage.stageHeight - _swatchSize));
				_palette.fillRect(selColRect, _currentColor);
			}
			else
			{
				_newBmp.floodFill(x, y, _currentColor);
			}
		}
	}
}