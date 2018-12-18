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
package aether.effects.transformations {
	
	import aether.effects.ImageEffect;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The GridEffect class provides a means of replicating an image over a grid with a specified
	 * number of columns and rows.
	 * 
	 * <pre>
	 * // the following creates a 3x3 grid using the original image
	 * 
	 * new GridEffect(3, 3).apply(image);
	 * </pre>
	 */
	public class GridEffect extends ImageEffect {
	
		private var _rows:uint;
		private var _columns:uint;

		/**
		 * Constructor.
		 * 
		 * @param rows The number of rows to render in the grid.
		 * @param columns The number of columns to render in the grid.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function GridEffect(
			rows:uint=2,
			columns:uint=2,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_rows = rows;
			_columns = columns;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var w:Number = bitmapData.width;
			var tW:Number = w/_columns;
			var h:Number = bitmapData.height;
			var tH:Number = h/_rows;
			var matrix:Matrix = new Matrix();
			matrix.scale(tW/w, tH/h);
			var image:BitmapData = new BitmapData(tW, tH, true, 0x00000000);
			image.draw(bitmapData, matrix);
			var grid:BitmapData = new BitmapData(w, h);
			var column:uint;
			for (var row:uint = 0; row < _rows; row++) {
				for (column = 0; column < _columns; column++) {
					grid.copyPixels(image, image.rect, new Point(column*tW, row*tH));
				}
			}
			bitmapData.copyPixels(grid, grid.rect, new Point());
		}
	
	}
	
}