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

package frocessing.math {
	
	import frocessing.geom.FNumber3D;
	
	/**
	* 算術関連のメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FMath{
		
		public static const PI         :Number = Math.PI;
		public static const TWO_PI     :Number = Math.PI*2;
		public static const HALF_PI    :Number = Math.PI/2;
		public static const QUART_PI   :Number = Math.PI/4;
		
		private static const RAD_TO_DEG:Number = 180.0/Math.PI;
		private static const DEG_TO_RAD:Number = Math.PI/180.0;
		
		//nEqual の許容誤差
		public static var NE:Number = 1e-6;
		
		private static var __random:SFMTRandom;
		
		//--------------------------------------------------------------------------------------------------- Calculation
		
		/**
		 * ベクトル長を計算します.
		 */
		public static function mag( x:Number, y:Number ):Number
		{
			return Math.sqrt( x * x + y * y );
		}
		
		/**
		 * ベクトル長を計算します(3D).
		 */
		public static function mag3d( x:Number, y:Number, z:Number ):Number
		{
			return Math.sqrt( x * x + y * y + z * z);
		}
		
		/**
		 * 距離を計算します.
		 */
		public static function dist( x0:Number, y0:Number, x1:Number, y1:Number ):Number
		{
			return Math.sqrt( (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0) );
		}
		
		/**
		 * 距離を計算します(3D).
		 */
		public static function dist3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):Number
		{
			return Math.sqrt( (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0) + (z1 - z0) * (z1 - z0) );
		}
		
		//------------------------
		
		/**
		 * 2乗の値を返します.
		 */
		public static function sq( value:Number ):Number
		{
			return value*value;
		}
		
		/**
		 * 任意の範囲で値を正規化します.
		 */
		public static function norm( value:Number, low:Number, high:Number ):Number
		{
			return ( value -low )/ (high - low);
		}
		
		/**
		 * 任意の範囲から割合に応じた値を返します.
		 * @param	a
		 * @param	b
		 * @param	value	0.0:a, 1.0:b, 0.5:middle value
		 */
		public static function lerp( a:Number, b:Number, amt:Number ):Number
		{
			return a + (b - a) * amt;
		}
		
		/*
		 * 中間値を返します.
		 
		public static function middle( a:Number, b:Number ):Number
		{
			return ( a + b ) * 0.5;
		}
		*/
		
		/**
		 * 値を、low1～high1 から low2～high2 へマッピングします.
		 * @param	value
		 * @param	low1
		 * @param	high1
		 * @param	low2
		 * @param	high2
		 */
		public static function map( value:Number, low1:Number, high1:Number, low2:Number, high2:Number ):Number
		{
			return low2 + (high2 - low2) * (value - low1)/ (high1 - low1);
		}
		
		/**
		 * 値を決められた範囲に入れます.
		 * @param	value
		 * @param	min
		 * @param	max
		 */
		public static function constrain( value:Number, min:Number, max:Number ):Number
		{
			if ( min > max ){
				var m:Number = max;
				max = min;
				min = m;
			}
			if ( value > max )
				return max;
			else if ( value < min )
				return min;
			else
				return value;
		}
		
		/**
		 * 
		 * @param	value
		 * @param	tick
		 */
		public static function quant( value:Number, tick:Number ):Number
		{
			return tick * Math.round(value / tick);
		}
		
		//--------------------------------------------------------------------------------------------------- Trigonometry
		
		/**
		 * ラジアンを度に変換します.
		 */
		public static function degrees( rad:Number ):Number
		{
			return RAD_TO_DEG * rad;
		}
		
		/**
		 * 度をラジアンに変換します.
		 */
		public static function radians( deg:Number ):Number
		{
			return DEG_TO_RAD * deg;
		}
		
		//--------------------------------------------------------------------------------------------------- Random
		
		/**
		 * random
		 * @param	high
		 * @param	low
		 */
		public static function random( high:Number, low:Number=0 ):Number
		{
			if ( __random == null )
				__random = new SFMTRandom();
			return low + (high - low) * __random.random();
		}
		
		/**
		 * set random seed
		 * @param	seed
		 */
		public static function randomSeed( seed:uint ):void
		{
			if ( __random == null )
				__random = new SFMTRandom( seed );
			else
				__random.randomSeed( seed );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 内積を取得します.
		 */
		public static function dot( x0:Number, y0:Number, x1:Number, y1:Number ):Number
		{
			return x0*x1 + y0*y1;
		}
		
		/**
		 * 内積を取得します(3d).
		 */
		public static function dot3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):Number
		{
			return x0*x1 + y0*y1 + z0*z1;
		}
		
		/**
		 * 外積を取得します.
		 */
		public static function cross( x0:Number, y0:Number, x1:Number, y1:Number ):Number
		{
			return x0*y1 - y0*x1;
		}
		/**
		 * 外積ベクトルを取得します(3d).
		 */
		public static function cross3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):FNumber3D
		{
			return new FNumber3D( y0*z1 - z0*y1, z0*x1 - x0*z1, x0*y1 - y0*x1 );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * 2を底とする対数を返します.
		 */
		public static function log2( value:Number ):Number
		{
			return Math.log(value) * Math.LOG2E;
		}
		
		/**
		 * 10を底とする対数を返します.
		 */
		public static function log10( value:Number ):Number
		{
			return Math.log(value) * Math.LOG10E;
		}
		
		/**
		 * sinh
		 */
		public static function sinh( x:Number ):Number
		{
			return ( Math.pow( Math.E, x ) - Math.pow( Math.E, -x ) )*0.5;
		}
		
		/**
		 * cosh
		 */
		public static function cosh( x:Number ):Number
		{
			return ( Math.pow( Math.E, x ) + Math.pow( Math.E, -x ) )*0.5;
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * 2つの値の差が <code>NE</code> 以下かどうか判定します.
		 */
		public static function nEqual( a:Number, b:Number ):Boolean
		{
			return ( a > b ) ? ( a - b ) < NE : ( b - a ) < NE;
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * ベクトル長を計算します(N次元).
		 */
		/*
		public static function magNd( values:Array ):Number
		{
			var m:Number = 0;
			var n:uint   = values.length;
			for ( var i:int = 0; i < n; i++ )
					m += values[i] * values[i];
			return Math.sqrt( m );
		}
		*/
		
		/**
		 * ベクトル長をまとめて計算します.
		 * 
		 * @param	xs	x coordinates
		 * @param	ys	y coordinates
		 */
		/*
		public static function mags( xs:Array, ys:Array ):Array
		{
			if ( xs.length != ys.length )
				throw new ArgumentError("値の数が異なります");
			
			var size:uint = xs.length;
			var res:Array = new Array( size );
			for ( var i:int = 0 ; i < size ; i++ )
				res[i] = mag( xs[i], ys[i] );
			return res;
		}
		*/
		
		/**
		 * ベクトル長をまとめて計算します(3D).
		 * 
		 * @param	xs	x coordinates
		 * @param	ys	y coordinates
		 * @param	zs	z coordinates
		 */
		/*
		public static function mags3d( xs:Array, ys:Array, zs:Array ):Array
		{
			if ( xs.length != ys.length || xs.length != zs.length )
				throw new ArgumentError("値の数が異なります");
			
			var size:uint = xs.length;
			var res:Array = new Array( size );
			for ( var i:int = 0 ; i < size ; i++ )
				res[i] = mag3d( xs[i], ys[i], zs[i] );
			return res;
		}
		*/
		
		/**
		 * 距離をまとめて計算します.
		 * @param	bx	base x
		 * @param	by	base y
		 * @param	xs	x coordinates
		 * @param	ys	y coordinates
		 */
		/*
		public static function dists( bx:Number, by:Number, xs:Array, ys:Array ):Array
		{
			if ( xs.length != ys.length )
				throw new ArgumentError("値の数が異なります");
			
			var xi:Number;
			var yi:Number;
			var size:uint = xs.length;
			var res:Array = new Array( size );
			for ( var i:int = 0 ; i < size ; i++ )
			{
				xi = xs[i] - bx;
				yi = ys[i] - by;
				res[i] = Math.sqrt( xi * xi + yi * yi );
			}
			return res;
		}
		*/
		/**
		 * 距離をまとめて計算します(3D).
		 */
		/*
		public static function dists3d( bx:Number, by:Number, bz:Number, xs:Array, ys:Array, zs:Array ):Array
		{
			if ( xs.length != ys.length || xs.length != zs.length )
				throw new ArgumentError("値の数が異なります");
			
			var xi:Number;
			var yi:Number;
			var zi:Number;
			var size:uint = xs.length;
			var res:Array = new Array( size );
			for ( var i:int = 0 ; i < size ; i++ )
			{
				xi = xs[i] - bx;
				yi = ys[i] - by;
				zi = zs[i] - bz;
				res[i] = Math.sqrt( xi * xi + yi * yi + zi * zi );
			}
			return res;
		}
		*/
		
		/**
		 * 距離を計算します(N次元).
		 */
		/*
		public static function distNd( values:Array, baseValues:Array=null ):Number
		{
			var m:Number = 0;
			var n:uint   = values.length;
			var i:int;
			if ( baseValues )
			{
				if ( baseValues.length != n )
					throw new ArgumentError("値の数が異なります");
				
				var mi:Number;
				for ( i = 0; i < n; i++ )
				{
					mi = values[i] - baseValues[i];
					m += mi * mi;
				}
			}
			else
			{
				for ( i = 0; i < n; i++ )
					m += values[i] * values[i];
			}
			return Math.sqrt( m );
		}
		*/
	}

}
