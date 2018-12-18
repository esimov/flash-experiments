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

package frocessing.bmp 
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 * 
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FBitmapData
	{
		/** @private */
		protected var _bd:BitmapData;
		
		public function FBitmapData( bitmapData:BitmapData ) {
			_bd = bitmapData;
		}
		
		public function get width():int{ 			return _bd.width; 	}
		public function get height():int {			return _bd.height;  }
		public function get rect():Rectangle {		return _bd.rect; 	}		
		public function get transparent():Boolean { return _bd.transparent; }
		
		public function dispose():void{
			_bd.dispose();
		}
		
		public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void{
			_bd.draw( source, matrix, colorTransform, blendMode, clipRect, smoothing );
		}
		
		public function fillRect(rect:Rectangle, color:uint):void{
			_bd.fillRect( rect, color );
		}
		
		public function lock():void{
			_bd.lock();
		}
		
		public function unlock(changeRect:Rectangle = null):void{
			_bd.unlock(changeRect);
		}
		
		public function getPixel(x:int, y:int):uint{
			return _bd.getPixel( x, y );
		}
		
		public function getPixel32(x:int, y:int):uint{
			return _bd.getPixel32( x, y );
		}
		
		public function setPixel(x:int, y:int, color:uint):void{
			_bd.setPixel( x, y, color );
		}
		
		public function setPixel32(x:int, y:int, color:uint):void{
			_bd.setPixel32( x, y, color );
		}
		
		public function drawPixel32(x:int, y:int, color:uint):void {
			var a:uint  = color >>> 24;
			if ( a > 0 ){
				var c1:uint = _bd.getPixel32( x, y );
				var a1:uint = (c1 >>> 24) + a;
				_bd.setPixel32( x, y, 
							   ( a1 < 255 ) ? a1 << 24 : 0xff000000 | 
							   ( (a ^ 0xff) * ( c1 >> 16 & 0xff ) + a * ( color >> 16 & 0xff ) ) << 8 & 0xff0000 | 
							   ( (a ^ 0xff) * ( c1 >> 8 & 0xff ) + a * ( color >> 8 & 0xff ) ) & 0xff00 | 
							   ( (a ^ 0xff) * ( c1 & 0xff ) + a * ( color & 0xff ) ) >> 8 );
			}
		}
		
		public function get bitmapData():BitmapData{
			return _bd;
		}
		
	}
	
}