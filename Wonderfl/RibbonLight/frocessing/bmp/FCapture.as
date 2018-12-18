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
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Display Capture.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FCapture
	{
		private static const CAPTURE_MAX:int = 4000;		
		private static const zerop:Point = new Point();
		
		//capture src
		private var _src:IBitmapDrawable;
		private var _src_x:Number;
		private var _src_y:Number;
		private var _src_w:Number;
		private var _src_h:Number;
		private var _src_is_diplayobject:Boolean;
		
		//capture target
		private var _dst:BitmapData;
		private var _dst_w:Number;
		private var _dst_h:Number;
		private var _default_draw_flg:Boolean;
		
		/**
		 * capture blend mode.
		 */
		public var blendMode:String;
		/**
		 * capture color transform.
		 */
		public var colorTransform:ColorTransform;
		/**
		 * clear bg color
		 */
		public var bgColor:uint = 0xff000000;
		 
		 
		/**
		 * create new Capture instance.
		 * 
		 * @param	dist
		 * @param	src
		 */
		public function FCapture( dist:BitmapData, src:IBitmapDrawable ) 
		{
			bitmapData = dist;
			source = src;
			blendMode = null;
			colorTransform = null;
		}
		
		/**
		 * capture target.
		 */
		public function get bitmapData():BitmapData { return _dst; }
		public function set bitmapData( value:BitmapData ):void 
		{
			_dst = value;
			_dst_w = _dst.width;
			_dst_h = _dst.height;
			_default_draw_flg = ( _dst_w  <= CAPTURE_MAX && _dst_h <= CAPTURE_MAX );
		}
		
		/**
		 * caputre source
		 */
		public function get source():IBitmapDrawable { return _src; }
		public function set source(value:IBitmapDrawable):void 
		{
			_src = value;
			if ( _src is DisplayObject ) {
				_src_is_diplayobject = true;
				_src_x = _src_y = 0;
				_src_w = _src_h = 0;
			}else {
				_src_is_diplayobject = false;
				_src_x = _src_y = 0;
				_src_w = BitmapData(_src).width;
				_src_h = BitmapData(_src).height;
			}
		}
		
		/**
		 * capture display to bitmapData
		 */
		public function capture():void
		{
			if ( _default_draw_flg ) {
				//default draw
				_dst.draw( _src, null, colorTransform, blendMode );
			}else {
				//huge draw
				if ( _src_is_diplayobject ) {
					var sr:Rectangle = DisplayObject(_src).getBounds(null);
					_src_x = sr.x;
					_src_y = sr.y;
					_src_w = sr.width;
					_src_h = sr.height;
				}
				//draw size
				var dw:Number = _src_w + _src_x;
				var dh:Number = _src_h + _src_y;
				
				if ( dw > CAPTURE_MAX || dh > CAPTURE_MAX ) {
					//draw by grid CAPTURE_MAX
					var cw:int = (_src_w < CAPTURE_MAX ) ? _src_w : _src_w/Math.ceil( _src_w/CAPTURE_MAX );
					var ch:int = (_src_h < CAPTURE_MAX ) ? _src_h : _src_h/Math.ceil( _src_h/CAPTURE_MAX );
					//grid buffer
					var clipBD:BitmapData = new BitmapData( cw, ch, true, 0 ); //TODO:(2)ObjectPool
					//clip
					var clip:Rectangle = new Rectangle( 0, 0, cw, ch );
					var copyClip:Rectangle = clip.clone();
					//draw size info
					var minX:Number = Math.floor( _src_x );
					var minY:Number = Math.floor( _src_y );
					var maxX:Number = ( _dst_w < dw ) ? _dst_w : dw;
					var maxY:Number = ( _dst_h < dh ) ? _dst_h : dh;
					//draw point and matrix
					var dp:Point  = new Point();
					var mt:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
					//draw
					for ( var h:Number = minY; h < maxY ; h += ch ) {
						copyClip.y = dp.y = h;
						mt.ty = -h;
						for ( var w:Number = minX; w < maxX ; w += cw ) {
							copyClip.x = dp.x = w;
							mt.tx = -w;
							clipBD.copyPixels( _dst, copyClip, zerop );
							clipBD.draw( _src, mt, colorTransform, blendMode, clip );
							_dst.copyPixels( clipBD, clip, dp );
						}
					}
					clipBD.dispose();
				}else {
					//default draw
					_dst.draw( source, null, colorTransform, blendMode );
				}
			}
		}
		
		/**
		 * clear target bitmapdata by bgColor.
		 */
		public function clear():void
		{
			_dst.fillRect( _dst.rect, bgColor );
		}
	}

}