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

package frocessing.core.canvas 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import frocessing.bmp.FCapture;
	
	use namespace canvasImpl;
	/**
	 * Canvas3D for BitmapData.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class BitmapDataCanvas3D extends GraphicsCanvas3D implements ICanvasRender
	{
		private var _shape:Shape;
		private var _bd:BitmapData;
		private var _capture:FCapture;
		
		/**
		 * 
		 */
		public function BitmapDataCanvas3D( bitmapData:BitmapData ) 
		{
			super( (_shape = new Shape()).graphics );
			_bd = bitmapData;
			_capture = new FCapture( _bd, _shape );
			_bd.lock();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function get drawTarget():Shape{
			return _shape;
		}
		
		/**
		 * 
		 */
		public function get bitmapData():BitmapData { return _bd; }
		public function set bitmapData(value:BitmapData):void {
			_capture.bitmapData = value;
			_bd = value;
			_bd.lock();
		}
		
		/**
		 * 
		 */
		public function get blendMode():String { return _capture.blendMode; }
		public function set blendMode(value:String):void {
			_capture.blendMode = value;
		}
		
		/** @inheritDoc */
		override public function render():void {
			super.render();
			_capture.capture();
			_bd.unlock();
			_bd.lock();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Primitive
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override canvasImpl function pixelImpl(x:Number, y:Number, color:uint, alpha:Number):void 
		{
			if ( alpha > 0 ){
				var a:uint  = Math.round( alpha * 0xff );
				var c1:uint = _bd.getPixel32( x, y );
				var a1:uint = (c1 >>> 24) + a;
				_bd.setPixel32( x, y, 
							   ( a1 < 255 ) ? a1 << 24 : 0xff000000 | 
							   ( (a ^ 0xff) * ( c1 >> 16 & 0xff ) + a * ( color >> 16 & 0xff ) ) << 8 & 0xff0000 | 
							   ( (a ^ 0xff) * ( c1 >> 8 & 0xff ) + a * ( color >> 8 & 0xff ) ) & 0xff00 | 
							   ( (a ^ 0xff) * ( c1 & 0xff ) + a * ( color & 0xff ) ) >> 8 );
			}else{
				_bd.setPixel( x, y, color );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// background
		
		/** @inheritDoc */
		override public function background(width:Number, height:Number, color:uint, alpha:Number):void {
			clear();
			_capture.bgColor = Math.round( alpha * 0xff ) << 24 | color;
			_capture.clear();
		}		
	}
	
}