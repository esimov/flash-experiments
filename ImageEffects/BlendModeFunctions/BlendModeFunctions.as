package {
	import flash.display.Sprite;
	public class BlendModeFunctions extends Sprite {
		public function BlendModeFunctions():void {
			var topPixel:Object = {red:0xff, green:0xcc, blue:0x99};
			var bottomPixel:Object = {red:0x99, green:0x33, blue:0x99};
			var method:String = "invert"; 
			var red:uint = this[method](topPixel.red, bottomPixel.red);
			var green:uint = this[method](topPixel.green, bottomPixel.green);
			var blue:uint = this[method](topPixel.blue, bottomPixel.blue);
			var resultPixel:uint = (red << 16) | (green << 8) | (blue);
			trace(resultPixel.toString(16));
		}
		
		private function normal(top:uint, bottom:uint):uint {
			return top;
		}
		
		private function multiply(top:uint, bottom:uint):uint {
			return (top * bottom) / 255;
		}
		
		private function screen(top:uint, bottom:uint):uint {
			return (255 - ((255 - top) * (255 - bottom))/255);
		}
		
		private function hardlight(top:uint, bottom:uint):uint {
			var color:uint;
			if (top > 127.5) {
				color = screen(bottom, top * 2 - 255);
			}
			else {
				color = multiply (bottom, top * 2);
			}
			return color;
		}
		
		private function overlay(top:uint, bottom:uint):uint {
			return hardlight(bottom, top);
		}
		
		private function add(top:uint, bottom:uint):uint {
			return Math.min(255, top + bottom);
		}
		
		private function substract(top:uint, bottom:uint):uint {
			return Math.max(0, top - bottom);
		}
		
		private function lighten (top:uint, bottom:uint):uint {
			return Math.max(top, bottom);
		}
		
		private function darken (top:uint, bottom:uint):uint {
			return Math.min(top, bottom);
		}
		
		private function difference (top:uint, bottom:uint):uint {
			return Math.abs(top - bottom);
		}
		
		private function invert (top:uint, bottom:uint):uint {
			return 255- bottom;
		}
	}
}