package  
{
	import flash.display.GraphicsPath;
	import flash.geom.Transform;
	import flash.events.MouseEvent;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.GradientType;

	/**
	 * @author simoe
	 */
	
	[SWF(backgroundColor = 0x00, width='640', height='640', frameRate='60')] 
	 
	public class CrazyTentacles extends Sprite
	{
		private const W:Number = stage.stageWidth;
		private const H:Number = stage.stageHeight;
		
		private var _stack:Vector.<Node>;
		private var _segLength:Number = 10;
		private var _numSeg:Number = 50;
		private var _numIteration:Number = 50;
		private var _numWaves:Number = 0.5;
		private var _waveFreq:Number = 1;
		private var _waveSpeed:Number = 0;
		private var _damping:Number = 0.001;
		private var _shiftSpeed:Number = 0;
		private var _mouseDown:Boolean = false;
		
		private var _canvas:Sprite;
		private var _points:Vector.<IGraphicsData>;
		private var _stroke:GraphicsStroke;
		private var _path:GraphicsPath;

		public function CrazyTentacles():void
		{
			if (stage)
			{
				initStage(null);
				removeEventListener(Event.ADDED_TO_STAGE, initStage);
			}
			else
			{
				throw new Error("Stage not active");
				addEventListener(Event.ADDED_TO_STAGE, initStage);
			}
		}
		
		private function initStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.fullScreenSourceRect = new Rectangle(0, 0, W, H);
			
			createBackground();
			init();
		}
		
		private function createBackground():void
		{
			var background:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(W, H);
			background.graphics.beginGradientFill(GradientType.RADIAL, [0xEFEFEF, 0xEFEFEF, 0xEAEAEA], [1, 1, 1], [0x00, 0x7F, 0xFF], matrix);
			background.graphics.drawRect(0, 0, W, H);
			background.graphics.endFill();
			addChild(background);
		}
		
		private function init():void
		{
			_points = new Vector.<IGraphicsData>();
			_stroke = new GraphicsStroke();
			_stroke.thickness = 1;
			_stroke.fill = new GraphicsSolidFill(0x000000, 0.3);
			_path = new GraphicsPath();
			
			_canvas = new Sprite();
			addChild(_canvas);
			
			_stack = new Vector.<Node>(100, true);
			for (var i:int = 0; i<100; i++)
			{
				_stack[i] = new Node(0, -i * _segLength, 0, 0);
			}
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function (e:Event):void {_mouseDown = !_mouseDown});
			addEventListener(Event.ENTER_FRAME, draw);
		}
		
		private function draw(event:Event):void
		{
			var shift:Number = 0;
			_canvas.graphics.clear();
			
			for (var it:int = 0; it< _numIteration; it++)
			{
				shift += _shiftSpeed;
				_stack[0].x = 0;
				_stack[0].y = 0;
				_stack[0].u = 0;
				_stack[0].v = 0;
				_stack[1].x = 0;
				_stack[1].y = -_segLength;
				_stack[1].u = 0;
				_stack[1].v = 0;
				
				if (_mouseDown)
				{
					var node: Node = Node(_stack[_numSeg - 1]);
					node.x = mouseX - W/2 + it / _numIteration;
					node.y = mouseY - H/2 + it / _numIteration;
					node.u = 0;
					node.v = 0;
				}
				
				for (var i:int = 0; i<_numSeg - 1; i++)
				{
					var seg_1:Node = Node(_stack[i]);
					var seg_2:Node = Node(_stack[i+1]);
					var dist_x:Number = seg_2.x - seg_1.x;
					var dist_y:Number = seg_2.y - seg_1.y;
					var length:Number = Math.sqrt(dist_x * dist_x + dist_y * dist_y);
					var fact:Number = 0.5 * (_segLength - length) / length;
					var fx:Number = dist_x / fact;
					var fy:Number = dist_y / fact;
					
					seg_1.x += fx; seg_1.y += fy; 
					seg_1.u += fx; seg_1.v += fy; 
					seg_2.x -= fx; seg_2.y -= fy;
					seg_2.u -= fx; seg_2.v -= fy;
				}
				
				for (i=0; i<_numSeg-2; i++)
				{
					var seg_a:Node = Node(_stack[i]);
					var seg_b:Node = Node(_stack[i+1]);
					var seg_c:Node = Node(_stack[i+2]);
					var dx:Number = seg_b.x - seg_a.x;
					var dy:Number = seg_b.y - seg_a.y;
					var len:Number = Math.sqrt(dx * dx + dy * dy);
					var nx1:Number = dx / len;
					var ny1:Number = dy / len;
					dx = seg_c.x - seg_b.x;
					dy = seg_c.y - seg_b.y;
					len = Math.sqrt(dx*dx + dy*dy);
					var nx2:Number = dx / len;
					var ny2:Number = dy / len;
					
					var dp:Number = nx1*nx2 + ny1*ny2;
					var cp:Number = -ny1*nx2 + ny2*nx1;
					var angle:Number = _waveSpeed * Math.sin(i * _waveFreq + shift) - _segLength/10*Math.atan2(cp, dp);
					fx = -ny1 * angle;
					fy = nx1 * angle;
					seg_a.x += fx; seg_a.y += fy;
					seg_a.u += fx; seg_a.v += fy;
					seg_b.x -= fx; seg_b.y -= fy;
					seg_b.u -= fx; seg_b.y -= fy;
					
					fx = -ny2 * angle;
					fy = nx2 * angle;
					seg_c.x += fx; seg_c.y += fy;
					seg_c.u += fx; seg_c.v += fy;
					seg_b.x -= fx; seg_b.y -= fy;
					seg_b.u -= fx; seg_b.y -= fy;
				}
			}
			
			for (i= 0; i<_numSeg; i++)
			{
				node = Node(_stack[i]);
				node.x += node.u;
				node.y += node.v;
				node.x *= 1 - _damping;
				node.y *= 1 - _damping;
			}
			
			var matrix:Matrix = new Matrix(); 
			matrix.translate(W/2, H/2);
			_canvas.transform.matrix = matrix;
			
			for (var step:Number=0; step<6; step++)
			{
				matrix.rotate(Math.PI/3);
				_canvas.transform.matrix = matrix;
				_path.moveTo(0, 0);
				for (var j:int = 0; j<_numSeg; j++)
				{
					var a:Node = Node(_stack[j]);
					_path.lineTo(a.x, a.y);
				}
				_points.push(_path, _stroke, null);
				_canvas.graphics.drawGraphicsData(_points);
			}
		}
	}
}
