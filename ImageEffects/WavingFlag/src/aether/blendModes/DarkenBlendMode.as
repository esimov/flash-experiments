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
package aether.blendModes {
	
	import flash.display.DisplayObject;

	/**
	 * The AddBlendMode class applies a "darken" blend mode to a display object, affecting how its pixels
	 * interact with pixels at depths below it, using a Pixel Bender shader, which allows for a percentage of
	 * the blend mode to be applied.
	 * 
	 * As with all <code>ShaderBlendMode</code> child classes, to use this class you must either embed the shader bytecode
	 * in a class using the name found in the static <code>shaderClass</code> property, or you must load the .pbj file
	 * using the name found in the static <code>shaderFile</code> property. Both of these properties are public, so
	 * you can change them as is necessary.
	 * 
	 * In addition, the <code>ShaderBlendMode</code> super class holds two static properties, <code>shaderClassPath</code>
	 * and <code>shaderFilePath</code>. Please see the <code>ShaderBlendMode</code> class's documentation on how these are
	 * used when loading or embedding shader bytecode.
	 * 
	 * <pre>
	 * // the following applies a darken blend mode at 50% to a display object;
	 * // this assumes the shader byte code was embedded in the same class
	 * 
	 * ShaderBlendMode.setShaderClassPath(this);
	 * displayObject.blendShader = new DarkenBlendMode(0.5).shader;
	 * </pre>
	 */
	public class DarkenBlendMode extends ShaderBlendMode {

		/**
		 * The default name of the class when the shader bytecode is embedded.
		 */
		public static var shaderClass:String = "DarkenKernel";
		/**
		 * The default name of the file when the shader is to be loaded.
		 */
		public static var shaderFile:String = "darken.pbj";

		/**
		 * Constructor.
		 * 
		 * @param percent The amount between 0 and 1 to apply for the blend mode.
		 * @param target The display object to which to apply the blend mode, which will then automatically
		 * 				 be updated whenever the blend mode percentage changes.
		 */
		public function DarkenBlendMode(percent:Number=1, target:DisplayObject=null):void {
			_shaderClass = shaderClass;
			_shaderFile = shaderFile;
			super(percent, target);
		}
		
	}

}