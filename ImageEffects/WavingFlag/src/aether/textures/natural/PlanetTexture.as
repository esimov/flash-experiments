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
	
	import aether.effects.adjustments.GradientMapEffect;
	import aether.textures.ITexture;
	import aether.utils.Adjustments;
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	
	/**
	 * The PlanetTexture creates uses Perlin noise, levels reduction and a palette remapping to create an image
	 * that can be used to texture a planet model. Since the colors and how they are distributed is configurable,
	 * there is a high number of possible permutations for different planets, natural and alien. The default
	 * settings create an Earth-like texture.
	 * 
	 * <pre>
	 * // the following creates a orange and earthtone planet texture
	 * // that is stretched horizontally before being drawn into a shape
	 * 
	 * var texture:PlanetTexture = new PlanetTexture(50, 400,
	 *   [0xFFEFEEDD, 0xFFFFCCAA, 0xFFFF6633],
	 *   [0, 127, 255],
	 *   [0, 127, 255]
	 * );
	 * 
	 * var bitmapData:BitmapData = new BitmapData(550, 400);
	 * var matrix:Matrix = new Matrix();
	 * matrix.scale(11, 1);
	 * bitmapData.draw(texture.draw(), matrix);
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(bitmapData);
	 * shape.graphics.drawRect(0, 0, 550, 400);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class PlanetTexture implements ITexture {
		
		private var _colors:Array;
		private var _ratios:Array;
		private var _levels:Array;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param width The pixel width of the texture.
		 * @param height The pixel height of the texture.
		 * @param colors The array of colors to be used for different areas in the texture.
		 * @param ratios The array of ratios that define how the colors are distributed in the texture.
		 *               The number of ratios must match the number of colors.
		 * @param levels The threshold levels for black point, middle gray point and white point that are
		 *               used to adjust the noise that is generated to create the texture. Altering
		 *               these levels can change the amount of "water" and "land" that appear in the texture.
		 */
		public function PlanetTexture(
			width:Number,
			height:Number,
			colors:Array=null,
			ratios:Array=null,
			levels:Array=null
		) {
			_width = width;
			_height = height;
			_colors = colors || [0x344F70, 0x9A7D60, 0x9A7D60, 0x64673E, 0x6D794C, 0xFFFFFF];
			_ratios = ratios || [38, 63, 80, 160, 240, 255];
			_levels = levels || [120, 140, 200];
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var baseX:Number = 50;
			var baseY:Number = 50;
			var numOctaves:uint = 5;

			var bitmapData:BitmapData = new BitmapData(_width, _height, false, 0);
			bitmapData.perlinNoise(baseX, baseY, numOctaves, int(new Date()), true, true, 1, true);
			Adjustments.setLevels(bitmapData, _levels[0], _levels[1], _levels[2]);
			new GradientMapEffect(_colors, _ratios).apply(bitmapData);
			return bitmapData;
		}
	
	}
	
}