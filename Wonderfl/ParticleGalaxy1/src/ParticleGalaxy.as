/**
 * @title Particle galaxy
 * @author Simo Endre (esimov)
 * 
 * Click and drag to explore in depth particle formation
 * Click and drag on y axe to rotate and x axe to explore in depth
 * Added some perlin noise effect for additional shining look
 * */

package
{
	import com.esimov.geom.Particle3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import net.hires.debug.Stats;
	
	[SWF (backgroundColor = 0x00, width = '600', height = '600')]

	public class ParticleGalaxy extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private static const PHI:Number = 3.14159265;
		
		private var _fl:Number = 250;
		private var _phi:Number;
		private var _theta:Number;
		private var _minDepth:Number;
		private var _maxDepth:Number;
		private var _fadeRate:Number;
		private var _maxLevelInc:Number;
		private var _offset:Number;
		private var _targetPhi:Number;
		private var _targetTheta:Number;
		private var _targetOffset:Number;
		
		private var _projCenterX:Number;
		private var _projCenterY:Number;
		private var _isDragging:Boolean = false;
		private var _firstParticle:Particle3D;
		
		private var _screen:Sprite;
		private var _bmpData:BitmapData;
		private var _bmp:Bitmap;
		private var _ct:ColorTransform;
		private var _blur:BlurFilter;
		private var _perlin:BitmapData;
		private var _offsets:Array = [new Point(0,0), new Point(0,0)];
		private var _particles:TextField;
		
		public function ParticleGalaxy():void
		{
			if (stage) initStage(null);
			else {
				addEventListener(Event.ADDED_TO_STAGE, initStage);
				throw new Error("Stage not initialized");
			}
		}
		
		private function initStage(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.quality = "heigh";
			stage.fullScreenSourceRect = new Rectangle(0, 0, WIDTH, HEIGHT);
			
			init();
		}
		
		private function init():void
		{
			_maxLevelInc = 37;
			_minDepth = - 100;
			_maxDepth = 210;
			_theta = PHI;
			_phi = - PHI;
			_offset = 80;
			_targetPhi = _phi;
			_targetTheta = _theta;
			_targetOffset = 129;
			_fadeRate = _maxLevelInc * (_maxDepth - _minDepth);
			
			_screen = new Sprite();
			_screen.x = _screen.y = 0;
			_bmpData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			_bmp = new Bitmap(_bmpData);
			_perlin = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			addChild(_screen);
			
			_screen.addChild(_bmp);
			//_screen.addChild(new Bitmap(_perlin));
			
			var tf:TextFormat = new TextFormat("Verdana", 10);
			_particles = new TextField();
			_particles.defaultTextFormat = tf;
			_particles.background = true;
			_particles.backgroundColor = 0x333333;
			_particles.autoSize = "right";
			_particles.textColor = 0xffffff;
			_particles.x = WIDTH - _particles.textWidth - 5;
			_particles.text = "";
			addChild(_particles);
			addChild(new Stats());
			
			_ct = new ColorTransform(0.77, 0.77, 0.77);
			_blur = new BlurFilter(3, 3, BitmapFilterQuality.MEDIUM); 
			
			_projCenterX = _screen.width >> 1;
			_projCenterY = _screen.height >> 1;
			
			createParticles();
			addEventListener(Event.ENTER_FRAME, beginTest);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			
		}
		
		private function beginDrag(event:MouseEvent):void
		{
			_isDragging = true;
		}
		
		private function endDrag(event:MouseEvent):void
		{
			_isDragging = false;
		}
		
		private function beginTest(event:Event):void
		{
			var p:Particle3D = _firstParticle;
			var c:uint = 0x808080;
			var red:uint = color >> 16 & 0xff;
			var green:uint = color >> 08 & 0xff;
			var blue:uint = color & 0xff;
			
			if (_isDragging)
			{
				_targetOffset = _screen.mouseX >> 1;
				_targetTheta = -0.1 * PHI + 1.2 * _screen.mouseY / _screen.height * PHI;
				_targetPhi = -1.2 * _screen.mouseY / _screen.height * PHI;
			}
			_phi += 0.1 * (_targetPhi - _phi);
			_theta += 0.1 * (_targetTheta - _theta);
			_offset += 0.1 * (_targetOffset - _offset);
			
			var cosP:Number = Math.cos(_phi);
			var sinP:Number = Math.sin(_phi);
			var cosT:Number = Math.cos(_theta);
			var sinT:Number = Math.sin(_theta);
			
			var C11:Number = cosT * sinP;
			var C12:Number = sinT * cosP;
			var C21:Number = - cosP * cosT;
			var C22:Number = - sinT * cosP;
			
			_perlin.lock();
			_perlin.perlinNoise(200, 200, 2, 4000, false, true, BitmapDataChannel.RED, true, _offsets);
			_perlin.threshold(_perlin, _perlin.rect, new Point(), ">", c, Math.max(0, red) << 16 | Math.max(0,green) << 8 | Math.max(0, blue), 0x00ff0000, false);
			_perlin.applyFilter(_perlin, _perlin.rect, new Point(), new BlurFilter(6,6));
			
			(_offsets[0] as Point).x += 1.0;
			(_offsets[0] as Point).y += 2.0;
			(_offsets[1] as Point).x -= 1.0;
			(_offsets[1] as Point).y -= 2.0;
			_perlin.colorTransform(_perlin.rect, _ct);
			_perlin.unlock();
			
			_bmpData.lock();
			_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(), _blur);
			_bmpData.colorTransform(_bmpData.rect, _ct);
			
			do
			{				
				p.u = C11 * p.x + C12 * p.y + cosP * p.z + _offset;
				p.v = - sinT * p.x + cosT * p.y;
				p.w = C21 * p.x + C22 * p.y + sinP * p.z;
				
				var df:Number = _fl / (_fl - p.u);
				p.projX = df * p.v + _projCenterX;
				p.projY = df * p.w + _projCenterY;
				
				if (p.projX < 0 || p.projX > WIDTH || p.projY < 0 || p.projY > HEIGHT)
				{
					p.onScreen = false;
				} else { p.onScreen = true }
				
				if (p.onScreen)
				{
					var perlinColor:uint = _perlin.getPixel(p.projX, p.projY) & 0xff;
					perlinColor = (perlinColor > 255) ? 255 : perlinColor;
					var readLevel:uint = _bmpData.getPixel(p.projX, p.projY) & 0xff;
					var dimm:Number = _fadeRate * (p.u - _minDepth);
					dimm = (dimm > _maxLevelInc) ? _maxLevelInc : (dimm < 0 ? 0 : dimm);
					
					var level:Number = (dimm + readLevel) + perlinColor * 0.114;
					level = (level > 255) ? 255 : level;
					
					var color:uint = level << 16 | level << 8 | level;
					_bmpData.setPixel(p.projX, p.projY, color);
				}
				
				p= p.next;
				
			} while (p != null);
			
			_perlin.unlock();
			_bmpData.unlock();
		}
		
		private function createParticles():void
		{
			var prevParticle:Particle3D;
			var minTheta:Number = - 3.14159265;
			var maxTheta:Number = 3.14159265;
			var minPhi:Number = - 3.14159265;
			var maxPhi:Number = 3.14159265;
			
			var numT:Number = 320;
			var numP:Number = 330;
			var count:Number = 0;
			
			var t0:Number = (maxTheta - minTheta) / numT;
			var p0:Number = (maxPhi - minPhi) / numP;
			
			for (var i:int = 0; i < numT; i++)
			{
				var tInc:Number = Math.min(minTheta, t0) + t0 * i;
				for (var j:int = 0; j < numP; j++)
				{
					var pInc:Number = Math.min(minPhi, p0) + p0 * j;
					
					var t:Number = tInc + t0 * (Math.random() * 10 - 5);
					var p:Number = pInc + p0 * (Math.random() * 10 - 5);
					
					var radT:Number = 50 + (0.5 * Math.cos(getTimer() * t));
					var radP:Number = 50 + (0.5 * Math.sin(getTimer() * p));
				
					var particle:Particle3D = new Particle3D();
									
					particle.x = radT * Math.cos(p) + radT * Math.sin(t) * Math.cos(p);
					particle.y = radT * Math.sin(p) + radP * Math.cos(t) * Math.sin(p);
					particle.z = radP * Math.sin(2*t);
					
					particle.next = prevParticle;
					prevParticle = particle;
					count ++;
				}
			}
			_firstParticle = particle;
			_particles.text = count + " particles";
		}		
	}
}