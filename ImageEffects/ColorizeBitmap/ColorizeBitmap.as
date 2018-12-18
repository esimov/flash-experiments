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
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	[SWF (backgroundColor = 0x000000, width = 1200, height = 800)]
	
	public class ColorizeBitmap extends Sprite {
		private static const PATH:String = "assets/harbor.jpg";
		private var _image:BitmapData;
		private var _bmpData:BitmapData;
		private var _bitmaps:Vector.<Bitmap>;
		private static const NUM_ROWS:Number = 4;
		private static const NUM_COLS:Number = 4;
		
		public function ColorizeBitmap():void {
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
					drawBitmap();
				}
			}
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
					changeBitmapColors(_bmpData);
					break;
				}
			}
		}
		
		private function colorizeBitmaps(origBmpData:BitmapData, color:ColorTransform):BitmapData {
			var variation:BitmapData = origBmpData.clone();
			variation.colorTransform(origBmpData.rect, color);
			return variation;
		}
		
		private function changeBitmapColors(original:BitmapData):void {
			var red:uint = Math.random() * 2 + 2.5;
			var green:uint = Math.random() * 2 + .5;
			var blue:uint = Math.random() * 2 + 1.5;
			_bitmaps[0].bitmapData = colorizeBitmaps(original, new ColorTransform (red, green, blue));
			for (var i:uint = 1; i< _bitmaps.length; i++) {
				_bitmaps[i].bitmapData = colorizeBitmaps(_bitmaps[i-1].bitmapData, new ColorTransform (red, green, blue));
			}
		}
	}
}