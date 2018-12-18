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

package frocessing.f3d 
{
	import frocessing.core.canvas.ICanvas3D;
	import frocessing.geom.FTransform3D;
	import frocessing.geom.FMatrix3D;
	
	/**
	* Abstract 3D Object
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DObject extends FTransform3D
	{
		//id
		private var _name:String;
		
		public var userData:Object;
		
		/** @private */
		protected var m11:Number;
		/** @private */
		protected var m12:Number;
		/** @private */
		protected var m13:Number;
		/** @private */
		protected var m21:Number;
		/** @private */
		protected var m22:Number;
		/** @private */
		protected var m23:Number;
		/** @private */
		protected var m31:Number;
		/** @private */
		protected var m32:Number;
		/** @private */
		protected var m33:Number;
		/** @private */
		protected var m41:Number;
		/** @private */
		protected var m42:Number;
		/** @private */
		protected var m43:Number;		
		/**
		 * 
		 */
		public function F3DObject( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			userData = { };
		}
		
		/**
		 * 
		 */
		public function get name():String{ return _name;  }
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		/**
		 * 
		 * @param	mtx
		 */
		public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
								         m21_:Number, m22_:Number, m23_:Number,
								         m31_:Number, m32_:Number, m33_:Number,
								         m41_:Number, m42_:Number, m43_:Number ):void
		{
			var mt0:FMatrix3D = matrix;
			m11 = mt0.m11 * m11_ + mt0.m12 * m21_ + mt0.m13 * m31_;
			m12 = mt0.m11 * m12_ + mt0.m12 * m22_ + mt0.m13 * m32_; 
			m13 = mt0.m11 * m13_ + mt0.m12 * m23_ + mt0.m13 * m33_;
			m21 = mt0.m21 * m11_ + mt0.m22 * m21_ + mt0.m23 * m31_; 
			m22 = mt0.m21 * m12_ + mt0.m22 * m22_ + mt0.m23 * m32_; 
			m23 = mt0.m21 * m13_ + mt0.m22 * m23_ + mt0.m23 * m33_;
			m31 = mt0.m31 * m11_ + mt0.m32 * m21_ + mt0.m33 * m31_;
			m32 = mt0.m31 * m12_ + mt0.m32 * m22_ + mt0.m33 * m32_;
			m33 = mt0.m31 * m13_ + mt0.m32 * m23_ + mt0.m33 * m33_;
			m41 = mt0.m41 * m11_ + mt0.m42 * m21_ + mt0.m43 * m31_ + m41_;
			m42 = mt0.m41 * m12_ + mt0.m42 * m22_ + mt0.m43 * m32_ + m42_;
			m43 = mt0.m41 * m13_ + mt0.m42 * m23_ + mt0.m43 * m33_ + m43_;
		}
		
		/**
		 * 
		 */
		public function draw( g:ICanvas3D ):void
		{
			;
		}
	}
	
}