package
{
	import com.esimov.Particle;
	import com.esimov.ForceField;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	
	[SWF (backgroundColor = "0x00", width = "600", height = "600")]

	public class ParticleForm extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private const RECT:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT);
		
		private var _bmd1:BitmapData;
		private var _bmd2:BitmapData;
		private var _bmd3:BitmapData;
		private var _blur:BlurFilter;
		private var _text:TextField;
		private var _fps:TextField;
		private var _matrix:Matrix;
		private var _force:ForceField;
		private var _dimm:ColorMatrixFilter;
		private var _frame:Number = 0;
		private var _time:Number = 0;
		
		public function ParticleForm():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
				throw new Error("Stage not active");
			}
			else {
				initStage();
			}
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			initStage();
		}
		
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.frameRate = 60;
			stage.fullScreenSourceRect = RECT;
			
			_text = new TextField();
			var tf:TextFormat = new TextFormat("Arial", 500, 0xffffff);
			tf.bold = true;
			_text.defaultTextFormat = tf;
			_text.width = WIDTH;
			_text.height = HEIGHT;
			_text.text = " ";
			
			_fps = new TextField();
			tf.size = 12;
			tf.bold = false;
			_fps.defaultTextFormat = tf;
			_fps.background = true;
			_fps.autoSize = TextFieldAutoSize.LEFT;
			_fps.backgroundColor = 0x999999;
			
			_bmd1 = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			_bmd2 = _bmd1.clone();
			_bmd3 = _bmd1.clone();
			
			_matrix = new Matrix();
			_blur = new BlurFilter(10, 10, BitmapFilterQuality.MEDIUM);
			_dimm = new ColorMatrixFilter([0.99, 0, 0, 0, 0,
										  0, 0.99, 0, 0, 0,
										  0, 0, 0.99, 0, 0,
										  0, 0, 0, 1, 0]);
			
			_force = new ForceField(_bmd3);
			addChild(new Bitmap(_force));
			addChild(_fps);
					 
			addEventListener(Event.ENTER_FRAME, onStartFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, input);
		}
		
		
		private function random(min:int, max:int = NaN):int
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			return Math.random() * (max - min) + max;
		}
		
		private function input (e:KeyboardEvent):void
		{
			_text.text = String.fromCharCode(e.charCode);
			_bmd1.fillRect(RECT, 0x00);
			_bmd1.draw(_text)
			var r:Rectangle = _bmd1.getColorBoundsRect(0xff, 0x0, false);
            _bmd2.fillRect(RECT, 0x0);
            _matrix.identity();
            _matrix.translate(-r.x, -r.y);
            var a:Number = 300 / (Math.max(r.width, r.height));
            _matrix.scale(a, a);
            _matrix.translate((WIDTH - r.width * a) / 2, (HEIGHT - r.height * a) / 2);
            _bmd2.draw(_bmd1, _matrix);
		}
		
		private function onStartFrame(e:Event):void
		{
			++ _frame;
			if (getTimer() - _time > 1000)
			{
				_fps.text = _frame + " FPS";
				_time = getTimer();
				_frame = 0;
			}
			_bmd3.draw(_bmd2, null, new ColorTransform(random(0, 0.7), 1, 1, 0.7), "add");
			_bmd3.applyFilter(_bmd3, RECT, new Point(0,0), _blur);
			_bmd3.applyFilter(_bmd3, RECT, new Point(0,0), _dimm);
			_force.update();
		}
	}
}