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
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import frocessing.geom.FMatrix;
	import frocessing.utils.FLoadUtil;
	import frocessing.utils.IObjectLoader;
	import frocessing.core.graphics.FPath;
	/**
	* Image Shape Loader.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeImageLoader extends FShapeImage implements IFShape, IObjectLoader
	{
		private var __loader:Loader;
		private var __status:int;
		private var __callback:Function;
		
		private var __w:Number;
		private var __h:Number;
		
		/**
		 * 
		 */
		public function FShapeImageLoader( url:String, loader:Loader = null, callback:Function=null, x:Number=0, y:Number=0, width:Number=NaN, height:Number=NaN, parent_group:IFShapeContainer=null ) 
		{
			super( null, x, y, width, height, parent_group );
			visible = false;
			
			__status   = 0;
			__callback = callback;	
			
			if ( loader != null )
				__loader = loader;
			else
				__loader = new Loader();
			
			FLoadUtil.load( url, __loader, __onComplete, __onError, int.MAX_VALUE );
		}
		
		/** @private */
		override protected function _init(bd:BitmapData, x:Number, y:Number, width:Number, height:Number):void 
		{
			_bitmapData = new BitmapData( 1, 1, false )
			
			_left   = x;
			_top    = y;
			_width  = width;
			_height = height;
			_geom_changed = false;
			
			__w = width;
			__h = height;
			
			bd_matrix = new FMatrix();
			
			_path = new FPath([], []);
		}
		
		private function __onComplete():void
		{
			var content:DisplayObject = __loader.content;
			
			_bitmapData.dispose();
			_bitmapData = new BitmapData( content.width, content.height, false );
			
			_bitmapData.draw( content, null, null, null, null );
			__loader.unload();
			
			__status = 1;
			__load_terminated();
			
			super._init( _bitmapData, _left, _top, __w, __h );
			visible = true;
		}
		
		private function __onError():void
		{
			__status = -1;
			__load_terminated();
		}
		
		private function __load_terminated():void
		{
			__loader = null;
			if ( __callback != null )
			{
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