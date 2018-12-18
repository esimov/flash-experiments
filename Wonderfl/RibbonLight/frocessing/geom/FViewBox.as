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

package frocessing.geom 
{
	import flash.geom.Matrix;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	/**
	* View Box
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FViewBox 
	{
		public static const NO_SCALE     :String = StageScaleMode.NO_SCALE;  // "noScale";
		public static const EXACT_FIT    :String = StageScaleMode.EXACT_FIT; // "exactFit";
		public static const NO_BORDER    :String = StageScaleMode.NO_BORDER; // "noBorder";
		public static const SHOW_ALL     :String = StageScaleMode.SHOW_ALL;  // "showAll";
		
		public static const CENTER       :String = "";
		public static const BOTTOM       :String = StageAlign.BOTTOM;		 // "B";
		public static const BOTTOM_LEFT  :String = StageAlign.BOTTOM_LEFT;	 // "BL";
		public static const BOTTOM_RIGHT :String = StageAlign.BOTTOM_RIGHT;  // "BR";
		public static const LEFT         :String = StageAlign.LEFT;		 	 // "L";
		public static const RIGHT        :String = StageAlign.RIGHT;		 // "R";
		public static const TOP          :String = StageAlign.TOP;			 // "T";
		public static const TOP_LEFT     :String = StageAlign.TOP_LEFT;	     // "TL";
		public static const TOP_RIGHT    :String = StageAlign.TOP_RIGHT;	 // "TR";
		
		/** source x(left) */
		public var x:Number;
		/** source y(top) */
		public var y:Number;
		/** source width */
		public var width:Number;
		/** source height */
		public var height:Number;
		
		/**
		 * @see flash.display.StageScaleMode
		 */
		public var scaleMode:String = NO_SCALE;
		
		private var _align:String = "";
		private var _px:Number = 0.5;
		private var _py:Number = 0.5;
		
		/**
		 * 
		 */
		public function FViewBox( x:Number=0, y:Number=0, width:Number=1, height:Number=1 ) 
		{
			this.x      = x;
			this.y      = y;
			this.width  = width;
			this.height = height;
		}
		
		/**
		 * set source rect.
		 * 
		 * @param	x		srcX
		 * @param	y		srcY
		 * @param	width	srcWidth
		 * @param	height	srcHeight
		 */
		public function setRect( x:Number, y:Number, width:Number, height:Number ):void 
		{
			this.x      = x;
			this.y      = y;
			this.width  = width;
			this.height = height;
		}
		
		/**
		 * 
		 * @param	targetX
		 * @param	targetY
		 * @param	targetWidth
		 * @param	targetHeight
		 */
		public function getTransformMatrix( targetX:Number, targetY:Number, targetWidth:Number, targetHeight:Number ):Matrix
		{
			var scaleX:Number = targetWidth / width;
			var scaleY:Number = targetHeight / height;
			if ( scaleMode == NO_SCALE ) {
				targetX += (targetWidth  - width ) * _px;
				targetY += (targetHeight - height) * _py;
				scaleX = scaleY = 1.0;
			}
			else if ( scaleMode == SHOW_ALL ) {
				if ( scaleX <= scaleY ) {
					scaleY = scaleX;
					targetY += (targetHeight - scaleX * height) * _py;
				} else {
					scaleX = scaleY;
					targetX += (targetWidth  - scaleY * width ) * _px;
				}
			}
			else if ( scaleMode == NO_BORDER ){
				if ( scaleX >= scaleY ) {
					scaleY = scaleX;
					targetY += (targetHeight - scaleX * height) * _py;
				} else {
					scaleX = scaleY;
					targetX += (targetWidth  - scaleY * width ) * _px;
				}
			}
			return new Matrix( scaleX, 0, 0, scaleY, targetX - x * scaleX, targetY - y * scaleY );
		}
		
		/**
		 * @see flash.display.StageAlign
		 */
		public function get align():String { return _align; }
		public function set align(value:String):void 
		{
			switch( value ) {
				case CENTER:       _px = 0.5; _py = 0.5; break;
				case LEFT:         _px = 0.0; _py = 0.5; break;
				case RIGHT:        _px = 1.0; _py = 0.5; break;
				case BOTTOM:   	   _px = 0.5; _py = 1.0; break;
				case BOTTOM_LEFT:  _px = 0.0; _py = 1.0; break;
				case BOTTOM_RIGHT: _px = 1.0; _py = 1.0; break;
				case TOP:          _px = 0.5; _py = 0.0; break;
				case TOP_LEFT:     _px = 0.0; _py = 0.0; break;
				case TOP_RIGHT:    _px = 1.0; _py = 0.0; break;
				default:		   _px = 0.5; _py = 0.5; value = CENTER; break;
			}
			_align = value;
		}
	}
	
}