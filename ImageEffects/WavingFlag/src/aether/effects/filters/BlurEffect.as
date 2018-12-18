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
package aether.effects.filters {
	
	import flash.filters.BlurFilter;
	
	/**
	 * The BlurEffect class provides a means to blur an image using an image effect and the <code>BlurFilter</code>.
	 * 
	 * <pre>
	 * // the following applies a Rorschach effect, the slightly blurs the result
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new RorschachEffect(),
	 *   new BlurEffect(2, 2)
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class BlurEffect extends BitmapFilterEffect {
	
		/**
		 * Constructor.
		 * 
		 * @param blurX The amount of blur to apply on the x axis.
		 * @param blurY The amount of blur to apply on the y axis.
		 * @param quality The quality of the blur, which corresponds to the number of passes made. THis should be a constant of
		 *                <code>BitmapFilterQuality</code>.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function BlurEffect(
			blurX:Number=5,
			blurY:Number=5,
			quality:int=1,
			blendMode:String=null,
			alpha:Number=1
		) {
			var blur:BlurFilter = new BlurFilter(blurX, blurY, quality);
			super(blur, blendMode, alpha);
		}
	
	}
	
}