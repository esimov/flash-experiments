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
package aether.effects.convolution {
	
	import aether.effects.ImageEffect;
	
	import flash.display.BitmapData;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	
	/**
	 * The ConvolutionEffect class provides a means to use the <code>ConvolutionFilter</code> 
	 * within a larger composite image effect.
	 * 
	 * <pre>
	 * // the following applies a Rorschach effect, then applies an outline to the result
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new RorschachEffect(),
	 *   new ConvolutionEffect(ConvolutionEffect.OUTLINE)
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class ConvolutionEffect extends ImageEffect {

		/**
		 * The matrix that can be used to sharpen an image.
		 */
		public static const SHARPEN:Array = [0,-1,0,-1,5,-1,0,-1,0];
		/**
		 * The matrix that can be used to outline the darker regions of an image.
		 */
		public static const OUTLINE:Array = [-5,5,0,-5,5,0,-5,5,0];
		/**
		 * The matrix that can be used to emboss an image.
		 */
		public static const EMBOSS:Array = [-2,-1,0,-1,1,1,0,1,2];
	
		private var _filter:ConvolutionFilter;

		/**
		 * Constructor.
		 * 
		 * @param matrix The matrix to use to perform the convolution effect. See Adobe's ConvolutionFilter.
		 * @param divisor The divisor to use to perform the convolution effect. See Adobe's ConvolutionFilter.
		 * @param bias The bias to use to perform the convolution effect. See Adobe's ConvolutionFilter.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function ConvolutionEffect(
			matrix:Array,
			divisor:Number=1,
			bias:Number=0,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			var numEntries:uint = matrix.length/3;
			_filter = new ConvolutionFilter(numEntries, numEntries, matrix, divisor, bias);
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), _filter);
		}
	
	}
	
}