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
	
	import aether.effects.ImageEffect;
	import aether.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	
	/**
	 * The BitmapFilterEffect class provides a means to apply a <code>BitmapFilter</code> using an image effect.
	 * 
	 * <pre>
	 * // the following applies a glow filter to an image that has alpha applied through an image effect
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new AlphaEffect(alphaMask),
	 *   new BitmapFilterEffect(
	 *     new GlowFilter()
	 *   )
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class BitmapFilterEffect extends ImageEffect {
	
		private var _filter:BitmapFilter;
		
		/**
		 * Constructor.
		 * 
		 * @param filter The bitmap filter to apply for the effect.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function BitmapFilterEffect(
			filter:BitmapFilter,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_filter = filter;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			ImageUtil.applyFilter(bitmapData, _filter);
		}
	
	}
	
}