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
package aether.effects.convolution {

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * The FindEdgesEffect class provides a simplified means of using the <code>ConvolutionEffect</code> 
	 * to do edge detection and outlining of an image.
	 * 
	 * <pre>
	 * // the following finds the higher contrast edges in an image, then inverts the result
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new FindEdgesEffect(),
	 *   new InvertEffect()
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class FindEdgesEffect extends ConvolutionEffect {
	
		static private const GRAYSCALE_MATRIX:Array = [.3, .59, .11, 0, 0, .3, .59, .11, 0, 0, .3, .59, .11, 0, 0, 0, 0, 0, 1, 0];

		private var _grayscale:Boolean;
	
		/**
		 * Constructor.
		 * 
		 * @param grayscale Whether the resulting image should be in grayscale.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function FindEdgesEffect(
			grayscale:Boolean=false,
			blendMode:String=null,
			alpha:Number=1
		) {
			var matrix:Array=[
				-1, -1, -1,
				-1,  8, -1,
				-1, -1, -1
			];
			super(matrix, 1, 0, blendMode, alpha);
			_grayscale = grayscale;		
		}

		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			super.applyEffect(bitmapData);
			if (_grayscale) {
				var gray:ColorMatrixFilter = new ColorMatrixFilter(GRAYSCALE_MATRIX);
				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), gray);
			}
		}
		
	}
	
}