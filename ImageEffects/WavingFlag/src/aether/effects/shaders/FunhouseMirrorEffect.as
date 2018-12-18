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

	/**
	 * The FunhouseMirrorEffect class wraps a Pixel Bender shader that distorts an image on both the x and y axes
	 * so that the image is stretched and contracted between specified start and end positions, with a ratio between
	 * to determine where the effect is fully applied.
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
	 * // the following applies a funhouse distortion on just the y axis to the image
	 * 
	 * new FunhouseMirrorEffect(
	 *   0,
	 *   0,
	 *   0,
	 *   0,
	 *   0,
	 *   image.height,
	 *   image.height/2,
	 *   1
	 * ).apply(image);
	 * </pre>
	 */
	public class FunhouseMirrorEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "FunhouseMirrorKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "funhouseMirror.pbj";

		private var _warpBeginX:uint;
		private var _warpEndX:uint;
		private var _warpRatioX:Number;
		private var _distortionX:Number;
		private var _warpBeginY:uint;
		private var _warpEndY:uint;
		private var _warpRatioY:Number;
		private var _distortionY:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param warpBeginX The x position at which the distortion will begin.
		 * @param warpEndX The x position at which the distortion will end.
		 * @param warpRatioX The ratio between the start and end of the x axis distortion that will have the full effect.
		 * @param distortionX The amount of distortion to apply to the x axis.
		 * @param warpBeginY The y position at which the distortion will begin.
		 * @param warpEndY The y position at which the distortion will end.
		 * @param warpRatioY The ratio between the start and end of the y axis distortion that will have the full effect.
		 * @param distortionY The amount of distortion to apply to the y axis.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function FunhouseMirrorEffect(
			warpBeginX:uint=0,
			warpEndX:uint=512,
			warpRatioX:Number=0.5,
			distortionX:Number=0.5,
			warpBeginY:uint=0,
			warpEndY:uint=512,
			warpRatioY:Number=0.5,
			distortionY:Number=0.5,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.warpBeginX = warpBeginX;
			this.warpEndX = warpEndX;
			this.warpRatioX = warpRatioX;
			this.distortionX = distortionX;
			this.warpBeginY = warpBeginY;
			this.warpEndY = warpEndY;
			this.warpRatioY = warpRatioY;
			this.distortionY = distortionY;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.color.warpBeginX = [_warpBeginX];
			data.color.warpEndX = [_warpEndX];
			data.color.warpRatioX = [_warpRatioX];
			data.color.distortionX = [_distortionX];
			data.color.warpBeginY = [_warpBeginY];
			data.color.warpEndY = [_warpEndY];
			data.color.warpRatioY = [_warpRatioY];
			data.color.distortionY = [_distortionY];
		}
		
		/**
		 * The x position at which the distortion will begin.
		 */
		public function set warpBeginX(x:uint):void {
			_warpBeginX = x;
		}

		/**
		 * The x position at which the distortion will end.
		 */
		public function set warpEndX(x:uint):void {
			_warpEndX = x;
		}

		/**
		 * The ratio between the start and end of the x axis distortion that will have the full effect.
		 */
		public function set warpRatioX(ratio:Number):void {
			_warpRatioX = ratio;
		}

		/**
		 * The amount of distortion to apply to the x axis.
		 */
		public function set distortionX(amount:Number):void {
			_distortionX = amount;
		}

		/**
		 * The y position at which the distortion will begin.
		 */
		public function set warpBeginY(x:uint):void {
			_warpBeginY = x;
		}

		/**
		 * The y position at which the distortion will end.
		 */
		public function set warpEndY(x:uint):void {
			_warpEndY = x;
		}

		/**
		 * The ratio between the start and end of the y axis distortion that will have the full effect.
		 */
		public function set warpRatioY(ratio:Number):void {
			_warpRatioY = ratio;
		}

		/**
		 * The amount of distortion to apply to the y axis.
		 */
		public function set distortionY(amount:Number):void {
			_distortionY = amount;
		}

	}

}