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
package aether.effects.carnival {
	
	import aether.effects.ImageEffect;
	import aether.utils.Adjustments;
	import aether.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The RorschachEffect class takes an image, applies a threshold to it, then mirrors the image
	 * horizontally along the y axis in the center of the image, creating a symmetrical two color
	 * image like those in Rorschach tests. The two colors used for the foreground "inkblots" and 
	 * the background paper are configurable.
	 * 
	 * <pre>
	 * // the following creates a Rorschach effect from an image using the default black and white colors
	 * 
	 * new RorschachEffect().apply(image);
	 * </pre>
	 * 
	 * @see aether.utils.Adjustments#threshold()
	 */
	public class RorschachEffect extends ImageEffect {
	
		private var _foregroundColor:uint;
		private var _backgroundColor:uint;
		
		/**
		 * Constructor.
		 * 
		 * @param foregraoundColor The color that will be used for the foreground inkblot elements.
		 * @param backgroundColor The color that will be used for the background of the image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function RorschachEffect(
			foregroundColor:uint=0xFF000000,
			backgroundColor:uint=0xFFFFFFFF,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_foregroundColor = foregroundColor;
			_backgroundColor = backgroundColor;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			ImageUtil.applyFilter(bitmapData, new BlurFilter(8, 8));
			Adjustments.threshold(bitmapData, 120);
			var clone:BitmapData = bitmapData.clone();
			var width:Number = bitmapData.width;
			var height:Number = bitmapData.height;
			var matrix:Matrix = new Matrix();
			matrix.scale(-1, 1);
			matrix.translate(width, 0);
			bitmapData.draw(clone, matrix, null, null, new Rectangle(0, 0, width/2, height));
			var foreground:BitmapData = new BitmapData(width, height, true, 0x00000000);
			var background:BitmapData = foreground.clone();
			foreground.fillRect(foreground.rect, _foregroundColor);
			background.fillRect(background.rect, _backgroundColor);
			background.copyChannel(bitmapData, bitmapData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			Adjustments.invert(bitmapData);
			foreground.copyChannel(bitmapData, bitmapData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			bitmapData.fillRect(bitmapData.rect, 0x00000000);
			var sprite:Sprite = new Sprite();
			var fg:Shape = new Shape();
			fg.graphics.beginBitmapFill(foreground);
			fg.graphics.drawRect(0, 0, width, height);
			fg.graphics.endFill();
			fg.alpha = (_foregroundColor >> 24 & 0xFF)/0xFF;
			sprite.addChild(fg);
			var bg:Shape = new Shape();
			bg.graphics.beginBitmapFill(background);
			bg.graphics.drawRect(0, 0, width, height);
			bg.graphics.endFill();
			bg.alpha = (_backgroundColor >> 24 & 0xFF)/0xFF;
			sprite.addChild(bg);
			bitmapData.draw(sprite);
		}
	
	}
	
}