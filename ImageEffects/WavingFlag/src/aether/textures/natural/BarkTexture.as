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
package aether.textures.natural {
	
	import aether.textures.ITexture;
	import aether.utils.Adjustments;
	import aether.utils.ImageUtil;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The BarkTexture creates a bark-like wood texture using a specified base color.
	 * 
	 * <pre>
	 * // the following creates the default color bark texture
	 * 
	 * var bark:BarkTexture = new BarkTexture(550, 400);
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(bark.draw());
	 * shape.graphics.drawRect(0, 0, 550, 400);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class BarkTexture implements ITexture {
		
		private var _color:uint;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param width The pixel width of the texture.
		 * @param height The pixel height of the texture.
		 * @param color The base color to be used for the bark.
		 */
		public function BarkTexture(width:Number, height:Number, color:uint=0xBB6600) {
			_color = color;
			_width = width;
			_height = height;
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var baseX:Number = 40;
			var baseY:Number = 200;
			var numOctaves:uint = 5;
			var fractal:Boolean = false;
			var threshold:Number = 57;

			var bitmap:BitmapData = new BitmapData(_width, _height, false, 0);
			bitmap.perlinNoise(baseX, baseY, numOctaves, int(new Date()), true, fractal, 1, true);
			
			var filtered:BitmapData = new BitmapData(_width, _height, false, 0x999999);
			filtered.draw(bitmap, null, new ColorTransform(1, 1, 1, .5));

			var matrix:Array=[
				-50, 50, 0,
				-50, 50, 0,
				-50, 50, 0
			];
			var filter:ConvolutionFilter = new ConvolutionFilter(3, 3, matrix, 2);
			ImageUtil.applyFilter(filtered, filter);

			var fill:BitmapData = new BitmapData(_width, _height, false, _color);
			fill.draw(filtered, null, new ColorTransform(1, 1, 1, .7));
			Adjustments.setLevels(fill, 20, 150, 255);
			ImageUtil.applyFilter(fill, new BlurFilter(1, 1));

			var noise:BitmapData = new BitmapData(_width, _height, false);
			noise.noise(int(new Date()), 0, 255, 7, true);
			fill.draw(noise, null, new ColorTransform(1, 1, 1, .1), BlendMode.MULTIPLY);

			return fill;
		}
	
	}
	
}