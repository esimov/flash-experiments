package {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	[SWF (backgroundColor = 0x00, width = 800, height = 600)]
	
	public class LightBulb extends Sprite
	{
		private var _particles:Vector.<Particle> = new Vector.<Particle>();
		private var _p:Particle;
		private var _stage:Sprite;
		private var _bmd:BitmapData;
		private var _bmp:Bitmap;
		private var _cmf:ColorMatrixFilter;
		
		public function LightBulb():void
		{
			if (stage) addEventListener(Event.ADDED_TO_STAGE, init)
			else removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			_stage = new Sprite();
			addChild(_stage);
			
			_bmd = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_bmp = new Bitmap(_bmd);
			//_bmp.blendMode = BlendMode.ADD;
			_stage.addChild(_bmp);
			
			_cmf = new ColorMatrixFilter([0.95, 0,      0,    0, 1,
										  0,    0.95,   0,    0, 1,
										  0,    0,   0.95,    0, 1,
										  0,    0,      0, 0.95, 1]);
			
			addEventListener(Event.ENTER_FRAME, onStart);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onStart(e:Event):void
		{
			var i:Number = _particles.length;
			while (i)
			{
				i--;
				var p:Particle = _particles[i] as Particle;
				p.x += p.vx;
				p.y += p.vy;
				p.z += p.z;
				p.rotationX += 5;
				p.rotationY += 2;
				p.rotationZ -=0.5;
				p.vx += Math.random() * - 0.7;
				p.vy += Math.random() * - 0.5;
				
				if (p.x < 0 || p.x > stage.stageWidth || p.y < 0 || p.y > stage.stageHeight)
				{
					_stage.removeChild(p);
					_particles.splice(i,1);
					//p = null;
				}
			}
			
			_bmd.draw(this);
			_bmd.applyFilter(_bmd, _bmd.rect, new Point(), _cmf);
			_bmd.applyFilter(_bmd, _bmd.rect, new Point(), new BlurFilter(8,8, 1));
		}
		
		
		private function onMove (e:MouseEvent):void
		{
			_p = new Particle(mouseX, mouseY, 0, Math.random() * 0xffffff, 1);
			_p.blendMode = BlendMode.ADD;
			
			_stage.addChild(_p);
			_particles.push(_p);
		}
	}
}
import flash.display.Sprite;

class Particle extends Sprite
{
	public var vx:Number;
	public var vy:Number;
	public var vz:Number;
	
	public function Particle(x:Number, y:Number, z:Number, color:uint, a:Number):void
	{
		vx = Math.random() * 6 - 3;
		vy = Math.random() * 6 - 3;
		vz = - 20 * Math.random();
		this.x = x;
		this.y = y;
		this.z = z;
		
		graphics.beginFill(color, a);
		graphics.drawCircle(0,0, Math.random() * 15 + 5);
		graphics.endFill();
	}
}