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

package frocessing.core {
	
	/**
	* Frocessing Constants
	* 
	* @author nutsu
	* @version 0.5
	*/
	public class F5C 
	{
		public static const RGB        :String = "rgb";
		public static const HSB        :String = "hsv";
		public static const HSV		   :String = "hsv";
		
		// Rect Ellipse Image Mode
		public static const CORNER        :int = 0;
		public static const CORNERS       :int = 1;
		public static const RADIUS        :int = 2;
		public static const CENTER        :int = 3;
		
		// Text Align
		public static const LEFT    	  :int = 37;
		public static const RIGHT   	  :int = 39;
		
		// Text y align
		public static const BASELINE	  :int = 0;
		public static const TOP     	  :int = 101;
		public static const BOTTOM  	  :int = 102;
		
		// Vertex Mode
		public static const POLYGON       :int = 0;
		public static const POINTS        :int = 2;
		public static const LINES         :int = 4;
		public static const TRIANGLES     :int = 9;
		public static const TRIANGLE_STRIP:int = 10;
		public static const TRIANGLE_FAN  :int = 11;
		public static const QUADS         :int = 16;
		public static const QUAD_STRIP    :int = 17;
		
		public static const OPEN      :Boolean = false;
		public static const CLOSE     :Boolean = true;
		
		public static const NORMALIZED    :int = 1;
		public static const IMAGE         :int = 0;
	}
}