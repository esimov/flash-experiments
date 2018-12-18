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
	* Rect Shape.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeRect extends AbstractFShape implements IFShape
	{
		private var _rx:Number;
		private var _ry:Number;
		
		/**
		 * 
		 */
		public function FShapeRect( x:Number, y:Number, width:Number, height:Number, rx:Number=0, ry:Number=0, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			//
			_left   = x;
			_top    = y;
			_width  = width;
			_height = height;
			_rx = ( rx > _width * 0.5 ) ? _width * 0.5 : rx;
			_ry = ( ry > _height * 0.5 ) ? _height * 0.5 : ry;
			
			updateShapeGeom();
		}
		
		public function get x():Number { return _left; }
		public function set x(value:Number):void {
			_left = value;
			_geom_changed = true;
		}
		
		public function get y():Number { return _top; }
		public function set y(value:Number):void {
			_top = value;
			_geom_changed = true;
		}
		
		public function set width(value:Number):void {
			_width = value;
			_geom_changed = true;
		}
		public function set height(value:Number):void {
			_height = value;
			_geom_changed = true;
		}
		
		public function get rx():Number { return _rx; }
		public function set rx(value:Number):void {
			_rx = value;
			_geom_changed = true;
		}
		
		public function get ry():Number { return _ry; }
		public function set ry(value:Number):void {
			_ry = value;
			_geom_changed = true;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void{
			if ( _rx <= 0 || _ry <= 0 )
				gc.drawRect( _left, _top, _width, _height );
			else
				gc.drawRoundRect( _left, _top, _width, _height, _rx * 2, _ry * 2 );
		}	
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom and Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function updateShapeGeom():void {
			if ( _rx <= 0 || _ry <= 0 )
				_path = FPath.getRectPath( _left, _top, _width, _height );
			else
				_path = FPath.getRoundRectPath( _left, _top, _left+_width, _top+_height, _rx, _ry );
			super.updateShapeGeom();
		}
	}
	
}