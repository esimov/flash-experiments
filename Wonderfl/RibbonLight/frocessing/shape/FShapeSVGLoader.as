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

package frocessing.shape 
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import frocessing.utils.IObjectLoader;
	import frocessing.utils.FLoadUtil;
	
	/**
	* Simple SVG Loader
	*  
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeSVGLoader extends FShapeSVG implements IObjectLoader
	{
		private var __loader:URLLoader;
		private var __status:int;
		private var __callback:Function;
		
		/**
		 * 
		 * @param	url
		 * @param	loader
		 * @param	callback	callback on complete or error
		 */
		public function FShapeSVGLoader( url:String, loader:URLLoader = null, callback:Function=null ) 
		{
			super( null, null );
			if( url==null || url=="" )
				throw new ArgumentError( "URL must not be empty." );
				
			visible    = false;
			__status   = 0;
			__callback = callback;
			
			__loader = ( loader != null ) ? loader :  new URLLoader();
			__loader.dataFormat = URLLoaderDataFormat.TEXT;
			FLoadUtil.load( url, __loader, __onComplete, __onError, int.MAX_VALUE );
		}
		
		private function __onComplete():void
		{
			_parse_svg_document( XML(__loader.data) );
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