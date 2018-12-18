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
package aether.effects.transformations {
	
	import aether.effects.ImageEffect;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The TransformEffect provides a way to transform an image using a matrix in an image effect, which
	 * can then be overlaid and blended with the underlying image or used in a composite effect.
	 * 
	 * <pre>
	 * // the following scales down the original image and draws black where there is no pixel information,
	 * // resulting in a black border around the original image
	 * 
	 * var matrix:Matrix = new Matrix();
	 * matrix.scale(0.9, 0.9);
	 * matrix.translate((image.width*0.1)/2, (image.height*0.1)/2);
	 * 
	 * new TransformEffect(
	 *   matrix,
	 *   0xFF000000
	 * ).apply(image);
	 * </pre>
	 */
	public class TransformEffect extends ImageEffect {
	
		private var _matrix:Matrix;
		private var _backgroundColor:uint;

		/**
		 * Constructor.
		 * 
		 * @param matrix The matrix transformation to apply to the image.
		 * @param backgroundColor The 32-bit color to use for pixels that do not have image information after the transformation.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function TransformEffect(
			matrix:Matrix,
			backgroundColor:uint=0,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_matrix = matrix;
			_backgroundColor = backgroundColor;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var copy:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, _backgroundColor);
			copy.draw(bitmapData, _matrix);
			bitmapData.copyPixels(copy, copy.rect, new Point());
		}
	
	}
	
}