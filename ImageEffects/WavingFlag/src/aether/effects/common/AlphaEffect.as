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
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	
	/**
	 * The AlphaEffect class provides a simplified way of using one image's alpha channel for
	 * another image within a larger composite effect. This effect is unique for an image effect
	 * in that it does not use the blend mode or alpha settings, as these are not applicable.
	 * 
	 * <pre>
	 * // the following applies mask's alpha channel to the completed effect
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new KaleidoscopeEffect(),
	 *   new AlphaEffect(mask)
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class AlphaEffect extends ImageEffect {
		
		private var _mask:BitmapData;
	
		/**
		 * Constructor.
		 * 
		 * @param mask The bitmap data with an alpha channel that will be used as a mask.
		 */
		public function AlphaEffect(mask:BitmapData) {
			_mask = mask;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function apply(bitmapData:BitmapData):void {
			bitmapData.copyChannel(_mask, _mask.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		}

	}
	
}