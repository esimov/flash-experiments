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

package frocessing.math 
{
	
	/**
	 * Curve Functions
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class FCurveMath 
	{
		
		/**
		 * quadratic bezier function
		 * @param	a	first point on the curve
		 * @param	b	control point
		 * @param	c	second point on the curve
		 * @param	t	value [0,1]
		 */
		public static function qbezierPoint( a:Number, b:Number, c:Number, t:Number ):Number
		{
			//var tp:Number = 1.0 - t;
			//return a*tp*tp + 2*b*t*tp + c*t*t;
			return a + 2*(b-a)*t*(1-t) + (c-a)*t*t;
		}
		
		/**
		 * cubic bezier function
		 * @param	a	first point on the curve
		 * @param	b	first control point
		 * @param	c	second control point
		 * @param	d	second point on the curve
		 * @param	t	value [0,1]
		 */
		public static function bezierPoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			//var tp:Number = 1.0 - t;
			//return a*tp*tp*tp + 3*b*t*tp*tp + 3*c*t*t*tp + d*t*t*t;
			return a + 3*(b-a)*t*(1.0-t)*(1.0-t) + 3*(c-a)*t*t*(1.0-t) + (d-a)*t*t*t;
		}
		
		/**
		 * spline function 
		 * @param	a	first point on the curve
		 * @param	b	second point on the curve
		 * @param	c	third point on the curve
		 * @param	d	fourth point on the curve
		 * @param	t	value [0,1]
		 * @param	tightness	spline curve tightness
		 */
		public static function curvePoint( a:Number, b:Number, c:Number, d:Number, t:Number, tightness:Number=1.0 ):Number
		{
			var v0:Number = tightness*( c - a )*0.5;
			var v1:Number = tightness*( d - b )*0.5;
			return t*t*t*( 2*b - 2*c + v0 + v1 ) + t*t*( -3*b + 3*c - 2*v0 - v1 ) + v0*t + b;
		}
		
		/**
		 * diff of quadratic bezier function
		 * @param	a	first point on the curve
		 * @param	b	control point
		 * @param	c	second point on the curve
		 * @param	t	value [0,1]
		 */
		public static function qbezierTangent( a:Number, b:Number, c:Number, t:Number ):Number
		{
			return 2*( t*( a + c - 2*b ) - a + b );
		}
		
		/**
		 * diff of cubic bezier function
		 * @param	a	first point on the curve
		 * @param	b	first control point
		 * @param	c	second control point
		 * @param	d	second point on the curve
		 * @param	t	value [0,1]
		 */
		public static function bezierTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			return 3*(d-a-3*c+3*b)*t*t + 6*(a+c-2*b)*t - 3*a+3*b;
		}
		
		/**
		 * diff of spline function
		 * @param	a	first control point
		 * @param	b	first point on the curve
		 * @param	c	second point on the curve
		 * @param	d	second control point
		 * @param	t	value [0,1]
		 * @param	tightness	spline curve tightness
		 */
		public static function curveTangent( a:Number, b:Number, c:Number, d:Number, t:Number, tightness:Number=1.0 ):Number
		{
			var v0:Number = tightness*( c - a )*0.5;
			var v1:Number = tightness*( d - b )*0.5;
			return 3*t*t*( 2*b -2*c + v0 + v1) + 2*t*( 3*c - 3*b - v1 - 2*v0 ) + v0;
		}
		
	}
	
}