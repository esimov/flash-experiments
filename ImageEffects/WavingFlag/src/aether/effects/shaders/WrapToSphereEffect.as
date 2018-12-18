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
	
	import flash.display.ShaderData;
	import flash.geom.Point;
	
	/**
	 * The WrapToSphereEffect class wraps a Pixel Bender shader that distorts an image as if wrapping it around a sphere.
	 * This is useful for applying textures to spherical images, like wrapping an Earth texture onto a planet. 
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
	 * // the following wraps the image texture around a circle with a radius of 200;
	 * // the texture used is specified as 600x400
	 * 
	 * new WrapToSphereEffect(
	 *   200,
	 *   600,
	 *   400
	 * ).apply(image);
	 * </pre>
	 */
	public class WrapToSphereEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "WrapToSphereKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "wrapToSphere.pbj";

		private var _radius:uint;
		private var _textureWidth:uint;
		private var _textureHeight:uint;
		
		/**
		 * Constructor.
		 * 
		 * @param radius The radius of the sphere around which to wrap the image.
		 * @param textureWidth The pixel width of the image to wrap.
		 * @param textureHeight The pixel height of the image to wrap.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function WrapToSphereEffect(
			radius:uint=256,
			textureWidth:uint=512,
			textureHeight:uint=512,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.textureWidth = textureWidth;
			this.textureHeight = textureHeight;
			this.radius = radius;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.radius.value = [_radius];
			data.textureWidth.value = [_textureWidth];
			data.textureHeight.value = [_textureHeight];
		}
		
		/**
		 * The pixel width of the image to wrap.
		 */
		public function set textureWidth(width:uint):void {
			_textureWidth = width;
		}

		/**
		 * The pixel height of the image to wrap.
		 */
		public function set textureHeight(height:uint):void {
			_textureHeight = height;
		}

		/**
		 * The radius of the sphere around which to wrap the image.
		 */
		public function set radius(radius:uint):void {
			_radius = radius;
		}

	}

}