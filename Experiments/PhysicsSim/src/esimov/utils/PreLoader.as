/**
 * Copyright (c) 2009 apdevblog.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package esimov.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * PreLoader works similar to the Loader class (loads SWF, GIF, JPG and PNG) but has an 
	 * integrated loader queue and some conveniences.
	 * 
	 * <p>Example implementation:
	 * <listing>
	 * var img:PreLoader = new PreLoader();
	 * img.addEventListener(ProgressEvent.PROGRESS, _onImgProgress);
	 * img.addEventListener(Event.COMPLETE, _onImgLoaded);
	 * img.load("image.jpg");
	 * addChild(img);
	 *
	 * function _onImgProgress(event : ProgressEvent)
	 * {
	 *   var perc:Number = event.bytesLoaded / event.bytesTotal;
	 *   trace(perc);
	 * }
	 *
	 * function _onImgLoaded(event : Event)
	 * {
	 *   trace("image loaded");
	 * }
	 * </listing>
	 * </p>
	 * 
	 * <p><code>PreLoader</code> communicates with the static class <code>PreloadProxy</code>, which is taking care
	 * of the actual loader queue. Only one loading process at a time is executed.</p>
	 * 
	 * <p>A typical use would be to add all stuff needed to load in an order that makes 
	 * somehow sense (i.e. intro.swf, home.swf, image1.png, image2.png, image3.png) with
	 * the standard method <code>load</code>. Read a <a href="http://code.google.com/p/apdev-preloader-queue/wiki/TypicalScenario" target="_blank">typical scenario</a>.</p>
	 * 
	 * <p>During runtime you can prioritize a loading process by using <code>loadNext()</code>, <code>loadAfter()</code>, 
	 * and <code>loadImmidately()</code>.</p>
	 * 
	 * <p>The PreLoader fires the exact same events as the standard Loader. Just make sure
	 * you set the listeners directly to the <code>PreLoader</code> instead of <code>contentLoaderInfo</code>.</p>
	 * 
	 * <p>Example:
	 * <listing>
	 * // set listener with Loader
	 * 
	 * var img:Loader = new Loader();
	 * img.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImgLoaded);
	 * 
	 * // set listener with PreLoader
  	 * var img:PreLoader = new PreLoader();
	 * img.addEventListener(Event.COMPLETE, _onImgLoaded);
	 * </listing></p>
	 * 
	 * @playerversion Flash 9
 	 * @langversion 3.0
	 *
	 * @package    com.apdevblog.load.PreLoader
	 * @author     Aron Woost / aron[at]apdevblog.com
	 * @copyright  2009 apdevblog.com
	 * 
	 * @see com.apdevblog.load.PreloadProxy PreloadProxy
	 * 
	 */
	public class PreLoader extends Sprite
	{
		private var __ldr:Loader = null;
		private var __urlReq:URLRequest = null;
		//
		private var _isLoaded : Boolean = false;
		private var _isInit   : Boolean = false;
		private var _smooth   : Boolean = false; // only works with images
		private var _context  : LoaderContext = new LoaderContext();
		private var _autoUnload : Boolean = false;
		//

		/**
		 * Constructor
		 */
		public function PreLoader()
		{
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		/**
		 * returns [PreLoader] thePassedUrl (i.e. [PreLoader] http://www.domain.com/image1.png).
		 */
		override public function toString():String
		{
			var url:String = __urlReq  == null ? "" : __urlReq.url;
			return "[PreLoader] " + url;
		}
		
		/**
		 * gets and sets the LoaderContext of the load process. 
		 * 
		 * <p>Might be needed when using the <code>smooth</code> option and loading images from
		 * a different domain.</p>
		 * 
		 * <p>Caution: Has to be set before <code>load</code> is called.</p>
		 */
		public function get loaderContext():LoaderContext
		{
			return _context;
		}
		
		public function set loaderContext(c:LoaderContext):void
		{
			_context = c;
		}
		
		/**
		 * returns the content DisplayObject of the containt loader.
		 * 
		 * @see flash.display.Loader#content
		 */
		public function get content():DisplayObject
		{
			return __ldr == null ? null : __ldr.content;
		}
		
		/**
		 * returns the LoaderInfo
		 * 
		 * <p>Similar to <code>Loader.contentLoaderInfo</code>.</p>
		 * 
		 * @see flash.display.LoaderInfo
		 * @see flash.display.Loader#contentLoaderInfo
		 */
		public function get contentLoaderInfo():LoaderInfo
		{
			return __ldr == null ? null : __ldr.contentLoaderInfo;
		}
		
		/**
		 * returns the url (if passed already).
		 */
		public function get url():String
		{
			return __urlReq == null ? "" : __urlReq.url;
		}
		
		/**
		 * returns the Loader.
		 */
		public function get loader():Loader
		{
			return __ldr;
		}
		
		/**
		 * returns the URLRequest (if passed already).
		 * 
		 * <p>Note: If you passed a <code>String</code> to the <code>load</code> method
		 * the automaticly generated <code>URLRequest</code> will be returned.</p>
		 */
		public function get urlRequest():URLRequest
		{
			return __urlReq;
		}
		
		/**
		 * returns if the loading is complete.
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		/**
		 * returns if is init.
		 * 
		 * <p>Is set to true, when <code>onLoadInit</code> is received.</p>
		 */
		public function get isInit():Boolean
		{
			return _isInit;
		}
		
		/**
		 * gets and sets whether the PreLoaded should be smoothed when scaled 
		 * (this applies only when loading image).
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		}

		public function set smooth(boo : Boolean) : void
		{
			_smooth = boo;
		}
		
		/**
		 * If true, unload is called, when the PreLoader is removed from stage (to 
		 * prepare the Loader for garbage collection).
		 */
		public function get autoUnload() : Boolean
		{
			return _autoUnload;
		}
		
		public function set autoUnload(autoUnload : Boolean) : void
		{
			_autoUnload = autoUnload;
		}			
		
		/**
		 * sets scaleX and scaleY in one go
		 * 
		 * @param s scale value (0-1)
		 */
		public function set scale(s:Number):void
		{
			scaleX = s;
			scaleY = s;
		}
		
		/**
		 * returns whether the PreLoader loads an image
		 */
		public function get isImage() : Boolean
		{
			return (contentLoaderInfo.contentType.indexOf("image") != -1);
		}
		
		/**
		 * loads the passed url (or <code>URLRequest</code>) by adding it to the end of the loader queue.
		 * 
		 * @param urlStringOrURLRequest url as <code>String</code> ("image.png") or <code>URLRequest</code>.
		 * 
		 * @see #loadNext()
		 * @see #loadAfter()
		 * @see #loadImmediately()
		 */
		public function load(urlStringOrURLRequest : *):void
		{
			var urlReq:URLRequest;
			
			if(urlStringOrURLRequest is String)
			{
				urlReq = new URLRequest(urlStringOrURLRequest);
			}
			else if(urlStringOrURLRequest is URLRequest)
			{
				urlReq = urlStringOrURLRequest;
			}
			else
			{
				throw new ArgumentError("The argument urlStringOrURLRequest has to be either type String or URLRequest");
			}			
			
			if(__ldr != null)
			{
				if(urlReq.url == __urlReq.url)
				{
					if(PreloadProxy.currentLoader() == this)
					{
						return;
					}
				}

				closeLoad();
			}
			
			_createLoader(urlReq);

			PreloadProxy.add(this);
		}
		
		/**
		 * loads the passed url (or <code>URLRequest</code>) by adding it after the current loading request.
		 * 
		 * <p>This call will be ignored when its currently loading.</p>
		 * 
		 * @param urlStringOrURLRequest url as <code>String</code> ("image.png") or <code>URLRequest</code>.
		 * 
		 * @see #load()
		 * @see #loadNext()
		 * @see #loadImmediately()
		 */
		public function loadNext(urlStringOrURLRequest : *):void
		{
			var urlReq:URLRequest;
			
			if(urlStringOrURLRequest is String)
			{
				urlReq = new URLRequest(urlStringOrURLRequest);
			}
			else if(urlStringOrURLRequest is URLRequest)
			{
				urlReq = urlStringOrURLRequest;
			}
			else
			{
				throw new ArgumentError("The argument urlStringOrURLRequest has to be either type String or URLRequest");
			}	
						
			if(__ldr != null)
			{
				if(urlReq.url == __urlReq.url)
				{
					if(PreloadProxy.currentLoader() == this)
					{
						return;
					}
				}

				closeLoad();
			}
			
			_createLoader(urlReq);
			
			PreloadProxy.addNext(this);
		}
		
		/**
		 * loads the passed url (or <code>URLRequest</code>) by canceling the current load and starts the load immediately.
		 * 
		 * <p>This call will be ignored when its currently loading.</p>
		 * 
		 * @param urlStringOrURLRequest url as <code>String</code> ("image.png") or <code>URLRequest</code>.
		 * 
		 * @see #load()
		 * @see #loadNext()
		 * @see #loadAfter()
		 */
		public function loadImmediately(urlStringOrURLRequest : *):void
		{
			var urlReq:URLRequest;
			
			if(urlStringOrURLRequest is String)
			{
				urlReq = new URLRequest(urlStringOrURLRequest);
			}
			else if(urlStringOrURLRequest is URLRequest)
			{
				urlReq = urlStringOrURLRequest;
			}
			else
			{
				throw new ArgumentError("The argument urlStringOrURLRequest has to be either type String or URLRequest");
			}	
			
			if(__ldr != null)
			{
				if(urlReq.url == __urlReq.url)
				{
					if(PreloadProxy.currentLoader() == this)
					{
						return;
					}
				}
				
				closeLoad();
			}
			
			_createLoader(urlReq);
				
			PreloadProxy.addImmediately(this);
		}
		
		/**
		 * Loads the passed url (or <code>URLRequest</code>) by adding it to the loader queue after the passed PreLoader object.
		 * 
		 * <p>This call will be ignored when its currently loading.</p>
		 * 
		 * @param urlStringOrURLRequest url as <code>String</code> ("image.png") or <code>URLRequest</code>.
		 * @param beforePreLoader <code>PreLoader</code> instance to queue urlStringOrURLRequest after 
		 * 
		 * @see #load()
		 * @see #loadNext()
		 * @see #loadImmediately()
		 */
		public function loadAfter(urlStringOrURLRequest : *, beforePreLoader : PreLoader):void
		{
			var urlReq:URLRequest;
			
			if(urlStringOrURLRequest is String)
			{
				urlReq = new URLRequest(urlStringOrURLRequest);
			}
			else if(urlStringOrURLRequest is URLRequest)
			{
				urlReq = urlStringOrURLRequest;
			}
			else
			{
				throw new ArgumentError("The argument urlStringOrURLRequest has to be either type String or URLRequest");
			}			
			
			if(__ldr != null)
			{
				if(urlReq.url == __urlReq.url)
				{
					if(PreloadProxy.currentLoader() == this)
					{
						return;
					}
				}

				closeLoad();
			}
			
			_createLoader(urlReq);
			
			PreloadProxy.addAfter(this, beforePreLoader);
		}		
		
		/**
		 * stops the load process (if currently loading) or removes load request from queue (if in queue).
		 * 
		 * <p>Note: <code>closeLoad</code> might or might not work locally. If you have problems using <code>closeLoad</code> locally
		 * test your project online.</p>
		 */
		public function closeLoad():void
		{
			PreloadProxy.closeLoad(this);
			
			__ldr = null;
			_isLoaded = false;
			_isInit = false;
		}
		
		/**
		 * @private
		 * 
		 * // TODO: to be removed!!!
		 */ 
		public function removeLoad():void
		{
			closeLoad();
		}			
		
		/**
		 * unloads the loader.
		 * 
		 * @see flash.display.Loader#unload()
		 */
		public function unload():void
		{
			if(__ldr == null) return;
			
			removeChild(__ldr);
			
			if(!_isLoaded)
			{
				closeLoad();
			}
			else
			{
				__ldr.unload();
				__ldr = null;
				_isLoaded = false;
				_isInit = false;
			}
		}

		/**
		 * private functions
		 */
		private function _createLoader(urlReq:URLRequest):void
		{
			__ldr = new Loader();
			__urlReq = urlReq;
			addChild(__ldr);
			
			_addLoadListener(__ldr);			
		}
		
		private function _addLoadListener(ldr:Loader):void
		{
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(Event.INIT, _onLoadInit, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(Event.OPEN, _onLoadOpen, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			ldr.contentLoaderInfo.addEventListener(Event.UNLOAD, _onUnload, false, 0, true);
		}
		
		private function _removeLoadListener(ldr:Loader):void
		{
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onLoadComplete);
			ldr.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
			ldr.contentLoaderInfo.removeEventListener(Event.INIT, _onLoadInit);
			ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
			ldr.contentLoaderInfo.removeEventListener(Event.OPEN, _onLoadOpen);
			ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			ldr.contentLoaderInfo.removeEventListener(Event.UNLOAD, _onUnload);			
		}		
		
		private function _onLoadOpen(e:Event):void
		{
			dispatchEvent(e);
		}	
			
		private function _onLoadComplete(evt:Event):void
		{
			_isLoaded = true;
			
			dispatchEvent(evt);
			
			if(_smooth && isImage)
			{
				var smoothImage:Bitmap = loader.content as Bitmap;
				smoothImage.smoothing = true;
			}
		}
		
		private function _onLoadInit(e:Event):void
		{
			_isInit = true;
			
			dispatchEvent(e);
		}
				
		private function _onLoadProgress(e:ProgressEvent):void
		{
			dispatchEvent(e);
		}
				
		private function _onLoadError(e:IOErrorEvent):void
		{
			dispatchEvent(e);
		}
		
		private function _onHttpStatus(e:HTTPStatusEvent):void
		{
			dispatchEvent(e);			
		}
		
		private function _onUnload(e:Event):void
		{
			_isLoaded = false;
			_isInit = false;
			
			dispatchEvent(e);
		}
		
		private function _onAddedToStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}
		
		private function _onRemovedFromStage(event : Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			
			if(_autoUnload)
			{
				if(__ldr == null) return;
				
				_removeLoadListener(__ldr);
				__ldr.unload();
			}
		}		
	}
}
