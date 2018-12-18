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

package frocessing.core {
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import frocessing.bmp.FBitmapData;
	import frocessing.color.FColor;
	import frocessing.core.canvas.BitmapDataCanvas3D;
	
	/**
	* F5BitmapData3D は、F5Graphics3D の描画を BitmapData で保持するクラスです.
	* 
	* @author nutsu
	* @version 0.6.1
	*/
	public class F5BitmapData3D extends F5Canvas3D
	{
		private var _c3dbmp:BitmapDataCanvas3D;
		
		private var _transparent:Boolean;
		private var _bgcolor:uint;
		/*
		private var _bitmapData:FBitmapData;
		private var screenRect:Rectangle;
		private var _shape:Shape;
		private var bitmapdata_transparent:Boolean;
		private var bitmapdata_bg:uint;
		
		public var blendMode:String;
		*/
		
		/**
		 * 新しい F5BitmapData3D クラスのインスタンスを生成します.
		 * 
		 * @param	width			BitmapData の 幅
		 * @param	height			BitmapData の 高さ
		 * @param	transparent		BitmapData の transparent
		 * @param	bgcolor			BitmapData の 背景色( 32bit Color )
		 */
		public function F5BitmapData3D( width:uint, height:uint, transparent:Boolean = false, bgcolor:uint = 0xffcccccc )
		{
			super( _c3dbmp = new BitmapDataCanvas3D( new BitmapData( width, height, transparent, bgcolor ) ), width, height );
			_width       = width;
			_height      = height;
			_transparent = transparent;
			_bgcolor     = bgcolor;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function get drawTarget():Shape { return _c3dbmp.drawTarget; } //TODO:test draw target
		
		/**
		 * 描画の対象となる BitmapData を示します.
		 */
		public function get bitmapData():BitmapData { return _c3dbmp.bitmapData; }
		
		/**
		 * グラフィックを BitmapData へ描画するときの blendMode を示します.
		 * @see flash.display.BlendMode
		 */
		public function get blendMode():String { return _c3dbmp.blendMode; }
		public function set blendMode(value:String):void {
			_c3dbmp.blendMode = value;
		}
		
		
		/**
		 * 幅と高さを設定します. このメソッドにより bitmapData のサイズが変更され、描画が初期状態になります.
		 */
		override public function size( width:uint, height:uint ):void
		{
			if( _width != width || _height != height ){
				super.size( width, height );
				_c3dbmp.bitmapData.dispose();
				_c3dbmp.bitmapData = new BitmapData( _width, _height, _transparent, _bgcolor );
			}
		}
		
		
		/** overwrite to transform @private */
		override public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			super.background( c1, c2, c3, c4 );
			if ( _width > 0 && _height > 0 ){
				_transparent = ( __calc_alpha < 1 )
				_bgcolor     = FColor.toARGB( __calc_color, __calc_alpha );
			}
		}
	}
}