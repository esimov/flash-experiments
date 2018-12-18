package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.display.BitmapDataChannel;
	import esimov.geom.Particle3D;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	[SWF(backgroundColor = 0x00, width = "600", height = "600")]

	public class ParticleSpace extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private static const MAX_LEVEL:Number = 12;
		
		private var _theta:Number;
		private var _phi:Number;
		private var _zMax:Number;
		private var _zMin:Number;
		private var _minLevel:Number;
		private var _maxLevel:Number;
		private var _offset:Number;
		private var _fadeRate:Number;
		private var _fl:Number = 250;
		
		private var _targetPhi:Number;
		private var _targetTheta:Number;
		private var _targetOffset:Number;
		private var _offsets:Array = [new Point(), new Point()];
		
		private var _bmpData:BitmapData;
		private var _perlin:BitmapData;
		private var _perlinBmp:Bitmap;
		private var _bmp:Bitmap;
		private var _screen:Sprite;
		private var _ct:ColorTransform;
		private var _blur:BlurFilter;
		
		private var _projCenterX:Number;
		private var _projCenterY:Number;
		
		private var _isDragging:Boolean = false;
		private var _firstParticle:Particle3D;
		
		public function ParticleSpace():void
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
			stage.quality = "medium";
			stage.fullScreenSourceRect = new Rectangle(0, 0, WIDTH, HEIGHT);
			
			main();
		}
		
		private function main():void
		{
			_offset = 80;
			_zMin = 0;
			_zMax = 120;
			_theta = Math.PI/2;
			_phi = - Math.PI/2;
			_targetOffset = 120;
			_targetPhi = _phi;
			_targetTheta = _theta;
			_fadeRate = MAX_LEVEL / (_zMax - _zMin);
			
			_screen = new Sprite();
			_screen.x = _screen.x = 0;
			addChild(_screen);
			_perlin = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			_perlinBmp = new Bitmap(_perlin);
			//_screen.addChild(_perlinBmp);
			
			_bmpData = new BitmapData(WIDTH, HEIGHT, false, 0x00);
			_bmp = new Bitmap(_bmpData);
			_screen.addChild(_bmp);
			
			_blur = new BlurFilter(4, 4, BitmapFilterQuality.MEDIUM);
			_ct = new ColorTransform(0.75, 0.75, 0.75);
			
			_projCenterX = _screen.width >> 1;
			_projCenterY = _screen.height >> 1;
			
			createParticles();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			addEventListener(Event.ENTER_FRAME, startFrame);

		}
		
		private function beginDrag(event:MouseEvent):void
		{
			_isDragging = true;
		}
		
		private function endDrag(event:MouseEvent):void
		{
			_isDragging = false;
		}
		
		private function startFrame(event:Event):void
		{
			var p:Particle3D = _firstParticle;
			if (_isDragging)
			{
				_targetPhi = 0.1*Math.PI + _screen.mouseX / _screen.width * Math.PI;
				_targetTheta = -1.2 * _screen.mouseY / _screen.height * Math.PI;
				_targetOffset = _screen.mouseX / 2;
			}
			
			_perlin.perlinNoise(180, 180, 2, 20, false, true, BitmapDataChannel.RED, true, _offsets);
			_perlin.applyFilter(_perlin, _perlin.rect, new Point(), _blur);
			(_offsets[0] as Point).x += 1.2;
			(_offsets[0] as Point).y += 1.2;
			(_offsets[1] as Point).x -= 1.2;
			(_offsets[1] as Point).y -= 1.2;
			
			_phi += 0.1 * (_targetPhi - _phi);
			_theta += 0.1 * (_targetTheta - _theta);
			_offset += 0.1 * (_targetOffset - _offset);
			
			var cosT:Number = Math.cos(_theta);
			var sinT:Number = Math.sin(_theta);
			var cosP:Number = Math.cos(_phi);
			var sinP:Number = Math.sin(_phi);
			
			var C11:Number = cosT * sinP;
			var C12:Number = sinT * sinP;
			var C21:Number = -cosT * cosP;
			var C22:Number = -cosP * sinT;
			
			_bmpData.lock();
			_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(), _blur);
			_bmpData.colorTransform(_bmpData.rect, _ct);
			
			while (p)
			{
				p.u = p.x * C11 + p.y * C12 + p.z * cosT + _offset;
				p.v = - p.x * sinT + p.y * cosT;
				p.w = p.x * C21 + p.y * C22 + p.z * sinP;
				
				var m:Number = _fl/ (_fl - p.u);
				p.projX = m * p.v + _projCenterX;
				p.projY = m * p.w + _projCenterY;
				
				if (p.projX < 0 || p.projX > WIDTH || p.projY < 0 || p.projY >> HEIGHT)
				{
					p.onScreen = false;
				} else { p.onScreen = true; }
				
				if (p.onScreen)
				{
					var perlinCol:uint = _perlin.getPixel(p.projX, p.projY);
					//perlinPosX += (perlinCol & 0xff - 0x80) * .015625;
					//perlinPosY += (perlinCol >> 8 & 0xff - 0x80) * .015625;
					//var col:uint = _perlin.getPixel(perlinPosX, perlinPosY);
					
					perlinCol = (perlinCol >> 16) & 0xff;
					perlinCol = (perlinCol > 255) ? 255 : perlinCol;
				
					var readLevel:uint = _bmpData.getPixel(p.projX, p.projY) & 0xff;
					var levelInc:Number = _fadeRate * (p.u - _zMin);
					levelInc = (levelInc > MAX_LEVEL) ? MAX_LEVEL : (levelInc < 0 ? 0 : levelInc);
					
					var level:Number = (levelInc + readLevel) + perlinCol * 0.156;
					level = (level > 255) ? 255 : level;
					
					var color:uint = (level << 16 | level << 8 | level) ;
					_bmpData.setPixel(p.projX, p.projY, color);
				}
				p = p.next;
			}
			_bmpData.unlock();
		}
		
		
		private function createParticles():void
		{
			var prevParticle:Particle3D;
			var pMin:Number = - Math.PI;
			var pMax:Number = Math.PI;
			var tMin:Number = - Math.PI;
			var tMax:Number = Math.PI;
			 
			var tNum:Number = 500;
			var pNum:Number = 420;
			 
			var tInc:Number = (tMax - tMin) / tNum;
			var pInc:Number = (pMax - pMin) / pNum;
			 
			for (var i:int = 0; i < tNum; i++)
			{
				var t0:Number = tMin + tInc * i;
				
				for (var j:int = 0; j < pNum; j++)
				{
					var particle:Particle3D = new Particle3D(0x00);
					var p0:Number = pMin + pInc * j;
					
					var t:Number = t0 + tInc * Math.random() * 2 - 1;
					var p:Number = p0 + pInc * Math.random() * 2 - 1;
					
					var radX:Number = 100 * (0.5 + 0.5*Math.cos(t));
					var radY:Number = 100 * (0.5 + 0.5*Math.sin(p)); 
					
					particle.x = radX * Math.cos(p) + radY * Math.cos(t)*Math.cos(p);
					particle.y = radX * Math.sin(p) + radY * Math.sin(t)*Math.sin(p);
					particle.z = radX * Math.sin(2*t);
					
					particle.next = prevParticle;
					prevParticle = particle;
				 }
			 }
			 _firstParticle = particle;
		}
	}
}