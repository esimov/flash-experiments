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

package frocessing.color {
	
	/**
	 * シアン（Cyan） マゼンタ(Magenta) イエロー(Yellow) による減法混色を定義するクラスです.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class ColorCMY extends AbstractColorUpdater implements IColor{
		
		private var _c:Number;	//Cyan
		private var _m:Number;	//Magenta
		private var _y:Number;	//Yellow
		
		/**
		 * 新しい ColorCMY クラスのインスタンスを生成します.
		 * 
		 * @param	c	Cyan [0,255]
		 * @param	m	Magenta [0,255]
		 * @param	y	Yellow [0,255]
		 * @param	a	Alpha [0.0,1.0]
		 */
		public function ColorCMY( c:uint=0, m:uint=0, y:uint=0, a:Number=1.0  ) 
		{
			cmy( c, m, y );
			_a = a;
		}
		
		/**
		 * インスタンスのクローンを生成します.
		 */
		public function clone():ColorCMY
		{
			var c:ColorCMY = new ColorCMY( _c, _m, _y, _a );
			c.copyFrom( this );
			return c;
		}
		
		//------------------------------------------------------------------------------------------------------------------- CMY
		
		/**
		 * 色の シアン（Cyan） 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get c():Number { return _c; }
		public function set c( value:Number ):void
		{
			_c = value & 0xff;
			check_rgb_flg = true;
		}
		
		/**
		 * 色の マゼンタ(Magenta) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get m():Number { return _m; }
		public function set m( value:Number ):void
		{
			_m = value & 0xff;
			check_rgb_flg = true;
		}
		
		/**
		 * 色の イエロー(Yellow) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get y():Number { return _y; }
		public function set y( value:Number ):void
		{
			_y = value & 0xff;
			check_rgb_flg = true;
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * CMY値で色を指定します.
		 * @param	c	Cyan [0,255]
		 * @param	m	Magenta [0,255]
		 * @param	y	Yellow [0,255]
		 */
		public function cmy( c:uint, m:uint, y:uint ):void
		{
			_c = c & 0xff;
			_m = m & 0xff;
			_y = y & 0xff;
			check_rgb_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- update
		
		/**
		 * CMY to RGB
		 * @private
		 */
		override protected function update_rgb():void 
		{
			_r = 0xff ^ _c;
			_g = 0xff ^ _m;
			_b = 0xff ^ _y;
			check_rgb_flg = false;
		}
		
		/**
		 * RGB to CMY
		 * @private
		 */
		override protected function apply_rgb():void 
		{
			_c = 0xff ^ _r;
			_m = 0xff ^ _g;
			_y = 0xff ^ _b;
		}
		
		/**
		 * GrayScale to CMY
		 * @private
		 */
		override protected function apply_grayscale():void 
		{
			_c = _m = _y = 0xff - _r;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STRING
		
		public function toString():String 
		{
			return "[CMY(" + _c + "," + _m + "," + _y + ")A("+ _a.toFixed(2)+")]";
		}
	}
	
}