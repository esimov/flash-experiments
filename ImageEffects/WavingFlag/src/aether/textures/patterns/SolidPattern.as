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
package aether.textures.patterns {
	
	import aether.textures.ITexture;
	
	import flash.display.BitmapData;
	
	/**
	 * The SolidPattern creates a 1x1 pixel of a solid color. This can be used in combination with other textures when a
	 * solid color is needed in a larger composite texture or effect.
	 * 
	 * <pre>
	 * // the following creates a solid pattern using a dark blue color;
	 * // this is blended with a stars texture to create a night sky
	 * 
	 * var blueColor:SolidPattern = new SolidPattern(0xFF000033);
	 * 
	 * var sky:BitmapData = new BitmapData(550, 400);
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new TextureEffect(blueColor),
	 *   new TextureEffect(new StarsTexture(550, 400), BlendMode.SCREEN)
	 *   ]
	 * ).apply(sky);
	 * 
	 * var bitmap:Bitmap = new Bitmap(sky);
	 * addChild(bitmap);
	 * </pre>
	 */
	public class SolidPattern implements ITexture {
		
		private var _color:uint;
		
		/**
		 * Constructor.
		 * 
		 * @param color The 32-bit color of the texture.
		 */
		public function SolidPattern(color:uint) {
			_color = color;
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			return new BitmapData(1, 1, true, _color);
		}
	
	}
	
}