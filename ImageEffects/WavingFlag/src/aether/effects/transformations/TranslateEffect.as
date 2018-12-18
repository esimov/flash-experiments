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
	import flash.geom.Rectangle;
	
	/**
	 * The TranslateEffect provides a means of translating the pixels of an image on the x and y axes. This
	 * is useful especially for animated effects that need to have wrapping textures when translated, as this
	 * effect automatically will wrap the texture for you.
	 * 
	 * <pre>
	 * // the following translates the pixels in the image right by 100, wrapping them to the opposite side
	 * 
	 * new TranslateEffect(100, 0, true).apply(image);
	 * </pre>
	 */
	public class TranslateEffect extends ImageEffect {
	
		private var _matrix:Matrix;
		private var _wrapAround:Boolean;
		private var _backgroundColor:uint;
		private var _smoothing:Boolean;

		/**
		 * Constructor.
		 * 
		 * @param x The amount to translate the image on the x axis.
		 * @param y The amount to translate the image on the y axis.
		 * @param wrapAround Whether pixels should wrap around to the opposite side when translated out of region.
		 * @param backgroundColor The 32-bit color to apply to the image, visible if wrapAround is false.
		 * @param useSmoothing Whether smoothing is applied during the translation transformations.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function TranslateEffect(
			x:Number,
			y:Number,
			wrapAround:Boolean=false,
			backgroundColor:uint=0,
			useSmoothing:Boolean=false,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_matrix = new Matrix();
			_matrix.translate(x, y);
			_wrapAround = wrapAround;
			_backgroundColor = backgroundColor;
			_smoothing = useSmoothing;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var bd:BitmapData = bitmapData;
			var w:Number = bd.width;
			var h:Number = bd.height;
			var b:BitmapData = new BitmapData(w, h, true, _backgroundColor);
			b.draw(bitmapData, _matrix, null, null, null, _smoothing);
			var matrix:Matrix = new Matrix();
			if (_wrapAround) {
				if (_matrix.tx==0&&_matrix.ty!=0) {
					if (_matrix.ty>0) {
						matrix.translate(0, _matrix.ty-h);
					} else {
						matrix.translate(0, _matrix.ty+h);
					}
					b.draw(bd, matrix, null, null, null, _smoothing);
				} else if (_matrix.tx!=0&&_matrix.ty==0) {
					if (_matrix.tx>0) {
						// this removes seam -- test more, then apply to others
						matrix.translate(_matrix.tx-w+1, 0);
					} else {
						matrix.translate(_matrix.tx+w, 0);
					}
					b.draw(bd, matrix, null, null, null, _smoothing);
				} else if (_matrix.tx>0&&_matrix.ty>0) {
					b.copyPixels(bd, new Rectangle(w-_matrix.tx, 0, _matrix.tx, h-_matrix.ty), new Point(0, _matrix.ty));
					b.copyPixels(bd, new Rectangle(0, h-_matrix.ty, w-_matrix.tx, _matrix.ty), new Point(_matrix.tx, 0));
					b.copyPixels(bd, new Rectangle(w-_matrix.tx, h-_matrix.ty, _matrix.tx, _matrix.ty), new Point());
				} else if (_matrix.tx<0&&_matrix.ty<0) {
					b.copyPixels(bd, new Rectangle(0, 0, -_matrix.tx, -_matrix.ty), new Point(w+_matrix.tx, h+_matrix.ty));
					b.copyPixels(bd, new Rectangle(0, -_matrix.ty, -_matrix.tx, h+_matrix.ty), new Point(w+_matrix.tx, 0));
					b.copyPixels(bd, new Rectangle(-_matrix.tx, 0, w+_matrix.tx, -_matrix.ty), new Point(0, h+_matrix.tx));
				} else if (_matrix.tx<0&&_matrix.ty>0) {
					b.copyPixels(bd, new Rectangle(0, 0, -_matrix.tx, h-_matrix.ty), new Point(w+_matrix.tx, _matrix.ty));
					b.copyPixels(bd, new Rectangle(0, h-_matrix.ty, -_matrix.tx, _matrix.ty), new Point(w+_matrix.tx, 0));
					b.copyPixels(bd, new Rectangle(-_matrix.tx, h-_matrix.ty, w+_matrix.tx, _matrix.ty), new Point());
				} else if (_matrix.tx>0&&_matrix.ty<0) {
					b.copyPixels(bd, new Rectangle(0, 0, w-_matrix.tx, -_matrix.ty), new Point(_matrix.tx, h+_matrix.ty));
					b.copyPixels(bd, new Rectangle(w-_matrix.tx, 0, _matrix.tx, -_matrix.ty), new Point(0, h+_matrix.ty));
					b.copyPixels(bd, new Rectangle(w-_matrix.tx, -_matrix.ty, _matrix.tx, h+_matrix.ty), new Point());
				}
			}
			bd.copyPixels(b, b.rect, new Point());
		}
	
	}
	
}