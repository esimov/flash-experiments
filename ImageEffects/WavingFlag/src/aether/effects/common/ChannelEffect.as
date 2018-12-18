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
package aether.effects.common {

	import aether.effects.ImageEffect;
	import aether.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The ChannelEffect class provides a way for an image effect to only be applied to a single channel
	 * in an image, as opposed to effecting the whole image.
	 * 
	 * <pre>
	 * // the following performs a levels adjustment on just the red channel in the image
	 * 
	 * new ChannelEffect(
	 *   new LevelsEffect(50, 127, 205),
	 *   BitmapDataChannel.RED
	 * ).apply(image);
	 * </pre>
	 */
	public class ChannelEffect extends ImageEffect {
	
		private var _effect:ImageEffect;
		private var _channel:uint;
	
		/**
		 * Constructor.
		 * 
		 * @param effect The image effect to apply.
		 * @param channel The channel to which the image effect should be applied.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function ChannelEffect(
			effect:ImageEffect,
			channel:uint,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_effect = effect;
			_channel = channel;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var clone:BitmapData = ImageUtil.getChannelData(bitmapData, _channel);
			_effect.apply(clone);
			bitmapData.copyChannel(clone, clone.rect, new Point(), _channel, _channel);
		}
	
	}
	
}