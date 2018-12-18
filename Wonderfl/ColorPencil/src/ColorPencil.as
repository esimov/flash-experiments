/**
 * Copyright esimov
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 */

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import net.hires.debug.Stats;
	
	[SWF (backgroundColor = 0x00, width = 800, height = 800)]
	
	public class ColorPencil extends Sprite
	{
		private static const PARTICLE_NUM:Number = 800;
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		
		private var _pathList:Vector.<Path> = new Vector.<Path>();
		private var _bmd:BitmapData;
		private var _bmp:Bitmap;
		private var _path:Path;
		var shape:Shape = new Shape();
		
		private var drawing:Boolean = false;
		
		public function ColorPencil()
		{
			if (stage) { addEventListener(Event.ADDED_TO_STAGE, init) }
			else removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;		
		
			addChild(shape);
			
			_bmd = new BitmapData(WIDTH, HEIGHT, true, 0x00);
			_bmp = new Bitmap(_bmd);
			addChild(_bmp);
			_bmp.blendMode = BlendMode.ADD;
			
			for (var i:int = 0; i < PARTICLE_NUM; i++)
			{
				_path = new Path();
				_path.init(0, 0, 5 + (i/20), 0.4, 50);
				_pathList.push(_path);
			}
			
			addChild(new Stats());
			
			addEventListener(Event.ENTER_FRAME, onStart);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseDown);
		}
		
		private function onStart(e:Event):void
		{
			var g:Graphics = shape.graphics;
			g.clear();
			g.beginFill(0xffffff, 1);
			
			for each (var p:Path in _pathList)
			{
				p.setPathPos(stage.mouseX, stage.mouseY);
				if (! drawing) { g.drawCircle(p._point.x, p._point.y, 1) }
			}
			g.endFill();
			
			if (drawing)
			{
				g = shape.graphics;
				g.clear();
				
				for (var i:int = 0; i< _pathList.length - 1; i++)
				{
					var particle:Path = _pathList[i] as Path;
					g.lineStyle(1, particle._color, 0.15);
					g.moveTo(particle._prev.x, particle._prev.y);
					g.lineTo(particle._point.x, particle._point.y);
				}
				
				_bmd.draw(shape, null, new ColorTransform(0.9, 0.9, 0.9), "add");
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (drawing) { drawing = false }
			else drawing = true;
			
			for (var i:int = 0; i< _pathList.length; i++)
			{
				_pathList[i]._color = 0xff0000 + 0xffffff * (i/ _pathList.length);
			}
		}
	}
}

import flash.events.Event;
import flash.geom.Point;
import flash.display.Sprite;

class Path extends Sprite
{
	internal var _acc:Number;
	internal var _dec:Number;
	internal var _max:Number;
	internal var _move:Point = new Point();
	internal var _mouse:Point = new Point();
	internal var _prev:Point = new Point();
	internal var _point:Point = new Point();
	internal var _color:uint = 0;
	
	public function Path():void
	{
		super();
		addEventListener(Event.ENTER_FRAME, onStartFrame);
	}
	
	public function init (x:Number = 1, y:Number = 1, acc:Number = 1, dec:Number = 1, maxSpeed:Number = 20):void
	{
		
		_point.x = _prev.x = x;
		_point.y = _prev.y = y;
		_move.x = 0;
		_move.y = 0;
		this._acc = acc;
		this._dec = dec;
		this._max = maxSpeed;
	}
	
	public function setPathPos(x:Number, y:Number):void
	{
		_mouse.x = x;
		_mouse.y = y;
	}
	
	public function onStartFrame(e:Event):void
	{
		_prev.x = _point.x;
		_prev.y = _point.y;
		var distX:Number = _mouse.x - _prev.x;
		var distY:Number = _mouse.y - _prev.y;
		var prev:Number = Math.sqrt(distX * distX + distY * distY);
		var angle:Number = Math.atan2(distY, distX);
		
		var vx:Number = Math.cos(angle) * _acc;
		var vy:Number = Math.sin(angle) * _acc;
		_move.x += vx;
		_move.y += vy;
		
		var moveSpeed:Number = Math.sqrt(_move.x * _move.x + _move.y * _move.y);
		var moveRadian:Number = Math.atan2(_move.y, _move.x);
		
		if (moveSpeed >= _max)
		{
			_move.x = Math.cos(moveRadian) * _acc;
			_move.y = Math.sin(moveRadian) * _acc;
		}
		
		_point.x += _move.x;
		_point.y += _move.y;
		
		var next:Number = Math.sqrt((_mouse.x - _point.x) * (_mouse.x - _point.x) + (_mouse.y - _point.y) * (_mouse.y - _point.y));
		if (prev < next)
		{
			_move.x *= _dec;
			_move.y *= _dec;
		}
	}
}