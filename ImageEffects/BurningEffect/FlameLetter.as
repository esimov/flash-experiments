package {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	import flash.display.BitmapDataChannel;
	import flash.geom.ColorTransform;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.events.Event;
	
	[SWF (backgroundColor = 0, width = 800, height = 600, frameRate = 60)]

	public class FlameLetter extends Sprite {
		private static const FLICKER_RATE:Number = 20;
		private var _flame:BitmapData;
		private var _perlinNoise:BitmapData;
		private var _perlinSeed:int;
		private var _perlinOffset:Array;
		private var _backField:TextField;
		public function FlameLetter():void {
			_flame = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x0000000);
			addChild(new Bitmap(_flame));
			makeLetter();
			applyGlowEffect();
			createNoise();
			//applyNoise();
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function makeLetter():TextField {
			var burningLetter:TextField = new TextField();
			burningLetter.selectable = false;
			burningLetter.autoSize = TextFieldAutoSize.LEFT;
			burningLetter.defaultTextFormat = new TextFormat("Arial", 60, 0x000000, true);
			burningLetter.text = "BURNING LETTER";
			burningLetter.x = stage.stageWidth/2 - burningLetter.width /2;
			burningLetter.y = stage.stageHeight/2 - burningLetter.height/2;
			addChild(burningLetter);
			return burningLetter;
		}
		
		private function applyGlowEffect():void {
			var field:TextField = makeLetter();
			field.filters = new Array(new GradientGlowFilter(0, 45, [0xff0000, 0xffff00], [1, 1], [50, 255], 40, 40));
			_backField = makeLetter();
			_backField.filters = [new BlurFilter(2, 2)];
		}
		
		private function createNoise():void {
			_perlinNoise = _flame.clone();
			_perlinSeed = int(new Date());
			_perlinOffset = new Array(new Point(), new Point());
		}
		
		private function applyNoise():void {
			_perlinNoise.perlinNoise(280, 120, 2, _perlinSeed, true, true, BitmapDataChannel.RED, false, _perlinOffset);
			(_perlinOffset[0] as Point).y += FLICKER_RATE;
			(_perlinOffset[1] as Point).y += FLICKER_RATE/2;
		}
		
		private function drawFlame():void {
			_flame.draw(stage, null, new ColorTransform(0.9, 0.7, 0.8, 0.8));
			_flame.lock();
			_flame.applyFilter(_flame, _flame.rect, new Point(0, 0), new BlurFilter(5, 5));
			//_flame.scroll(0, -5);
			applyNoise();
			_flame.applyFilter(_flame, _flame.rect, new Point(), 
								 new DisplacementMapFilter(_perlinNoise, new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.RED, 2, 16, 
															DisplacementMapFilterMode.CLAMP, 0));
			_flame.unlock();
		}
		
		private function onStartFrame(e:Event):void {
			_backField.visible = false;
			drawFlame();
			_backField.visible = true;
		}
	}
}