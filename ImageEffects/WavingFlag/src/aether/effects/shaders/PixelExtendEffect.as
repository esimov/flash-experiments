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
package aether.effects.shaders {
	
	import aether.utils.MathUtil;

	import flash.display.ShaderData;

	/**
	 * The PixelExtendEffect class wraps a Pixel Bender shader that stretches the pixels on one side of the image
	 * starting at the specified start position in the direction specified for the effect. By animating the start 
	 * position, you can create a transition effect of the pixels being stretched into position.
	 * 
	 * As with all <code>ShaderEffect</code> child classes, to use this class you must either embed the shader bytecode
	 * in a class using the name found in the static <code>shaderClass</code> property, or you must load the .pbj file
	 * using the name found in the static <code>shaderFile</code> property. Both of these properties are public, so
	 * you can change them as is necessary.
	 * 
	 * In addition, the <code>ShaderEffect</code> super class holds two static properties, <code>shaderClassPath</code>
	 * and <code>shaderFilePath</code>. Please see the <code>ShaderEffect</code> class's documentation on how these are
	 * used when loading or embedding shader bytecode.
	 * 
	 * <pre>
	 * // the following stretches the pixels from the middle of the image to the right of the image
	 * 
	 * new PixelExtendEffect(
	 *   PixelExtendEffect.RIGHT,
	 *   image.width-100
	 * ).apply(image);
	 * </pre>
	 */
	public class PixelExtendEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "PixelExtendKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "pixelExtend.pbj";

		/**
		 * The constant to use to specify a stretching pixels to the left.
		 */
		public static const LEFT:uint = 0;
		/**
		 * The constant to use to specify a stretching pixels to the top.
		 */
		public static const TOP:uint = 1;
		/**
		 * The constant to use to specify a stretching pixels to the right.
		 */
		public static const RIGHT:uint = 2;
		/**
		 * The constant to use to specify a stretching pixels to the bottom.
		 */
		public static const BOTTOM:uint = 3;

		private var _direction:uint;
		private var _startPixel:uint;
		
		/**
		 * Constructor.
		 * 
		 * @param direction The direction to which to extend the pixels. This should be an integer value betweem 0 and 3.
		 * @param startPixel The position of the pixel at which the effect will begin. Whether this pixel is an x or y position
		 *                   is determined by the direction of the effect.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function PixelExtendEffect(
			direction:uint=0,
			startPixel:uint=0,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.direction  = direction;
			this.startPixel = startPixel;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.direction.value = [_direction];
			data.startPixel.value = [_startPixel];
		}
		
		/**
		 * The direction to which to extend the pixels. This should be an integer value betweem 0 and 3.
		 */
		public function set direction(direction:uint):void {
			_direction = MathUtil.clamp(direction, 0, 3);
		}

		/**
		 * The position of the pixel at which the effect will begin. Whether this pixel is an x or y position
		 * is determined by the direction of the effect.
		 */
		public function set startPixel(startPixel:uint):void {
			_startPixel = startPixel;
		}

	}

}