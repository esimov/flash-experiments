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
	import flash.display.Graphics;
	import frocessing.core.graphics.FPath;
	/**
	* Circle Shape.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeCircle extends AbstractFShape implements IFShape
	{		
		private var _cx:Number;
		private var _cy:Number;
		private var _r:Number;
		
		
		/**
		 * 
		 */
		public function FShapeCircle( x:Number, y:Number, radius:Number, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			
			_cx = x;
			_cy = y;
			_r  = radius;
			_left   = _cx - _r;
			_top    = _cy - _r;
			_width  = _height = _r*2;
			
			updateShapeGeom();
		}
		
		public function get cx():Number { return _cx; }
		public function set cx(value:Number):void {
			_cx   = value;
			_left = _cx - _r;
			_geom_changed = true;
		}
		
		public function get cy():Number { return _cy; }
		public function set cy(value:Number):void {
			_cy  = value;
			_top = _cy - _r;
			_geom_changed = true;
		}
		
		public function get r():Number { return _r; }
		public function set r(value:Number):void {
			_r = value;
			_left   = _cx - _r;
			_top    = _cy - _r;
			_width  = _height = _r*2;
			_geom_changed = true;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			gc.drawCircle( _cx, _cy, _r );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom and Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function updateShapeGeom():void {
			_path = FPath.getEllipsePath( _cx, _cy, _r, _r );
			super.updateShapeGeom();
		}
		
	}
	
}