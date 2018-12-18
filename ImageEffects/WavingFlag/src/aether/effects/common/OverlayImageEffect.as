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
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The OverlayImageEffect class provides a way to copy one image onto another image, generally
	 * during a larger composite effect. The class allows you to control the image and where in the
	 * destination image the overlay is placed.
	 * 
	 * <pre>
	 * // the following applies a texture effect, then overlays an image on top of it
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new TextureEffect(
	 *     new StoneTexture(300, 300)
	 *   ),
	 *   new OverlayImageEffect(overlay)
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class OverlayImageEffect extends ImageEffect {
	
		private var _image:BitmapData;
		private var _matrix:Matrix;
		
		/**
		 * Constructor.
		 * 
		 * @param image The image to overlay.
		 * @param point The position in the destination image at which the overlay will be set.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function OverlayImageEffect(
			image:BitmapData,
			point:Point=null,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			if (point == null) {
				point = new Point();
			}
			_image = image;
			_matrix = new Matrix();
			_matrix.translate(point.x, point.y);
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			bitmapData.draw(_image, _matrix);
		}
	
	}
	
}