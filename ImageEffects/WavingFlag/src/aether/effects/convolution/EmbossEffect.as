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
	
	/**
	 * The EmbossEffect class provides a simplified means of using the <code>ConvolutionEffect</code> 
	 * to apply an embossing to an image.
	 * 
	 * <pre>
	 * // the following embosses an image with an amount of 5
	 * 
	 * new EmbossEffect(5).apply(image);
	 * </pre>
	 */
	public class EmbossEffect extends ConvolutionEffect {

		/**
		 * Constructor.
		 * 
		 * @param amount The amount of embossing to apply in the convolution effect.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function EmbossEffect(
			amount:Number=2,
			blendMode:String=null,
			alpha:Number=1
		) {
			var matrix:Array = [
				-amount, -1,      0,
				     -1,  1,      1,
				      0,  1, amount
			];
			super(matrix, 1, 0, blendMode, alpha);
		}
	
	}
	
}