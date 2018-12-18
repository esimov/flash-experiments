package
{
	import flash.events.Event;
	
	import com.bit101.components.Label;import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.HUISlider;
	
	[SWF (background = 0x00, width = "600", height = "600")]
	
	public class Flower extends AbstractShader1
	{
		private var _shaderURL:String = "../assets/pbk/Flower.pbj";
		public function Flower():void
		{
			super(_shaderURL);
			controlPanel();
		}
		
		override protected function controlPanel():void
		{
			super.controlPanel();
			
			var xOffLabel:Label = new Label(_window, 1, 70, "X: ");
			var yOffLabel:Label = new Label(_window, 1, 90, "Y: ");
			_xOff = new HUISlider(_window, 8, 70,null);
			_xOff.width = _window.width;
			_xOff.setSliderParams(0.0, 10.0, 0.0);
			_xOff.tick = 0.01;
			_yOff = new HUISlider(_window, 8, 90,null);
			_yOff.width = _window.width;
			_yOff.tick = 0.01;
			_yOff.setSliderParams(0.0, 20.0, 2.0);
		}
		
		override protected function onLoadShader(event:Event):void
		{
			super.onLoadShader(event);
			
			_shader.data.resolution.value = [WIDTH/2, HEIGTH/2];
			_shader.data.offsetX.value = [_xOff.value];
			_shader.data.offsetY.value = [_yOff.value];
			_shader.data.red.value = [_red.value];
			_shader.data.green.value = [_green.value];
			_shader.data.blue.value = [_blue.value];
		}
		
		override protected function loop(event:Event):void
		{
			super.loop(event);
			
			time += 0.008;
			_shader.data.time.value = [time];
			_shader.data.offsetX.value = [_xOff.value];
			_shader.data.offsetY.value = [_yOff.value];
			_shader.data.red.value = [_red.value];
			_shader.data.green.value = [_green.value];
			_shader.data.blue.value = [_blue.value];
		}
	}
}