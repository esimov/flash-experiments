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

package frocessing.core.canvas 
{
	import flash.geom.Matrix;
	import frocessing.core.graphics.FGradient;
	use namespace canvasImpl;
	/**
	* グラデーション塗りを定義します.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class CanvasGradientFill extends FGradient implements ICanvasFill
	{
		public function CanvasGradientFill( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number=0.0) {
			super(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		public function apply( g:CanvasStyleAdapter ):void{
			g.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		public function clone():ICanvasFill {
			return new CanvasGradientFill( type, colors.concat(), alphas.concat(), ratios.concat(), ( matrix == null ) ? null : matrix.clone(), spreadMethod, interpolationMethod, focalPointRatio );
		}
	}
}