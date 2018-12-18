package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import com.bit101.components.*;
	import flash.filters.ColorMatrixFilter;
	import fl.motion.AdjustColor;
	import fl.transitions.Tween;
	import fl.transitions.easing.Elastic;
	import fl.transitions.TweenEvent;
	import flash.display.Shape;
	
	[SWF (backgroundColor = 0x000000, width = 600, height = 628)]
	
	public class HistogramTest3 extends AbstractImageLoader {
		private var _histograms:Vector.<Vector.<Number>>;
		private var _channels:Vector.<Number>;
		private var _channelsData:Vector.<BitmapData>;
		private var _channelsBitmap:Vector.<Bitmap>;
		private var _histogramBitmap:Bitmap;
		private var _histogramData:BitmapData;
		private var _colorMatrix:Array = [];
		private var _maxPixel:Number ;
		private var _value:Number;
		private var _adjustColor:AdjustColor;
		private static const COEF:Number = 9;
		private var _colorChange:Boolean = false;
		private var _max:Number;
		
		private var _redSlider:HSlider;
		private var _greenSlider:HSlider;
		private var _blueSlider:HSlider;
		private var _alphaSlider:HSlider;
		private var _brightness:HSlider;
		private var _contrast:HSlider;
		private var _hue:HSlider;
		private var _saturation:HSlider;
		private var _level:RangeSlider;
		
		private var r:Array = [];
		private var g:Array = [];
		private var b:Array = [];
		
		private static const CHANNELS:uint = 4;
		
		public function HistogramTest3():void {
			super ("assets/image.jpg");
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageAdded(evt:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
		}
		
		override protected function postImage():void {
			addChild(_loadedBitmap);
					
			createHistogramChannels();
			createHistogramBitmaps();
			createSliderPanel();
			
			// Loop trough bitmap array and draw the histogram channels
			for (var c:uint = 0; c < CHANNELS; c++) {
				var channel:BitmapData = _channelsData[c] as BitmapData;
				drawHistogramChannel(channel, _histograms[c], _maxPixel, Math.pow(2, c));
				trace(channel);
			}
			drawHistogramChannel(channel, _histograms[3], _maxPixel, 8);
		}
		
		/**
			Use the custom panel components by Keith Peters to simulate the color variations
		*/
			
		private function createSliderPanel():void {
			var topPanel:Panel = new Panel(this, _loadedBitmap.width, _loadedBitmap.y);
			var vDistance:Number = 20;
			topPanel.color = 0xF5F3F3;
			topPanel.setSize(stage.stageWidth - _loadedBitmap.width, _loadedBitmap.height * 2);
			var panel:Panel = new Panel(topPanel, this.x + 5, this.y + 5);
			panel.setSize(topPanel.width - 10, topPanel.height - 10);
			panel.color = 0x212121;
			panel.gridColor = 0x000000;
			panel.shadow = true;
			
			var colorSelector:Label = new Label(panel, panel.x, panel.y, "Image Color Manipulation");
			
			// Red channel slider
			var redLabel:Label = new Label(panel, panel.x, colorSelector.y + vDistance, "Red Channel");
			_redSlider = new HSlider(panel, redLabel.x , redLabel.y + vDistance, sliderHandler);
			_redSlider.setSize(130, 10);
			_redSlider.value = 1;
			_redSlider.maximum = 255;
			_redSlider.minimum = 1;
			
			// Green channel slider
			var greenLabel:Label = new Label(panel, redLabel.x, _redSlider.y + vDistance, "Green Channel");
			_greenSlider = new HSlider(panel, greenLabel.x, greenLabel.y + vDistance, sliderHandler);
			_greenSlider.setSize(130, 10);
			_greenSlider.value = 1;
			_greenSlider.maximum = 255;
			_greenSlider.minimum = 1;
			
			// Green channel slider
			var blueLabel:Label = new Label(panel, greenLabel.x, _greenSlider.y + vDistance, "Blue Channel");
			_blueSlider = new HSlider(panel, blueLabel.x, blueLabel.y + vDistance, sliderHandler);
			_blueSlider.setSize(130, 10);
			_blueSlider.value = 1;
			_blueSlider.maximum = 255;
			_blueSlider.minimum = 1;
			
			// Alpha channel slider
			var alphaLabel:Label = new Label (panel, blueLabel.x, _blueSlider.y + vDistance, "Alpha Channel");
			_alphaSlider = new HSlider(panel, alphaLabel.x, alphaLabel.y + vDistance, sliderHandler);
			_alphaSlider.setSize(130, 10);
			_alphaSlider.value = 1;
			_alphaSlider.maximum = 255;
			_alphaSlider.minimum = 1;
			
			var brightnessLabel:Label = new Label(panel, alphaLabel.x, _alphaSlider.y + vDistance, "Brightness");
			_brightness = new HSlider(panel, brightnessLabel.x, brightnessLabel.y + vDistance, sliderHandler);
			_brightness.setSize (130, 10);
			_brightness.value = 0;
			_brightness.maximum = 100;
			_brightness.minimum = 1;
			
			var contrastLabel:Label = new Label(panel, brightnessLabel.x, _brightness.y + vDistance, "Contrast");
			_contrast = new HSlider (panel, contrastLabel.x, contrastLabel.y + vDistance, sliderHandler);
			_contrast.setSize (130, 10);
			_contrast.value = 0;
			_contrast.maximum = 100;
			_contrast.minimum = 1;
			
			var hueLabel:Label = new Label(panel, contrastLabel.x, _contrast.y + vDistance, "Hue");
			_hue = new HSlider (panel, hueLabel.x, hueLabel.y + vDistance, sliderHandler);
			_hue.setSize (130, 10);
			_hue.value = 0;
			_hue.maximum = 100;
			_hue.minimum = 1;
			
			var satLabel:Label = new Label(panel, hueLabel.x, _hue.y + vDistance, "Saturation");
			_saturation = new HSlider (panel, satLabel.x, satLabel.y + vDistance, sliderHandler);
			_saturation.setSize (130, 10);
			_saturation.value = 0;
			_saturation.maximum = 100;
			_saturation.minimum = 1;
			
			var level:Label = new Label(panel, satLabel.x, _saturation.y + vDistance, "Level");
			_level = new RangeSlider (RangeSlider.HORIZONTAL, panel, level.x, level.y + vDistance + 10, levelSliderHandler);
			_level.setSize(130, 10);
			_level.minimum = 0;
			_level.maximum = 255;
			_level.lowValue = 0;
			_level.highValue = 255;
			_level.labelPosition= "top";
			_level.labelMode = "move";
			_max = _level.maximum / 2;
		}
		
		/** 
			Adjust the brightness values of all pixels by remapping the bitmap with paletteBitmap()
			@param bitmapData The bitmap data to adjust
			@param black The number between 0 and 255 below all the pixels in the palette will have a brightness value of 0
			@param gray The number between black and white below all the pixels in the pallette will have a brightness value of 127
			@param white The number between 0 and 255 below all the pixels in the palette will have a brightness value of 255
		*/
		private function setLevels(bitmapData:BitmapData, min:uint, mid:uint, max:uint):void {
			min = _level.lowValue;
			max = _level.highValue;
			for (var i:Number = 0; i<= min; i++) {
				r.push(0x00);
				g.push(0x00);
				b.push(0x00);
			}
			var range:Number = mid - min;
			var value:uint = 0;
			for (i = min + 1; i <= mid; i++) {
				value = ((i - min) / range) * mid;
				r.push(value << 16);
				g.push(value << 8);
				b.push(value);
			}
			
			range = max - mid;
			for (i = mid + 1; i <= max; i++) {
				value = ((i - mid) / range) * mid + 128;
				r.push(value << 16);
				g.push(value << 8);
				b.push(value);
			}
			
			for (i = max+1; i <= 255; i++) {
				 r.push(0xff << 16);
				 g.push(0xff << 8);
				 b.push(0xff);
			}
			
			bitmapData.paletteMap(bitmapData, bitmapData.rect, new Point(), r, g, b);
/*			r.splice(0, r.length);
			g.splice(0, g.length);
			b.splice(0, b.length);
*/		}
		
		private function levelSliderHandler(evt:Event):void {
			if (_level.lowValue < _max || _level.highValue > _max){
				setLevels(_loadedBitmap.bitmapData, _level.lowValue, _max, _level.highValue);
				_histogramData = _loadedBitmap.bitmapData.clone();
				_histogramBitmap = new Bitmap(_histogramData);
				redrawHistogram();
			
					for (var c:uint = 0; c < CHANNELS; c++) {
						var channel:BitmapData = _channelsData[c] as BitmapData;
						drawHistogramChannel(channel, _histograms[c], _maxPixel, Math.pow(2, c));
					}
					drawHistogramChannel(channel, _histograms[3], _maxPixel, 8);
			}
			
			else if (_level.lowValue >= _max) {
				_level.lowValue = _max;
			}
			
			else if (_level.highValue <= _max) {
				_level.highValue = _max;
			}
		}
		
		private function sliderHandler(evt:Event):void {
			_adjustColor = new AdjustColor();
			var tweenColor:Tween = new Tween(_adjustColor, "contrast", Elastic.easeOut, 0, 100, 2, true);
			if (evt.currentTarget == _redSlider || evt.currentTarget == _greenSlider || 
				evt.currentTarget == _blueSlider || evt.currentTarget == _alphaSlider) {
				if (_redSlider.value !== 0 || _greenSlider.value !== 0 || _blueSlider.value !== 0 || _alphaSlider.value !== 0) {
					var matrix: Array = new Array(1, 0, 0, 0, _redSlider.value,
											  	  0, 1, 0, 0, _greenSlider.value,
											  	  0, 0, 1, 0, _blueSlider.value,
											  	  0, 0, 0, 1, _alphaSlider.value);
					_colorMatrix = matrix;
					var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(_colorMatrix);
					_loadedBitmap.filters = [colorFilter];
					_histogramData = _loadedBitmap.bitmapData.clone();
					_histogramData.applyFilter(_histogramData, _histogramData.rect, new Point(), colorFilter);
					_histogramBitmap = new Bitmap(_histogramData);
					
					redrawHistogram();
		
					for (var c:uint = 0; c < CHANNELS; c++) {
						var channel:BitmapData = _channelsData[c] as BitmapData;
						drawHistogramChannel(channel, _histograms[c], _maxPixel, Math.pow(2, c));
					}
					drawHistogramChannel(channel, _histograms[3], _maxPixel, 8);
				}
			}
				
			switch (evt.currentTarget) {
				case _brightness:
				_adjustColor.brightness = _brightness.value;
				_adjustColor.contrast = _contrast.value;
				_adjustColor.hue = _hue.value;
				_adjustColor.saturation = _saturation.value;
				_colorMatrix = _adjustColor.CalculateFinalFlatArray();
				tweenColor.addEventListener(TweenEvent.MOTION_CHANGE, onImageChange);				
				break;
				
				case _contrast:
				_adjustColor.brightness = _brightness.value;
				_adjustColor.contrast = _contrast.value;
				_adjustColor.hue = _hue.value;
				_adjustColor.saturation = _saturation.value;
				_colorMatrix = _adjustColor.CalculateFinalFlatArray();
				tweenColor.addEventListener(TweenEvent.MOTION_CHANGE, onImageChange);
				break;
				
				case _hue:
				_adjustColor.brightness = _brightness.value;
				_adjustColor.contrast = _contrast.value;
				_adjustColor.hue = _hue.value;
				_adjustColor.saturation = _saturation.value;
				_colorMatrix = _adjustColor.CalculateFinalFlatArray();
				tweenColor.addEventListener(TweenEvent.MOTION_CHANGE, onImageChange);
				break;
				
				case _saturation:
				_adjustColor.brightness = _brightness.value;
				_adjustColor.contrast = _contrast.value;
				_adjustColor.hue = _hue.value;
				_adjustColor.saturation = _saturation.value;
				_colorMatrix = _adjustColor.CalculateFinalFlatArray();
				tweenColor.addEventListener(TweenEvent.MOTION_CHANGE, onImageChange);
				break;
				
				case _level:
				
				default:
				break;
			}
		}
		
		
		private function onImageChange (evt:TweenEvent):void {
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(_colorMatrix);
			_loadedBitmap.filters = [colorFilter];
			_histogramData = _loadedBitmap.bitmapData.clone();
			_histogramData.applyFilter(_histogramData, _histogramData.rect, new Point(), colorFilter);
			_histogramBitmap = new Bitmap(_histogramData);
				
			redrawHistogram();

			for (var c:uint = 0; c < CHANNELS; c++) {
				var channel:BitmapData = _channelsData[c] as BitmapData;
				drawHistogramChannel(channel, _histograms[c], _maxPixel, Math.pow(2, c));
			}
			drawHistogramChannel(channel, _histograms[3], _maxPixel, 8);
		}
		
		
		/**
		 Calculate the highest pixel value running through the 4 channels with a for loop
		*/
		
		private function getMaxPixel(histogram:Vector.<Vector.<Number>>):Number {
			var channel:Vector.<Number>;
			var maxPixel:Number = 0;
			
			for (var i:uint = 0; i< CHANNELS; i++) {
				channel = histogram[i];
				for (var c:uint = 0; c< 256; c++) {
					maxPixel = Math.max(channel[c], maxPixel);
				}
			}
			
			return maxPixel;
		}
		
		private function createHistogramChannels():void {
			var channel:Bitmap;
			_channelsData = new Vector.<BitmapData>();
			_channelsBitmap = new Vector.<Bitmap>();
			for (var i:uint = 0; i< CHANNELS; i++) {
				var channelData:BitmapData = new BitmapData(_loadedBitmap.width, _loadedBitmap.height/4, true, 0xff000000);
				_channelsData.push(channelData);
				channel = new Bitmap(channelData);
				_channelsBitmap.push(channel);
				addChild(channel);
			}
		}
		
		private function createHistogramBitmaps():void {
			_histograms = _loadedBitmap.bitmapData.histogram();
			_maxPixel = getMaxPixel(_histograms);
			for (var i:uint = 0; i < CHANNELS; i++) {
				var channel:Bitmap = _channelsBitmap[i];
				channel.x = _loadedBitmap.x;
				channel.y = _loadedBitmap.height + (i*_loadedBitmap.height/4);
			}
		}
		
		private function redrawHistogram():void {
			_histograms = _histogramBitmap.bitmapData.histogram();
			_maxPixel = getMaxPixel(_histograms);
		}
		
		private function drawHistogramChannel(channelData:BitmapData,
											  histogram:Vector.<Number>,
											  maxPixel:uint,
											  channelHistogram:uint):void
		{
			var max:Number;
			var peak:Shape = new Shape();
			var histogramData:BitmapData = channelData.clone();
			histogramData.fillRect(new Rectangle(0, 0, channelData.width, channelData.height), 0x000000);
				for (var c:uint = 0; c < 256; c++) {
					max = histogram[c] / maxPixel * 256;
					histogramData.fillRect(new Rectangle (c*2, channelData.height - max * 20, 2, max * 20), 0xffffffff);
				}
			channelData.copyChannel(histogramData, histogramData.rect, new Point(), channelHistogram, channelHistogram);
		}
	}
}
