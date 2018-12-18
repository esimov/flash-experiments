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
	 * The LevelsEffect class allows you to adjust the levels of an image by setting a black point (below
	 * which all pixels will be recolored black), a white point (below which all pixels will be recolored
	 * white) and a medium gray point (used to redistribute the remaining colors in the image between
	 * the black and white points).
	 * 
	 * <pre>
	 * // the following increases the contrast of an image through levels, then applies it as an
	 * // overlay to the original image using a HARDLIGHT blend mode
	 * 
	 * new LevelsEffect(
	 *   50,
	 *   127,
	 *   205,
	 *   BlendMode.HARDLIGHT
	 * ).apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#setLevels()
	 */
	public class LevelsEffect extends ImageEffect {
	
		private var _blackPoint:uint;
		private var _midPoint:uint;
		private var _whitePoint:uint;

		/**
		 * Constructor.
		 * 
		 * @param blackPoint The value between 0 and 255 below which all pixels will be set to black.
		 * @param midPoint The point in the range between the <code>blackPoint</code> and the <code>whitePoint</code>
		 *                 that determines how the pixels of this intermediate brightness are distributed across the 
		 *                 remaining range.
		 * @param whitePoint The value between 0 and 255 above which all pixels will be set to white.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function LevelsEffect(
			blackPoint:uint,
			midPoint:uint,
			whitePoint:uint,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_blackPoint = blackPoint;
			_midPoint = midPoint;
			_whitePoint = whitePoint;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			Adjustments.setLevels(bitmapData, _blackPoint, _midPoint, _whitePoint);
		}
	
	}
	
}