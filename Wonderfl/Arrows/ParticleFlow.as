package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Timer;
	import net.hires.debug.Stats;
	import flash.filters.BlurFilter;
	
	[SWF (backgroundColor = 0xffffff, width = 640, height = 640)]
	
	public class ParticleFlow extends Sprite
	{
		//CONST
		private static const NUM_PARTICLES:Number = 2500;
		private static const ROT_STEP:Number = 150;
		
		//Public variables
		public var w:Number = stage.stageWidth;
		public var h:Number = stage.stageHeight;
		
		//Private variables
		private var _particles:Vector.<Particle> = new Vector.<Particle>(NUM_PARTICLES, true);
		private var _forceField:BitmapData = new BitmapData(w, h, true, 0x00);
		private var _rotArr:Vector.<BitmapData> = new Vector.<BitmapData>(ROT_STEP, true);
		private var _seed:int = Math.floor(Math.random() * 0xff);
		private var _offsets:Array = new Array(new Point(), new Point());
		
		public function ParticleFlow():void
		{
			if (stage) {
				addEventListener(Event.ADDED_TO_STAGE, init);
			} else removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, resetFunc);
			timer.start();
			
			var sprite:Sprite = new Sprite();
			
			var dummy:Shape = new Shape();
			dummy.graphics.lineStyle(1, 0x00, 1);
			dummy.graphics.beginFill(0xffffff, 1);
			dummy.graphics.moveTo(2, 4);
            dummy.graphics.lineTo(8, 4);
            dummy.graphics.lineTo(8, 0);
            dummy.graphics.lineTo(20, 7);
            dummy.graphics.lineTo(8, 14);
            dummy.graphics.lineTo(8, 10);
            dummy.graphics.lineTo(2, 10);
            dummy.graphics.lineTo(2, 4);
			dummy.graphics.endFill();
			
			addChild(sprite);
			addChildAt(new Stats(), numChildren);
			
			resetFunc();
			
			var i:Number = ROT_STEP;
			while (i--) {
				var matrix:Matrix = new Matrix();
				matrix.translate(-11, -11);
				matrix.rotate( (360 / ROT_STEP * i) * Math.PI / 180);
				matrix.translate(11, 11);
				_rotArr[i] = new BitmapData(22, 22, true, 0x00);
				_rotArr[i].draw(dummy, matrix);
			}
			
			for (i = 0; i< NUM_PARTICLES; i++) {
				var posX:Number = Math.random() * w;
				var posY:Number = Math.random() * h;
				_particles[i] = new Particle(posX, posY);
				sprite.addChild(_particles[i]);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onStartFrame(event:Event):void
		{
			var pos:Number = 0;
			for (var i:Number = 0; i < NUM_PARTICLES; i++)
			{
				var arrow:Particle = _particles[i];
				var oldX:Number = arrow.x;
				var oldY:Number = arrow.y;
				
				pos = _forceField.getPixel(arrow.x >> 1, arrow.y >> 1);
				arrow.ax += ( (pos 		& 0xff) - 0x80) * 0.0007;
				arrow.ay += ( (pos >> 8 & 0xff) - 0x80) * 0.0007;
				arrow.vx += arrow.ax;
				arrow.vy += arrow.ay;
				arrow.x += arrow.vx;
				arrow.y += arrow.vy;
				
				var posX:Number = arrow.x;
				var posY:Number = arrow.y;
				var rot:Number = Math.atan2( (posY - oldY), (posX - oldX)) * 180 / Math.PI;
				var angle:int = rot / 360 * ROT_STEP;
				angle = (angle ^ (angle >> 31) ) - (angle >> 31);
				arrow.rot += (angle - arrow.rot) * 0.3;
				arrow.bitmapData = _rotArr[arrow.rot];
				
				arrow.ax *= 0.94;
				arrow.ay *= 0.94;
				arrow.vx *= 0.92;
				arrow.vy *= 0.92;
				
				(posX < 0) ? (arrow.x = w) : 
					(posX > w) ? (arrow.x = 0) : w;
				(posY < 0) ? (arrow.y = h) :
					(posY > h) ? (arrow.y = 0) : h;
			}
		}
		
		private function resetFunc(event:Event = null):void
		{
			_forceField.perlinNoise(117, 117, 4, _seed, false, true, 6, false, _offsets);
			_forceField.applyFilter(_forceField, _forceField.rect, new Point(0,0), new BlurFilter(5,5));
			//Bitmap(_forceField).blendMode = BlendMode.DARKEN;
			(_offsets[0] as Point).x += 1.5; 
			(_offsets[1] as Point).y -= 1.8;
			_seed = Math.floor(Math.random() * 0xFFFFFF);
		}
	}
}
import flash.display.Bitmap;

class Particle extends Bitmap
{
	public var rot:int = 0;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var ax:Number = 0;
	public var ay:Number = 0;
	
	public function Particle(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
	}
}