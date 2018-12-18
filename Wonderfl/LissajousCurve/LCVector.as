/* @title LISSAJOUS CURVE
 * @author Simo Endre (esimov)
 *
 * AS3 port of bit101 Lissajous Curve experiment (http://www.bit-101.com/jscanvas/webs_02.html)
 * Core drawing implementation significantly changed for better optimization.
 * Tryed with vector implementation but performance was pretty poor, so changed to bitmap drawing
 * and implemented Xiaolin Wu antialiasing algorithm (http://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm)
 * 
 * For best view change to full screen
 * 
 */

package
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import net.hires.debug.Stats
	import flash.display.Shape;
	
	[SWF (backgroundColor = 0xffffff, width = '1440', height ='1080')] 
	
	public class LCVector extends Sprite
	{
		private const WIDTH:Number = stage.stageWidth
		private const HEIGHT:Number = stage.stageHeight;
		
		private var _screen:Sprite;
		private var _dist:Number;
		private var _angleX:Number = 0;
		private var _angleY:Number = 0;
		private var _speedX:Number = Math.random() * 0.1 - 0.05;
		private var _speedY:Number = Math.random() * 0.1 - 0.05;
		private var _points:Array = new Array();
		private var _canvas:Shape = new Shape();
		
		public function LCVector()
		{
			if (stage) { initStage(null) }
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, initStage);
				throw new Error("Stage not active");
			}
		}
		
		private function initStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;

			stage.fullScreenSourceRect = new Rectangle(0, 0, WIDTH, HEIGHT);
			init();
		}
		
		private function init():void
		{
			_screen = new Sprite();
			addChild(_screen);
			//_bmd = new BitmapData(WIDTH, HEIGHT, true, 0xffffffff);
			//_bmp = new Bitmap(_bmd);
			_screen.addChild(_canvas);
			addChild(new Stats());
								
			stage.addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, onStart);
		}
		
		private function onClick(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onStart);
			//_bmd.fillRect(_bmd.rect, 0xffffffff);
			resetFunc();
			addEventListener(Event.ENTER_FRAME, onStart); 
		}
		
		
		/**
		 *	"Extremely Fast Line Algorithm"
		 *	@author     Po-Han Lin (original version: http://www.edepot.com/algorithm.html)
		 *	@author     Simo Santavirta (AS3 port: http://www.simppa.fi/blog/?p=521) 
		 */
		 
		private function efla(bmd:BitmapData, x:int, y:int, x2:int, y2:int, color:uint): void
		{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
 
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
			{
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
 
				var yLonger:Boolean = true;
			}
			else
			{
				yLonger = false;
			}
 
			var inc:int = longLen < 0 ? -1 : 1;
 
			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;
			
			bmd.lock();
			if (yLonger)
			{
				for (var i:int = 0; i != longLen; i += inc)
				{
					bmd.setPixel(x + i*multDiff, y+i, color);
				}
			}
			else
			{
				for (i = 0; i != longLen; i += inc)
				{
					bmd.setPixel(x+i, y+i*multDiff, color);
				}
			}
			bmd.unlock();
		}
		
		private function resetFunc():void
		{
			_points.splice(0, _points.length);
			_dist = 0;
			_angleX = Math.random() * Math.PI / 2;
			_angleY = - Math.random() * Math.PI / 4;
			_speedX = Math.random() * 0.1 - 0.05;
			_speedY = Math.random() * 0.1 - 0.05;
		}
		
		
		/**
		 *	"Xiaolin Wu's line algorithm with anti aliasing"
		 *	http://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm
		 */
		 
		private function AALine(bmd:BitmapData, x1:int, y1:int, x2:int, y2:int, c:uint):void
		{
			var steep:Boolean = (y2 - y1) < 0 ? -(y2 - y1) : (y2 - y1) > (x2 - x1) < 0 ? -(x2 - x1) : (x2 - x1);
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var swap:int;
			var alpha:Number;
			
			if (steep)
			{
				swap = x1; x1 = y1; y1 = swap;
				swap = x2; x2 = y2; y2 = swap;
				swap = dx; dx = dy; dy = swap;
			}
			
			if (x1 > x2)
			{
				swap = x1; x1 = x2; x2 = swap;
				swap = y1; y1 = y2; y2 = swap;
			}
			
			var gradient:Number = dy / dx;
			var xend:Number = x1;
			var yend:Number = y1 + gradient * (xend - x1);
			var xgap:Number = 1.0 - ((x1 + 0.5) % 1.0);
			var xpx1:int = int(xend);
			var ypx1:int = yend;
			
			alpha = (1.0 - (yend % 1.0)) * xgap;
			drawAlpha(bmd, ypx1, xpx1, alpha, c);
			
			alpha = (yend % 1.0) * xgap;
			drawAlpha(bmd, ypx1, xpx1 + 1, alpha, c);
			
			var intery:Number = yend + gradient;
			
			xend = x2;
			yend = y2 + gradient * (xend - x2);
			xgap = (x2 + 0.5) % 1.0;
			var xpx2:int = int(xend);
			var ypx2:int = yend;
			
			alpha = (1 - (yend % 1)) * xgap;
			drawAlpha(bmd, ypx2, xpx2, alpha, c);
			
			alpha = (yend % 1.0) * xgap;
			drawAlpha(bmd, ypx2, xpx2 + 1, alpha, c);
			
			var x:int = xpx1;
			bmd.lock();
			while (x++ < xpx2)
			{
				alpha = (1 - (intery % 1.0));
				drawAlpha(bmd, intery, x, alpha, c);
				alpha = (intery % 1.0);
				drawAlpha(bmd, intery + 1, x, alpha, c);
				intery = intery + gradient;
			}
			bmd.unlock();
		}
		
			
		private function drawAlpha(bmd:BitmapData, x:int, y:int, a:Number, c:Number):void
		{
			var pc:uint = bmd.getPixel32(x, y);
			var r0:uint = (pc & 0x00ff0000) >> 16;
			var g0:uint = (pc & 0x0000ff00) >> 08;
			var b0:uint = (pc & 0x000000ff) >> 00;
			
			var r1:uint = (c & 0x00ff0000) >> 16;
			var g1:uint = (c & 0x0000ff00) >> 08;
			var b1:uint = (c & 0x000000ff) >> 00;
			
			var ac:Number = 0xff;
			var rc:Number = r1*a+r0*(1-a);
			var gc:Number = g1*a+g0*(1-a);
			var bc:Number = b1*a+b0*(1-a);
			
			var color:uint = (ac << 24) + (rc << 16) + (gc << 08) + bc;
			bmd.setPixel32(x, y, color);
		}
		
		private function onStart(e:Event):void
		{			
			var p0:Node = new Node();
			var p1:Node = new Node();
			var dx:Number;
			var dy:Number;
			var color:uint = 0xff000000;
			
			p1.x = WIDTH / 2 + Math.cos(_angleX) * WIDTH / 2;
			p1.y = HEIGHT / 2 + Math.sin(_angleY) * HEIGHT / 2;
			_angleX += _speedX;
			_angleY += _speedY;
			_speedX += Math.random() * 0.01 - 0.005;
			_speedY += Math.random() * 0.01 - 0.005;
			_speedX *= 0.995;
			_speedY *= 0.995;
			
			for (var i:int = 0; i < _points.length; i++)
			{
				p0 = _points[i]; 					
				dx = p0.x - p1.x;;
				dy = p0.y - p1.y;
				
				_dist = Math.sqrt(dx * dx + dy * dy);
				
				if (_dist < 1) return;
				if (_dist < 65)
				{
					var alpha:uint	= (color >> 24) & 0xff;
					var red:uint	= (color >> 16) & 0xff;
					var green:uint	= (color >> 08) & 0xff;
					var blue:uint	= (color >> 00) & 0xff;
					
					var min:Number = Math.min(alpha - _dist / 80, 0xff);
					var max:Number = Math.max(117, min);
					alpha = (alpha < 0xff) ? max : min;
					red = (red < 255) ? red - (_dist * 0.48) : 255 - (_dist * 0.78);
					green = (green < 255) ? green - (_dist * 0.69) : 255 - (_dist * 0.29);
					blue = (blue < 255) ? blue - (_dist * 0.34) : 255 - (_dist * 0.45);
					color = (alpha << 24) | (red << 16) | (green << 08) | blue;
					
					_canvas.graphics.lineStyle(0.2, 0x00, 1 - _dist / 100);
					_canvas.graphics.moveTo(p0.x, p0.y);
					_canvas.graphics.lineTo(p1.x, p1.y);
					//Uncomment this line to test with FAST LINE ALGORITHM
					//efla(_bmd, p0.x, p0.y, p1.x, p1.y, color);
					//AALine(_bmd, p0.x, p0.y, p1.x, p1.y, color);
				}
			} 
			_points.push(p1);
		}
	}	
}