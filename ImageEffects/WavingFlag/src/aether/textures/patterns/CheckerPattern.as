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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The CheckerPattern provides a means to draw rectangles of alternating colors in a checkerboard pattern.
	 * The class allows you to define the 32-bit colors of the alternating checks as well as their width and height.
	 * 
	 * <pre>
	 * // the following creates a black and white checkerboard with the checks being 50x50px
	 * 
	 * var checkers:CheckerPattern = new CheckerPattern(50, 50, 0xFF000000, 0xFFFFFFFF);
	 * var sprite:Sprite = new Sprite();
	 * sprite.graphics.beginBitmapFill(checkers.draw());
	 * sprite.graphics.drawRect(0, 0, 500, 500);
	 * sprite.graphics.endFill();
	 * addChild(sprite);
	 * </pre>
	 */
	public class CheckerPattern implements ITexture {
		
		private var _checkWidth:Number;
		private var _checkHeight:Number;
		private var _color1:uint;
		private var _color2:uint;
	
		/**
		 * Constructor.
		 * 
		 * @param checkWidth The pixel width of a single check in the pattern.
		 * @param checkHeight The pixel height of a single check in the pattern.
		 * @param color1 The 32-bit color of first check in the pattern.
		 * @param color2 The 32-bit color of the alternating check in the pattern.
		 */
		public function CheckerPattern(
			checkWidth:Number,
			checkHeight:Number,
			color1:uint,
			color2:uint
		) {
			_checkWidth = checkWidth;
			_checkHeight = checkHeight;
			_color1 = color1;
			_color2 = color2;
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var w:Number = _checkWidth*2;
			var h:Number = _checkHeight*2;
			var pattern:BitmapData = new BitmapData(w, h, true, 0x00000000);
			var count:uint = 0;
			var totalColumns:uint = 2;
			var totalRows:uint = 2;
			var c:uint;
			for (var r:uint = 0; r < totalRows; r++) {
				for (c = 0; c < totalColumns; c++) {
					pattern.fillRect(new Rectangle(c*_checkWidth, r*_checkHeight, _checkWidth, _checkHeight), count++%2>0 ? _color1 : _color2);
				}
				count++;
			}
			return pattern;
		}
	
	}
	
}