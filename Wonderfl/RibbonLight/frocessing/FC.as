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

package frocessing {
	
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	import frocessing.core.F5C;
	
	/**
	* Frocessing Constants.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FC {
		
		public static const VERSION:String = "0.6";
		
		public static const LINE_SCALE_MODE_NONE           :String = LineScaleMode.NONE;
		public static const LINE_SCALE_MODE_NORMAL         :String = LineScaleMode.NORMAL;
		public static const LINE_SCALE_MODE_HORIZONTAL     :String = LineScaleMode.HORIZONTAL;
		public static const LINE_SCALE_MODE_VERTICAL       :String = LineScaleMode.VERTICAL;
		
		public static const CAPS_STYLE_NONE                :String = CapsStyle.NONE;
		public static const CAPS_STYLE_ROUND               :String = CapsStyle.ROUND;
		public static const CAPS_STYLE_SQUARE              :String = CapsStyle.SQUARE;
		
		public static const JOINT_STYLE_BEVEL              :String = JointStyle.BEVEL;
		public static const JOINT_STYLE_MITER              :String = JointStyle.MITER;
		public static const JOINT_STYLE_ROUND              :String = JointStyle.ROUND;
		
		public static const GRADIENT_TYPE_LINEAR           :String = GradientType.LINEAR;
		public static const GRADIENT_TYPE_RADIAL           :String = GradientType.RADIAL;
		
		public static const SPREAD_METHOD_PAD              :String = SpreadMethod.PAD;
		public static const SPREAD_METHOD_REFLECT          :String = SpreadMethod.REFLECT;
		public static const SPREAD_METHOD_REPEAT           :String = SpreadMethod.REPEAT;
		
		public static const INTERPOLATION_METHOD_LINEAR_RGB:String = InterpolationMethod.LINEAR_RGB;
		public static const INTERPOLATION_METHOD_RGB       :String = InterpolationMethod.RGB;
		
		public static const RGB        :String = F5C.RGB;
		public static const HSB        :String = F5C.HSB;
		public static const HSV        :String = F5C.HSV;
		
		public static const CORNER        :int = F5C.CORNER;
		public static const CORNERS       :int = F5C.CORNERS;
		public static const RADIUS        :int = F5C.RADIUS;
		
		public static const CENTER        :int = F5C.CENTER;
		
		public static const LEFT    	  :int = F5C.LEFT;
		public static const RIGHT   	  :int = F5C.RIGHT;
		public static const BASELINE	  :int = F5C.BASELINE;
		public static const TOP     	  :int = F5C.TOP;
		public static const BOTTOM  	  :int = F5C.BOTTOM;
		
		public static const POINTS        :int = F5C.POINTS;
		public static const LINES         :int = F5C.LINES; 
		public static const TRIANGLES     :int = F5C.TRIANGLES;
		public static const TRIANGLE_FAN  :int = F5C.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = F5C.TRIANGLE_STRIP;
		public static const QUADS         :int = F5C.QUADS;
		public static const QUAD_STRIP    :int = F5C.QUAD_STRIP;
		
		public static const OPEN      :Boolean = F5C.OPEN;
		public static const CLOSE     :Boolean = F5C.CLOSE;
		
		public static const PI         :Number = Math.PI;
		public static const TWO_PI     :Number = Math.PI*2;
		public static const HALF_PI    :Number = Math.PI/2;
		public static const QUART_PI   :Number = Math.PI/4;
		
	}
	
}