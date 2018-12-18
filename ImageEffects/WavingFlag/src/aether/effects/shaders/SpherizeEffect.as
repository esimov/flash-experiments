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
	import flash.geom.Point;

	/**
	 * The SpherizeEffect class wraps a Pixel Bender shader that distorts an image by pinching or bulging its pixels
	 * at the specified <code>center</code> out to the specified <code>radius</code> at the specified <code>amount</code>
	 * of distortion.
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
	 * // the following bulges the pixels at the mouse position for 100px radius
	 * 
	 * new SpherizeEffect(
	 *   new Point(stage.mouseX, stage.mouseY),
	 *   100
	 * ).apply(image);
	 * </pre>
	 */
	public class SpherizeEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "SpherizeKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "spherize.pbj";

		private var _amount:Number;
		private var _center:Point;
		private var _radius:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param center The position in the image that serves as the center of the spherize effect.
		 * @param radius The radius of the effect out from the center position.
		 * @param amount The amount of spherization to apply, from -1 to 1. Negative numbers will result in pinching.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function SpherizeEffect(
			center:Point,
			radius:Number,
			amount:Number=1,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.amount = amount;
			this.radius = radius;
			this.center = center;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.center.value = [_center.x, _center.y];
			data.radius.value = [_radius];
			data.amount.value = [_amount];
		}
		
		/**
		 * The amount of spherization to apply, from -1 to 1. Negative numbers will result in pinching.
		 */
		public function set amount(amount:Number):void {
			_amount = MathUtil.clamp(amount, -1, 1);
		}

		/**
		 * The radius of the effect out from the center position.
		 */
		public function set radius(radius:Number):void {
			_radius = radius;
		}

		/**
		 * The position in the image that serves as the center of the spherize effect.
		 */
		public function set center(center:Point):void {
			_center = center;
		}

	}

}