package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.HUISlider;
	
	[SWF (background = 0x00, width = "800", height = "800")]
	
	public class PlasmaTunnel extends AbstractShader1
	{
		private var _shaderURL:String = "../assets/pbk/Plasma.pbj";
		private var _xpos:Number;
		private var _ypos:Number;
		
		public function PlasmaTunnel():void
		{
			super(_shaderURL);
			controlPanel();
		}
		
		override protected function controlPanel():void
		{
			super.controlPanel();
			
			var effect:Label = new Label(_window, 1, 70, "X: ");
			_xOff = new HUISlider(_window, 8, 70,null);
			_xOff.width = _window.width;
			_xOff.setSliderParams(0.0, 0.5, 0.08);
		}
		
		override protected function onLoadShader(event:Event):void
		{
			super.onLoadShader(event);
			
			_xpos = _bmp.mouseX;
			_ypos = _bmp.mouseY;
			
			_shader.data.resolution.value = [WIDTH*1.5, HEIGTH*1.5];
			_shader.data.deform.value = [_xOff.value];
			
			onStageResize(null);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		override protected function loop(event:Event):void
		{
			super.loop(event);
			
			_xpos += (_bmp.mouseX - _xpos) * 0.1;
			_ypos += (_bmp.mouseY - _ypos) * 0.1;
			
			time += 0.008;
			_shader.data.time.value = [time];
			_shader.data.deform.value = [_xOff.value];
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			_shader.data.center.value = [_xpos, _ypos];
		}
		
		private function onStageResize(event:Event):void
		{
			_bmp.x = (stage.stageWidth - _bmp.width) >> 1;
			_bmp.y = (stage.stageHeight - _bmp.height) >> 1;
		}
	}
}