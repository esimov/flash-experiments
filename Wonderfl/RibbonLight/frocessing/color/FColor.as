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
	 * 色を定義するクラスです.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class FColor implements IColor
	{
		//
		private var _a:Number;	//Alpha
		private var _r:uint;	//Red
		private var _g:uint;	//Green
		private var _b:uint;	//Blue
		private var _h:Number;	//Hue
		private var _s:Number;	//Saturation
		private var _v:Number;	//Value | Brightness
		
		//
		private var __update_rgb_flg:Boolean;
		private var __update_hsv_flg:Boolean;
		
		/**
		 * 新しい FColor クラスのインスタンスを生成します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>new FColor( gray )</listing>
		 * <listing>new FColor( gray, alpha )</listing>
		 * <listing>new FColor( hex )</listing>
		 * <listing>new FColor( hex, alpha )</listing>
		 * <listing>new Fcolor( red, green, blue )</listing>
		 * <listing>new FColor( red, green, blue, alpha )</listing>
		 * <listing>new FColor( hue, saturation, brightness, alpha, false )</listing>
		 * 
		 * @param	c1		first value
		 * @param	c2		second value
		 * @param	c3		third value
		 * @param	c4		fourth value
		 * @param	byRGB	false to in hsv
		 */
		public function FColor( c1:Number = 0, c2:Number = NaN, c3:Number = NaN, c4:Number = 1.0, byRGB:Boolean = true )
		{
			color( c1, c2, c3, c4, byRGB );
		}
		
		/**
		 * インスタンスのクローンを生成します.
		 */
		public function clone():FColor
		{
			var __instance:FColor = new FColor();
			__instance._r = _r;
			__instance._g = _g;
			__instance._b = _b;
			if ( __update_hsv_flg ) __update_hsv();
			__instance._h = _h;
			__instance._s = _s;
			__instance._v = _v;
			return __instance;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Value
		
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		public function get value():uint
		{
			if ( __update_rgb_flg ) __update_rgb();
			return _r << 16 | _g << 8 | _b;
		}
		public function set value( value_:uint ):void
		{
			_r = value_ >> 16 & 0xff;
			_g = value_ >> 8 & 0xff;
			_b = value_ & 0xff;
			__update_hsv_flg = true;
			__update_rgb_flg = false;
		}
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		public function get value32():uint
		{
			if ( __update_rgb_flg ) __update_rgb();
			return a8<<24 | _r << 16 | _g << 8 | _b;
		}
		public function set value32( value_:uint ):void
		{
			_a = ( value_ >>> 24 ) / 0xff;
			value = value_;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Alpha
		
		/**
		 * 色の 透明度(Alpha) 値を示します.<br/>
		 * 有効な値は 0.0　～　1.0　です.デフォルト値は　1.0　です.
		 */
		public function get a():Number { return _a; }
		public function set a(value_:Number):void
		{
			_a = value_;
		}
		
		/**
		 * alpha value by 0xff
		 */
		private function get a8():uint {  return Math.round( _a * 0xff ) & 0xff; }
		
		//------------------------------------------------------------------------------------------------------------------- RGB
		
		/**
		 * 色の 赤(Red) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get r():uint
		{
			if ( __update_rgb_flg ) __update_rgb();
			return _r;
		}
		public function set r( value_:uint ):void
		{
			if ( __update_rgb_flg ) __update_rgb();
			_r = value_ & 0xff;
			__update_hsv_flg = true;
		}
		
		/**
		 * 色の 緑(Green) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get g():uint
		{
			if ( __update_rgb_flg ) __update_rgb();
			return _g;
		}
		public function set g( value_:uint ):void
		{
			if ( __update_rgb_flg ) __update_rgb();
			_g = value_ & 0xff;
			__update_hsv_flg = true;
		}
		
		/**
		 * 色の 青(Blue) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		public function get b():uint
		{
			if ( __update_rgb_flg ) __update_rgb();
			return _b;
		}
		public function set b( value_:uint ):void
		{
			if ( __update_rgb_flg ) __update_rgb();
			_b = value_ & 0xff;
			__update_hsv_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- HSV
		
		/**
		 * 色の 色相(Hue) 値を、色相環上のラジアン( 0～2PI )で示します.<br/>
		 * 0 が赤、2PI/3 が緑、4PI/3 が青になります. 
		 */
		public function get hr():Number { return Math.PI * h / 180; }
		public function set hr( value_:Number ):void
		{
			h = 180*value_/Math.PI;
		}
		
		/**
		 * 色の 色相(Hue) 値を、色相環上の角度( 0～360 )で示します.<br/>
		 * 0 度が赤、120 度が緑、240 度が青になります. 
		 */
		public function get h():Number
		{
			if ( __update_hsv_flg ) __update_hsv();
			return _h;
		}
		public function set h( value_:Number ):void
		{
			if ( __update_hsv_flg ) __update_hsv();
			_h = value_;
			__update_rgb_flg = true;
		}
		
		/**
		 * 色の 彩度(Saturation) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 1 です.
		 */
		public function get s():Number
		{
			if ( __update_hsv_flg ) __update_hsv();
			return _s;
		}
		public function set s( value_:Number ):void
		{
			if ( __update_hsv_flg ) __update_hsv();
			if ( value_ > 1 ) { _s = 1; } else if ( value_ < 0 ) { _s = 0; } else { _s = value_; }
			__update_rgb_flg = true;
		}
		
		/**
		 * 色の 明度(Value・Brightness) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 1 です.
		 */
		public function get v():Number 
		{
			if ( __update_hsv_flg ) __update_hsv();
			return _v;
		}
		public function set v( value_:Number ):void
		{
			if ( __update_hsv_flg ) __update_hsv();
			if ( value_ > 1 ) { _v = 1; } else if ( value_ < 0 ) { _v = 0; } else { _v = value_; }
			__update_rgb_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * RGB値で色を指定します.
		 * @param	r	Red [0,255]
		 * @param	g	Green [0,255]
		 * @param	b	Blue [0,255]
		 */
		public function rgb( r_:uint, g_:uint, b_:uint ):void
		{
			_r = r_ & 0xff;
			_g = g_ & 0xff;
			_b = b_ & 0xff;
			__RGBtoHSV( _r, _g, _b );
			_h = __cache_h;
			_s = __cache_s;
			_v = __cache_v;
			__update_rgb_flg = false;
			__update_hsv_flg = false;
		}
		
		/**
		 * HSV値で色を指定します.
		 * @param	h	Hue (degree 360)
		 * @param	s	Saturation [0.0,1.0]
		 * @param	v	Brightness [0.0,1.0]
		 */
		public function hsv( h_:Number, s_:Number = 1.0, v_:Number = 1.0 ):void
		{
			_h = h_;
			if ( s_ > 1 ) { _s = 1; } else if ( s_ < 0 ) { _s = 0; } else { _s = s_; }
			if ( v_ > 1 ) { _v = 1; } else if ( v_ < 0 ) { _v = 0; } else { _v = v_; }
			__HSVtoRGB( _h, _s, _v );
			_r = __cache_r;
			_g = __cache_g;
			_b = __cache_b;
			__update_rgb_flg = false;
			__update_hsv_flg = false;
		}
		
		/**
		 * グレイ値で色を指定します.
		 * @param	gray	Gray [0,255]
		 */
		public function gray( gray_:uint ):void
		{
			_r = _g = _b = gray_ & 0xff;
			_h = _s = 0.0;
			_v = _r / 0xff;
			__update_rgb_flg = false;
			__update_hsv_flg = false;
		}
		
		/**
		 * 色の指定を行います.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>color( gray )</listing>
		 * <listing>color( gray, alpha )</listing>
		 * <listing>color( hex )</listing>
		 * <listing>color( hex, alpha )</listing>
		 * <listing>color( red, green, blue )</listing>
		 * <listing>color( red, green, blue, alpha )</listing>
		 * <listing>color( hue, saturation, brightness, alpha, false )</listing>
		 * 
		 * @param	c1	first value
		 * @param	c2	second value
		 * @param	c3	third value
		 * @param	c4	fourth value
		 * @param	byRGB	false to in hsv
		 */
		public function color( c1:Number, c2:Number = NaN, c3:Number = NaN, c4:Number = 1.0, byRGB:Boolean = true ):void
		{
			if ( c3 >= 0 )
			{
				_a = c4;
				if( byRGB )
					rgb( uint(c1), uint(c2), uint(c3) );
				else
					hsv( c1, c2, c3 );
			}
			else if ( c2 >= 0 )
			{
				_a = c2;
				if ( uint(c1) <= 0xff )
					gray( c1 );
				else
					value = c1;
			}
			else
			{
				_a = 1.0;
				if ( uint(c1) <= 0xff )
					gray( c1 );
				else if ( c1 >>> 24 > 0 )
					value32 = c1;
				else
					value = c1;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- UPDATE
		
		/**
		 * @private
		 */
		private function __update_rgb():void
		{
			__HSVtoRGB( _h, _s, _v );
			_r = __cache_r;
			_g = __cache_g;
			_b = __cache_b;
			__update_rgb_flg = false;
		}
		
		/**
		 * @private
		 */
		private function __update_hsv():void
		{
			__RGBtoHSV( _r, _g, _b );
			_h = __cache_h;
			_s = __cache_s;
			_v = __cache_v;
			__update_hsv_flg = false;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STRING, VALUE
		
		/**
		 * @return "[FColor(r,g,b,a)]"
		 */
		public function toString():String 
		{
			return "[FColor(" + _r + "," + _g + "," + _b + ","+ _a.toFixed(2)+")]";
		}
		
		/**
		 * @return 0xRRBBGG
		 */
		public function valueOf():uint 
		{
			return value;
		}
		
		//------------------------------------------------------------------------------------------------------------------- READ
		
		/**
		 * 透明度(alpha)を返します.
		 * @param	col	32 bit color 0xAARRGGBB
		 * @return	0 to 1
		 */
		public static function alpha( col:uint ):Number
		{
			return ( col >>> 24 ) / 0xff;
		}
		
		/**
		 * 赤(red) 値を返します.
		 */
		public static function red( col:uint ):uint
		{
			return col >> 16 & 0xff;
		}
		
		/**
		 * 緑(green) 値を返します.
		 */
		public static function green( col:uint ):uint
		{
			return col >> 8 & 0xff;
		}
		
		/**
		 * 青(blue) 値を返します.
		 */
		public static function blue( col:uint ):uint
		{
			return col & 0xff;
		}
		
		/**
		 * 色相(hue) 値を返します.
		 * @return	degree 0 to 360
		 */
		public static function hue( col:uint ):Number
		{
			if ( col != __read ) __readHSV( col );
			return __read_h;
		}
		
		/**
		 * 彩度(saturation) 値を返します.
		 * @return	0 to 1
		 */
		public static function saturation( col:uint ):Number
		{
			if ( col != __read ) __readHSV( col );
			return __read_s;
		}
		
		/**
		 * 明度(value・brightness) 値を返します.
		 * @return	0 to 1
		 */
		public static function brightness( col:uint ):Number
		{
			if ( col != __read ) __readHSV( col );
			return __read_v;
		}
		
		private static var __read:uint = 0;
		private static var __read_h:Number = 0;
		private static var __read_s:Number = 0;
		private static var __read_v:Number = 0;
		
		private static function __readHSV( col:uint ):void
		{
			__read = col;
			__RGBtoHSV( col >> 16 & 0xff, col >> 8 & 0xff, col & 0xff );
			__read_h = __cache_h;
			__read_s = __cache_s;
			__read_v = __cache_v;
		}
		
		//------------------------------------------------------------------------------------------------------------------- CREATE
		
		/**
		 * RGB値　を HSV値 に変換します.
		 * @param	r	red [0,255]
		 * @param	g	green [0,255]
		 * @param	b	blue [0,255]
		 * @return	{ h:Number, s:Number, v:Number }
		 */
		public static function RGBtoHSV( r:uint, g:uint, b:uint ):Object
		{
			r = r & 0xff;
			g = g & 0xff;
			b = b & 0xff;
			__RGBtoHSV( r, g, b );
			return { h:__cache_h, s:__cache_s, v:__cache_v };
		}
		
		/**
		 * HSV値 を RGB値 に変換します.
		 * @param	h	hue degree 360
		 * @param	s	saturation [0.0,1.0]
		 * @param	v	brightness [0.0,1.0]
		 * @return	{ r:uint, g:uint ,b:uint }
		 */
		public static function HSVtoRGB( h:Number, s:Number, v:Number ):Object
		{
			if ( s > 1 ) { s = 1; } else if ( s < 0 ) { s = 0; }
			if ( v > 1 ) { v = 1; } else if ( v < 0 ) { v = 0; }
			__HSVtoRGB( h, s, v );
			return { r:__cache_r, g:__cache_g, b:__cache_b };
		}
		
		/**
		 * RGB値 と alpha値 を uint に変換します.
		 * @param	r	red [0,255]
		 * @param	g	green [0,255]
		 * @param	b	blue [0,255]
		 * @param	a	alpha [0,1]
		 */
		public static function RGBtoValue( r:uint, g:uint, b:uint, a:Number=0 ):uint
		{
			if( a>0 )
				return ( uint( a * 0xff ) & 0xff ) << 24 | r << 16 & 0xff0000 | g << 8 & 0x00ff00 | b & 0xff;
			else
				return r << 16 & 0xff0000 | g << 8 & 0x00ff00 | b & 0xff;
		}
		
		/**
		 * HSV値 と alpha値 を uint に変換します.
		 * @param	h	hue degree 360
		 * @param	s	saturation [0.0,1.0]
		 * @param	v	brightness [0.0,1.0]
		 * @param	a	alpha [0,1]
		 */
		public static function HSVtoValue( h:Number, s:Number, v:Number, a:Number=0 ):uint
		{
			if ( s > 1 ) { s = 1; } else if ( s < 0 ) { s = 0; }
			if ( v > 1 ) { v = 1; } else if ( v < 0 ) { v = 0; }
			__HSVtoRGB( h, s, v );
			if( a>0 )
				return ( uint( a * 0xff ) & 0xff ) << 24 | __cache_r << 16 | __cache_g << 8 | __cache_b;
			else
				return __cache_r << 16 | __cache_g << 8 | __cache_b;
		}
		
		/**
		 * グレー値 を uint に変換します.
		 * @param	gray	[0,255]
		 * @param	a	alpha [0,1]
		 */
		public static function GrayToValue( gray:uint, a:Number=0 ):uint
		{
			var g:uint = gray & 0xff;
			if ( a > 0 )
				return ( uint( a * 0xff ) & 0xff ) << 24 | g << 16 | g << 8 | g;
			else
				return g << 16 | g << 8 | g;
		}
		
		/**
		 * 0xRRGGBB と alpha を 0xAARRGGBB にします.
		 * @param	col	hex
		 * @param	a	alpha [0,1]
		 */
		public static function toARGB( col:uint, a:Number = 1.0 ):uint
		{
			if( col>>>24 > 0 )
				return ( uint( a * 0xff ) & 0xff ) << 24 | (col & 0x00ffffff);
			else
				return ( uint( a * 0xff ) & 0xff ) << 24 | col;
		}
		
		/**
		 * uint を RGB値 に変換します.
		 * @param	col	0xRRGGBB
		 * @return	{ r:uint, g:uint ,b:uint }
		 */
		public static function ValueToRGB( col:uint ):Object
		{
			return { r:(col >> 16 & 0xff), g:(col >> 8 & 0xff), b:(col & 0xff) };
		}
		
		/**
		 * uint を HSV値 に変換します.
		 * @param	col	0xRRGGBB
		 * @return	{ h:Number, s:Number, v:Number }
		 */
		public static function ValueToHSV( col:uint ):Object
		{
			return RGBtoHSV( col >> 16 & 0xff, col >> 8 & 0xff, col & 0xff );
		}
		
		/*
		public static function invert( col:uint ):uint
		{
			return col ^ 0xffffffff;
		}
		*/
		
		//------------------------------------------------------------------------------------------------------------------- CONVERT
		
		private static var __cache_r :uint  = 0;
		private static var __cache_g :uint  = 0;
		private static var __cache_b :uint  = 0;
		private static var __cache_h:Number = 0;
		private static var __cache_s:Number = 0;
		private static var __cache_v:Number = 0;
		
		/**
		 * @private
		 */
		public static function __RGBtoHSV( r:uint, g:uint, b:uint ):void
		{
			if( r!=g || r!=b ){
				if ( g > b ) {
					if ( r > g ) { //r>g>b
						__cache_v = r/255;
						__cache_s = (r - b) / r;
						__cache_h = 60 * (g - b) / (r - b);
					}else if( r < b ){ //g>b>r
						__cache_v = g/255;
						__cache_s = (g - r) / g;
						__cache_h = 60 * (b - r) / (g - r) + 120;
					}else { //g=>r=>b
						__cache_v = g/255;
						__cache_s = (g - b) / g;
						__cache_h = 60 * (b - r) / (g - b) + 120;
					}
				}else{
					if ( r > b ) { // r>b=>g
						__cache_v = r/255;
						__cache_s = (r - g) / r;
						__cache_h = 60 * (g - b) / (r - g);
						if ( __cache_h < 0 ) __cache_h += 360;
					}else if ( r < g ){ //b=>g>r
						__cache_v = b/255;
						__cache_s = (b - r) / b;
						__cache_h = 60 * (r - g) / (b - r) + 240;
					}else { //b=>r=>g
						__cache_v = b/255;
						__cache_s = (b - g) / b;
						__cache_h = 60 * (r - g) / (b - g) + 240;
					}
				}
			}else {
				__cache_h = __cache_s = 0;
				__cache_v = r/255;
			}
		}
		
		/**
		 * @private
		 */
		private static function __HSVtoRGB( h:Number, s:Number, v:Number ):void
		{
			if ( s > 0 ) {
				h = ((h < 0) ? h % 360 + 360 : h % 360 ) / 60;
				if ( h < 1 ) {
					__cache_r = Math.round( 255*v );
					__cache_g = Math.round( 255*v * ( 1 - s * (1 - h) ) );
					__cache_b = Math.round( 255*v * ( 1 - s ) );
				}else if ( h < 2 ) {
					__cache_r = Math.round( 255*v * ( 1 - s * (h - 1) ) );
					__cache_g = Math.round( 255*v );
					__cache_b = Math.round( 255*v * ( 1 - s ) );
				}else if ( h < 3 ) {
					__cache_r = Math.round( 255*v * ( 1 - s ) );
					__cache_g = Math.round( 255*v );
					__cache_b = Math.round( 255*v * ( 1 - s * (3 - h) ) );
				}else if ( h < 4 ) {
					__cache_r = Math.round( 255*v * ( 1 - s ) );
					__cache_g = Math.round( 255*v * ( 1 - s * (h - 3) ) );
					__cache_b = Math.round( 255*v );
				}else if ( h < 5 ) {
					__cache_r = Math.round( 255*v * ( 1 - s * (5 - h) ) );
					__cache_g = Math.round( 255*v * ( 1 - s ) );
					__cache_b = Math.round( 255*v );
				}else{
					__cache_r = Math.round( 255*v );
					__cache_g = Math.round( 255*v * ( 1 - s ) );
					__cache_b = Math.round( 255*v * ( 1 - s * (h - 5) ) );
				}
			}else {
				__cache_r = __cache_g = __cache_b = Math.round( 255*v );
			}
		}
	}
}