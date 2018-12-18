package
{
	import esimov.geom.Point3D;
	import esimov.sound.BeatPortPlayer;
	import com.bit101.components.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	[SWF (backgroundColor = 0x00, width = '1080', height = '720')]
	
	/**
	 * @autohor esimov //Simo Endre//
	 * @title 1k Tunnel
	 */
	
	public class Wormhole extends Sprite
	{
		private const W:Number = stage.stageWidth;
		private const H:Number = stage.stageHeight;
		
		private var Z:Number = -0.40;
		private var T:Number = 0;
		
		private var _mouseClick:Boolean = false;
		private var _stage:Sprite = new Sprite();
		private var _uiBar:Sprite = new Sprite();
		private var _stroke:GraphicsStroke;
		private var _stroke2:GraphicsStroke;
		private var _background:GraphicsSolidFill;
		private var _path:GraphicsPath;
		private var _points:Vector.<IGraphicsData>;
		private var _player:BeatPortPlayer;
		private var _point:Point3D;
		private var _checkBox:CheckBox;
		
		public function Wormhole()
		{
			if (stage) init(null);
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				throw new Error("Stage not active");
			}
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.displayState = StageDisplayState.NORMAL;
			stage.fullScreenSourceRect = new Rectangle(0, 0, W, H);
			
			stage.doubleClickEnabled = true;
			_player = new BeatPortPlayer();
			_player.play(15);
			
			addChild(_stage);
			_stage.addChild(_uiBar);
			
            _uiBar.graphics.clear();
            _uiBar.graphics.beginFill(0, 0.7);
            _uiBar.graphics.drawRect(0, 0, W, 16);
            _uiBar.graphics.endFill();
            _uiBar.y = H - 16;
			
			_checkBox = new CheckBox(_uiBar, 2, 2, "FULL SCREEN", toggleFullScreen);
			_checkBox.selected = false;
			
			drawQuad(0, 2*Math.PI/30, -5, 0.25);
			addEventListener(Event.ENTER_FRAME, draw);
			stage.addEventListener(MouseEvent.CLICK, click);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, changeFullscreen);
		}
		
		private function createSurface(a:Number, z:Number):Point3D
		{
			var r:Number = W/10;
			var R:Number = W/3;
			var b:Number = -2*Math.cos(a*8 + T);
			
			return new Point3D(W/2 + (R*Math.cos(a) + r*Math.sin(z+2*T))/z + Math.cos(a)*b,
							   H/2 + (R*Math.sin(a))/z + Math.sin(a)*b, Z);
		}
		
		/**
		* @param a angle
		* @param da delta angle
		* @param z depth
		* @param dz depth delta   
		*/
		private function drawQuad(a:Number, da:Number, z:Number, dz:Number):void
		{
			var v:Array = [createSurface(a,z),
						   createSurface(a+da,z),
						   createSurface(a+da, z+dz),
						   createSurface(a, z+dz)];
			
			_points = new Vector.<IGraphicsData>();
			_stroke = new GraphicsStroke();
			_stroke.thickness = 1;
			_stroke.fill = new GraphicsSolidFill(0x102020,0.95);
			
			_path = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
			_path.moveTo(Point3D(v[0]).x, Point3D(v[0]).y);
			
			for (var i:Number = 0; i < v.length; i++)
			{
				_path.lineTo(Point3D(v[i]).x, Point3D(v[i]).y);
			}
			_background = new GraphicsSolidFill(0x663399, 0.95);
		}
		
		/**
		 * CLick to change to wireframe
		 */
		
		private function click(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			_mouseClick = !_mouseClick;
			_stroke2 = _stroke;
			_stroke2.thickness = 1;
			_stroke2.fill = new GraphicsSolidFill(0xC41A97,0.4);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		private function mouseWheel(event:Event):void
		{
			stage.removeEventListener(MouseEvent.CLICK, click);
			_player.next();
			stage.addEventListener(MouseEvent.CLICK, click);
		}
		
		private function changeFullscreen(event:Event):void 
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN) {
                _checkBox.selected = true;
            } else {
                _checkBox.selected = false;
            }
        }
		
		private function toggleFullScreen(event:Event):void
		{
			event.stopPropagation();
			if (!_checkBox.selected)
			{
				stage.fullScreenSourceRect = new Rectangle(0, 0, W, H);
				stage.displayState = StageDisplayState.NORMAL;
				_uiBar.y = H - 16;
			}
            else {
				stage.fullScreenSourceRect = new Rectangle(0, 0, 1024, 768);
            	stage.displayState = StageDisplayState.FULL_SCREEN;			
				_uiBar.y = 752;
			}
		}
		
		/**
		 * The core of the algorithm. Draw the quad in every frame
		 */
		
		private function draw(event:Event):void
		{
			T += 1/10;
			graphics.clear();
			
			var n:Number = 40;
			var a:Number = 0;
			var da:Number = 2*Math.PI/n;
			var dz:Number = 0.25;
			var spectL:Number = 0; var spectR:Number = 0;
			
			var bytes:ByteArray = new ByteArray();
			
			var posX:Number = 0.0012 * (mouseX - W>>1);
			var posY:Number = 0.0012 * (mouseY - H>>1);
			
			if (!SoundMixer.areSoundsInaccessible())
			{
				var i:int;
				SoundMixer.computeSpectrum(bytes, true);
				
				bytes.position = 0;
				for (i = 0; i< 128; i++)
				{
					spectL += bytes.readFloat();
				}

				spectL /= 100;
				
				bytes.position = 4*256;
				for (i = 0; i< 128; i++)
				{
					spectR += bytes.readFloat();
				}

				spectR /= 100;
				
			}
			for (var z:Number = Z + 12; z>Z; z-=dz)
			{
				for (i = 0; i<n;i++)
				{
					var fog:Number = 1/(Math.max(z+0.7)-3, 1);
					if (z <= 2)
					{
						fog = Math.min(1,Math.pow(z/2,2));	
					}
					var k:Number = (255*(fog*Math.abs(Math.sin(i/n*2*3.14+T)))) >> 0;
					var m:Number = (255*(fog*0.01*(Math.cos(n/z*3.14) + spectR*10))) >> 0;
					var l:Number = (117*(fog*0.9*(Math.sin(z*3.14) + spectL*10))) >> 0;
					k *= (0.55+0.45*Math.cos((i/n+0.55)*Math.PI*posX));
					k = k >> 0;
					m = m >> 0;
					n = n >> 0;
					
					var r:uint = (k>>16 & 0xff);
					var g:uint = (m>>08 & 0xff)>>4;
					var b:uint = (l>>00 & 0xff)<<16;
					_background = new GraphicsSolidFill(r | g | b, 0.95);
					_mouseClick == false ? _points.push(_path, _stroke, _background) : _points.push(_path, _stroke2, null)
					graphics.drawGraphicsData(_points);
					drawQuad(a,da,z,dz);
					if (i%3 == 0)
					{
						_background.color = 0x00;
						drawQuad(a,da/8, z, dz);
					}
					a += da;
				}
			}
			Z -= 0.05;
			if(Z <= dz) Z += dz;
		}
	}
}