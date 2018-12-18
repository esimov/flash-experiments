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

package frocessing.core.graphics 
{
	import flash.geom.Matrix;
	import frocessing.geom.FGradientMatrix;
	import frocessing.geom.FMatrix;
	/**
	* グラデーションを定義します.
	* 
	* Matrixはノーマライズされた値を指定します。
	* 実際適用されるMatrixは、（left,top,width,height）にマッピングされます.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FNormalGradient extends FGradient
	{		
		/**
		 * true の場合、実際適用されるMatrixは、（left,top,width,height）にマッピングされます.
		 */
		public var isNormal:Boolean;
		
		/** @private */
		protected var _mapped_matrix:FMatrix;
		/** @private */
		protected var _x:Number = 0;
		/** @private */
		protected var _y:Number = 0;
		/** @private */
		protected var _w:Number = 1;
		/** @private */
		protected var _h:Number = 1;
		
		/**
		 * 
		 */
		public function FNormalGradient( normal:Boolean, type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number=0.0) {
			super( type, colors, alphas, ratios, ( matrix != null ) ? matrix : new FGradientMatrix(1,0,0,1,0.5,0.5), spreadMethod, interpolationMethod, focalPointRatio );
			isNormal       = normal;
			_mapped_matrix = new FMatrix( this.matrix.a, this.matrix.b, this.matrix.c, this.matrix.d, this.matrix.tx, this.matrix.ty );
		}
		
		public function setRect( left:Number, top:Number, width:Number, height:Number ):void {
			if ( left != _x || top != _y || width != _w || height != _h ) {
				_x = left; _y = top; _w = width; _h = height;
			}
		}
		
		public function get mappedMatrix():Matrix 
		{ 
			if ( isNormal ) {
				//matrix(a, b, c, d, tx, ty) . matrix( w, 0, 0, h, x, y )
				_mapped_matrix.setMatrix( matrix.a * _w, matrix.b * _h, matrix.c * _w, matrix.d * _h, matrix.tx * _w + _x, matrix.ty * _h + _y );
			}else {
				_mapped_matrix.setMatrix( matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty );
			}
			return _mapped_matrix;
		}
		
		/*
		public function clone():FNormalGradient{
			var g:FNormalGradient = new FNormalGradient( _isNormal, type, colors.concat(), alphas.concat(), ratios.concat(), matrix.clone(), spreadMethod, interpolationMethod, focalPointRatio );
			g._mapped_matrix.setMatrix( _mapped_matrix.a, _mapped_matrix.b, _mapped_matrix.c, _mapped_matrix.d, _mapped_matrix.tx, _mapped_matrix.ty );
			g._x = _x;
			g._y = _y;
			g._h = _h;
			g._w = _w;
			return g;
		}
		*/
	}
}