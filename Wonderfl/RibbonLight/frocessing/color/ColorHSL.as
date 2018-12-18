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
	 * 色相（Hue） 彩度(Saturation) 輝度(Lightness) で色を定義するクラスです.
	 * 
	 * @author nutsu
	 * @version 0.5.9
	 */
	public class ColorHSL extends AbstractColorUpdater implements IColor{
		
		private var _h:Number;	//Hue
		private var _s:Number;	//Saturation
		private var _l:Number;	//Lightness
		
		/**
		 * 新しい ColorHSL クラスのインスタンスを生成します.
		 * 
		 * @param	h	Hue (degree 360)
		 * @param	s	Saturation [0.0,1.0]
		 * @param	l	Lightness [0.0,1.0]
		 * @param	a	Alpha [0.0,1.0]
		 */
		public function ColorHSL( h:Number=0.0, s:Number = 1.0, l:Number = 0.5, a:Number = 1.0  ) 
		{
			hsl( h, s, l );
			_a = a;
		}
		
		/**
		 * インスタンスのクローンを生成します.
		 */
		public function clone():ColorHSL
		{
			var c:ColorHSL = new ColorHSL( _h, _s, _l, _a );
			c.copyFrom( this );
			return c;
		}
		
		//------------------------------------------------------------------------------------------------------------------- HSL
		
		/**
		 * 色の 色相(Hue) 値を、色相環上の角度( 0～360 )で示します.<br/>
		 * 0 度が赤、120 度が緑、240 度が青になります. 
		 */
		public function get h():Number { return _h; }
		public function set h( value:Number ):void
		{
			_h = value;
			check_rgb_flg = true;
		}
		/**
		 * 色の 色相(Hue) 値を、色相環上のラジアン( 0～2PI )で示します.<br/>
		 * 0 が赤、2PI/3 が緑、4PI/3 が青になります. 
		 */
		public function get hr():Number { return Math.PI*_h / 180; }
		public function set hr( value:Number ):void
		{
			_h = 180*value/Math.PI;
			check_rgb_flg = true;
		}
		
		/**
		 * 色の 彩度(Saturation) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 1.0 です.
		 */
		public function get s():Number { return _s; }
		public function set s( value:Number ):void
		{
			if ( value > 1.0 ) { _s = 1.0; } else if ( value < 0.0 ) { _s = 0.0; } else { _s = value; }
			check_rgb_flg = true;
		}
		
		/**
		 * 色の 輝度(Lightness) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 0.5 です.
		 */
		public function get l():Number { return _l; }
		public function set l( value:Number ):void
		{
			if ( value > 1.0 ) { _l = 1.0; } else if ( value < 0.0 ) { _l = 0.0; } else { _l = value; }
			check_rgb_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * HSL値で色を指定します.
		 * @param	h	Hue (degree 360)
		 * @param	s	Saturation [0.0,1.0]
		 * @param	l	Lightness [0.0,1.0]
		 */
		public function hsl( h:Number, s:Number = 1.0, l:Number = 0.5 ):void
		{
			_h = h;
			if ( s > 1.0 ) { _s = 1.0; } else if ( s < 0.0 ) { _s = 0.0; } else { _s = s; }
			if ( l > 1.0 ) { _l = 1.0; } else if ( l < 0.0 ) { _l = 0.0; } else { _l = l; }
			check_rgb_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- update
		
		/**
		 * HSL to RGB
		 * @private
		 */
		override protected function update_rgb():void 
		{
			if ( _s > 0 ) {
				var v:Number = (_l <= 0.5) ? _l + _s * _l : _l + _s * (1 - _l);
				var p:Number = 2.0 * _l - v;
				var h:Number = ((_h < 0) ? _h % 360 + 360 : _h % 360 ) / 60;
				if ( h < 1 ) {
					_r = Math.round( 255*v );
					_g = Math.round( 255*( p + (v - p) * h ) );
					_b = Math.round( 255*p );
				}else if ( h < 2 ) {
					_r = Math.round( 255*( p + (v - p) * (2 - h) ) );
					_g = Math.round( 255*v );
					_b = Math.round( 255*p );
				}else if ( h < 3 ) {
					_r = Math.round( 255*p );
					_g = Math.round( 255*v );
					_b = Math.round( 255*( p + (v - p) * (h - 2) ) );
				}else if ( h < 4 ) {
					_r = Math.round( 255*p );
					_g = Math.round( 255*( p + (v - p) * (4 - h) ) );
					_b = Math.round( 255*v );
				}else if ( h < 5 ) {
					_r = Math.round( 255*( p + (v - p) * (h - 4) ) );
					_g = Math.round( 255*p );
					_b = Math.round( 255*v );
				}else{
					_r = Math.round( 255 * v );
					_g = Math.round( 255*p );
					_b = Math.round( 255 * ( p + (v - p) * (6 - h) ) );
				}
			}else{
				_r = _g = _b = Math.round( 255*_l );
			}
			check_rgb_flg = false;
		}
		
		/**
		 * RGB to HSL
		 * @private
		 */
		override protected function apply_rgb():void 
		{
			if( _r!=_g || _r!=_b ){
				if ( _g > _b ) {
					if ( _r > _g ) { //r>g>b
						_l = (_r + _b);
						_s = (_l > 255) ? (_r - _b) / (510 - _l) : (_r - _b) / _l;
						_h = 60 * (_g - _b) / (_r - _b);
					}else if( _r < _b ){ //g>b>r
						_l = (_g + _r);
						_s = (_l > 255) ? (_g - _r) / (510 - _l) : (_g - _r) / _l;
						_h = 60 * (_b - _r) / (_g - _r) + 120;
					}else { //g=>r=>b
						_l = (_g + _b);
						_s = (_l > 255) ? (_g - _b) / (510 - _l) : (_g - _b) / _l;
						_h = 60 * (_b - _r) / (_g - _b) + 120;
					}
				}else{
					if ( _r > _b ) { // r>b=>g
						_l = (_r + _g);
						_s = (_l > 255) ? (_r - _g) / (510 - _l) : (_r - _g) / _l;
						_h = 60 * (_g - _b) / (_r - _g);
						if ( _h < 0 ) _h += 360;
					}else if ( _r < _g ){ //b=>g>r
						_l = (_b + _r);
						_s = (_l > 255) ? (_b - _r) / (510 - _l) : (_b - _r) / _l;
						_h = 60 * (_r - _g)/(_b - _r) + 240;
					}else { //b=>r=>g
						_l = (_b + _g);
						_s = (_l > 255) ? (_b - _g) / (510 - _l) : (_b - _g) / _l;
						_h = 60 * (_r - _g)/(_b - _g) + 240;
					}
				}
				_l /= 510;
			}else {
				_h = _s = 0;
				_l = _r/255;
			}
		}
		
		/**
		 * GrayScale to HSL
		 * @private
		 */
		override protected function apply_grayscale():void 
		{
			//_h = 0;
			_s = 0;
			_l = _r/255;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STRING
		
		public function toString():String 
		{
			return "[HSL(" + _h.toFixed(2) + "," + _s.toFixed(2) + "," + _l.toFixed(2) + ")A("+ _a.toFixed(2)+")]";
		}
	}
	
}