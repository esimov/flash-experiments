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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The MarbleTexture creates a marble stone texture using a specified base color.
	 * 
	 * <pre>
	 * // the following creates a purplish marble texture
	 * 
	 * var marble:MarbleTexture = new MarbleTexture(550, 400, 0xFF774499);
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(marble.draw());
	 * shape.graphics.drawRect(0, 0, 550, 400);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class MarbleTexture implements ITexture {
		
		private var _color:uint;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param width The pixel width of the texture.
		 * @param height The pixel height of the texture.
		 * @param color The base color for the marble.
		 */
		public function MarbleTexture(width:Number, height:Number, color:uint) {
			_color = color;
			_width = width;
			_height = height;
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var baseX:Number = 100;
			var baseY:Number = 100;
			var numOctaves:uint = 5;
			var fractal:Boolean = false;
			var marble:BitmapData = new BitmapData(_width, _height, false, 0xFFFFFFFF);
			marble.perlinNoise(baseX, baseY, numOctaves, int(new Date()), true, fractal, 1, true);
			var marbleClip:Sprite = new Sprite();
			marbleClip.graphics.beginFill(_color);
			marbleClip.graphics.drawRect(0, 0, _width, _height);
			marbleClip.graphics.endFill();
			var gmc:Bitmap = new Bitmap(marble);
			marbleClip.addChild(gmc);
			var colors:Array = [0x999999, 0x777777, 0x555555, 0xAAAAAA, 0x888888, 0x6F6F6F, 0x999999];
			var ratios:Array = [10, 40, 60, 140, 160, 200, 215];
			new GradientMapEffect(colors, ratios).apply(marble);
			gmc.blendMode = BlendMode.HARDLIGHT;
			var noise:BitmapData = new BitmapData(_width, _height);
			var nmc:Bitmap = new Bitmap(noise);
			noise.draw(nmc, new Matrix());
			noise.noise(Number(new Date()), 200, 255, 7, true);
			nmc.blendMode = BlendMode.MULTIPLY;
			nmc.filters = [new BlurFilter(2, 2, 1)];
			var composite:BitmapData = new BitmapData(_width, _height);
			composite.draw(marbleClip, new Matrix());
			marble.dispose();
			noise.dispose();
			return composite;
		}
	
	}
	
}