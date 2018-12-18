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
	import aether.utils.MathUtil;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	
	/**
	 * The StarsTexture creates a solid black rectangle with speckled white dots at a variable density.
	 * 
	 * <pre>
	 * // the following creates a dense night sky
	 * 
	 * var stars:StarsTexture = new StarsTexture(550, 400, 0.3);
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(stars.draw());
	 * shape.graphics.drawRect(0, 0, 550, 400);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class StarsTexture implements ITexture {
		
		private var _density:Number;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param width The pixel width of the texture.
		 * @param height The pixel height of the texture.
		 * @param density The density of the stars in the texture. The higher the number, the more stars will appear.
		 */
		public function StarsTexture(width:Number, height:Number, density:Number=0.1) {
			_density = MathUtil.clamp(density, 0, 1);
			_width = width;
			_height = height;
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var noise:BitmapData = new BitmapData(_width, _height, false);
			var perlin:BitmapData = noise.clone();
			noise.noise(int(new Date()), 0, 255, 7, true);
			ImageUtil.applyFilter(noise, new BlurFilter(2, 2));
			var black:uint = 160 - 80*_density;
			var mid:uint = (200 - black)/2 + black;
			Adjustments.setLevels(noise, black, mid, 200);
			perlin.perlinNoise(50, 50, 2, Math.random(), false, true, 7, true);
			noise.draw(perlin, null, null, BlendMode.MULTIPLY);
			perlin.dispose();
			return noise;
		}
	
	}
	
}