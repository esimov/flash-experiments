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

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Dispatched once a shader has been loaded, instantiated and is ready.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Class to handle loading or embedding, and passing values to a shader that can
	 * be applied as a blend mode to a display object.
	 * 
	 * <pre>
	 * // the following tells the ShaderBlendMode class that the file to load is in a "pbj" subdirectory
	 * // relative to where the application SWF is located
	 * 
	 * ShaderBlendMode.shaderFilePath = "/pbj/";
	 * var blendMode:MultiplyBlendMode = new MultiplyBlendMode(0.5);
	 * blendMode.addEventListener(Event.COMPLETE, onShaderLoaded);
	 * </pre>
	 * 
	 * <pre>
	 * // the following tells the ShaderBlendMode class that the shaders were embedded in the class
	 * // com.mysite.Shaders
	 * 
	 * ShaderBlendMode.shaderClassPath = "com.mysite.Shaders";
	 * displayObject.blendShader = new MultiplyBlendMode(0.5).shader;
	 * </pre>
	 *
	 */
	public class ShaderBlendMode extends EventDispatcher {
		
		/**
		 * The map of loaded shaders so subsequent calls to constructors will not reload pbjs.
		 */
		private static var _loadedShaders:Dictionary = new Dictionary();

		/**
		 * The path in which all shader files to be loaded can be found. This is global for the application.
		 */
		public static var shaderFilePath:String = "/pixelBender/blendModes/";
		/**
		 * The class in which all embedded shaders can be referenced. This is global for the application.
		 */
		public static var shaderClassPath:String = "";
		
		private var _shader:Shader;
		private var _percent:Number;
		private var _target:DisplayObject;

		/**
		 * The name of the class that the shader was embedded as.
		 */
		protected var _shaderClass:String;
		/**
		 * The name of the file the shader can be loaded from.
		 */
		protected var _shaderFile:String;
			
		/**
		 * Constructor. This accepts a path to a .pbj file to load or
		 * a shader bytecode class to instantiate. If a file needs to be loaded,
		 * the loading is initiated immediately. Completion of load will result in
		 * a COMPLETE event being fired.
		 *
		 * @param percent The amount between 0 and 1 to apply for the blend mode.
		 * @param target The display object to which to apply the blend mode, which will then automatically
		 * 				 be updated whenever the blend mode percentage changes.
		 */
		public function ShaderBlendMode(percent:Number=1, target:DisplayObject=null) {
			_percent = percent;
			_target = target;
			try {
				var shaderClass:Class = getDefinitionByName(shaderClassPath + "_" + _shaderClass) as Class;
				createShader(ByteArray(new shaderClass()));
			} catch (e:Error) {
				var className:String = getQualifiedClassName(this);
				if (_loadedShaders[className]) {
					createShader(_loadedShaders[className] as ByteArray);
				} else {
					loadShader(shaderFilePath + _shaderFile);
				}
			}
		}

		/**
		 * Dynamically determines the correct path to the embedded shader bytecode based on the class or class instance.
		 * 
		 * @param theClass The class or class instance that contains all of the embedded shaders.
		 */
		public static function setShaderClassPath(theClass:Object):void {
			shaderClassPath = getQualifiedClassName(theClass).split("::").join(".");
		}

		/**
		 * Creates the Shader instance from the bytecode.
		 *
		 * @param data The ByteArray containing the shader bytecode.
		 */
		private function createShader(data:ByteArray):void {
			_shader = new Shader(data);
			percent = _percent;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Loads the specified .pbj file.
		 *
		 * @param path The path to the .pbj file to load.
		 */
		private function loadShader(path:String):void {
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onShaderLoaded);
			loader.load(new URLRequest(path));
		}

		/**
		 * Handler for when the .pbj file completes loading.
		 *
		 * @param event Event dispatched by URLLoader.
		 */
		private function onShaderLoaded(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			var shader:ByteArray = loader.data as ByteArray;
			var className:String = getQualifiedClassName(this);
			_loadedShaders[className] = shader;
			createShader(shader);
		}

		/**
		 * Returns the percent of the blend mode that is or will be applied to the display object.
		 *
		 * @returns The value between 0 and 1 to apply for the blend mode.
		 */
		public function get percent():Number {
			return _percent;
		}

		/**
		 * Sets the percent of the blend mode to apply to the display object. A value of 1
		 * will apply the blend mode fully to the display object. A value of 0 will not
		 * apply the blend mode at all. Intermediate values between 0 and 1 will apply
		 * a percent of the full effect.
		 *
		 * @param percent The value between 0 and 1 to apply for the blend mode.
		 */
		public function set percent(percent:Number):void {
			_percent = percent;
			try {
				// wrap scalar values in an array
				_shader.data.percent.value = [percent];
				if (_target) {
					_target.blendMode = BlendMode.NORMAL;
					_target.blendShader = shader;
				}
			} catch (e:Error) {
				trace(e.getStackTrace());
			}
		}

		/**
		 * Returns the Shader instance this class wraps.
		 *
		 * @return The Shader instance managed by this class.
		 */
		public function get shader():Shader {
			return _shader;
		}

	}

}