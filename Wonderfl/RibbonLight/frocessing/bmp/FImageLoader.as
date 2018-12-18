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

package frocessing.bmp 
{
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import frocessing.utils.IObjectLoader;
	import frocessing.utils.FLoadUtil;
	
	/**
	* Simple Image Loader
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FImageLoader extends FImage implements IObjectLoader
	{
		private var __loader:Loader;
		private var __status:int;
		private var __callback:Function;
		
		public var bgcolor:uint = 0x00000000;
		public var smooth:Boolean = false;
		
		/**
		 * FImage Loader.
		 */
		public function FImageLoader( url:String, loader:Loader = null, callback:Function=null, bitmapData:BitmapData=null ) 
		{
			super( bitmapData );
			if( url==null || url=="" )
				throw new ArgumentError( "URL must not be empty." );
			
			if ( _bd == null )
				_bd = new BitmapData( 4, 4, true, bgcolor );
			
			__status   = 0;
			__callback = callback;	
			
			__loader = ( loader != null ) ? loader : new Loader();
			
			FLoadUtil.load( url, __loader, __onComplete, __onError, int.MAX_VALUE );
		}
		
		
		private function __onComplete():void
		{
			var content:DisplayObject = __loader.content;
			try{
				if ( content.width != _bd.width || content.height != _bd.height ){
					var t:Boolean = _bd.transparent;
					dispose();
					_bd = new BitmapData( content.width, content.height, t, bgcolor );
				}else{
					_bd.fillRect( _bd.rect, bgcolor );
				}
				_bd.draw( content, null, null, null, null, smooth );
			}catch ( e:Error ){
				;
			}
			__loader.unload();
			__status = 1;
			__load_terminated();
		}
		
		private function __onError():void
		{
			__status = -1;
			__load_terminated();
		}
		
		private function __load_terminated():void
		{
			__loader = null;
			if ( __callback != null ){
				__callback.call();
				__callback = null;
			}
		}
		
		/**
		 * load status. 0:loading, 1:complete, -1:error
		 */
		public function get status():int { return __status; }
		/**
		 * load completed.
		 */
		public function get success():Boolean { return __status == 1; }
		
	}
	
}