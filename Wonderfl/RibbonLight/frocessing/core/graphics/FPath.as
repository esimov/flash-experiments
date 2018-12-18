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

package frocessing.core.graphics 
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * 
	 * @author nutsu
	 * @version 0.6
	 * 
	 * @see frocessing.core.graphics.FPathCommand
	 */
	public class FPath 
	{
		
		public var commands:Array;
		public var data:Array;
		
		/**
		 * create new FPath object.
		 * 
		 * @param	commands
		 * @param	data
		 */
		public function FPath( commands:Array=null, data:Array=null ) 
		{
			this.commands = (commands!=null) ? commands : [];
			this.data     = (data!=null)? data : [];
		}
		
		/**
		 * move path position.
		 */
		public function moveTo( x:Number, y:Number ):void {
			commands.push( FPathCommand.MOVE_TO );
			data.push( x, y );
		}
		
		/**
		 * add line path.
		 */
		public function lineTo( x:Number, y:Number ):void {
			commands.push( FPathCommand.LINE_TO );
			data.push( x, y );
		}
		
		/**
		 * add quadratic bezier path.
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void { 
			commands.push( FPathCommand.CURVE_TO );
			data.push( cx, cy, x, y );
		}
		
		/**
		 * add cubic bezier path.
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void { 
			commands.push( FPathCommand.BEZIER_TO );
			data.push( cx0, cy0, cx1, cy1, x, y );
		}
		
		/**
		 * close path to move position.
		 */
		public function closePath():void {
			commands.push( FPathCommand.CLOSE_PATH );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Paths
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * create Line Path.
		 */
		public static function getLinePath( x1:Number, y1:Number, x2:Number, y2:Number ):FPath 
		{
			return new FPath( [FPathCommand.MOVE_TO,FPathCommand.LINE_TO], [x1, y1, x2, y2] );
		}
		
		/**
		 * create Ellipse Path.
		 */
		public static function getEllipsePath( x:Number, y:Number, rx:Number, ry:Number ):FPath 
		{
			var _P:Number = 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			return new FPath([ 
				FPathCommand.MOVE_TO, 
				FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, 
				FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO
			],[
				x + rx, y ,
				x + rx     , y + ry * _T, x + rx * _P, y + ry * _P ,
				x + rx * _T, y + ry     , x          , y + ry      ,
				x - rx * _T, y + ry     , x - rx * _P, y + ry * _P ,
				x - rx     , y + ry * _T, x - rx     , y           ,
				x - rx     , y - ry * _T, x - rx * _P, y - ry * _P ,
				x - rx * _T, y - ry     , x          , y - ry      ,
				x + rx * _T, y - ry     , x + rx * _P, y - ry * _P ,
				x + rx     , y - ry * _T, x + rx     , y 
			]);
		}
		
		/**
		 * create Rect Path.
		 */
		public static function getRectPath( x:Number, y:Number, width:Number, height:Number ):FPath 
		{
			return new FPath( 
				[FPathCommand.MOVE_TO,FPathCommand.LINE_TO,FPathCommand.LINE_TO,FPathCommand.LINE_TO,FPathCommand.CLOSE_PATH],
				[ x, y, x + width, y, x + width, y + height, x, y + height]
			);
		}
		
		/**
		 * create Round Rect Path.
		 */
		public static function getRoundRectPath( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number, ry:Number ):FPath
		{
			var _P:Number = 1 - 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 1 - 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			return new FPath([ 
				FPathCommand.MOVE_TO, 
				FPathCommand.LINE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, 
				FPathCommand.LINE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO, 
				FPathCommand.LINE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO,
				FPathCommand.LINE_TO, FPathCommand.CURVE_TO, FPathCommand.CURVE_TO
			],[
				x0 + rx, y0,
				x1 - rx, y0, x1 - rx * _T, y0          , x1 - rx * _P, y0 + ry * _P,
							 x1          , y0 + ry * _T, x1          , y0 + ry,
				x1, y1 - ry, x1          , y1 - ry * _T, x1 - rx * _P, y1 - ry * _P,
							 x1 - rx * _T, y1          , x1 - rx     , y1,
				x0 + rx, y1, x0 + rx * _T, y1          , x0 + rx * _P, y1 - ry * _P,
							 x0          , y1 - ry * _T, x0          , y1 - ry,
				x0, y0 + ry, x0          , y0 + ry * _T, x0 + rx * _P, y0 + ry * _P,
							 x0 + rx * _T, y0          , x0 + rx     , y0
			]);
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geom
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * get path area rectangle.
		 * 
		 * @param	commands
		 * @param	data
		 * @param	rect		update target rect. 
		 * @return	Rectangle	if rect is not null, return update target rect.
		 */		
		public static function getRect( commands:Array, data:Array, rect:Rectangle=null ):Rectangle 
		{
			var len:int  = commands.length;
			var len2:int = data.length;
			if ( len < 1 || len2 < 2 )
				return null;
			
			var minX:Number = data[data.length-2];
			var minY:Number = data[data.length-1];
			var maxX:Number = minX;
			var maxY:Number = minY;
			if ( rect != null ) {
				minX = rect.x; minY = rect.y; maxX = rect.right; maxY = rect.bottom;
			}
			var di:int = 0;
			var px:Number = 0;
			var py:Number = 0;
			var tx:Number;
			var ty:Number;
			var cx:Number;
			var cy:Number;
			var t:Number;
			var DD:Number;
			var Dq:Number;
			for ( var i:int = 0; i < len; i++ ) {
				var c:int = commands[i];
				if ( c == FPathCommand.LINE_TO || c == FPathCommand.MOVE_TO ){
					px = data[di]; di++;
					py = data[di]; di++;
				} else if ( c == FPathCommand.CURVE_TO ){
					tx = px;
					ty = py;
					cx = data[di]; di++;
					cy = data[di]; di++;
					px = data[di]; di++;
					py = data[di]; di++;
					t = ( tx - cx ) / ( px + tx - 2 * cx );
					if ( t > 0 && t < 1 )	{
						t = tx*(1-t)*(1-t) + 2*cx*t*(1-t) + px*t*t;
						if ( t > maxX ) maxX = t;
						else if ( t < minX ) minX = t;
					}
					t = ( ty - cy ) / ( py + ty - 2 * cy );
					if ( t > 0 && t < 1 ) {
						t = ty*(1-t)*(1-t) + 2*cy*t*(1-t) + py*t*t;
						if ( t > maxY ) maxY = t;
						else if ( t < minY ) minY = t;
					}
				} else if ( c == FPathCommand.BEZIER_TO ){
					tx = px;
					ty = py;
					cx = data[di]; di++;
					cy = data[di]; di++;
					var cx2:Number = data[di]; di++;
					var cy2:Number = data[di]; di++;
					px = data[di]; di++;
					py = data[di]; di++;
					DD = px - tx + 3 * ( cx - cx2 );
					if ( DD != 0 ) {
						Dq = Math.sqrt( (tx-cx)*px + cx2*(cx2-tx-cx) + cx*cx );
						t = (Dq - cx2 + 2 * cx - tx) / DD;
						if ( t > 0 && t < 1 ){
							t = tx*(1-t)*(1-t)*(1-t) + 3*cx*t*(1-t)*(1-t) + 3*cx2*t*t*(1-t) + px*t*t*t;
							if ( t > maxX ) maxX = t;
							else if ( t < minX ) minX = t;
						}
						t = ( -Dq - cx2 + 2 * cx - tx) / DD;
						if ( t > 0 && t < 1 ){
							t = tx*(1-t)*(1-t)*(1-t) + 3*cx*t*(1-t)*(1-t) + 3*cx2*t*t*(1-t) + px*t*t*t;
							if ( t > maxX ) maxX = t;
							else if ( t < minX ) minX = t;
						}
					}else if ( ( t = tx + cx2 - 2 * cx) != 0 ) {
						t = 0.5 * (tx - cx) / t;
						if ( t > 0 && t < 1 ) {
							t = tx*(1-t)*(1-t)*(1-t) + 3*cx*t*(1-t)*(1-t) + 3*cx2*t*t*(1-t) + px*t*t*t;
							if ( t > maxX ) maxX = t;
							else if ( t < minX ) minX = t;
						}
					}
					DD = py - ty + 3 * ( cy - cy2 );
					if ( DD != 0 ) {
						Dq = Math.sqrt( (ty-cy)*py + cy2*(cy2-ty-cy) + cy*cy );
						t = (Dq - cy2 + 2 * cy - ty) / DD;
						if ( t > 0 && t < 1 )	{
							t = ty*(1-t)*(1-t)*(1-t) + 3*cy*t*(1-t)*(1-t) + 3*cy2*t*t*(1-t) + py*t*t*t;
							if ( t > maxY ) maxY = t;
							else if ( t < minY ) minY = t;
						}
						t = ( -Dq - cy2 + 2 * cy - ty) / DD;
						if ( t > 0 && t < 1 )	{
							t = ty*(1-t)*(1-t)*(1-t) + 3*cy*t*(1-t)*(1-t) + 3*cy2*t*t*(1-t) + py*t*t*t;
							if ( t > maxY ) maxY = t;
							else if ( t < minY ) minY = t;
						}
					}else if( ( t = 2 * ty + 2 * cy2 - 4 * cy) != 0 ) {
						t = (ty - cy) / t;
						if ( t > 0 && t < 1 )	{
							t = ty*(1-t)*(1-t)*(1-t) + 3*cy*t*(1-t)*(1-t) + 3*cy2*t*t*(1-t) + py*t*t*t;
							if ( t > maxY ) maxY = t;
							else if ( t < minY ) minY = t;
						}
					}
				} else {
					continue;
				}
				if ( px > maxX ) maxX = px;
				else if ( px < minX ) minX = px;
				if ( py > maxY ) maxY = py;
				else if ( py < minY ) minY = py;
			}
			if ( rect != null ) {
				rect.x = minX;
				rect.y = minY;
				rect.width = maxX - minX;
				rect.height = maxY - minY;
				return rect;
			}else {
				return new Rectangle( minX, minY, maxX - minX, maxY - minY );
			}
		}
		
		/**
		 * Transform Graphics Path Data
		 */
		public static function transform( data:Array, a:Number = 1.0, b:Number = 0.0, c:Number = 0.0, d:Number = 1.0, tx:Number = 0, ty:Number = 0 ):Array 
		{
			var len:int = data.length;
			var dat:Array = [];
			for ( var i:int = 0, j:int=1; i < len; i += 2, j += 2 ) {
				var x:Number = data[i];
				var y:Number = data[j];
				dat[i] = a*x + c*y + tx;
				dat[j] = b*x + d*y + ty;
			}
			return dat;
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public static function drawPath( graphics:Graphics, commands:Array, data:Array, bezierDetail:uint=20 ):void
		{
			var len:int = commands.length;
			if ( len == 0 )
				return;
				
			var sx:Number = 0;
			var sy:Number = 0;
			var px:Number = 0;
			var py:Number = 0;
			var xi:int    = 0;
			var yi:int    = 1;
			for ( var i:int = 0; i < len ; i++ ){
				var c:int = commands[i];
				if ( c == 2 ){ //LINE_TO
					graphics.lineTo( px = data[xi], py = data[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( c == 3 ){ //CURVE_TO
					graphics.curveTo( data[xi], data[yi], px = data[int(xi + 2)], py = data[int(yi + 2)] );
					xi += 4;
					yi += 4;
				}
				else if ( c == 10 ) { //BEZIER_TO
					var x:Number = data[int(xi + 4)];
					var y:Number = data[int(yi + 4)];
					px -= x;
					py -= y;
					var cx0:Number = data[xi] - x;
					var cy0:Number = data[yi] - y;
					var cx1:Number = data[int(xi + 2)] - x;
					var cy1:Number = data[int(yi + 2)] - y;
					var k:Number = 1.0/bezierDetail;
					var t:Number = 0;
					var tp:Number;
					//bezier curve drawing
					for ( var j:int = 1; j <= bezierDetail; j++ ){
						t += k;
						tp = 1.0 - t;
						graphics.lineTo( px*(1-t)*(1-t)*(1-t) + 3*cx0*t*(1-t)*(1-t) + 3*cx1*t*t*(1-t) + x,
										 py*(1-t)*(1-t)*(1-t) + 3*cy0*t*(1-t)*(1-t) + 3*cy1*t*t*(1-t) + y );
					}
					px = x;
					py = y;
					xi += 6;
					yi += 6;
				}
				else if ( c == 1 ){ //MOVE_TO
					graphics.moveTo( sx = px = data[xi], sy = py = data[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( c == 100 ){ //CLOSE_PATH
					graphics.lineTo( px = sx, py = sy );
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PathData
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	commands
		 * @param	data
		 * @return	FPathElement[]
		 */
		public static function getPathElements( commands:Array, data:Array ):Array
		{
			var paths:Array = [];
			var len:int = commands.length;
			var start:FPathMove = null;
			var pre:FPathElement = null;
			var xi:int  = 0;
			var yi:int  = 1;
			for ( var i:int = 0; i < len ; i++ ){
				var cmd:int = commands[i];
				if ( cmd == FPathCommand.LINE_TO ) {
					paths.push( pre = pre.next = new FPathLine( pre, data[xi], data[yi] ) );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == FPathCommand.BEZIER_TO ) {
					paths.push( pre = pre.next = new FPathBezier( pre, data[xi], data[yi], data[int(xi + 2)], data[int(yi + 2)], data[int(xi + 4)], data[int(yi + 4)] ) );
					xi += 6;
					yi += 6;
				}
				else if ( cmd == FPathCommand.CURVE_TO ) {
					paths.push( pre = pre.next = new FPathCurve( pre, data[xi], data[yi], data[int(xi + 2)], data[int(yi + 2)] ) );
					xi += 4;
					yi += 4;
				}
				else if ( cmd == FPathCommand.MOVE_TO ) {
					if( pre != null ){
						paths.push( pre = pre.next = start = new FPathMove(data[xi], data[yi]) );
					}else {
						paths.push( pre = start = new FPathMove(data[xi], data[yi]) );
					}
					xi += 2;
					yi += 2;
				}
				else if ( cmd == FPathCommand.CLOSE_PATH ) {
					paths.push( pre = pre.next = new FPathClose(pre, start) );
				}
			}
			return paths;
		}
	}
	
}