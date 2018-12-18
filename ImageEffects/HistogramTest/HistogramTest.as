package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF (backgroundColor = 0x000000, width = 864, height = 314)]
	
	public class HistogramTest extends AbstractImageLoader {
		private var _histogram:Vector.<Vector.<Number>>;
		
		public function HistogramTest():void {
			super("assets/image.jpg");
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		/**
		* Dispatch event to notify when stage is activated
		*/
		
		private function onStageAdded(evt:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override protected function postImage():void {
			_histogram = _loadedBitmap.bitmapData.histogram();
			var maxPixel:uint = getMaxPixels(_histogram);
			var channelData:BitmapData = new BitmapData(_loadedBitmap.width, _loadedBitmap.height, true, 0xFF000000);
			drawChannelHistogram(channelData, maxPixel, _histogram[0], BitmapDataChannel.RED);
			drawChannelHistogram(channelData, maxPixel, _histogram[1], BitmapDataChannel.GREEN);
			drawChannelHistogram(channelData, maxPixel, _histogram[2], BitmapDataChannel.BLUE);
			var histogramBitmap:Bitmap = new Bitmap(channelData);
			
			addChild(_loadedBitmap);
			addChild(histogramBitmap);
			histogramBitmap.x = _loadedBitmap.width;
			//trace (_loadedBitmap.height - histogramBitmap.height);
			//trace (_loadedBitmap.width + "," + _loadedBitmap.height);
			var bottomArea:Rectangle = _loadedBitmap.getBounds(this);
			histogramBitmap.y = bottomArea.bottom - histogramBitmap.height;
		}
		
		private function getMaxPixels(histogram:Vector.<Vector.<Number>>):uint {
			var channel:Vector.<Number>;
			var maxPixels:uint = 0;
			
			for (var i:uint = 0; i< 3; i++) {
				channel = histogram[i];
				for (var c:uint = 0; c< 256; c++) {
					maxPixels = Math.max(channel[c], maxPixels);
				}
			}
			return maxPixels;
		}
		
		private function drawChannelHistogram(bitmapData:BitmapData, 
											  maxPixels:uint,
											  channelData:Vector.<Number>,
											  histogramChannel:uint):void {
			var histogram:BitmapData = bitmapData.clone();
			var max:Number;
			for (var x:uint = 0; x< 256; x++) {
				max = channelData[x] / maxPixels * 256;
				histogram.fillRect(new Rectangle(x*2, _loadedBitmap.height-max, 1, max), 0xffffffff);
			}
			
			bitmapData.copyChannel(histogram, histogram.rect, new Point(), histogramChannel, histogramChannel);
		}
	}
}