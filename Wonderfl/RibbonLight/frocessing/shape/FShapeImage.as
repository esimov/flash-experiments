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
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import frocessing.core.canvas.CanvasBitmapFill;
	import frocessing.geom.FMatrix;
	import frocessing.core.graphics.FPath;
	/**
	* Image Shape.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeImage extends AbstractFShape implements IFShape, IFShapeImage
	{
		/** @private */
		protected var _bitmapData:BitmapData;
		
		/** @private */
		protected var bd_matrix:FMatrix;
		
		public var smoothing:Boolean = true;
		
		/**
		 * 
		 */
		public function FShapeImage( bitmapdata:BitmapData, x:Number=0, y:Number=0, width:Number=NaN, height:Number=NaN, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			_init( bitmapdata, x, y, width, height );
		}
		
		/** @private */
		protected function _init( bd:BitmapData, x:Number, y:Number, width:Number, height:Number ):void
		{
			_bitmapData = bd;
			_left = x;
			_top  = y;
			if ( isNaN( width * height ) ){
				_width  = _bitmapData.rect.width;
				_height = _bitmapData.rect.height;
			}else{
				_width  = width;
				_height = height;
			}
			_strokeEnabled = false;
			_fillEnabled   = false;
			bd_matrix = new FMatrix( _width / _bitmapData.rect.width, 0, 0, _height / _bitmapData.rect.height, _left, _top );
			
			_fill = new CanvasBitmapFill( _bitmapData, bd_matrix, false, false );
			
			updateShapeGeom();
		}
		
		public function get x():Number { return _left; }
		public function set x(value:Number):void {
			bd_matrix.tx = _left = value;
			_geom_changed = true;
		}
		
		public function get y():Number { return _top; }
		public function set y(value:Number):void {
			bd_matrix.ty = _top = value;
			_geom_changed = true;
		}
		
		public function set width(value:Number):void {
			_width = value;
			bd_matrix.a = _width / _bitmapData.rect.width;
			_geom_changed = true;
		}
		
		public function set height(value:Number):void {
			_height = value;
			bd_matrix.d = _height / _bitmapData.rect.height;
			_geom_changed = true;
		}
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		public function set bitmapData(value:BitmapData):void {
			_bitmapData = value;
			bd_matrix.setMatrix( _width / _bitmapData.rect.width, 0, 0, _height / _bitmapData.rect.height, _left, _top );
			_fill = new CanvasBitmapFill( _bitmapData, bd_matrix, false, false );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void {
			gc.beginBitmapFill( _bitmapData, bd_matrix, false, smoothing );
			gc.drawRect( _left, _top, _width, _height );
			gc.endFill();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom and Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function updateShapeGeom():void {
			_path = FPath.getRectPath( _left, _top, _width, _height );
			super.updateShapeGeom();
		}
	}
	
}