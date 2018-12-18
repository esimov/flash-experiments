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
	 * 赤(Red) 緑(Green) 青(Blue) で色を定義するクラスです.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class ColorRGB implements IColor
	{	
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		private var _a:Number;
		
		/**
		 * 新しい ColorRGB クラスのインスタンスを生成します.
		 * 
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 * @param	a_	Alpha [0,1]
		 */
		public function ColorRGB( r:uint=0, g:uint=0, b:uint=0, a:Number=1.0 )
		{
			rgb( r, g, b );
			_a = a;
		}
		
		/**
		 * インスタンスのクローンを生成します.
		 */
		public function clone():ColorRGB
		{
			return new ColorRGB( _r, _g, _b, _a );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Value
		
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		public function get value():uint { return _r << 16 | _g << 8 | _b; }
		public function set value( colorValue:uint ):void
		{
			_r = colorValue >> 16 & 0xff;
			_g = colorValue >> 8 & 0xff;
			_b = colorValue & 0xff;
		}
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		public function get value32():uint { return (Math.round( _a * 0xff ) & 0xff) << 24 | _r << 16 | _g << 8 | _b ; }
		public function set value32( colorValue:uint ):void
		{
			_r = colorValue >> 16 & 0xff;
			_g = colorValue >> 8 & 0xff;
			_b = colorValue & 0xff;
			_a = ( colorValue >>> 24 ) / 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Alpha
		
		/**
		 * 色の 透明度(Alpha) 値を示します.<br/>
		 * 有効な値は 0.0　～　1.0　です.デフォルト値は　1.0　です.
		 */
		public function get a():Number { return _a; }
		public function set a(value:Number):void
		{
			_a = value;
		}
		
		//------------------------------------------------------------------------------------------------------------------- RGB
		
		/**
		 * 色の 赤(Red) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get r():uint { return _r; }
		public function set r( value:uint ):void
		{
			_r = value & 0xff;
		}
		
		/**
		 * 色の 緑(Green) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get g():uint { return _g; }
		public function set g( value:uint ):void
		{
			_g = value & 0xff;
		}
		
		/**
		 * 色の 青(Blue) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get b():uint { return _b; }
		public function set b( value:uint ):void
		{
			_b = value & 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * RGB値で色を指定します.
		 * @param	r	Red [0,255]
		 * @param	g	Green [0,255]
		 * @param	b	Blue [0,255]
		 */
		public function rgb( r:uint, g:uint, b:uint ):void
		{
			_r = r & 0xff;
			_g = g & 0xff;
			_b = b & 0xff;
		}
		
		/**
		 * グレイ値で色を指定します.
		 * @param	gray_	Gray [0,255]
		 */
		public function gray( gray_:uint ):void
		{
			_r = _g = _b = gray_ & 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- CONVERT
		
		/**
		 * RGB 値を HSV 値に変換して ColorHSV クラスのインスタンスを生成します.
		 */
		public function toHSV():ColorHSV
		{
			var c:ColorHSV = new ColorHSV();
			c.rgb( _r, _g, _b );
			c.a = _a;
			return c;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STRING, VALUE
		
		public function toString():String 
		{
			return "[RGB(" + _r + "," + _g + "," + _b + ")A("+ _a.toFixed(2)+")]";
		}
		
		/**
		 * @return 0xRRBBGG
		 */
		public function valueOf():uint 
		{
			return value;
		}
	}
	
}