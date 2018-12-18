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
package aether.effects.texture {

	import aether.effects.ImageEffect;
	import aether.utils.Adjustments;
	import aether.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The DistressEffect class offers a way to distress an image by a variable amount through the use of
	 * noise and displacement. 
	 * 
	 * <pre>
	 * // the following displaces an image by an amount of 10
	 * 
	 * new DistressEffect(10).apply(image);
	 * </pre>
	 */
	public class DistressEffect extends ImageEffect {
	
		private var _amount:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param amount The amount of distress to apply to the image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function DistressEffect(amount:Number=1, blendMode:String=null, alpha:Number=1) {
			init(blendMode, alpha);
			_amount = amount;
		}
	
		/**
		 * Performs the distress on the image.
		 * 
		 * @param bitmapData The image to distress.
		 */
		private function distressImage(bitmapData:BitmapData):void {
			var baseX:Number = 20;
			var baseY:Number = 20;
			var numOctaves:uint = 5;
			var fractal:Boolean = true;
			var perlin:BitmapData = bitmapData.clone();
			perlin.perlinNoise(baseX, baseY, numOctaves, int(new Date()), true, fractal, BitmapDataChannel.RED, true);
			Adjustments.setLevels(perlin, 0, 50, 100);
			var displaceX:Number = _amount;
			var displaceY:Number = _amount*3;
			ImageUtil.applyFilter(bitmapData, new DisplacementMapFilter(perlin, new Point(), 1, 1, displaceX, displaceY, DisplacementMapFilterMode.CLAMP));

			var noise:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			ImageUtil.applyFilter(noise, new BlurFilter(displaceX, displaceY));
			noise.noise(int(new Date()), 0, 255, BitmapDataChannel.RED, true);
			ImageUtil.applyFilter(noise, new BlurFilter(displaceX, displaceY));
			Adjustments.setLevels(noise, 105, 107, 109);

			var alpha:BitmapData = ImageUtil.getChannelData(bitmapData, BitmapDataChannel.ALPHA);
			alpha.draw(noise, null, new ColorTransform(1, 1, 1, Math.min(1, _amount*.2)), BlendMode.MULTIPLY);
			
			bitmapData.copyChannel(alpha, alpha.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		}

		/**
		* Draws a copy of the image, rotated 180 degrees, into the original image.
		*
		* @param bitmapData The image to rotate.
		*/
		private function rotateImage(bitmapData:BitmapData):void {
			var matrix:Matrix = new Matrix();
			// PI radians == 180 degress
			matrix.rotate(Math.PI);
			matrix.translate(bitmapData.width, bitmapData.height);
			var rotatedBitmap:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			rotatedBitmap.draw(bitmapData, matrix);
			// copy rotated data into original bitmap data
			bitmapData.copyPixels(rotatedBitmap, bitmapData.rect, new Point());
		}

		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			distressImage(bitmapData);
			rotateImage(bitmapData);
			distressImage(bitmapData);
			rotateImage(bitmapData);
		}
	
	}
	
}