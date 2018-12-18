package {
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import net.hires.debug.Stats;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	[SWF (backgroundColor = 0x00, width = 800, height = 600)]
	
	public class ParticleWave1 extends Sprite
	{
		private static const NUM_PARTICLE:Number = 6000;
		private var _particles:Vector.<Particle> = new Vector.<Particle>(NUM_PARTICLE, true);
		private var w:Number = stage.stageWidth;
		private var h:Number = stage.stageHeight;
		private var _map:BitmapData = new BitmapData (w, h, false, 0x00);
		private var _canvas:BitmapData = new BitmapData (w, h, false, 0x00);
		private var timeBmd:BitmapData;
		private var _tmp:BitmapData = new BitmapData (w, h, false, 0x00);
		private var time:Bitmap;
		private var _blend:Bitmap;
		private var timeTextField:TextField;
		
		public function ParticleWave1():void
		{
			if (stage) addEventListener(Event.ADDED_TO_STAGE, init);
			else removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			for (var i:Number = 0; i< NUM_PARTICLE; i++)
			{
				_particles[i] = new Particle();
				_particles[i].x = Math.random() * w;
				_particles[i].y = Math.random() * h;
			}
			_blend = new Bitmap(_canvas);
			_blend.blendMode = BlendMode.SCREEN;
			addChild(_blend);
			
			addChild(new Stats());
			timeBmd = new BitmapData(800, 200, true, 0x00);
			time = new Bitmap(timeBmd);
			//addChild(time);
			timeTextField = new TextField();
			addChild(timeTextField);
			timeTextField.x = 0;
			onClick(null);
			stage.addEventListener(MouseEvent.CLICK, onClick);					
			addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onStartFrame(e:Event):void
		{
			_canvas.lock();
			
			for (var i:Number = 0; i< NUM_PARTICLE; i++)
			{
				var pos:uint = _map.getPixel(_particles[i].x, _particles[i].y);
				_particles[i].x += ( (pos 		& 0xff) * .015625) - 1.5;
				_particles[i].y += ( (pos >> 8 	& 0xff) * .015625) - 1.5;
				
				(_particles[i].x < 0) ? _particles[i].x += _canvas.width :
					(_particles[i].x > w) ? _particles[i].x -= _canvas.width : null;
				(_particles[i].y < 0) ? _particles[i].y += _canvas.height :
					(_particles[i].y > h) ? _particles[i].y -= _canvas.height : null;
				
				_canvas.setPixel(_particles[i].x, _particles[i].y, _particles[i].color);
			}
			_canvas.unlock();
			_canvas.colorTransform(_canvas.rect, new ColorTransform(1, 1, 1, 1, -2, -2, -2));
			
			getTime();
		}
		
		private function onClick(e:MouseEvent):void
		{
			for (var i:Number = 0; i< NUM_PARTICLE; i++)
			{
				_particles[i].x = Math.random() * stage.stageWidth;
				_particles[i].y = Math.random() * stage.stageHeight;
				_particles[i].color = Math.floor(Math.random() * 0xFFFFFF + 0xFFFFFF);
			}
			
			_map.perlinNoise(Math.random() * 1500, Math.random() * 1500, 5, Math.random() * 1000, true, true);
		}
		
		private function getTime():void
		{
			var textFormat:TextFormat = new TextFormat("Arial", 300, 0xffffff);
			textFormat.bold = true;
			//timeTextField = new TextField();
			timeTextField.defaultTextFormat = textFormat;
			//timeTextField.autoSize = TextFieldAutoSize.CENTER;
			timeTextField.selectable = false;
			timeTextField.width = stage.width - 40;
			timeTextField.height = 300;
			timeTextField.mouseEnabled = false;
			timeTextField.blendMode = "overlay";
			
			var time:Date = new Date();
			var hours:Number = time.getHours();
			var minutes:Number = time.getMinutes();
			var seconds:Number = time.getSeconds();
			var minutesStr:String;
			var secondsStr:String;
			var ampm:String = "";
			(hours > 12) ? ampm = "PM" : ampm = "AM";
			(hours > 12) ? hours = hours - 12 : null;
			if (String(minutes).length == 1) minutesStr = "0" + String(minutes);
			if (String(seconds).length == 1) secondsStr = "0" + seconds.toString();
			timeTextField.text = String(hours) + ":" + minutes + ":" + seconds + ampm;
						
			
			//timeBmd.draw(timeTextField, null, null, "add");
			//timeBmd.fillRect(timeBmd.rect, 0x00);
			//tbmd.fillRect(tbmd.rect, 0x00);
			
		}
	}
}

class Particle {
	public var x:Number = 0;
	public var y:Number = 0;
	public var color:uint = 0x00;
}