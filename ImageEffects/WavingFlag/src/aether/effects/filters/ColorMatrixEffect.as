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
package aether.effects.filters {
	
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * The ColorMatrixEffect class provides a means to recolor an image using an image effect
	 * and the <code>ColorMatrixFilter</code>.
	 * 
	 * <pre>
	 * // the following creates a sepia-toned image
	 * 
	 * new ColorMatrixEffect(ColorMatrixEffect.SEPIA).apply(image);
	 * </pre>
	 * 
	 * <pre>
	 * // the following swaps the red and blue channels in an image
	 * 
	 * new ColorMatrixEffect(
	 *   [
	 *   0, 0, 1, 0, 0,
	 *   0, 1, 0, 0, 0,
	 *   1, 0, 0, 0, 0,
	 *   0, 0, 0, 1, 0
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class ColorMatrixEffect extends BitmapFilterEffect {
	
		/**
		 * The matrix that can be used to make an image grayscale.
		 */
		static public var GRAYSCALE:Array = [.3, .59, .11, 0, 0, .3, .59, .11, 0, 0, .3, .59, .11, 0, 0, 0, 0, 0, 1, 0];
		/**
		 * The matrix that can be used to make an sepia-toned.
		 */
		static public var SEPIA:Array = [.5, .59, .11, 0, 0, .4, .59, .11, 0, 0, .16, .59, .11, 0, 0, 0, 0, 0, 1, 0];
		/**
		 * The matrix that can be used to remove all color transformations on the image.
		 */
		static public var IDENTITY:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];

		private var _matrix:Array;

		/**
		 * Constructor.
		 * 
		 * @param matrix The matrix to pass to the <code>ColorMatrixFilter</code> to determine the color transformation.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function ColorMatrixEffect(matrix:Array, blendMode:String=null, alpha:Number=1) {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			super(filter, blendMode, alpha);
		}
	
	}
	
}