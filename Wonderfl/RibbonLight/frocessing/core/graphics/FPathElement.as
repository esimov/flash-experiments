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
	/**
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FPathElement
	{
		public var prev:FPathElement;
		public var next:FPathElement;
		/** @private */
		protected var _x:Number;
		/** @private */
		protected var _y:Number;
		
		public function FPathElement( prev:FPathElement, x:Number, y:Number) {
			this.prev = prev;
			next = null;
			_x = x;
			_y = y;
		}
		public function get x():Number {  return _x; }
		public function get y():Number {  return _y; }
		public function get px():Number { return prev.x; }
		public function get py():Number { return prev.y;  }
		public function get command():int {	return FPathCommand.NO_OP; };
		
		public function pointX( t:Number ):Number { return _x; }
		public function pointY( t:Number ):Number { return _y; }
		public function tangentX( t:Number ):Number { return 0; }
		public function tangentY( t:Number ):Number { return 0; }
		
		/**
		 * 
		 * @param	commands
		 * @param	data
		 * @return	FPathElement[]
		 */
		public static function createElements( commands:Array, data:Array ):Array
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