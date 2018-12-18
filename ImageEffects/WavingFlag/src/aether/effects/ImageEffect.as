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
package aether.effects {

	import aether.utils.ImageUtil;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;

	/**
	 * The ImageEffect class serves as an abstract base class for all image effects in the aether library. It should not be
	 * instantiated directly. Instead, concrete child classes extending this class should be used to create specific effects.
	 * The benefit of using this class is the ability to easily create composite effects using multiple specific child classes
	 * as well the ability to apply these effects, singularly or as composites, as an overlay of the original image.
	 */
	public class ImageEffect {
		
		/**
		 * The blend mode to use in the final effect.
		 */
		protected var _blendMode:String;
		/**
		 * The alpha to apply in the final effect.
		 */
		protected var _alpha:Number;

		/**
		 * Initializes the common properties for an image effect. This should be invoked by the concrete child class
		 * in its constructor.
		 * 
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		protected function init(blendMode:String=null, alpha:Number=1):void {
			_blendMode = blendMode;
			_alpha = alpha;
		}

		/**
		 * Internal method to perform the necessary bitmap manipulations on the data. This method should be
		 * overridden by all concrete child classes of <code>ImageEffect</code>. This differs from <code>apply()</code>
		 * in that <code>apply()</code> is the public interface to applying the effect and handles whether the affect
		 * is applied as an overlay with a blend mode or not. This method, in contrast, simply should perform the 
		 * effect on the data without regard to how the final data is applied to the original image.
		 * 
		 * @param bitmapData The data to which the image effect will be applied.
		 * 
		 * @see #apply()
		 */
		protected function applyEffect(bitmapData:BitmapData):void {}

		/**
		 * Applies the configured image effect to the specified bitmap data. This is a destructive method,
		 * copying over the pixels in the original bitmap data. If you wish to maintain the original data
		 * unaltered, be sure to clone it before invoking this method.
		 * 
		 * @param bitmapData The data to which the image effect will be applied.
		 */
		public function apply(bitmapData:BitmapData):void {
			var clone:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			ImageUtil.copyPixels(bitmapData, clone);
			if ((!_blendMode || _blendMode == BlendMode.NORMAL) && _alpha == 1){
				applyEffect(clone);
			} else {
				var overlay:BitmapData = clone.clone();
				applyEffect(overlay);
				clone.draw(overlay, null, new ColorTransform(1, 1, 1, _alpha), _blendMode);
			}
			ImageUtil.copyPixels(clone, bitmapData);
		}

	}

}