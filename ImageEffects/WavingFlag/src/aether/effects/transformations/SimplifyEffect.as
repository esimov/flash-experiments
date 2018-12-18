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
	
	/**
	 * The SimplifyEffect class creates a pixelated pattern or mosaic of an image by scaling an image down into
	 * a new bitmap data, then scaling it back up into the original bitmap data. This produces the same pixelation
	 * that would occur when simply scaling up an image. The <code>amount</code> determines how much the original
	 * image is scaled, and thus the amount of pixelation. A value of 1 will result in no pixelation. Anything 
	 * higher will result in some pixelation.
	 * 
	 * <pre>
	 * // the following simplifies an image by an amount of 20
	 * 
	 * new SimplifyEffect(20).apply(image);
	 * </pre>
	 */
	public class SimplifyEffect extends ImageEffect {
	
		private var _amount:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param amount The amount to simplify the image. This should be a value between 1 (no effect) and the lesser of the
		 *               width and height of the image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function SimplifyEffect(amount:Number, blendMode:String=null, alpha:Number=1) {
			init(blendMode, alpha);
			_amount = amount;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var bw:Number = bitmapData.width;
			var bh:Number = bitmapData.height;
			var w:uint = bw/_amount;
			var h:uint = bh/_amount;
			var m:Matrix = new Matrix();
			m.scale(w/bw, h/bh);
			var b:BitmapData = new BitmapData(w, h, true, 0x000000);
			b.draw(bitmapData, m);
			m = new Matrix();
			m.scale(bw/w, bh/h);
			bitmapData.draw(b, m);
		}
	
	}
	
}