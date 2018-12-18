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
	 * The SaturationEffect class allows you to adjust the saturation of an image. The <code>amount</code> controls
	 * the level of saturation/desaturation, with values below 1 desaturatiing an image (0 is a fully desaturated
	 * image) and values over 1 increasing an image's color saturation.
	 * 
	 * <pre>
	 * // the following completely desaturates an image before posterizing it
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new SaturationEffect(0),
	 *   new PosterizeEffect(4)
	 *   ]
	 * ).apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#saturate()
	 */
	public class SaturationEffect extends ImageEffect {
	
		private var _amount:Number;

		/**
		 * Constructor.
		 * 
		 * @param amount The amount of color saturation to apply to the image. Numbers below 1 will result in desaturation
		 *               (with 0 signifying full desaturation) while numbers above 1 will saturate the colors of an image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function SaturationEffect(amount:Number=1, blendMode:String=null, alpha:Number=1) {
			init(blendMode, alpha);
			_amount = amount;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			Adjustments.saturate(bitmapData, _amount);
		}
	
	}
	
}