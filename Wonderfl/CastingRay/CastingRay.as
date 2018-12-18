package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import net.hires.debug.Stats;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.utils.getTimer;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	[SWF (backgroundColor = 0x00, width = '512', height = '512')]

	public class CastingRay extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private var _canvas:Bitmap;
		private var _base:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
		private var _rot:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
		private var _dst:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
		private var _mtx:Matrix = new Matrix();
		private var _stat:Stats = new Stats();
		
		public function CastingRay():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			} else {
				removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
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
			stage.frameRate = 60;
			
			graphics.beginFill(0x00);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			addChild(_canvas = new Bitmap());
			addChild(_stat);
			_stat.visible = false;
			
			var circle:Sprite = new Sprite();
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			var color:uint;
			var px, py:int;
			var r:Rectangle = new Rectangle(0, 0, 30, 30);
			for (var x:int = 0; x < 6; x++)
			{ 
				for (var y:int = 0; y < 6; y++)
				{
					color = 1 | x * 0x110 | y * 0x10100;
					r.x = WIDTH / 4 + x*50;
					r.y = HEIGHT / 4 + y*50;
					_base.fillRect(r, color >> 8 & 0xFF );
					
					px = WIDTH/4 + x * 50;
					py = HEIGHT/4 + y * 50;
					color = 1 | x * 0x100 | y * 0x10000;
					g.beginFill(color);
					g.drawCircle(px, py, 15);
					g.endFill();
					circle.addChild(shape);
					_base.draw(circle, null);
				}
			}
			
			stage.addEventListener(MouseEvent.CLICK, function (e:*) { _stat.visible = !_stat.visible} );
			addEventListener(Event.ENTER_FRAME, onStart);			
		}
		
		private function process(src:BitmapData, tx:Number, ty:Number):BitmapData
		{
			var n:int = 8;
			var tmp:BitmapData;
			_mtx.identity();
			_mtx.translate(-WIDTH * 1/WIDTH, -HEIGHT * 1/HEIGHT);
			_mtx.translate(tx, ty);
			_mtx.scale(1.003564, 1.003564);
			src.lock();	_dst.lock();
			
			while (n--)
			{
				_mtx.concat(_mtx);
				_dst.copyPixels(src, src.rect, _dst.rect.topLeft);
				_dst.draw(src, _mtx, null, "add");
				_dst.applyFilter(_dst, _dst.rect, _dst.rect.topLeft, new BlurFilter(5, 5));
				tmp = _dst;
				_dst = src;
				src = tmp;
			
			}
			src.unlock(); _dst.unlock();
			return src;
		}
		
		private function onStart(e:Event):void
		{
			_mtx.identity();
			_mtx.translate(-WIDTH/2, -HEIGHT/2);
			_mtx.rotate(getTimer() / 1000);
			_mtx.translate(WIDTH/2, HEIGHT/2);
			_rot.fillRect(_rot.rect, 0x00);
			_rot.draw(_base, _mtx);
			_canvas.bitmapData = process(_rot, 0.5 - mouseX/WIDTH, 0.5 - mouseY/HEIGHT);
		}
	}
}