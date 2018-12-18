// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing.(http://processing.org)
// Copyright (c) 2004-08 Ben Fry and Casey Reas
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// 
// Frocessing drawing library
// Copyright (C) 2008-10  TAKANAWA Tomoaki (http://nutsu.com) and
//					   	  Spark project (www.libspark.org)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// contact : face(at)nutsu.com
//

package frocessing.utils 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * Simple Loader Util.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FLoadUtil 
	{
		private static var __d:Dictionary = new Dictionary(true);
		
		/**
		 * load helper. use URLLoader or Loader or Sound class.
		 * 
		 * @param	url			url ( if null, load manually )
		 * @param	loader		URLLoader or Loader or Sound ( if null, URLLoader will be created. )
		 * @param	complete	callback on complete
		 * @param	error		callback on io error or security error
		 * @param	priority	priority of event listener
		 * @return	loader instance.(URLLoader or Loader or Sound)
		 */
		public static function load( url:String, loader:EventDispatcher = null, complete:Function = null, error:Function = null, priority:int = 0 ):EventDispatcher
		{
			return request( (url !=null ) ? new URLRequest(url) : null, loader, complete, error, priority );
		}
		
		/**
		 * URLRequest helper. use URLLoader or Loader or Sound class.
		 * 
		 * @param	request		URLRequest ( if null, load manually )
		 * @param	loader		URLLoader or Loader or Sound ( if null, URLLoader will be created. )
		 * @param	complete	callback on complete
		 * @param	error		callback on io error or security error
		 * @param	priority	priority of event listener
		 * @return	loader instance.(URLLoader or Loader or Sound)
		 */
		public static function request( request:URLRequest, loader:EventDispatcher = null, complete:Function = null, error:Function=null, priority:int=0 ):EventDispatcher
		{
			var loadobject:*;
			if ( loader == null ){
				loadobject = loader = new URLLoader();
			}
			else if ( loader is Loader ){
				loadobject = loader;
				loader = Loader(loader).contentLoaderInfo;
			}
			else if( loader is URLLoader ){
				loadobject = loader;
			}
			else if ( loader is Sound ) {
				loadobject = loader;
			}
			else{
				throw( new Error( "loader have to be URLLoader or Loader or Sound." ) );
			}
			
			//Complete
			if ( complete != null ){
				loader.addEventListener( Event.COMPLETE, __onComplete, false, priority );
			}
			//Error
			if ( error != null ){
				loader.addEventListener( IOErrorEvent.IO_ERROR, __onError, false, priority );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, __onError, false, priority );
			}
			__d[loader] = { complete:complete, error:error };
			
			//Load
			if( request != null ){
				if ( loader is URLLoader )
					URLLoader( loadobject ).load( request );
				else if ( loader is LoaderInfo )
					Loader( loadobject ).load( request );
				else if ( loader is Sound )
					Sound( loadobject ).load( request );
			}
			return loadobject;
		}
		
		private static function __onComplete( e:Event ):void
		{
			__callback( EventDispatcher(e.target), "complete" );
		}
		private static function __onError( e:Event ):void
		{
			__callback( EventDispatcher(e.target), "error" );
		}
		
		private static function __callback( ed:EventDispatcher, kind:String ):void
		{
			var func:Function = __d[ed][kind];
			if ( func != null ) {
				var hasArg:Boolean = false; 
				try {
					if ( func.length == 1 ) {
						hasArg = true;
					}
				}catch ( e:Error ) {
					hasArg = false;
				}
				if ( hasArg ) {
					func.call(null, (ed is LoaderInfo) ? LoaderInfo(ed).loader : ed );
				}else {
					func.call();
				}
			}
			if ( ed.hasEventListener( Event.COMPLETE ) ){
				ed.removeEventListener( Event.COMPLETE, __onComplete );
			}
			if ( ed.hasEventListener( IOErrorEvent.IO_ERROR ) ){
				ed.removeEventListener( IOErrorEvent.IO_ERROR, __onError );
				ed.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, __onError );
			}
			delete __d[ed];
		}
	}
}
