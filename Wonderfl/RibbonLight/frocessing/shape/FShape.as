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
	import flash.geom.Rectangle;
	import frocessing.core.graphics.FPathCommand;
	import frocessing.core.graphics.FPath;
	/**
	* Path Shape
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShape extends AbstractFShape implements IFShape
	{
		/** @private */
		protected var _commands:Array;
		/** @private */
		protected var _vertices:Array;
		
		/**
		 * 
		 */
		public function FShape( commands:Array=null, vertices:Array=null, parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			
			//path
			_commands = ( commands != null ) ? commands : [];
			_vertices = ( vertices != null ) ? vertices : [];
			
			_path = new FPath( _commands, _vertices );
			
			updateShapeGeom();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * the segment number of lines when draw bezier.
		 */
		public var bezierDetail:uint = 20;
		
		/** @private */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			var len:int = _commands.length;
			if ( len == 0 )
				return;
				
			var sx:Number = 0;
			var sy:Number = 0;
			var px:Number = 0;
			var py:Number = 0;
			var xi:int    = 0;
			var yi:int    = 1;
			for ( var i:int = 0; i < len ; i++ )
			{
				var cmd:int = _commands[i];
				if ( cmd == FPathCommand.LINE_TO )
				{
					px = _vertices[xi];
					py = _vertices[yi];
					gc.lineTo( px, py );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == FPathCommand.BEZIER_TO )
				{
					var x0:Number = px;
					var y0:Number = py;
					var cx0:Number = _vertices[xi];
					var cy0:Number = _vertices[yi];
					var cx1:Number = _vertices[int(xi + 2)];
					var cy1:Number = _vertices[int(yi + 2)];
					px = _vertices[int(xi + 4)];
					py = _vertices[int(yi + 4)];
					var k:Number = 1.0/bezierDetail;
					var t:Number = 0;
					for ( var j:int = 1; j <= bezierDetail; j++ ){
						t += k;
						gc.lineTo( x0*(1-t)*(1-t)*(1-t) + 3*cx0*t*(1-t)*(1-t) + 3*cx1*t*t*(1-t) + px*t*t*t, 
								   y0*(1-t)*(1-t)*(1-t) + 3*cy0*t*(1-t)*(1-t) + 3*cy1*t*t*(1-t) + py*t*t*t );
					}
					xi += 6;
					yi += 6;
				}
				else if ( cmd == FPathCommand.CURVE_TO )
				{
					gc.curveTo( _vertices[xi], _vertices[yi], px = _vertices[int(xi + 2)], py = _vertices[int(yi + 2)] );
					xi += 4;
					yi += 4;
				}
				else if ( cmd == FPathCommand.MOVE_TO )
				{
					sx = px = _vertices[xi];
					sy = py = _vertices[yi];
					gc.moveTo( sx, sy );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == FPathCommand.CLOSE_PATH )
				{
					gc.lineTo( sx, sy );
					px = sx;
					py = sy;
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// path commands
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			_commands.push( FPathCommand.MOVE_TO );
			_vertices.push( x, y );
		}
		
		/**
		 * 
		 */
		public function lineTo( x:Number, y:Number ):void
		{
			_commands.push( FPathCommand.LINE_TO );
			_vertices.push( x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			_commands.push( FPathCommand.CURVE_TO );
			_vertices.push( cx, cy, x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			_commands.push( FPathCommand.BEZIER_TO );
			_vertices.push( cx0, cy0, cx1, cy1, x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function closePath():void
		{
			_commands.push( FPathCommand.CLOSE_PATH );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function get left():Number{
			_check_geom();
			return _left;
		}
		
		/** @inheritDoc */
		override public function get top():Number {
			_check_geom();
			return _top;
		}
		
		/** @inheritDoc */
		override public function get width():Number {
			_check_geom();
			return _width;
		}
		
		/** @inheritDoc */
		override public function get height():Number {
			_check_geom();
			return _height;
		}
		
		/** @inheritDoc */
		override public function updateShapeGeom():void 
		{
			if ( _commands.length > 0 ) {
				var r:Rectangle = FPath.getRect( _commands, _vertices );// null のとき
				_left   = r.x;
				_top    = r.y;
				_width  = r.width;
				_height = r.height;
			}else {
				_left   = 0;
				_top    = 0;
				_width  = 1;
				_height = 1;
			}
			super.updateShapeGeom();
		}
		
	}
	
}