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

package frocessing.geom 
{
	/**
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class NumberMatrix3D 
	{
		public var m11:Number;
		public var m12:Number;
		public var m13:Number;
		public var m21:Number
		public var m22:Number;
		public var m23:Number;
		public var m31:Number;
		public var m32:Number;
		public var m33:Number;
		public var m41:Number;
		public var m42:Number;
		public var m43:Number;
		public function NumberMatrix3D( n11:Number, n12:Number, n13:Number, n21:Number, n22:Number, n23:Number, n31:Number, n32:Number, n33:Number, n41:Number, n42:Number, n43:Number ) {
			m11 = n11; m12 = n12; m13 = n13; m21 = n21; m22 = n22; m23 = n23; m31 = n31; m32 = n32; m33 = n33; m41 = n41; m42 = n42; m43 = n43;
		}
		
	}
	
}