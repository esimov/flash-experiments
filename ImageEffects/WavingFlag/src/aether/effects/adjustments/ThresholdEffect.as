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
		
	/**
	 * The ThresholdEffect class allows you to apply a brightness threshold to an image, above which
	 * all pixels will be colored white and below which all pixels will be colored black.
	 * 
	 * <pre>
	 * // the following applies a threshold to an image, then applies this with a MULTIPLY
	 * // blend mode so that only the black color will be visible over the original image
	 * 
	 * new ThresholdEffect(
	 *   127,
	 *   BlendMode.MULTIPLY
	 * ).apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#threshold()
	 */
	public class ThresholdEffect extends ImageEffect {
	
		private var _threshold:uint;

		/**
		 * Constructor.
		 * 
		 * @param threshold The brightness value, between 0 and 255, that should be the threshold above and below which the
		 *                  pixels of an image will be recolored black or white.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function ThresholdEffect(
			threshold:uint=128,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_threshold = threshold;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			Adjustments.threshold(bitmapData, _threshold);
		}
	
	}
	
}