package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	[SWF (backgroundColor = 0x33333333, width = 800, height = 600)]
	
	public class FaceProjection extends Sprite
	{
		private var _loader:Loader;
		public var bitmapData:BitmapData;
		
		private const W:Number = stage.stageWidth;
		private const H:Number = stage.stageHeight;
		
		public var projection:Projection;
		public var particles:Array = [];
	
		public function FaceProjection():void
		{
			if (stage) addEventListener(Event.ADDED_TO_STAGE, initStage);
			else removeEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoad);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOEvent);
			_loader.load(new URLRequest("assets/face.jpg"));
		}
		
		private function IOEvent(e:IOErrorEvent):void
		{
			throw new Error("Image not found");
		}
		
		private function imageLoad(e:Event):void
		{
			bitmapData = e.target.content.bitmapData as BitmapData;
			addChild(new Bitmap(bitmapData));
			
			var w:Number = bitmapData.width;
			var h:Number = bitmapData.height;
			var s:Number = 9;
			
			for (var xx:Number = 0; xx < w; xx++)
			{
				for (var yy:Number = 0; yy < h; yy++)
				{
					var color:uint = bitmapData.getPixel(xx, yy);
					var red:uint = (color >> 16) & 0xff;
					var green:uint = (color >> 8) & 0xff;
					var blue:uint = (color >> 0) & 0xff;
					var px:Number = xx * s - (w/2 * s);
					var py:Number = yy * s - (h/2 * s);
					
					if (red > 1)
					{
						particles.push(new Particle(px, py, red));
					}
				}
			}
			
			projection = new Projection(W, H, particles);
			addChild(projection);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onMouse(e:MouseEvent):void
		{
			if (e.type == "mouseDown") mouseDown = true;
			if (e.type == "mouseUp") mouseDown = false;
		}
		
		private var vx:Number = 1;
		private var vy:Number = 0;
		private var lx:Number = 0;
		private var ly:Number = 0;
		private var friction:Number = 0.999;
		private var mouseDown:Boolean = false;
		
		private function onStart(evt:Event ):void
		{
			if (mouseDown)
			{
				vx = lx - stage.mouseX;
				vy = ly - stage.mouseY;
			}
			else
			{
				vx *= friction;
				vy *= friction;
			}
			if(Math.abs(vx) <= 0.1) vx = 0;
			if(Math.abs(vy) <= 0.1) vy = 0;
			lx = stage.mouseX;
			ly = stage.mouseY;
			
			for each (var particle:Particle in particles)
			{
				rotateFace (particle, "z", "y", vy);
				rotateFace (particle, "x", "z", -vx);
			}
			
			projection.update();
		}
		
		private function rotateFace(p:Particle, a:String, b:String, r:Number):void
		{
			var cos:Number;
			var sin:Number;
			var posA:Number;
			var posB:Number;
			var rad:Number = Math.PI / 360;
			
			cos = Math.cos(r * rad);
			sin = Math.sin(r * rad);
			posA = p[a];
			posB = p[b];
			p[a] = posA * cos - posB * sin;
			p[b] = posB * cos + posA * sin;
		}
	}
}


internal class Particle
{
	public var x:Number;
	public var y:Number;
	public var z:Number;
	
	public function Particle(x:Number, y:Number, z:Number):void
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;

internal class Projection extends Bitmap
{
	private var w:Number;
	private var h:Number;
	private var particles:Array;
	
	private var fl:Number = 600;
	private var vx:Number;
	private var vy:Number;
	private var px:Number;
	private var py:Number;
	private var color:uint;
	
	public function Projection(w:Number, h:Number, particles:Array):void
	{
		this.w = w;
		this.h = h;
		this.particles = particles;
		
		bitmapData = new BitmapData(w, h, true, 0x00);
		vx = 0;
		vy = 0;
		px = w/2;
		py = h/2;
	}
	
	public function update():void
	{
		var cl:uint = 0;
		bitmapData.fillRect(bitmapData.rect, 0x00);
		bitmapData.lock();
		
		for each (var p:Particle in particles)
		{
			var scale:Number = fl / (fl + p.z);
			vx = px + p.x * scale;
			vy = py + p.y * scale;
			cl = 255 - ((50 + p.z) * 100 / 255);
			cl = cl < 0 ? 0 : cl;
			cl = cl > 255 ? 255 : cl;
			color = 0xff000000 | cl << 16 | cl << 8 | cl;
			bitmapData.setPixel32(vx, vy, color);
		}
		bitmapData.unlock();
	}
}