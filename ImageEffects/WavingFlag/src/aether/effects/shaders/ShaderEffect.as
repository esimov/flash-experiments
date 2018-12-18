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

	import aether.effects.ImageEffect;
	
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
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
	 * The ShaderEffect class is an abstract base class to be extended by any image effect that uses
	 * a Pixel Bender shader for its image manipulations. This class takes care of either instantiating an embedded
	 * shader or loading an external shader file.
	 * 
	 * ShaderEffect has two static properties that are used to determine the directory in which loaded
	 * shaders can be found and the name of the class in which embedded shaders where declared. If you are using
	 * the Flex compiler and are embedded the bytecode of your shaders, this must be done in a single class.
	 * The name of this class should then be set as the <code>shaderClassPath</code> static property of
	 * ShaderEffect. If, instead, you are loadeding external .pbj files for the shader data, you must set the
	 * <code>shaderFilePath</code> static property of ShaderEffect to let the class know in which directory
	 * the shader files can be found.
	 * 
	 * <pre>
	 * // the following tells the ShaderEffect class that the file to load is in a "pbj" subdirectory
	 * // relative to where the application SWF is located
	 * 
	 * ShaderEffect.shaderFilePath = "/pbj/";
	 * var stampEffect:StampEffect = new StampEffect();
	 * stampEffect.addEventListener(Event.COMPLETE, onShaderLoaded);
	 * </pre>
	 * 
	 * <pre>
	 * // the following tells the ShaderEffect class that the shaders were embedded in the class
	 * // com.mysite.Shaders
	 * 
	 * ShaderEffect.shaderClassPath = "com.mysite.Shaders";
	 * var stampEffect:StampEffect = new StampEffect();
	 * </pre>
	 * @todo Once the shader is loaded, we should not load it a second time.
	 */
	public class ShaderEffect extends ImageEffect implements IEventDispatcher {
		
		/**
		 * The map of loaded shaders so subsequent calls to constructors will not reload pbjs.
		 */
		private static var _loadedShaders:Dictionary = new Dictionary();

		/**
		 * The path in which all shader files to be loaded can be found. This is global for the application.
		 */
		public static var shaderFilePath:String = "/pixelBender/";
		/**
		 * The class in which all embedded shaders can be referenced. This is global for the application.
		 */
		public static var shaderClassPath:String = "";
		
		/**
		 * Dynamically determines the correct path to the embedded shader bytecode based on the class or class instance.
		 * 
		 * @param theClass The class or class instance that contains all of the embedded shaders.
		 */
		public static function setShaderClassPath(theClass:Object):void {
			shaderClassPath = getQualifiedClassName(theClass).split("::").join(".");
		}
		
		private var _filter:ShaderFilter;
		private var _ready:Boolean;
		private var _eventDispatcher:EventDispatcher;

		/**
		 * The name of the class that the shader was embedded as.
		 */
		protected var _shaderClass:String;
		/**
		 * The name of the file the shader can be loaded from.
		 */
		protected var _shaderFile:String;
			
		/**
		 * Initializes the common properties for an image effect. This method takes care of either instantiating
		 * the shader that was embedded or loading the shader from an external file.
		 * 
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		override protected function init(blendMode:String=null, alpha:Number=1):void {
			super.init(blendMode, alpha);
			_eventDispatcher = new EventDispatcher();
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
		 * Loads the shader .pbj file from the specified path.
		 * 
		 * @param path The path to the shader .pbj file.
		 */
		private function loadShader(path:String):void {
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onShaderLoaded);
			loader.load(new URLRequest(path));
		}
		
		/**
		 * Creates the Shader instance using the specified bytecode.
		 * 
		 * @param data The ByteArray instance holding the shader bytecode.
		 */
		private function createShader(data:ByteArray):void {
			var shader:Shader = new Shader(data);
			_filter = new ShaderFilter(shader);
			_ready = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Sets the parameters of the loaded shader based on the settings passed to the effect.
		 * 
		 * @param data The ShaderData object on which parameters must be set.
		 */
		protected function configureShader(data:ShaderData):void {}
		
		/**
		 * The handler for when a shader loads successfully. This calls the <code>createShader()</code> method.
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
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 * 
		 * @param type The type of event.
		 * @param listener  The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param priority The priority level of the event listener.
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong reference (the default)
		 *                         prevents your listener from being garbage-collected. A weak reference does not. 
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object,
		 * a call to this method has no effect.
		 * 
		 * @param type The type of event.
		 * @param listener The listener object to remove.
		 * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
		 *                   If the listener was registered for both the capture phase and the target and bubbling phases,
		 *                   two calls to <code>removeEventListener()</code> are required to remove both: one call with <code>useCapture</code>
		 *                   set to <code>true</code>, and another call with <code>useCapture</code> set to <code>false</code>. 
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Dispatches an event into the event flow. The event target is the EventDispatcher object upon which <code>dispatchEvent()</code> is called.
		 * 
		 * @param event The event object dispatched into the event flow.
		 * 
		 * @return A value of <code>true</code> unless <code>preventDefault()</code> is called on the event, in which case it returns <code>false</code>.  
		 */
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the
		 * specified event type. This method returns true if an event listener is triggered during any phase of the event flow
		 * when an event of the specified type is dispatched to this EventDispatcher object or any of its descendants. 
		 * 
		 * @param type The type of event.
		 * 
		 * @return A value of <code>true</code> if a listener of the specified type will be triggered; <code>false</code> otherwise. 
		 */
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}

		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
		 * This allows you to determine where an EventDispatcher object has altered handling of an event type in
		 * the event flow hierarchy. To determine whether a specific event type will actually trigger an event listener,
		 * use <code>IEventDispatcher.willTrigger()</code>. 
		 * 
		 * @param type The type of event.
		 * 
		 * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise. 
		 */
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			if (_ready) {
				configureShader(_filter.shader.data);
				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), _filter);
			}
		}
		
		/**
		 * Whether the shader effect is ready to be applied, which means the bytecode has been loaded and parsed.
		 */
		public function get ready():Boolean {
			return _ready;
		}

	}

}