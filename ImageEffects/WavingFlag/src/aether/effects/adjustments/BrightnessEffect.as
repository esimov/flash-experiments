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
	 * The BrightnessEffect class allows you to darken or brighten an image. The <code>amount</code> controls
	 * how much brightening or darkening will occur, with values greater than 0 resulting in a brightening of the image
	 * while values less than 0 resulting in darkening.
	 * 
	 * <pre>
	 * // the following brightens an image by 20 then applies it as an overlay to the
	 * // original image using a OVERLAY blend mode
	 * 
	 * new BrightnessEffect(
	 *   30,
	 *   BlendMode.OVERLAY
	 * ).apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#adjustBrightness()
	 */
	public class BrightnessEffect extends ImageEffect {
	
		private var _amount:Number;

		/**
		 * Constructor.
		 * 
		 * @param amount The amount of brightness change to apply to the original image. Values greater than 0 will
		 *               result in a brightening of the image while values less than 0 will result in darkening.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function BrightnessEffect(
			amount:Number,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_amount = amount;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			Adjustments.adjustBrightness(bitmapData, _amount);
		}
	
	}
	
}