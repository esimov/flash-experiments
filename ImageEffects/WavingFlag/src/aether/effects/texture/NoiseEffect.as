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

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * The NoiseEffect class provides a means to apply variable noise to an image.
	 * 
	 * <pre>
	 * // the following applies slight noise to the image
	 * 
	 * new NoiseEffect(0.1).apply(image);
	 * </pre>
	 */
	public class NoiseEffect extends ImageEffect {
	
		private var _strength:Number;

		/**
		 * Constructor.
		 * 
		 * @param strength The amount of noise to apply, from 0 to 1. A value of 0 will have no affect. A value of 1 will
		 *                 completely obscure the original image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function NoiseEffect(strength:Number=1, blendMode:String=null, alpha:Number=1) {
			init(blendMode, alpha);
			_strength = strength;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var noise:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			noise.fillRect(noise.rect, 0xFFFFFF);
			var seed:uint = (Math.random()*1000)|0;
			noise.noise(seed, 0, 255, 1, true);
			var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, _strength, 0, 0, 0, 0);
			bitmapData.draw(noise, new Matrix(), colorTransform, BlendMode.MULTIPLY);
		}
	
	}
	
}