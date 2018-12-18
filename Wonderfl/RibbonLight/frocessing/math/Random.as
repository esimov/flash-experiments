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

package frocessing.math{

	/**
	* 乱数を生成するメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.1.2
	*/
	public class Random 
	{
		private static var normal_flg:Boolean = false;
		private static var normal_tmp:Number;
		
		/**
		 * 指定された数の乱数(0～1)を生成します.
		 * 
		 * @param	size	乱数の数
		 * @return	Number[]
		 */
		public static function randoms( size:uint ):Array
		{
			var result:Array = new Array(size);
			for( var i:uint=0; i<size; i++ )
				result[i] = Math.random();
			return result;
		}
		
		//--------------------------------------------------------------------------------------------------- NORMAL
		
		/**
		 * 期待値 0 分散 1 の正規乱数を生成します.
		 */
		public static function normal():Number
		{
			if ( normal_flg = !normal_flg )
			{
				var u1:Number = Math.sqrt( -2.0*Math.log( Math.random() ) );
				var u2:Number = 2.0*Math.PI*Math.random();
				normal_tmp = u1*Math.sin(u2);
				return u1*Math.cos(u2);
			}
			else
			{
				return normal_tmp;
			}
		}
		
		/**
		 * 正規乱数の集合を生成します.
		 *	
		 * @param	size	サンプル数
		 * @param	e		期待値(平均値)
		 * @param	sigma	標準偏差
		 * @return Array	Number[]
		 */
		public static function normals( size:uint, e:Number=0.0, sigma:Number=1.0 ):Array
		{
			var result:Array = new Array(size);
			var i:int;
			var p:Number = 2.0*Math.PI;
			for ( i=1; i<size; i+=2 ){
				var u1:Number    = Math.sqrt( -2.0*Math.log( Math.random() ) )*sigma;
				var u2:Number    = p*Math.random();
				result[i]        = u1*Math.cos(u2) + e;
				result[int(i-1)] = u1*Math.sin(u2) + e;
			}
			if( i==size )	
				result[int(size-1)] = Math.sqrt( -2.0*Math.log( Math.random() ) ) * Math.cos( p*Math.random() ) * sigma + e;
			
			return result;
		}
		
		//--------------------------------------------------------------------------------------------------- EXPO
		
		/**
		 * 指数乱数を生成します.
		 * f(x) = a*e^-a*x
		 * 
		 * @param	alpha	alpha>0
		 * @return	Number
		 */
		public static function expo( a:Number ):Number
		{
			if( a<=0 )
				throw( new ArgumentError( "a > 0" ) );
			return -Math.log(1.0-Math.random())/a;
		}
		
		/**
		 *　指数乱数の集合を生成します.
		 * 
		 *　@param	size	サンプル数
		 *　@param	a		a>0
		 *　@return	Number[]
		 */
		public static function expos( size:uint, a:Number ):Array
		{
			if( a<=0 )
				throw( new ArgumentError( "a > 0" ) );
			var result:Array = new Array(size);
			for (var i:uint=0; i<size; i++)
				result[i] = -Math.log(1.0-Math.random())/a ;
			return result;
		}
	
		//--------------------------------------------------------------------------------------------------- INTEGER
		
		/**
		 * 整数の乱数を生成します.
		 * 
		 * @param	range	数値幅
		 * @return	0～range
		 */
		public static function integer( range:int ):int
		{
			range += ( range>0 ) ? 1 : -1;
			return Math.floor( Math.random()*range );
		}
	
		/**
		 * 整数の乱数の集合を生成します.
		 * 
		 * @param	size	サンプル数
		 * @param	min		最小値
		 * @param	max		最大値
		 * @return			int[]
		 */
		public static function integers( size:uint, min:int, max:int ):Array
		{
			if( max<min )
			{
				var tmp:int = min;
				min = max;
				max = tmp;
			}
			var result:Array = new Array(size);
			var range:int    = max-min;
			for( var i:int=0; i<size; i++ ) result[i] = integer(range)+min;
			return result;
		}
	
		/**
		 * 重複なしの整数の乱数の集合を生成します.
		 * 
		 * @param	size	サンプル数
		 * @param	min		最小値
		 * @param	max		最大値
		 * @return			int[]
		 */
		public static function uniqueIntegers( size:uint, min:int, max:int ):Array
		{
			if( max<min )
			{
				var tmp:int = min;
				min = max;
				max = tmp;
			}
			var range:int    = max - min;
			if ( range < size )
				throw new Error("指定の幅がサイズより小さい");
			
			var result:Array = [];
			for( var i:int=0; i<size; i++ )
			{
				var n:int = integer(range)+min;
				if( result.indexOf(n)==-1 )
					result.push( n );
				else
					i--;
			}
			return result;
		}
		
		/**
		 * Arrayのデータをランダムに入れ替えます
		 * 
		 * @param	data
		 */
		public static function shake( data:Array ):Array
		{
			var len:int = data.length;
			var indexes:Array = new Array(len);
			for ( var i:int = 0; i < len; i++ )
				indexes[i] = i;
			
			var rslt:Array = [];
			while ( len > 0 )
			{
				var k:int = Math.floor(Math.random()*len);
				rslt.push( data[indexes[k]] );
				indexes.splice( k, 1 );
				len--;
			}
			return rslt;			
		}
	
		/**
		 * 0 から size-1 までの整数をランダムに並べた配列を生成します
		 * 
		 * @param	size
		 */
		public static function shakedIntegers( size:int ):Array
		{
			var len:int = size;
			var indexes:Array = new Array(len);
			for ( var i:int = 0; i < len; i++ )
				indexes[i] = i;
			
			var rslt:Array = [];
			while ( len > 0 )
			{
				var k:int = Math.floor(Math.random()*len);
				rslt.push( indexes[k] );
				indexes.splice( k, 1 );
				len--;
			}
			return rslt;
		}
		
		//--------------------------------------------------------------------------------------------------- COR
		
		/**
		 *	相関係数ありの正規乱数の集合を生成します.
		 *	@param size  サンプル数
		 *	@param cor	 相関係数 0.0 to 1.0
		 *	@param e     期待値
		 *	@param sigma 標準偏差
		 *	@return Number[]
		 */
		public static function cor( size:uint, co:Number, e:Number = 0.0, sigma:Number = 1.0 ):Array
		{
			var res1:Array = new Array(size);
			var res2:Array = new Array(size);
			var	xs:Array = normals(size ,e ,sigma);
			var	ys:Array = normals(size ,e ,sigma);
			var ck:Number = Math.sqrt(1.0-co*co);
			for( var i:int=0;i<size;i++){
				res1[i] = xs[i];
				res2[i] = co*xs[i] + ck*ys[i];
			}
			return [res1,res2];
		}
		
	}

}
