/**
 * @title Pixel Surface Model
 * @author Simo Endre (esimov)
 *
 * High resolution vertex data models can be found @ http://www.cyberware.com/products/scanners/pxSamples.html
 * Other scan samples @ http://graphics.stanford.edu/data/3Dscanrep/
 * For vertex point extraction i used a program from Kárpáti Zoltán (http://web.axelero.hu/karpo/) 
 * and slightly modified the obtained txt file for my own purposes.
 * We need only the x, y and z coordinate, so other aditional information can be deleted.
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
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;
	
	import net.hires.debug.Stats;
	import com.bit101.components.Style;
	import com.bit101.components.Label;
	
	
	[SWF (backgroundColor = 0x00, width = '800', height = '600')]

	public class PixelSurfaceModel extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		private static const PHI:Number = 3.14159265;
		
		private var _fl:Number = 250;
		private var _phi:Number = 0;
		private var _theta:Number = 0;
		private var _minDepth:Number;
		private var _maxDepth:Number;
		private var _expInt:Number;
		private var _expRate:Number;
		private var _maxLevel:Number;
		
		private var _projCenterX:Number;
		private var _projCenterY:Number;
		private var _numParticles:Number;
		private var _firstParticle:Particle3D;
		
		private var _screen:Sprite;
		private var _bmpData:BitmapData;
		private var _bmp:Bitmap;
		private var _ct:ColorTransform;
		private var _blur:BlurFilter;
		private var _particles:TextField;
		
		private var _loader:URLLoader;
		private var _label:Label;
		private var _vertices:Vector.<Number>;
		
		private var mousePressed:Boolean = false;
		
		public function PixelSurfaceModel():void
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
			_screen = new Sprite();
			_screen.x = _screen.y = 0;
			addChild(_screen);
			
			Style.setStyle(Style.LIGHT);
			_label = new Label(_screen, 0, HEIGHT - 15, "Loading File...");
			
			Security.loadPolicyFile("http://esimov.zxq.net/crossdomain.xml");
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			context.securityDomain = SecurityDomain.currentDomain;
			_loader = new URLLoader();
			_loader.load(new URLRequest("assets/bunny_model.txt"));
			_loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadProgress(event:ProgressEvent):void
		{
			var perc:int = int(event.bytesLoaded / event.bytesTotal) * 100;
			_label.text = "Loading: " + perc + " %";
			if (perc >= 100)
			_screen.removeChild(_label);
		}
		
		private function onLoadError(event:IOErrorEvent):void
		{
			throw new IllegalOperationError("Loading source file has failed...");
		}
		
		
		private function onLoadComplete(event:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			
			_vertices = new Vector.<Number>();
			var stringData:String = event.target.data as String;
			var delimitator:RegExp = /\s+/;
			var stringArr:Array = stringData.split(delimitator);
			_numParticles = stringArr.length / 5;
			
			for (var i:Number = 0; i < stringArr.length; i++)
			{
				_vertices.push(Number(stringArr[i]));
			}
			
			var level0:Number = 1/_fl;
			var level1:Number = 1;
			_minDepth = -120;
			_maxDepth = 120;
			_maxLevel = 255;
			
			_expInt = (Math.log(level0) - Math.log(level1)) / (_minDepth - _maxDepth);
			_expRate = _maxLevel * level1 + Math.pow(level1/level0, _minDepth/ (_minDepth - _maxDepth));
			
			_theta = 3*PHI/2;
			_phi = - PHI/4;
			
			_bmpData = new BitmapData(WIDTH, HEIGHT, true, 0xff000000);
			_bmp = new Bitmap(_bmpData);
			_screen.addChild(_bmp);
			
			var tf:TextFormat = new TextFormat("Verdana", 10);
			_particles = new TextField();
			_particles.defaultTextFormat = tf;
			_particles.background = true;
			_particles.backgroundColor = 0x333333;
			_particles.autoSize = "right";
			_particles.textColor = 0xffffff;
			_particles.x = WIDTH - _particles.textWidth - 5;
			_particles.text = "";
			
			addChild(new Stats());
			_screen.addChild(_particles);
			
			_ct = new ColorTransform(0.8, 0.8, 0.8);
			_blur = new BlurFilter(2, 2, BitmapFilterQuality.MEDIUM); 
			
			_projCenterX = _screen.width >> 1;
			_projCenterY = _screen.height >> 1;
			
			createParticles();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePress);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMousePress);
			addEventListener(Event.ENTER_FRAME, beginTest);
		}
		
		private function onMousePress(event:MouseEvent):void
		{
			switch(event.type)
			{
				case "mouseDown":
				mousePressed = true;
				break;
				
				case "mouseUp":
				mousePressed = false;
				break;
				
				default:
				break;
			}
		}
		
		private function beginTest(event:Event):void
		{
			var p:Particle3D = _firstParticle;
			var dx:Number = 0;
			var dy:Number = 0;
			
			if (!mousePressed)
			{
				dx = 0.00824 * Math.cos(getTimer() * 0.0001855);
				dy = 0.00824 * Math.sin(getTimer() * 0.0001855);
			}
			else
			{
				dx = 0.00012 * (mouseY - _projCenterY);
				dy = 0.00012 * (mouseX - _projCenterX);
			}
			
			_phi = dx + _phi ;
			_theta = dy + _theta ;
			
			var cosP:Number = Math.cos(_phi);
			var sinP:Number = Math.sin(_phi);
			var cosT:Number = Math.cos(_theta);
			var sinT:Number = Math.sin(_theta);
			
			var C11:Number = cosT * sinP;
			var C12:Number = sinT * sinP;
			var C21:Number = - cosP * cosT;
			var C22:Number = - sinT * cosP;
			
			_bmpData.lock();
			_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(), _blur);
			_bmpData.colorTransform(_bmpData.rect, _ct);
			
			do
			{				
				p.u = C11 * p.x + C12 * p.y + cosP * p.z;
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
					var color:uint = _bmpData.getPixel(p.projX, p.projY) & 0xff;
					var level:Number = _expRate*Math.exp(_expInt*p.u);
					level = (level > _maxLevel) ? _maxLevel : level;
					
					if (level > color)
					_bmpData.setPixel(p.projX, p.projY,(level << 16 | level << 8 | level));
				}
				
				p = p.next;
				
			} while (p != null);
			
			_bmpData.unlock();
		}
		
		private function createParticles():void
		{
			var prevParticle:Particle3D;
			var scale:Number = 2200;
			var offsetX:Number = 0.0182325;
			var offsetY:Number = -0.089232;
			var offsetZ:Number = -0.0092234;
			
			for (var i:Number = 0; i < _numParticles; i++)
			{
				var particle:Particle3D = new Particle3D(0x00);
				particle.x = scale * (_vertices[i*5] + offsetX);
				particle.y = scale * (_vertices[i*5+1] + offsetY);
				particle.z = scale * (_vertices[i*5+2] + offsetZ);
				
				particle.next = prevParticle;
				prevParticle = particle;
			}
			
			_firstParticle = particle;
			_particles.text = _numParticles + " particles";
		}
	}
}
