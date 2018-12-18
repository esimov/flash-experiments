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
	* Line Shape.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeLine extends AbstractFShape implements IFShape
	{
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;
		
		/**
		 * 
		 */
		public function FShapeLine( x1:Number, y1:Number, x2:Number, y2:Number, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			
			_fillEnabled = false;
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
			
			updateShapeGeom();
		}
		
		public function get x1():Number { return _x1; }
		public function set x1(value:Number):void {
			_x1 = value;
			if (_x1 < _x2){
				_left = _x1; _width = _x2 - _x1;
			}else {
				_left = _x2; _width = _x1 - _x2;
			}
			_geom_changed = true;
		}
		
		public function get y1():Number { return _y1; }
		public function set y1(value:Number):void {
			_y1 = value;
			if (_y1 < _y2){
				_top = _y1; _height = _y2 - _y1;
			}else {
				_top = _y2; _height = _y1 - _y2;
			}
			_geom_changed = true;
		}
		
		public function get x2():Number { return _x2; }
		public function set x2(value:Number):void {
			_x2 = value;
			if (_x1 < _x2){
				_left = _x1; _width = _x2 - _x1;
			}else {
				_left = _x2; _width = _x1 - _x2;
			}
			_geom_changed = true;
		}
		
		public function get y2():Number { return _y2; }
		public function set y2(value:Number):void {
			_y2 = value;
			if (_y1 < _y2){
				_top = _y1; _height = _y2 - _y1;
			}else {
				_top = _y2; _height = _y1 - _y2;
			}
			_geom_changed = true;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw Graphics
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void{
			gc.moveTo( _x1, _y1 );
			gc.lineTo( _x2, _y2 );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom and Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function updateShapeGeom():void {
			_path = FPath.getLinePath( _x1, _y1, _x2, _y2 );
			super.updateShapeGeom();
		}
		
	}
	
}