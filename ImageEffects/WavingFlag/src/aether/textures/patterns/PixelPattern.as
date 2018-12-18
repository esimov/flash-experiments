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
package aether.textures.patterns {
	
	import aether.textures.ITexture;

	import flash.display.BitmapData;
	
	/**
	 * The PixelPattern creates a pattern of pixels, with the color of each pixel being determined by an individual index
	 * in a multidimensional array. The definition that is passed to the constructor is this multidimensional array with
	 * the indices of the top level array holding the values of each row in the pattern and the nested arrays (the rows)
	 * holding the values for each pixel in the row.
	 * 
	 * For instance, the following definition would create 2 pixel wide black and white stripes that could be tiled:
	 * 
	 * <pre>
	 * var definition:Array = [
	 *   [0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0xFF000000]
	 * ];
	 * </pre>
	 * 
	 * Note that in this example, only one row needs to be defined. If more rows are needed, more arrays can be defined, as
	 * in the following, which draws a simple pattern of a solid red pixel surrounded by solid black.
	 * 
	 * <pre>
	 * var definition:Array = [
	 *   [0xFF000000, 0xFF000000, 0xFF000000],
	 *   [0xFF000000, 0xFFFF0000, 0xFF000000],
	 *   [0xFF000000, 0xFF000000, 0xFF000000]
	 * ];
	 * </pre>
	 * 
	 * <pre>
	 * // the following creates a pixel pattern taht will result in diagonal stripes when tiled;
	 * 
	 * var stripes:PixelPattern = new PixelPattern(
	 *   [
	 *     [0xFF000000, 0xFF000000, 0xFF0000FF],
	 *     [0xFF000000, 0xFF0000FF, 0xFF000000],
	 *     [0xFF0000FF, 0xFF000000, 0xFF000000]
	 *   ]
	 * );
	 * 
	 * 
	 * var sprite:Sprite = new Sprite();
	 * sprite.graphics.beginBitmapFill(stripes.draw());
	 * sprite.graphics.drawRect(0, 0, 100, 100);
	 * sprite.graphics.endFill();
	 * addChild(sprite);
	 * </pre>
	 */
	public class PixelPattern implements ITexture {
	
		private var _definition:Array;
	
		/**
		 * Constructor.
		 * 
		 * @param definition A two dimensional array with each index of the nested arrays indicating the 32-bit color value
		 *                   of an individual pixel. Each index of the top level array signifies a different row of the pattern.
		 */
		public function PixelPattern(definition:Array) {
			_definition = definition;
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var w:Number = _definition[0].length;
			var h:Number = _definition.length;
			var pattern:BitmapData = new BitmapData(w, h, true, 0x00FFFFFF);
			var c:uint;
			for (var r:uint = 0; r < h; r++) {
				for (c = 0; c < w; c++) {
					pattern.setPixel32(c, r, _definition[r][c]);
				}
			}
			return pattern;
		}
	
	}
	
}