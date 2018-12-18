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
	 * The WormholeEffect class wraps a Pixel Bender shader that distorts an image by twisting its pixels about a specified
	 * <code>center</code> position. The <code>twirlAngle</code> determines the amount of twisting distortion that is applied,
	 * and the <code>radius</code> determines how far out from the center the twisting affects. The <code>gravity</code>
	 * setting can be used to pull the image towards the center position, scaling it down as it gets "sucked" into the wormhole.
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
	 * // the following applies a wormhole distortion to the image with the effect centered
	 * // at the image's center
	 * 
	 * new WormholeEffect(
	 *   new Point(image.width/2, image.height/2),
	 *   200,
	 *   360
	 * ).apply(image);
	 * </pre>
	 */
	public class WormholeEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "WormHoleKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "wormhole.pbj";

		private var _twirlAngle:Number;
		private var _gravity:Number;
		private var _center:Point;
		private var _radius:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param center The position in the image that serves as the center of the wormhole effect.
		 * @param radius The radius of the effect out from the center position.
		 * @param twirlAngle The amount the image will be twisted around the center position.
		 * @param gravity The amount of the image that will be pulled toward the central position.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function WormholeEffect(
			center:Point,
			radius:Number=50,
			twirlAngle:Number=0,
			gravity:Number=0,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.twirlAngle = twirlAngle;
			this.gravity = gravity;
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
			data.twirlAngle.value = [_twirlAngle];
			data.gravity.value = [_gravity];
		}
		
		/**
		 * The amount the image will be twisted around the center position.
		 */
		public function set twirlAngle(angle:Number):void {
			_twirlAngle = angle;
		}

		/**
		 * The amount of the image that will be pulled toward the central position.
		 */
		public function set gravity(gravity:Number):void {
			_gravity = gravity;
		}

		/**
		 * The radius of the effect out from the center position.
		 */
		public function set radius(radius:Number):void {
			_radius = radius;
		}

		/**
		 * The position in the image that serves as the center of the wormhole effect.
		 */
		public function set center(center:Point):void {
			_center = center;
		}

	}

}