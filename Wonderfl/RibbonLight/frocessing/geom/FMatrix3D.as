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

	/**
	* FMatrix3D
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FMatrix3D {
		
		//変換行列 4x4 から4列目(0,0,0,1)を省略
		public var m11:Number;
		public var m12:Number;
		public var m13:Number;
		public var m21:Number;
		public var m22:Number;
		public var m23:Number;
		public var m31:Number;
		public var m32:Number;
		public var m33:Number;
		public var m41:Number;
		public var m42:Number;
		public var m43:Number;
		
		/**
		 * 新しく FMatrix3D インスタンスを生成します.
		 */
		public function FMatrix3D( m11_:Number=1.0, m12_:Number=0.0, m13_:Number=0.0,
								   m21_:Number=0.0, m22_:Number=1.0, m23_:Number=0.0,
								   m31_:Number=0.0, m32_:Number=0.0, m33_:Number=1.0,
								   m41_:Number=0.0, m42_:Number=0.0, m43_:Number=0.0 )
		{
			m11 = m11_; m12 = m12_; m13 = m13_;
			m21 = m21_; m22 = m22_; m23 = m23_;
			m31 = m31_; m32 = m32_; m33 = m33_;
			m41 = m41_; m42 = m42_; m43 = m43_;
		}
		
		/**
		 * 行列値を設定します.
		 */
		public function setMatrix( m11_:Number, m12_:Number, m13_:Number,
								   m21_:Number, m22_:Number, m23_:Number,
								   m31_:Number, m32_:Number, m33_:Number,
								   m41_:Number, m42_:Number, m43_:Number ):void
		{
			m11 = m11_; m12 = m12_; m13 = m13_;
			m21 = m21_; m22 = m22_; m23 = m23_;
			m31 = m31_; m32 = m32_; m33 = m33_;
			m41 = m41_; m42 = m42_; m43 = m43_;
		}
		
		/**
		 * 
		 */
		public function copyMatrix( mt:FMatrix3D ):void
		{
			m11 = mt.m11; m12 = mt.m12; m13 = mt.m13;
			m21 = mt.m21; m22 = mt.m22; m23 = mt.m23;
			m31 = mt.m31; m32 = mt.m32; m33 = mt.m33;
			m41 = mt.m41; m42 = mt.m42; m43 = mt.m43;
		}
		
		/**
		 * 
		 */
		public function identity():void
		{
			m11 = 1; m12 = 0; m13 = 0;
			m21 = 0; m22 = 1; m23 = 0;
			m31 = 0; m32 = 0; m33 = 1;
			m41 = 0; m42 = 0; m43 = 0;
		}
		
		/**
		* クローン
		*/
		public function clone():FMatrix3D
		{
			return new FMatrix3D(m11,m12,m13,m21,m22,m23,m31,m32,m33,m41,m42,m43);
		}
		
		/**
		 * 同じ行列かチェック
		 */
		public function equals(m:FMatrix3D):Boolean
		{
			return ( m11==m.m11 && m12==m.m12 && m13==m.m13 && 
					 m21==m.m21 && m22==m.m22 && m23==m.m23 && 
					 m31==m.m31 && m32==m.m32 && m33==m.m33 &&
					 m41==m.m41 && m42==m.m42 && m43==m.m43 );
		}
		
		/**
		* ベクトルの変換
		* @param	FNumber3D
		*/
		public function transform( v:FNumber3D ):FNumber3D
		{
			return new FNumber3D(
				m11*v.x + m21*v.y + m31*v.z + m41,
				m12*v.x + m22*v.y + m32*v.z + m42,
				m13*v.x + m23*v.y + m33*v.z + m43 );
		}
		
		//---------------------------------------------------------------------------------------------------INVERT
		
		/**
		 * 逆行列
		 */
		public function invert():void
		{
			var d:Number = m11*m22*m33 + m12*m23*m31 + m13*m21*m32 - m11*m23*m32 - m12*m21*m33 - m13*m22*m31;
			if ( d != 0 )
			{
				var n11:Number = (m22*m33 - m23*m32)/d;
				var n21:Number = (m23*m31 - m21*m33)/d;
				var n31:Number = (m21*m32 - m22*m31)/d;
				var n12:Number = (m13*m32 - m12*m33)/d;
				var n22:Number = (m11*m33 - m13*m31)/d;
				var n32:Number = (m12*m31 - m11*m32)/d;
				var n13:Number = (m12*m23 - m13*m22)/d;
				var n23:Number = (m13*m21 - m11*m23)/d;
				var n33:Number = (m11*m22 - m12*m21)/d;
				var n41:Number = (-m21*m32*m43+m22*m31*m43+m21*m33*m42-m23*m31*m42-m22*m33*m41+m23*m32*m41)/d;
				var n42:Number = (m11*m32*m43-m12*m31*m43-m11*m33*m42+m13*m31*m42+m12*m33*m41-m13*m32*m41)/d; 
				var n43:Number = (-m11*m22*m43+m12*m21*m43+m11*m23*m42-m13*m21*m42-m12*m23*m41+m13*m22*m41)/d;
				setMatrix( n11, n12, n13, n21, n22, n23, n31, n32, n33, n41, n42, n43 );
				//identity();
				//appendTranslation( -m41, -m42, -m43 );
				//appendMatrix( n11, n12, n13, n21, n22, n23, n31, n32, n33, 0, 0, 0 );
			}
			else
			{
				new Error( "can not make invert matrix." );
			}
		}
		
		//---------------------------------------------------------------------------------------------------PREPEND
		
		/**
		 * 現在の行列の前に、指定の行列を product します.
		 */
		public function prepend( mtx:FMatrix3D ):void
		{
			var n11:Number = mtx.m11 * m11 + mtx.m12 * m21 + mtx.m13 * m31;
			var n12:Number = mtx.m11 * m12 + mtx.m12 * m22 + mtx.m13 * m32; 
			var n13:Number = mtx.m11 * m13 + mtx.m12 * m23 + mtx.m13 * m33;
			var n21:Number = mtx.m21 * m11 + mtx.m22 * m21 + mtx.m23 * m31; 
			var n22:Number = mtx.m21 * m12 + mtx.m22 * m22 + mtx.m23 * m32; 
			var n23:Number = mtx.m21 * m13 + mtx.m22 * m23 + mtx.m23 * m33;
			var n31:Number = mtx.m31 * m11 + mtx.m32 * m21 + mtx.m33 * m31; 
			var n32:Number = mtx.m31 * m12 + mtx.m32 * m22 + mtx.m33 * m32; 
			var n33:Number = mtx.m31 * m13 + mtx.m32 * m23 + mtx.m33 * m33;
			var n41:Number = mtx.m41 * m11 + mtx.m42 * m21 + mtx.m43 * m31 + m41; 
			var n42:Number = mtx.m41 * m12 + mtx.m42 * m22 + mtx.m43 * m32 + m42; 
			var n43:Number = mtx.m41 * m13 + mtx.m42 * m23 + mtx.m43 * m33 + m43;
			m11 = n11; m12 = n12; m13 = n13;
			m21 = n21; m22 = n22; m23 = n23;
			m31 = n31; m32 = n32; m33 = n33;
			m41 = n41; m42 = n42; m43 = n43;
		}
		
		/**
		 * 現在の行列の前に、指定の行列を product します.
		 */
		public function prependMatrix( t11:Number, t12:Number, t13:Number,
									   t21:Number, t22:Number, t23:Number,
									   t31:Number, t32:Number, t33:Number,
									   t41:Number, t42:Number, t43:Number ):void
		{
			var n11:Number = t11 * m11 + t12 * m21 + t13 * m31;
			var n12:Number = t11 * m12 + t12 * m22 + t13 * m32; 
			var n13:Number = t11 * m13 + t12 * m23 + t13 * m33;
			var n21:Number = t21 * m11 + t22 * m21 + t23 * m31; 
			var n22:Number = t21 * m12 + t22 * m22 + t23 * m32; 
			var n23:Number = t21 * m13 + t22 * m23 + t23 * m33;
			var n31:Number = t31 * m11 + t32 * m21 + t33 * m31; 
			var n32:Number = t31 * m12 + t32 * m22 + t33 * m32; 
			var n33:Number = t31 * m13 + t32 * m23 + t33 * m33;
			var n41:Number = t41 * m11 + t42 * m21 + t43 * m31 + m41; 
			var n42:Number = t41 * m12 + t42 * m22 + t43 * m32 + m42; 
			var n43:Number = t41 * m13 + t42 * m23 + t43 * m33 + m43;
			m11 = n11; m12 = n12; m13 = n13;
			m21 = n21; m22 = n22; m23 = n23;
			m31 = n31; m32 = n32; m33 = n33;
			m41 = n41; m42 = n42; m43 = n43;
		}
		
		/**
		 * 
		 * @param	sx
		 * @param	sy
		 * @param	sz
		 */
		public function prependScale( sx:Number, sy:Number, sz:Number ):void
		{
			//sx,0,0, 0,sy,0, 0,0,sz
			m11 *= sx;
			m12 *= sx;
			m13 *= sx;
			m21 *= sy;
			m22 *= sy;
			m23 *= sy;
			m31 *= sz;
			m32 *= sz;
			m33 *= sz;
		}
		
		/**
		 * 
		 * @param	tx
		 * @param	ty
		 * @param	ty
		 */
		public function prependTranslation( tx:Number, ty:Number, tz:Number ):void
		{
			//1,0,0, 0,1,0, 0,0,1, tx,ty,tz
			m41 += tx * m11 + ty * m21 + tz * m31;
			m42 += tx * m12 + ty * m22 + tz * m32;
			m43 += tx * m13 + ty * m23 + tz * m33;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function prependRotationX( angle:Number ):void
		{
			//1,0,0, 0,c,-s, 0,s,c
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n21:Number = c * m21 - s * m31; 
			var n22:Number = c * m22 - s * m32; 
			var n23:Number = c * m23 - s * m33;
			var n31:Number = s * m21 + c * m31; 
			var n32:Number = s * m22 + c * m32; 
			var n33:Number = s * m23 + c * m33;
			m21 = n21; m22 = n22; m23 = n23;
			m31 = n31; m32 = n32; m33 = n33;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function prependRotationY( angle:Number ):void
		{
			//c,0,s, 0,1,0, -s,0,c
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n11:Number =  c * m11 + s * m31;
			var n12:Number =  c * m12 + s * m32; 
			var n13:Number =  c * m13 + s * m33;
			var n31:Number = -s * m11 + c * m31; 
			var n32:Number = -s * m12 + c * m32; 
			var n33:Number = -s * m13 + c * m33;
			m11 = n11; m12 = n12; m13 = n13;
			m31 = n31; m32 = n32; m33 = n33;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function prependRotationZ( angle:Number ):void
		{
			//c,-s,0, s,c,0, 0,0,1
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n11:Number = c * m11 - s * m21;
			var n12:Number = c * m12 - s * m22; 
			var n13:Number = c * m13 - s * m23;
			var n21:Number = s * m11 + c * m21; 
			var n22:Number = s * m12 + c * m22; 
			var n23:Number = s * m13 + c * m23;
			m11 = n11; m12 = n12; m13 = n13;
			m21 = n21; m22 = n22; m23 = n23;
		}
		
		//---------------------------------------------------------------------------------------------------APPEND
		
		/**
		 * 現在の行列に、指定の行列を product します.
		 */
		public function append( mtx:FMatrix3D ):void
		{
			var n11:Number = m11 * mtx.m11 + m12 * mtx.m21 + m13 * mtx.m31;
			var n12:Number = m11 * mtx.m12 + m12 * mtx.m22 + m13 * mtx.m32; 
			var n13:Number = m11 * mtx.m13 + m12 * mtx.m23 + m13 * mtx.m33;
			var n21:Number = m21 * mtx.m11 + m22 * mtx.m21 + m23 * mtx.m31; 
			var n22:Number = m21 * mtx.m12 + m22 * mtx.m22 + m23 * mtx.m32; 
			var n23:Number = m21 * mtx.m13 + m22 * mtx.m23 + m23 * mtx.m33;
			var n31:Number = m31 * mtx.m11 + m32 * mtx.m21 + m33 * mtx.m31; 
			var n32:Number = m31 * mtx.m12 + m32 * mtx.m22 + m33 * mtx.m32; 
			var n33:Number = m31 * mtx.m13 + m32 * mtx.m23 + m33 * mtx.m33;
			var n41:Number = m41 * mtx.m11 + m42 * mtx.m21 + m43 * mtx.m31 + mtx.m41; 
			var n42:Number = m41 * mtx.m12 + m42 * mtx.m22 + m43 * mtx.m32 + mtx.m42; 
			var n43:Number = m41 * mtx.m13 + m42 * mtx.m23 + m43 * mtx.m33 + mtx.m43;
			m11 = n11; m12 = n12; m13 = n13;
			m21 = n21; m22 = n22; m23 = n23;
			m31 = n31; m32 = n32; m33 = n33;
			m41 = n41; m42 = n42; m43 = n43;
		}
		
		/**
		 * 現在の行列に、指定の行列を product します.
		 */
		public function appendMatrix( t11:Number, t12:Number, t13:Number,
									  t21:Number, t22:Number, t23:Number,
									  t31:Number, t32:Number, t33:Number,
									  t41:Number, t42:Number, t43:Number ):void
		{
			var n11:Number = m11 * t11 + m12 * t21 + m13 * t31;
			var n12:Number = m11 * t12 + m12 * t22 + m13 * t32; 
			var n13:Number = m11 * t13 + m12 * t23 + m13 * t33;
			var n21:Number = m21 * t11 + m22 * t21 + m23 * t31; 
			var n22:Number = m21 * t12 + m22 * t22 + m23 * t32; 
			var n23:Number = m21 * t13 + m22 * t23 + m23 * t33;
			var n31:Number = m31 * t11 + m32 * t21 + m33 * t31; 
			var n32:Number = m31 * t12 + m32 * t22 + m33 * t32; 
			var n33:Number = m31 * t13 + m32 * t23 + m33 * t33;
			var n41:Number = m41 * t11 + m42 * t21 + m43 * t31 + t41; 
			var n42:Number = m41 * t12 + m42 * t22 + m43 * t32 + t42; 
			var n43:Number = m41 * t13 + m42 * t23 + m43 * t33 + t43;
			m11 = n11; m12 = n12; m13 = n13;
			m21 = n21; m22 = n22; m23 = n23;
			m31 = n31; m32 = n32; m33 = n33;
			m41 = n41; m42 = n42; m43 = n43;
		}
		
		/**
		 * 
		 * @param	sx
		 * @param	sy
		 * @param	sz
		 */
		public function appendScale( sx:Number, sy:Number, sz:Number ):void
		{
			//sx,0,0, 0,sy,0, 0,0,sz
			m11 *= sx;
			m12 *= sy;
			m13 *= sz;
			m21 *= sx;
			m22 *= sy;
			m23 *= sz;
			m31 *= sx;
			m32 *= sy;
			m33 *= sz;
			m41 *= sx;
			m42 *= sy;
			m43 *= sz;
		}
		
		/**
		 * 
		 * @param	tx
		 * @param	ty
		 * @param	tz
		 */
		public function appendTranslation( tx:Number, ty:Number, tz:Number ):void
		{
			//1,0,0, 0,1,0, 0,0,1, tx,ty,tz
			m41 += tx;
			m42 += ty;
			m43 += tz;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function appendRotationX( angle:Number ):void
		{
			//1,0,0, 0,c,-s, 0,s,c
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n12:Number =  m12 * c + m13 * s; 
			var n13:Number = -m12 * s + m13 * c;
			var n22:Number =  m22 * c + m23 * s;
			var n23:Number = -m22 * s + m23 * c;
			var n32:Number =  m32 * c + m33 * s;
			var n33:Number = -m32 * s + m33 * c;
			var n42:Number =  m42 * c + m43 * s; 
			var n43:Number = -m42 * s + m43 * c;
			m12 = n12; m13 = n13;
			m22 = n22; m23 = n23;
			m32 = n32; m33 = n33;
			m42 = n42; m43 = n43;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function appendRotationY( angle:Number ):void
		{
			//c,0,s, 0,1,0, -s,0,c
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n11:Number = m11 * c - m13 * s;
			var n13:Number = m11 * s + m13 * c;
			var n21:Number = m21 * c - m23 * s;
			var n23:Number = m21 * s + m23 * c;
			var n31:Number = m31 * c - m33 * s;
			var n33:Number = m31 * s + m33 * c;
			var n41:Number = m41 * c - m43 * s;
			var n43:Number = m41 * s + m43 * c;
			m11 = n11; m13 = n13;
			m21 = n21; m23 = n23;
			m31 = n31; m33 = n33;
			m41 = n41; m43 = n43;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function appendRotationZ( angle:Number ):void
		{
			//c,-s,0, s,c,0, 0,0,1
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var n11:Number =  m11 * c + m12 * s;
			var n12:Number = -m11 * s + m12 * c;
			var n21:Number =  m21 * c + m22 * s; 
			var n22:Number = -m21 * s + m22 * c;
			var n31:Number =  m31 * c + m32 * s; 
			var n32:Number = -m31 * s + m32 * c;
			var n41:Number =  m41 * c + m42 * s; 
			var n42:Number = -m41 * s + m42 * c; 
			m11 = n11; m12 = n12;
			m21 = n21; m22 = n22;
			m31 = n31; m32 = n32;
			m41 = n41; m42 = n42;
		}
		
		public function appendRotation( ux:Number, uy:Number, uz:Number, angle:Number ):void
		{
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var d:Number = Math.sqrt( ux * ux + uy * uy + uz * uz );
			ux /= d;
			uy /= d;
			uz /= d;
			appendMatrix(
				c - ux * ux * c + ux * ux,
				-uz * s - ux * uy * c + ux * uy,
				uy * s - ux * uz * c + ux * uz,
				uz * s - ux * uy * c + ux * uy,
				c - uy * uy * c + uy * uy,
				-ux * s - uy * uz * c + uy * uz,
				-uy * s - ux * uz * c + ux * uz,
				ux * s - uy * uz * c + uy * uz, 
				c - uz * uz * c + uz * uz,
				0, 0, 0 );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* 積
		* @param	FMatrix3D
		* @return	FMatrix3D
		*/
		public function product(mtx:FMatrix3D):FMatrix3D
		{
			return new FMatrix3D(
				m11*mtx.m11 + m12*mtx.m21 + m13*mtx.m31, 
				m11*mtx.m12 + m12*mtx.m22 + m13*mtx.m32, 
				m11*mtx.m13 + m12*mtx.m23 + m13*mtx.m33,
				m21*mtx.m11 + m22*mtx.m21 + m23*mtx.m31, 
				m21*mtx.m12 + m22*mtx.m22 + m23*mtx.m32, 
				m21*mtx.m13 + m22*mtx.m23 + m23*mtx.m33,
				m31*mtx.m11 + m32*mtx.m21 + m33*mtx.m31, 
				m31*mtx.m12 + m32*mtx.m22 + m33*mtx.m32, 
				m31*mtx.m13 + m32*mtx.m23 + m33*mtx.m33,
				m41*mtx.m11 + m42*mtx.m21 + m43*mtx.m31 + mtx.m41, 
				m41*mtx.m12 + m42*mtx.m22 + m43*mtx.m32 + mtx.m42, 
				m41*mtx.m13 + m42*mtx.m23 + m43*mtx.m33 + mtx.m43);
		}
		
		//---------------------------------------------------------------------------------------------------STATIC
		
		/**
		* Scale変換行列
		* @param	scaleX
		* @param	scaleY
		* @param	scaleZ
		* @return	
		*/
		public static function scale( sx:Number=1.0, sy:Number=1.0, sz:Number=1.0 ):FMatrix3D
		{
			return new FMatrix3D( sx,0,0, 0,sy,0, 0,0,sz );
		}
		
		/**
		* 移動変換行列
		* @param	translateX
		* @param	translateY
		* @param	translateZ
		* @return
		*/
		public static function translate( tx:Number, ty:Number, tz:Number):FMatrix3D
		{
			return new FMatrix3D( 1,0,0, 0,1,0, 0,0,1, tx,ty,tz );
		}
		
		/**
		* 回転行列　X軸回転
		* @param	radian
		* @return	FMatrix3D
		*/
		public static function rotateX( a:Number ):FMatrix3D
		{
			var s:Number = Math.sin(a);
			var c:Number = Math.cos(a);
			return new FMatrix3D( 1,0,0, 0,c,-s, 0,s,c );
		}
		
		/**
		* 回転行列　Y軸回転
		* @param	radian
		* @return	FMatrix3D
		*/
		public static function rotateY( a:Number ):FMatrix3D
		{
			var s:Number = Math.sin(a);
			var c:Number = Math.cos(a);
			return new FMatrix3D( c,0,s, 0,1,0, -s,0,c );
		}
		
		/**
		* 回転行列　Z軸回転
		* @param	radian
		* @return	FMatrix3D
		*/
		public static function rotateZ( a:Number ):FMatrix3D
		{
			var s:Number = Math.sin(a);
			var c:Number = Math.cos(a);
			return new FMatrix3D( c,-s,0, s,c,0, 0,0,1 );
		}
		
		/**
		 * 任意軸回転
		 * @param	axis
		 * @param	t
		 * @return
		 */
		public static function rotateAxis( u:FVector, a:Number ):FMatrix3D
		{
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			u.normalize(1.0);
			var ux:Number = u.x;
			var uy:Number = u.y;
			var uz:Number = u.z;
			return new FMatrix3D(
				cos-ux*ux*cos+ux*ux, -uz*sin-ux*uy*cos+ux*uy, uy*sin-ux*uz*cos+ux*uz,
				uz*sin-ux*uy*cos+ux*uy, cos-uy*uy*cos+uy*uy, -ux*sin-uy*uz*cos+uy*uz,
				-uy*sin-ux*uz*cos+ux*uz, ux*sin-uy*uz*cos+uy*uz, cos-uz*uz*cos+uz*uz );
		}
		
		/**
		 * 任意軸への投射ベクトル変換
		 * @param	u	軸ベクトル
		 * @return	FMatrix3D
		 */
		/*
		public static function dotMatrix( u:FVector ):FMatrix3D{
			return new FMatrix3D( u.x*u.x,u.x*u.y,u.x*u.z, u.y*u.x,u.y*u.y,u.y*u.z, u.z*u.x,u.z*u.y,u.z*u.z );
		}
		*/
		
		/**
		 * 任意軸との法線ベクトル変換
		 * @param	u	軸ベクトル
		 * @return	FVector
		 */
		/*
		public static function crossMatrix( u:FVector ):FMatrix3D{
			return new FMatrix3D( 0,-u.z,u.y, u.z,0,-u.x, -u.y,u.x,0 );
		}
		*/
		
		//---------------------------------------------------------------------------------------------------
		
		/*
		public function add(mtx:FMatrix3D):FMatrix3D
		{
			return new FMatrix3D(
				m11+mtx.m11, m12+mtx.m12, m13+mtx.m13,
				m21+mtx.m21, m22+mtx.m22, m23+mtx.m23,
				m31+mtx.m31, m32+mtx.m32, m33+mtx.m33,
				m41+mtx.m41, m42+mtx.m42, m43+mtx.m43);
		}
		
		public function subtract(mtx:FMatrix3D):FMatrix3D
		{
			return new FMatrix3D(
				m11-mtx.m11, m12-mtx.m12, m13-mtx.m13,
				m21-mtx.m21, m22-mtx.m22, m23-mtx.m23,
				m31-mtx.m31, m32-mtx.m32, m33-mtx.m33,
				m41-mtx.m41, m42-mtx.m42, m43-mtx.m43);
		}
		
		public function multi(m:Number):FMatrix3D
		{
			return new FMatrix3D(
				m11*m, m12*m, m13*m, 
				m21*m, m22*m, m23*m, 
				m31*m, m32*m, m33*m,  
				m41*m, m42*m, m43*m);
		}
		
		public function offset(mtx:FMatrix3D):void
		{
			m11 += mtx.m11; m12 += mtx.m12; m13 += mtx.m13;
			m21 += mtx.m21; m22 += mtx.m22; m23 += mtx.m23;
			m31 += mtx.m31; m32 += mtx.m32; m33 += mtx.m33;
			m41 += mtx.m41; m42 += mtx.m42; m43 += mtx.m43;
		}
		*/
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* toString
		* @return	String
		*/
		public function toString():String
		{
			return "[FMatrix3D ("+m11+","+m12+","+m13+")("+m21+","+m22+","+m23+")("+m31+","+m32+","+m33+")("+m41+","+m42+","+m43+")]";
		}
	}
}
