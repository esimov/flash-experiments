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
package aether.effects.texture {
	
	import aether.effects.ImageEffect;
	import aether.textures.ITexture;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	/**
	 * The TextureEffect provides a way to apply an aether texture as an image effect, which can then
	 * use the blend mode and alpha to overlay the texture
	 * 
	 * <pre>
	 * // the following applies a solid pattern of medium gray over an image,
	 * // which reduces its contrast
	 * 
	 * new TextureEffect(
	 *   new SolidPattern(0xFF7F7F7F),
	 *   null,
	 *   0.5
	 * ).apply(image);
	 * </pre>
	 */
	public class TextureEffect extends ImageEffect {
	
		private var _texture:ITexture;

		/**
		 * Constructor.
		 * 
		 * @param texture The texture to apply to the image.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function TextureEffect(texture:ITexture, blendMode:String=null, alpha:Number=1) {
			init(blendMode, alpha);
			_texture = texture;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var pattern:BitmapData = _texture.draw();
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(pattern);
			shape.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
			shape.graphics.endFill();
			bitmapData.draw(shape);
		}
	
	}
	
}