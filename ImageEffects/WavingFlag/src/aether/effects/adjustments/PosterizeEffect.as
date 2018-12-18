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
	 * The PosterizeEffect class allows you to limit the number of colors in an image through posterization.
	 * The <code>levels</code> determines how many colors will appear in each channel. The total number of
	 * colors in an image would then be determined by that number cubed, so the default setting of 2 would
	 * mean an image with up to 8 colors (2x2x2).
	 * 
	 * <pre>
	 * // the following posterizes an image, then applies it as an
	 * // overlay to the original image using an OVERLAY blend mode
	 * 
	 * new PosterizeEffect(
	 *   3,
	 *   BlendMode.OVERLAY
	 * ).apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#posterize()
	 */
	public class PosterizeEffect extends ImageEffect {
	
		private var _levels:uint;

		/**
		 * Constructor.
		 * 
		 * @param levels The maximum number of colors that should be allowed in each color channel.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function PosterizeEffect(
			levels:uint=2,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_levels = levels;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			Adjustments.posterize(bitmapData, _levels);
		}
	
	}
	
}