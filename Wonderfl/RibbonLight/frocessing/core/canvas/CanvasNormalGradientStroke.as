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
	import frocessing.core.graphics.FNormalGradient;
	use namespace canvasImpl;
	/**
	* グラデーションの線描画を定義します.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class CanvasNormalGradientStroke extends FNormalGradient implements ICanvasStroke, ICanvasStrokeFill
	{
		private var _s:CanvasStroke;
		
		public function CanvasNormalGradientStroke( stroke:CanvasStroke, isNormal:Boolean, type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0.0 ) {
			super(isNormal, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			_s = stroke;
		}
		
		public function apply( g:CanvasStyleAdapter ):void {
			g.lineStyle( _s.thickness, _s.color, _s.alpha, _s.pixelHinting, _s.scaleMode, _s.caps, _s.joints, _s.miterLimit );
			g.lineGradientStyle( type, colors, alphas, ratios, mappedMatrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		public function clone():ICanvasStroke {
			var g:CanvasNormalGradientStroke = new CanvasNormalGradientStroke( CanvasStroke(_s.clone()), isNormal, type, colors.concat(), alphas.concat(), ratios.concat(), matrix.clone(), spreadMethod, interpolationMethod, focalPointRatio );
			g._mapped_matrix.setMatrix( _mapped_matrix.a, _mapped_matrix.b, _mapped_matrix.c, _mapped_matrix.d, _mapped_matrix.tx, _mapped_matrix.ty );
			g._x = _x;
			g._y = _y;
			g._h = _h;
			g._w = _w;
			return g;
		}
		
		public function get stroke():CanvasStroke { return _s; }
		public function set stroke( value:CanvasStroke ):void { _s = value; }
	}
}