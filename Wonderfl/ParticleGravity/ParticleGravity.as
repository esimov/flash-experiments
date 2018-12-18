package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	import net.hires.debug.Stats;
	
	[SWF(backgroundColor = 0x00, width = "512", height = "512")]

	public class ParticleGravity extends Sprite
	{
		private static const NUM_PART:Number = 40000;
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		
		private var _screen:Bitmap;
		private var _bmpData:BitmapData;
		private var _count:int = 0;
		private var _firstParticle:Particle;
		private var _force:int = 200;
		private var _rect:Rectangle;
		private var _clicked:Boolean;
		private var _ct:ColorTransform = new ColorTransform(0.6, 0.4, 0.8, 1);
		
		public function ParticleGravity():void
		{
			if (stage) { initStage(null) }
			else {
				addEventListener(Event.ADDED_TO_STAGE, initStage);
			}
		}
		
		private function initStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.quality = "low";
			stage.mouseChildren = false;
			
			var prev:Particle;
			var count:int = 0;
			while(count <= NUM_PART)
			{
				//var dx:Number = (Math.random() < 0.5 ? 1 : WIDTH) + Math.random();
				//var dy:Number = (Math.random() < 0.5 ? 1 : HEIGHT) + Math.random();
				var dx:Number = Math.random() * WIDTH;
				var dy:Number = Math.random() * HEIGHT;
				var p:Particle = new Particle(dx, dy);
				p.next = prev;
				prev = p;
				count ++;
			}
			_firstParticle = p;
			
			_bmpData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			_screen = new Bitmap(_bmpData);
			_rect = _bmpData.rect;
			addChild(_screen);
			addChild(new Stats());
			
			stage.addEventListener(MouseEvent.CLICK, function (e:*) { _clicked = !_clicked; });
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onStart(e:Event):void
		{
			var step:Boolean = _count % 4 == 0;
			var p:Particle = _firstParticle;
			var color:uint;
			var r:uint = 0;
			var g:uint = 0;
			var b:uint = 0;
			var phase:Number = 0;
			const phaseInc:Number = 220 / 44100;
			var angle_x:Number = 0;
			var angle_y:Number = 0;
			
			_bmpData.lock();
			while(p)
			{
				phase += phaseInc;
				if (phase >= 4)
				{
					phase -= phaseInc;
				}
				
				(_clicked) ? _force = -200 : _force = 200;
				
				angle_x = phase * Math.PI * 2;
				angle_y = phase * Math.PI * 2;
				const pm_x:Number = (Math.cos(angle_x) + 0.5) * 0.05;
				const pm_y:Number = (Math.sin(angle_y) + 0.5) * 0.05;
				
				color = _bmpData.getPixel(p.x, p.y);
				r = (color & 0xff0000) >> 16;
				g = (color & 0x00ff00) >> 08;
				b = (color & 0x0000ff) >> 00;
				if (step)
				{
					var dx:Number = mouseX - p.x;
					var dy:Number = mouseY - p.y;
					var dist:Number = _force / (dx * dx + dy * dy);
					p.vx += (Math.cos(p.t * angle_x) * (pm_x + 0.045) * 0.005);
					p.vy += (Math.sin(p.t * angle_y) * (pm_y + 0.045) * 0.005);
					p.vx += dist * dx;
					p.vy += dist * dy;
				}
				p.x += p.vx;
				p.y += p.vy;
				
				p.vx *= 0.985;
				p.vy *= 0.985;
				
				if (step)
				{
					if (p.x >= WIDTH)
					{
						p.vx *= -1;
						//p.x = WIDTH - (p.x - WIDTH);
						p.x = 0;
					} else if (p.x < 0){
						p.vx *= -1;
						//p.x -= p.x;
						p.x = WIDTH;
					}
					
					if (p.y >= HEIGHT)
					{
						p.vy *= -1;
						//p.y = HEIGHT - (p.x - HEIGHT);
						p.y = 0;
					} else if (p.y < 0){
						p.vy *= -1;
						//p.y -= p.y;
						p.y = HEIGHT;
					}
				}
				r += 0xdd;
				g += 0xaa;
				b += 0xcc;

				if(r > 0xff) r = 0xff;
				if(g > 0xff) g = 0xff;
				if(b > 0xff) b = 0xff;
				
				_bmpData.setPixel(p.x >> 0, p.y >> 0, (r << 0xCC) | (g << 0x10) | b << 0x40);
				p = p.next;
			}
			_bmpData.colorTransform(_rect, _ct);
			_bmpData.applyFilter(_bmpData, _rect, new Point(), new BlurFilter(2, 2));
			_bmpData.unlock();
			_count ++;
		}
	}
}