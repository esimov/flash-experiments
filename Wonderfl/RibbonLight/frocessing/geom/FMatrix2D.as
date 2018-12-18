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

package frocessing.geom {
	
	import flash.geom.Matrix;
	
	/**
	* FMatrix2D クラスは flash.geom.Matrix の拡張クラスです.
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FMatrix2D extends FMatrix
	{	
		/**
		 a , b , 0
		 c , d , 0
		 tx, ty, 1
		 */
	
		/**
		 * 新しく FMatrix2D インスタンスを生成します.
		 */
		public function FMatrix2D( a:Number=1.0, b:Number=0.0, c:Number=0.0, d:Number=1.0, tx:Number=0.0, ty:Number=0.0 )
		{
			super( a, b, c, d, tx, ty );
		}
		
		/**
		* クローンを生成します.
		*/
		override public function clone():Matrix
		{
			return new FMatrix2D( a, b, c, d, tx, ty );
		}
		
		/**
		 * 同じ行列かチェックします.
		 */
		public function equals(m:Matrix):Boolean
		{
			return ( a==m.a   && b==m.b && c==m.c && d==m.d && tx==m.tx && ty==m.ty );
		}
		
		//---------------------------------------------------------------------------------------------------PREPEND
		
		/**
		 * prepend matrix.
		 * @param	mtx		matrix
		 */
		public function prepend( mtx:Matrix ):void
		{
			var n11:Number = mtx.a * a + mtx.b * c;
			var n12:Number = mtx.a * b + mtx.b * d;
			var n21:Number = mtx.c * a + mtx.d * c; 
			var n22:Number = mtx.c * b + mtx.d * d;
			var n31:Number = mtx.tx * a + mtx.ty * c + tx; 
			var n32:Number = mtx.tx * b + mtx.ty * d + ty;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		/**
		 * prepend scale matrix.
		 * @param	sx	scaleX
		 * @param	sy	scaleY
		 */
		public function prependScale( sx:Number, sy:Number ):void
		{
			//sx,0,0,sx,0,0
			a *= sx;
			b *= sx;
			c *= sy;
			d *= sy;
		}
		
		/**
		 * prepend translate matrix.
		 * @param	x	translate x
		 * @param	y	translate y
		 */
		public function prependTranslation( x:Number, y:Number ):void
		{
			//1,0,0,1,x,y
			tx += x * a + y * c;
			ty += x * b + y * d;
		}
		
		/**
		 * prepend rotate matrix.
		 * @param	angle	rotate radian
		 */
		public function prependRotation( angle:Number ):void
		{
			//c, s, -s, c, 0, 0
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			var n11:Number = cos * a + sin * c;
			var n12:Number = cos * b + sin * d;
			var n21:Number = -sin * a + cos * c;
			var n22:Number = -sin * b + cos * d;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* 積の結果を、新しい FMatrix2D インスタンスで返します.
		*/
		public function product( mtx:Matrix ):FMatrix2D
		{
			return new FMatrix2D(
				a*mtx.a + b*mtx.c,
				a*mtx.b + b*mtx.d,
				c*mtx.a + d*mtx.c, 
				c*mtx.b + d*mtx.d,
				tx*mtx.a + ty*mtx.c + mtx.tx, 
				tx*mtx.b + ty*mtx.d + mtx.ty );
		}
		
		/**
		 * 積の結果を、新しい FMatrix2D インスタンスで返します.
		 */
		public function preProduct( mtx:Matrix ):FMatrix2D
		{			
			return new FMatrix2D(
				mtx.a * a + mtx.b * c,
				mtx.a * b + mtx.b * d,
				mtx.c * a + mtx.d * c, 
				mtx.c * b + mtx.d * d,
				mtx.tx * a + mtx.ty * c + tx, 
				mtx.tx * b + mtx.ty * d + ty );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/*
		* 加算の結果を、新しい FMatrix2D インスタンスで返します.
		
		public function add( mtx:Matrix ):FMatrix2D
		{
			return new FMatrix2D(
				a+mtx.a, b+mtx.b,
				c+mtx.c, d+mtx.d,
				tx+mtx.tx, ty+mtx.ty );
		} 
		*/
		
		/*
		* 減算の結果を、新しい FMatrix2D インスタンスで返します.
		
		public function subtract(mtx:Matrix):FMatrix2D 
		{
			return new FMatrix2D(
				a-mtx.a, b-mtx.b,
				c-mtx.c, d-mtx.d,
				tx-mtx.tx, ty-mtx.ty );
		}
		*/
		
		/*
		 * 乗算の結果を、新しい FMatrix2D インスタンスで返します.
		
		public function multi(m:Number):FMatrix2D
		{
			return new FMatrix2D(
				a*m, b*m,  
				c*m, d*m,  
				tx*m, ty*m );
		}
		 */
		
		/*
		* 行列値をオフセットします.
		
		public function offset(mtx:Matrix):void
		{
			a += mtx.a; b += mtx.b;
			c += mtx.c; d += mtx.d;
			tx += mtx.tx; ty += mtx.ty;
		}
		*/
		
		//---------------------------------------------------------------------------------------------------STATIC
		
		/**
		* create scale matrix.
		* @param	sx	scaleX
		* @param	sy	scaleY
		
		public static function scaleMatrix( sx:Number = 1.0, sy:Number = 1.0 ):FMatrix2D
		{
			return new FMatrix2D( sx, 0, 0, sy, 0, 0 );
		}
		*/
		
		/**
		* create translate matrix.
		* @param	tx	translate x
		* @param	ty	translate y
		
		public static function translateMatrix( tx:Number, ty:Number ):FMatrix2D
		{
			return new FMatrix2D( 1, 0, 0, 1, tx, ty );
		}
		*/
		
		/**
		* create rotate matrix.
		* @param	a	rotate radian
		
		public static function rotateMatrix( a:Number ):FMatrix2D
		{
			var s:Number = Math.sin(a);
			var c:Number = Math.cos(a);
			return new FMatrix2D( c, s, -s, c, 0, 0 );
		}
		*/
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* 
		*/
		override public function toString():String
		{
			return "[FMatrix2D ("+a+","+b+")("+c+","+d+")("+tx+","+ty+")]";
		}
	}
	
}