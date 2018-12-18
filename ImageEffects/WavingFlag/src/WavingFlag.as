package {
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.geom.Point;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Transform;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.display.BlendMode;
	
	import aether.utils.ImageUtil;
	import flash.geom.ColorTransform;
	
	[SWF (backgroundColor = 0xBEEBF0, width = 420, height = 280)]
	
	public class WavingFlag extends AbstractImageLoader
	{
		private var _bitmap:BitmapData;
		private var _scaledImage:BitmapData;
		private var _noise:BitmapData;
		private var _gradient:BitmapData;
		private var _flagClone:BitmapData;
		private var _shadowFlag:Bitmap;
		private var _offset:Array;
		private var _seed:int;
		
		private static const WIND_RATE:Number = 14;
		
		public function WavingFlag():void 
		{
			if (stage)
			{
				try	
				{
					super("assets/flag.png");
				}
				catch (e:Error) { trace("Image not found" + e.message); }
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			else
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		
		private function init(e:Event):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override protected function postImage():void 
		{
			drawFlag();
			gradientOverlay();
			makeNoise();
			
			addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function drawFlag():void
		{
			_bitmap = _loadedBitmap.bitmapData;
			var stageHeight:Number = stage.stageHeight;
			var stageWidth:Number = stage.stageWidth;
			var bitmapHeight:Number = _bitmap.height;
			var bitmapWidth:Number = _bitmap.width;
			var pole:Shape = new Shape();
			var poleHeight:Number = stageHeight - 10;
			var poleWidth:Number = 15;
			var matrix:Matrix = new Matrix();
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.blurX = 15;
			shadow.blurY = 15;
			shadow.distance = 9;
			shadow.alpha = 0.7;
			shadow.hideObject = true;
			shadow.angle = 90;
			shadow.quality = BitmapFilterQuality.HIGH;
			
			matrix.createGradientBox(poleWidth, poleHeight);
			pole.graphics.beginGradientFill(GradientType.LINEAR, [0x333333, 0x666666, 0x999999, 0xCCCCCC, 0xAAAAAA], [1, 1, 1, 1, 1], [50, 80, 120, 180, 255], matrix);
			pole.graphics.drawRoundRect(0,0, poleWidth, poleHeight,5,5);
			pole.graphics.endFill();
			pole.x = 25;
			pole.y = stageHeight - poleHeight;
			var poleData:BitmapData = new BitmapData(poleWidth/2, poleHeight/2, true, 0x00000000);
			var poleBMP:Bitmap = new Bitmap(poleData);
			poleData.draw(pole);
			poleBMP.y = pole.y + poleHeight;
			poleBMP.x = pole.x + 5;
			poleBMP.filters = [shadow];
			poleBMP.rotation = 210;
			addChild(poleBMP);
			addChild(pole);
			
			var pt:Point = new Point((stageWidth - bitmapWidth)/2, (stageHeight - bitmapHeight)/2);
			
			var cord:Shape = new Shape();
			cord.graphics.lineStyle(2, 0x666666);
			cord.graphics.moveTo(pole.x, pole.y + 3);
			cord.graphics.lineTo(pt.x, pt.y);
			cord.graphics.moveTo(pole.x, pt.y + bitmapHeight + 15);
			cord.graphics.lineTo(pt.x, pt.y + bitmapHeight);
			
			var flag:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0x00000000);
			flag.copyPixels(_bitmap, _bitmap.rect, pt);
			flag.draw(cord);
			_bitmap = flag;
			_loadedBitmap.bitmapData = _bitmap;
			addChild(_loadedBitmap);
			
			_flagClone = _bitmap.clone();
			_shadowFlag = new Bitmap(_flagClone);
			var angle:Number = 30 * Math.PI / 180;
			matrix = new Matrix();
			matrix.c = - Math.tan(angle);
			matrix.a *= .9;
			matrix.b *= .8;
			trace (angle);
			_shadowFlag.transform.matrix = matrix;
			
			_shadowFlag.filters = [new DropShadowFilter(25, 45, 0, 0.4, 10, 10, 0.5,BitmapFilterQuality.HIGH, false, false, true)];
			_shadowFlag.x = _loadedBitmap.x + _loadedBitmap.width * 0.5;
			_shadowFlag.y = _loadedBitmap.y + _loadedBitmap.height * 0.2;
			addChildAt(_shadowFlag, numChildren -1);
		}
				
		private function gradientOverlay():void
		{
			var width:Number = stage.stageWidth;
			var height:Number = stage.stageHeight;
			_gradient = new BitmapData(width, height, true, 0x00000000);
			var gradient:Shape = new Shape();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height);
			gradient.graphics.beginGradientFill(GradientType.LINEAR, [0x7F7F7F, 0x7F7F7F], [1, 0], [20, 80], matrix);
			gradient.graphics.drawRect(0, 0, width, height);
			gradient.graphics.endFill();
			_gradient.draw(gradient);
		}
		
		private function makeNoise():void
		{
			_noise = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_seed = int(new Date());
			_offset = [new Point()];
		}
		 
		private function applyNoise():void
		{
			_noise.perlinNoise(200, 200, 1, _seed, false, true, BitmapDataChannel.RED, true, _offset);
			(_offset[0] as Point).x -= WIND_RATE;
		}
		
		private function waveFlag():void
		{
			applyNoise();
			_noise.copyPixels(_gradient, _gradient.rect, new Point(), _noise, new Point(), true);
			var flag:BitmapData = _bitmap.clone();
			ImageUtil.applyFilter(flag, new DisplacementMapFilter(_noise, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED, 60, 40));
			ImageUtil.applyFilter(_flagClone, new DisplacementMapFilter(_noise, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.BLUE, 20, 20));
			ImageUtil.copyChannel(flag, _noise, BitmapDataChannel.ALPHA);
			flag.draw(_noise, null, new ColorTransform(1, 1, 1, 0.5), BlendMode.HARDLIGHT);
			_loadedBitmap.bitmapData = flag;
		}
		
		private function onStartFrame(e:Event):void
		{
			waveFlag();
		}
	}
}