package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.BlendMode;
	
	import com.esimov.Ball;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	
	[SWF(backgroundColor = 0x333333, width = "480", height = "480")]

	public class Metaball extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		
		private var _balls:Vector.<Ball>;
		private var _base:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
		private var _bin:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
		private var _screen:Bitmap = new Bitmap(_bin);
		private var _txtFace:BitmapData;
		private var _mtx:Matrix = new Matrix();
		private var _face:Matrix = new Matrix();
		private var _centerPt:Point = new Point();
		private var _cf:ConvolutionFilter = new ConvolutionFilter(3, 3, [-1.5, -2.5, 0,
																		 -2.5, 0, 2.5,
																		  0, 2.5, 1.5], 1.4, 136);
		private var _ct:ColorTransform = new ColorTransform(40, 4, 1.6, 1, -1280, -320, -320, 0);
		
		public function Metaball():void
		{
			if (stage == null)
			{
				throw new Error("Stage not active");
				addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			}
			else {
				init();
			}
		}
		
		private function onStageAdded(e:*):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			Ball.bmp = new BitmapData(Ball.R*2, Ball.R*2, false, 0x00);
			_mtx.createGradientBox(Ball.R*2, Ball.R*2);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.RADIAL, [0x808080, 0x00], [1, 1], [0, 255], _mtx);
			shape.graphics.drawRect(0, 0, Ball.R*2, Ball.R*2);
			shape.graphics.endFill();
			
			_base.draw(shape, null);
			_base.draw(shape, null, null, BlendMode.MULTIPLY);
			Ball.bmp.applyFilter(_base, Ball.bmp.rect, Ball.bmp.rect.topLeft, new BlurFilter(12,12));
			
			_txtFace = new BitmapData(48, 20, true, 0x00000000);
			var tf:TextField = new TextField();
			var format:TextFormat = new TextFormat("Calibri", 18, null, null, null, null, null, null, "center");
			tf.defaultTextFormat = format;
			tf.autoSize =TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.text = "Hello";
			tf.textColor = 0x0;
			tf.width = 40;
			tf.height = 18;
			_txtFace.draw(tf, null);
			
			_balls = new Vector.<Ball>(25, null);
			for (var i:int = 0; i < _balls.length; i++)
			{
				_balls[i] = new Ball();
			}
			
			addChild(_screen);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			for (var i:int = 0; i < _balls.length; i++) { Ball(_balls[i]).checkHolding(event.localX, event.localY); }
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			for (var i:int = 0; i < _balls.length; i++) { Ball(_balls[i]).holding = false; }
		}
		
		private function onStart(event:Event):void
		{
			Ball.mouse.x = mouseX;
			Ball.mouse.y = mouseY;
			
			for (var i:int = 0; i < _balls.length; i++) { Ball(_balls[i].gravity()) }
			for (i = 0; i < _balls.length - 1; i++) 
			{
				for (var j:int = i+1; j < _balls.length; j++)
				{
					Ball(_balls[i]).interaction(_balls[j]);
				}
			}
			for (i = 0; i < _balls.length; i++) { Ball(_balls[i]).run(); }
			
			calcBallsCenter();
			
			_base.fillRect(_base.rect, 0x00);
			for (i = 0; i< _balls.length; i++) { Ball(_balls[i]).draw(_base) }
			_bin.applyFilter(_base, _bin.rect, _bin.rect.topLeft, _cf);
			_base.colorTransform(_bin.rect, _ct);
			_bin.draw(_base, null, null, BlendMode.MULTIPLY);
			drawFace();
		}
		
		private function calcBallsCenter():void
		{
			for (var i:int = 0; i< _balls.length; i++)
			{
				_centerPt.offset(Ball(_balls[i]).pos.x, Ball(_balls[i]).pos.y);
			}
				var div:Number = 1 / _balls.length;
				_centerPt.x *= div;
				_centerPt.y *= div;
		}
		
		private function drawFace():void
		{
			_face.identity();
			_face.translate(-24, -10);
			_face.rotate(Math.atan2(_balls[0].pos.y - _centerPt.y, _balls[0].pos.x - _centerPt.x));
			_face.translate(_centerPt.x, _centerPt.y);
			_bin.draw(_txtFace, _face, null, null, null, true);
		}
	}
}