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
	* Ellipse Shape.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeEllipse extends AbstractFShape implements IFShape
	{
		private var _cx:Number;
		private var _cy:Number;
		private var _rx:Number;
		private var _ry:Number;
		
		/**
		 * 
		 */
		public function FShapeEllipse( x:Number, y:Number, radiusX:Number, radiusY:Number, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			
			_cx = x;
			_cy = y;
			_rx = radiusX;
			_ry = radiusY;
			_left   = _cx - _rx;
			_top    = _cy - _ry;
			_width  = _rx*2;
			_height = _ry*2;
			
			updateShapeGeom();
		}
		
		public function get cx():Number { return _cx; }
		public function set cx(value:Number):void {
			_cx   = value;
			_left = _cx - _rx;
			_geom_changed = true;
		}
		
		public function get cy():Number { return _cy; }
		public function set cy(value:Number):void {
			_cy  = value;
			_top = _cy - _ry;
			_geom_changed = true;
		}
		
		public function get rx():Number { return _rx; }
		public function set rx(value:Number):void {
			_rx = value;
			_width = _rx * 2;
			_left = _cx - _rx;
			_geom_changed = true;
		}
		
		public function get ry():Number { return _ry; }
		public function set ry(value:Number):void {
			_ry = value;
			_height = _ry * 2;
			_top = _cy - _ry;
			_geom_changed = true;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void{
			gc.drawEllipse( _left, _top, _width, _height );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom and Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function updateShapeGeom():void {
			_path = FPath.getEllipsePath( _cx, _cy, _rx, _ry );
			super.updateShapeGeom();
		}
	}
	
}