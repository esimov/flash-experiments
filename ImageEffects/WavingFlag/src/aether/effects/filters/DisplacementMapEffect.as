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
	
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * The DisplacementMapEffect class provides a means of displacing an image using an image effect
	 * and the <code>DisplacementMapFilter</code>.
	 * 
	 * <pre>
	 * // the following displaces the image with the map
	 * 
	 * new DisplacementMapEffect(map).apply(image);
	 * </pre>
	 */
	public class DisplacementMapEffect extends BitmapFilterEffect {

		/**
		 * Constructor.
		 * 
		 * @param map The bitmap data to use as the displacement map.
		 * @param scaleX The amount of distortion to apply to the x axis.
		 * @param scaleY The amount of distortion to apply to the y axis.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function DisplacementMapEffect(
			map:BitmapData,
			scaleX:Number=10,
			scaleY:Number=10,
			blendMode:String=null,
			alpha:Number=1
		) {
			var filter:DisplacementMapFilter = new DisplacementMapFilter(map, new Point(), 1, 1, scaleX, scaleY, DisplacementMapFilterMode.CLAMP);
			super(filter, blendMode, alpha);
		}
	
	}
	
}