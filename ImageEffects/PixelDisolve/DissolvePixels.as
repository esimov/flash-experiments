package {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLRequest;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.filters.ColorMatrixFilter;
	
	[SWF (backgroundColor = 0x000000, width = 1200, height = 800)]
	
	public class DissolvePixels extends Sprite {
		private static const PATH:String = "assets/harbor.jpg";
		private var _image:BitmapData;
		private var _bmpData:BitmapData;
		private var _bitmaps:Vector.<Bitmap>;
		private static const NUM_ROWS:Number = 5;
		private static const NUM_COLS:Number = 5;
		
		public function DissolvePixels():void {
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(evt:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			importImage(PATH);
		}
		
		private function importImage(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(path));
		}
		
		private function onLoadComplete(evt:Event):void {
			var scaleX:Number;
			var scaleY:Number;
			
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			_image = bitmap.bitmapData;
			_bitmaps = new Vector.<Bitmap>();
			
			var imageH:Number = stage.stageHeight / NUM_COLS;
			var imageW:Number = stage.stageWidth / NUM_ROWS;
			if (imageH > NUM_COLS * _image.height && imageW > NUM_ROWS * _image.width)  {					  
				scaleX = _image.width / imageW;
				scaleY = _image.height / imageH;
			}
			else {
				scaleX = imageW / _image.width;
				scaleY = imageH / _image.height;
			}
			var matrix:Matrix = new Matrix();
			_bmpData = new BitmapData(_image.width * scaleX, _image.height * scaleY);
			matrix.scale(scaleX, scaleY);
			_bmpData.draw(_image, matrix);
			
			for (var row:uint = 0; row< NUM_ROWS; row++) {
				for (var col:uint = 0; col< NUM_COLS; col++) {
					createBitmaps(col * imageW, row * imageH);
				}
			}
			
			drawBitmap();
			changeColors();
			stage.addEventListener(MouseEvent.CLICK, onImageClick);
		}
		
		private function createBitmaps(x:Number, y:Number):void {
			var bitmap:Bitmap = new Bitmap();
			bitmap.x = x;
			bitmap.y = y;
			addChild(bitmap);
			_bitmaps.push(bitmap);
		}
		
		private function drawBitmap():void {
			for each (var bitmap:Bitmap in _bitmaps) {
				bitmap.bitmapData = _bmpData.clone();
				trace (_bitmaps.length);
			}
		}
		
		private function onImageClick (evt:MouseEvent):void {
			for each (var image:Bitmap in _bitmaps) {
				if (image.hitTestPoint(evt.localX, evt.localY)) {
					var time:Timer = new Timer(10, 0);
					time.start();
					time.addEventListener(TimerEvent.TIMER, onStartTime);
				}
			}
		}
		
		private function applyFilter(bitmap:Bitmap):void {
			var matrix:Array = new Array(1, 0, 0, 0, 50,
										 0, 1, 0, 0, 50,
										 0, 0, 1, 0, 50,
										 0, 0, 0, 1, 0);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			bitmap.filters = [filter];
		}
		
		private function changeColors():void {
			for (var i:uint = 0; i< _bitmaps.length; i +=2) {
				applyFilter(_bitmaps[i]);
			}
		}

		private function onStartTime(evt:TimerEvent):void {
			var numPixels:int;
			var randomSeed:int = Math.floor(Math.random() * int.MAX_VALUE);
			for (var i:uint = 1; i< _bitmaps.length; i++) {
				numPixels = (_bitmaps[i].bitmapData.width * _bitmaps[i].bitmapData.height) / i*3;
				randomSeed = _bitmaps[i-1].bitmapData.pixelDissolve(_bitmaps[i-1].bitmapData, _bitmaps[i-1].bitmapData.rect, new Point(), randomSeed, numPixels);
				_bitmaps[i].bitmapData.pixelDissolve(_bitmaps[i].bitmapData, _bitmaps[i].bitmapData.rect, new Point(0,0), randomSeed, numPixels);
				evt.updateAfterEvent();
			}
		}
	}
}