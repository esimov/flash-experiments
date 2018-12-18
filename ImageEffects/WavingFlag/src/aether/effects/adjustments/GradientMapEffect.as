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
package aether.effects.adjustments {

	import aether.effects.ImageEffect;
	import aether.utils.Adjustments;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * The GradientMapEffect class allows you to remap an image's colors to a custom gradient using
	 * <code>BitmapData.paletteMap()</code>. The colors and ratios specified in the constructor correspond
	 * with the colors and ratios that would be used in a <code>Graphics.beginGradientFill()</code> call.
	 * 
	 * <pre>
	 * // the following creates a tritone sepia image with a custom gradient
	 * 
	 * new GradientMapEffect(
	 *   [0x000000, 0xAA7733, 0xFFFFFF],
	 *   [0, 100, 225]
	 * ).apply(image);
	 * </pre>
	 */
	public class GradientMapEffect extends ImageEffect {
		
		private var _colors:Array;
		private var _ratios:Array;
		private var _map:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param colors The array of colors defining the gradient to which to remap the colors of the image.
		 * @param ratios The array of values that determines how colors in the gradient should be distributed
		 *               based on the brightness value of the original image. The length of this array must
		 *               equal the length of the colors array.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function GradientMapEffect(
			colors:Array,
			ratios:Array,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_colors = colors;
			_ratios = ratios;
		}
	
		/**
		 * Creates a palette map for the red, green and blue channels to be used with BitmapData's paletteMap method.
		 * 
		 * @param colors The array of colors for the palette map.
		 * @param ratios The array of ratios for the palette map.
		 */ 
		private function createPaletteMap(colors:Array, ratios:Array):void {
			_map = {};
			_map.r = [];
			_map.g = [];
			_map.b = [];
			var gC:Array = [];
			var r:Number;
			var g:Number;
			var b:Number;
			var c:Number;
			var c1:Object;
			var c2:Object;
			var r1:Number;
			var r2:Number;
			var index:Number = 0;
			var cI:Number = 0;
			var br:Number;
			var cL:Number = colors.length;
			for (var i:uint = 0; i < cL; i++){
				c = colors[i];
				gC.push({r:c>>16&255,g:c>>8&255,b:c&255});
			}
			for (i = 0; i < 256; i++){
				cI = findColorIndex(i, ratios, cL, index);
				index = (cI < 0) ? 0 : cI;
				c1 = gC[index];
				c2 = gC[index + 1];
				r1 = ratios[index];
				r2 = ratios[index + 1];
				if (c2 == null || cI < 0){
					r = c1.r;
					g = c1.g;
					b = c1.b;
				} else {
					br = (i - r1)/(r2 - r1);
					r = ((c2.r - c1.r)|0) * br + c1.r;
					g = ((c2.g - c1.g)|0) * br + c1.g;
					b = ((c2.b - c1.b)|0) * br + c1.b;
				}
				_map.r.push(r << 16);
				_map.g.push(g << 8);
				_map.b.push(b);
			}
		}
	
		/**
		 * Finds the color to be used for a certain position in a color channel array.
		 * 
		 * @param pos The position in the 256 values of a channel.
		 * @param ratios The ratio values for the palette map.
		 * @param rLength The number of ratio values.
		 * @param index The current index being assessed in the ratios array.
		 * 
		 * @return The color to be used for the specified position.
		 */
		private function findColorIndex(
			pos:uint,
			ratios:Array,
			rLength:uint,
			index:uint
		):Number {
			var r1:Number;
			var r2:Number;
			if (pos < ratios[index]) return -1;
			for (var i:uint = index; i < rLength; i++){
				r1 = ratios[i];
				r2 = ratios[i + 1];
				if ((pos >= r1 && pos < r2) || isNaN(r2)) return i;
			}
			return 0;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var grayscaleImage:BitmapData = bitmapData.clone();
			Adjustments.desaturate(grayscaleImage);
			if (_map == null) {
				createPaletteMap(_colors, _ratios);
			}
			bitmapData.copyPixels(grayscaleImage, grayscaleImage.rect, new Point());
			bitmapData.paletteMap(bitmapData, bitmapData.rect, new Point(), _map.r, _map.g, _map.b);
		}
	
	}
	
}