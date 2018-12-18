/**

Copyright (c) 2009 Todd M. Yard

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/
package aether.utils {

	/**
	 * The Color class provides a simplified means of working with different representations of color, from decimal and 
	 * hexidecimal notation, to RGB and HSV color models. The class also contains a number of constants that can prove
	 * helpful with more common colors.
	 */
	public class Color {
	
		/**
		 * The <code>Color.RED</code> constant holds the numeric value of red, 0xFF0000.
		 */
		static public const RED:uint = 0xFF0000;
		/**
		 * The <code>Color.BLUE</code> constant holds the numeric value of blue, 0x0000FF.
		 */
		static public const BLUE:uint = 0x0000FF;
		/**
		 * The <code>Color.CYAN</code> constant holds the numeric value of cyan, 0x00FFFF.
		 */
		static public const CYAN:uint = 0x00FFFF;
		/**
		 * The <code>Color.GREEN</code> constant holds the numeric value of green, 0x00FF00.
		 */
		static public const GREEN:uint = 0x00FF00;
		/**
		 * The <code>Color.YELLOW</code> constant holds the numeric value of yellow, 0xFFFF00.
		 */
		static public const YELLOW:uint = 0xFFFF00;
		/**
		 * The <code>Color.PURPLE</code> constant holds the numeric value of purple, 0xFF00FF.
		 */
		static public const PURPLE:uint = 0xFF00FF;
		/**
		 * The <code>Color.BLACK</code> constant holds the numeric value of black, 0x000000.
		 */
		static public const BLACK:uint = 0x000000;
		/**
		 * The <code>Color.WHITE</code> constant holds the numeric value of white, 0xFFFFFF.
		 */
		static public const WHITE:uint = 0xFFFFFF;
		/**
		 * The <code>Color.ORANGE</code> constant holds the numeric value of orange, 0xFF6600.
		 */
		static public const ORANGE:uint = 0xFF6600;
		
		private var _value:uint;
		private var _hue:uint;
		private var _saturation:uint;
		private var _brightness:uint;
		private var _changed:Boolean;
		
		/**
		 * Constructor.
		 * 
		 * @param value The numeric value that represents the color.
		 * 
		 * @example
		 * <pre>
		 * // The following creates a new Color instance of red
		 * 
		 * var color:Color = new Color(Color.RED);
		 * </pre>
		 * 
		 * <pre>
		 * // The following creates a new Color instance, then traces out the rgb values
		 * 
		 * var color:Color = new Color(0x117F98);
		 * trace(color.red, color.green, color.blue);
		 * </pre>
		 */
		public function Color(value:uint) {
			_value = value;
			_changed = true;
		}

		/**
		 * Recalculates the HSV values if the color has changed since the last calculation.
		 */
		private function calculateHSV():void {
			if (!_changed) return;
			var r:uint = red;
			var g:uint = green;
			var b:uint = blue;
			_brightness = Math.max(Math.max(r,g),b);
			var min:Number = Math.min(Math.min(r,g),b);
			_saturation = (_brightness <= 0) ? 0 : Math.round(100*(_brightness - min)/_brightness);
			_brightness = Math.round((_brightness/255)*100);
			_hue = 0;
			if((r==g) && (g==b))  _hue = 0;
			else if(r>=g && g>=b) _hue = 60*(g-b)/(r-b);
			else if(g>=r && r>=b) _hue = 60  + 60*(g-r)/(g-b);
			else if(g>=b && b>=r) _hue = 120 + 60*(b-r)/(g-r);
			else if(b>=g && g>=r) _hue = 180 + 60*(b-g)/(b-r);
			else if(b>=r && r>=g) _hue = 240 + 60*(r-g)/(b-g);
			else if(r>=b && b>=g) _hue = 300 + 60*(r-b)/(r-g);
			else _hue = 0;
			_hue = Math.round(_hue);
			_changed = false;
		}

		/**
		 * Sets the value of the color based on HSV values.
		 * 
		 * @param hue The hue of the color, from 0 to 360.
		 * @param saturation The saturation of the color, from 0 to 100.
		 * @param brightness The brightness/value of the color, from 0 to 100.
		 */	
		private function setValueFromHSV(hue:Number, saturation:Number, brightness:Number):void {
			var r:uint;
			var g:uint;
			var b:uint;
			var h:uint = Math.round(hue);
			var s:uint = Math.round(saturation*255/100);
			var v:uint = Math.round(brightness*255/100);
			if(s == 0) {
				r = g = b = v;
			} else {
				var t1:Number = v;	
				var t2:Number = (255-s)*v/255;	
				var t3:Number = (t1-t2)*(h%60)/60;
				if(h==360) h = 0;
				if(h<60) {r=t1;	b=t2;	g=t2+t3}
				else if(h<120) {g=t1;	b=t2;	r=t1-t3}
				else if(h<180) {g=t1;	r=t2;	b=t2+t3}
				else if(h<240) {b=t1;	r=t2;	g=t1-t3}
				else if(h<300) {b=t1;	g=t2;	r=t2+t3}
				else if(h<360) {r=t1;	g=t2;	b=t1-t3}
				else {r=0;	g=0;	b=0}
			}
			red = r;
			green = g;
			blue = b;
		}

		/**
		 * Returns a new <code>Color</code> instance with the same color value.
		 * 
		 * @return A new <code>Color</code> instance with the same color value.
		 */	
		public function copy():Color {
			return new Color(_value);
		}

		/**
		 * The value of the red component of the color as a decimal from 0 to 255.
		 */
		public function get red():uint {
			return _value >> 16 & 0xFF;
		}
		public function set red(value:uint):void {
			_value = value << 16 | green << 8 | blue;
			_changed = true;
		}

		/**
		 * The value of the green component of the color as a decimal from 0 to 255.
		 */
		public function get green():uint {
			return _value >> 8 & 0xFF;
		}
		public function set green(value:uint):void {
			_value = red << 16 | value << 8 | blue;
			_changed = true;
		}

		/**
		 * The value of the blue component of the color as a decimal from 0 to 255.
		 */
		public function get blue():uint {
			return _value & 0xFF;
		}
		public function set blue(value:uint):void {
			_value = red << 16 | green << 8 | value;
			_changed = true;
		}
		
		/**
		 * The hue of the color as a decimal from 0 to 360.
		 */
		public function get hue():uint {
			calculateHSV();
			return _hue;
		}
		public function set hue(value:uint):void {
			_changed = true;
			calculateHSV();
			setValueFromHSV(value, _saturation, _brightness);
			_hue = value;
		}

		/**
		 * The saturation of the color as a decimal from 0 to 100.
		 */
		public function get saturation():uint {
			calculateHSV();
			return _saturation;
		}
		public function set saturation(value:uint):void {
			_changed = true;
			calculateHSV();
			setValueFromHSV(_hue, value, _brightness);
			_saturation = value;
		}

		/**
		 * The brightness of the color as a decimal from 0 to 100.
		 */
		public function get brightness():uint {
			calculateHSV();
			return _brightness;
		}
		public function set brightness(value:uint):void {
			_changed = true;
			calculateHSV();
			setValueFromHSV(_hue, _saturation, value);
			_brightness = value;
		}

		/**
		 * The decimal value of the color.
		 */
		public function get decValue():uint {
			return _value;
		}
		public function set decValue(value:uint):void {
			_value = value;
			_changed = true;
		}
		
		/**
		 * The hexidecimal value of the color, as a string preceded by "0x".
		 */
		public function get hexValue():String {
			var value:String = _value.toString(16);
			while (value.length < 6) value = "0" + value;
			return "0x" + value;
		}
		public function set hexValue(value:String):void {
			_value = parseInt(value, 16);
			_changed = true;
		}
		
	}

}