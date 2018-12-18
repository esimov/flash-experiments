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
	 * The StampEffect class wraps a Pixel Bender shader that applies a brightness threshold to the image, then
	 * recolors the pixels below the threshold using the <code>backgroundColor</code> and recolors those above the
	 * threshold using the <code>foregroundColor</code>.
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
	 * // the following applies a stamp effect to the image with the default settings
	 * 
	 * new StampEffect().apply(image);
	 * </pre>
	 */
	public class StampEffect extends ShaderEffect {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "StampKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "stamp.pbj";

		private var _foregroundColor:uint;
		private var _backgroundColor:uint;
		private var _threshold:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param threshold The pixel brightness below which a pixel will be given the background color.
		 *                  This should be between 0 and 1.
		 * @param foregroundColor The color to apply to pixels above the brightness threshold.
		 * @param backgroundColor The color to apply to pixels below the brightness threshold.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function StampEffect(
			threshold:Number=.4,
			foregroundColor:uint=0xFFFFFFFF,
			backgroundColor:uint=0xFF000000,
			blendMode:String=null,
			alpha:Number=1
		) {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			this.threshold = threshold;
			this.foregroundColor  = foregroundColor;
			this.backgroundColor  = backgroundColor;
			init(blendMode, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function configureShader(data:ShaderData):void {
			data.levelsThreshold.value = [_threshold];
			data.foregroundColor.value = [
				(_foregroundColor >> 16 & 0xFF)/0xFF,
				(_foregroundColor >> 8 & 0xFF)/0xFF,
				(_foregroundColor & 0xFF)/0xFF,
				(_foregroundColor >> 24 & 0xFF)/0xFF
			];
			data.backgroundColor.value = [
				(_backgroundColor >> 16 & 0xFF)/0xFF,
				(_backgroundColor >> 8 & 0xFF)/0xFF,
				(_backgroundColor & 0xFF)/0xFF,
				(_backgroundColor >> 24 & 0xFF)/0xFF
			];
		}
		
		/**
		 * The color to apply to pixels above the brightness threshold.
		 */
		public function set foregroundColor(color:uint):void {
			_foregroundColor = color;
		}

		/**
		 * The color to apply to pixels below the brightness threshold.
		 */
		public function set backgroundColor(color:uint):void {
			_backgroundColor = color;
		}

		/**
		 * The pixel brightness below which a pixel will be given the background color.
		 * This should be between 0 and 1.
		 */
		public function set threshold(threshold:Number):void {
			_threshold = MathUtil.clamp(threshold, 0, 1);
		}

	}

}