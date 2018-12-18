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
	 * The IsolateColorEffect class wraps a Pixel Bender shader that isolates a specified color in an image, allowing
	 * for a hue and luminance threshold. Non-isolated pixels can either be hidden or made grayscale.
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
	 * // the following isolates the color red in the image, making other pixels grayscale
	 * 
	 * new IsolateColorEffect(
	 *   0xFF0000,
	 *   20,
	 *   100
	 * ).apply(image);
	 * </pre>
	 */
	public class IsolateColorEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "IsolateColorKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "isolateColor.pbj";

		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;
		private var _hueThreshold:uint;
		private var _luminanceThreshold:uint;
		private var _hideNonIsolated:uint;
		
		/**
		 * Constructor.
		 * 
		 * @param color The color to isolate in the image.
		 * @param hueThreshold The allowed difference between an evaluated pixel's hue and the hue of the isolated color to judge
		 *                     as a match.
		 * @param luminanceThreshold The allowed difference between an evaluated pixel's luminance and the luminace of the isolated
		 *                           color to judge as a match.
		 * @param hideNonIsolated Whether pixels not isolated will be hidden (<code>true</code>) or made grayscale (<code>false</code>).
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function IsolateColorEffect(
			color:uint=0xFF0000,
			hueThreshold:uint=10,
			luminanceThreshold:uint=60,
			hideNonIsolated:Boolean=false,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.color = color;
			this.hueThreshold = hueThreshold;
			this.luminanceThreshold = luminanceThreshold;
			this.hideNonIsolated = hideNonIsolated;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.color.value = [_red, _green, _blue];
			data.hueThreshold.value = [_hueThreshold];
			data.luminanceThreshold.value = [_luminanceThreshold];
			data.hideNonIsolated.value = [_hideNonIsolated];
		}
		
		/**
		 * The color to isolate in the image.
		 */
		public function set color(color:uint):void {
			color = MathUtil.clamp(color, 0, 0xFFFFFF);
			_red = color >> 16 & 0xFF;
			_green = color >> 8 & 0xFF;
			_blue = color & 0xFF;
		}

		/**
		 * The allowed difference between an evaluated pixel's hue and the hue of the isolated color to judge as a match.
		 */
		public function set hueThreshold(threshold:uint):void {
			_hueThreshold = MathUtil.clamp(threshold, 0, 360);
		}

		/**
		 * The allowed difference between an evaluated pixel's luminance and the luminace of the isolated
		 * color to judge as a match.
		 */
		public function set luminanceThreshold(threshold:uint):void {
			_luminanceThreshold = MathUtil.clamp(threshold, 0, 255);
		}

		/**
		 * Whether pixels not isolated will be hidden (<code>true</code>) or made grayscale (<code>false</code>).
		 */
		public function set hideNonIsolated(hide:Boolean):void {
			_hideNonIsolated = hide ? 1 : 0;
		}

	}

}