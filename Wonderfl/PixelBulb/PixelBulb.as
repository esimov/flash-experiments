package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	[SWF (backgroundColor = 0x00, width = 800, height = 800)]
	
	public class PixelBulb extends Sprite
	{
		private var mouseDown:Boolean = false;
		private var particles:Vector.<Particle> = new Vector.<Particle>();
		private var row:Number = 100;
		private var col:Number = 100;
		private var bitmapData:BitmapData;
		private var interval:Number = 7;
		
		public const W:Number = stage.stageWidth;
		public const H:Number = stage.stageHeight;
		
		public function PixelBulb():void
		{
			if (stage) addEventListener(Event.ADDED_TO_STAGE, initStage)
			else removeEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			
			var offsetX:int = (W - row * interval) / 2;
			var offsetY:int = (H - col * interval) / 2;
			for (var i:int = 0; i< row; i++)
			{
				for (var j:int = 0; j< col; j++)
				{
					var particle:Particle = new Particle(interval * i + offsetX, interval * j + offsetY);
					particles.push(particle);
					//trace(particles);
				}
			}
			bitmapData = new BitmapData(W, H, false, 0x00);
			addChild(new Bitmap(bitmapData));
						
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onMouse(e:MouseEvent):void
		{
			if (e.type == "mouseDown") { mouseDown = true }
			if (e.type == "mouseUp") { mouseDown = false }
		}
		
		private function onStart(e:Event):void
		{
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect, 0x00);
			
			var mPoint:Point = new Point(mouseX, mouseY);
			for each (var p:Particle in particles)
			{
				bitmapData.setPixel(p.x, p.y, 0xffcc00);
				p.update(mPoint, mouseDown);
			}
			bitmapData.unlock();
		}
	}
}

import flash.geom.Point;

internal class Particle
{
	private var _x:int;
	private var _y:int;
	private var maxDist:Number = 110;
	private var localX:Number;
	private var localY:Number;
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var dx:Number;
	private var dy:Number;
	private var spring:Number = 0.048;
	private var friction:Number = 0.94;
	
	public function Particle(x:int, y:int):void
	{
		this._x = localX = x;
		this._y = localY = y;
	}
	
	public function update(mousePoint:Point, mouseDown:Boolean):void
	{
		var dist:Number = Point.distance(mousePoint, new Point(localX, localY));
		var dir:Number = mouseDown ? 1 : -1;
		if (dist < maxDist)
		{
			var diff:Number = dist * dir * (maxDist - dist) / maxDist;
			var distX:Number = mousePoint.x - localX;
			var distY:Number = mousePoint.y - localY;
			var rad:Number = Math.atan2(distY, distX);
			var transCoord:Point = Point.polar(diff, rad);
			dx = localX + transCoord.x;
			dy = localY + transCoord.y;
		} else {
			dx = localX;
			dy = localY;
		}
			vx += (dx - _x) * spring;
			vy += (dy - _y) * spring;
			vx *= friction;
			vy *= friction;
			this._x += vx;
			this._y += vy;
			
		//if (vx <= 0.01) vx = 0;
		//if (vy <= 0.01) vy = 0;
	}
	
	public function get x():Number { return _x }
	
	public function get y():Number { return _y }
}