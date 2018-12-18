package  
{
	import flash.display.Sprite;
	import com.bit101.components.*;
	import flash.events.Event;
	
	[SWF(width="960", height="720", backgroundColor="#FFFFFF", frameRate="60")]
	
	public class Main extends Sprite
	{		
		public function Main()
		{
			var Demo:Class = FlockDemo;
			addChild(new Demo());
		}
	}
}
