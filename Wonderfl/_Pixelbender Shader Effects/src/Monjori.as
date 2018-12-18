package
{
	import flash.events.Event;
	
	import com.bit101.components.Label;import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.HUISlider;
	
	[SWF (background = 0x00, width = "640", height = "480")]
	
	public class Monjori extends AbstractShader1
	{
		private var _shaderURL:String = "../assets/pbk/Monjori.pbj";
		public function Monjori():void
		{
			super(_shaderURL);
			controlPanel();
		}
		
		override protected function controlPanel():void
		{
			super.controlPanel();
			_red.setSliderParams(0.1, 20.0, 1.3);
			_green.setSliderParams(0.1, 20.0, 8.0);
			_blue.setSliderParams(0.1, 20.0, 14.0);
		}
		
		override protected function onLoadShader(event:Event):void
		{
			super.onLoadShader(event);
			
			_shader.data.resolution.value = [WIDTH, HEIGTH];
			_shader.data.color.value = [_red.value, _green.value, _blue.value];
		}
		
		override protected function loop(event:Event):void
		{
			super.loop(event);
			
			time += 0.008;
			_shader.data.time.value = [time];
			_shader.data.color.value = [_red.value, _green.value, _blue.value];
		}
	}
}