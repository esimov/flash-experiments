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
	import flash.geom.Matrix;
	
	/**
	* Matrix for Gradient.
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FGradientMatrix extends FMatrix
	{
		
		/**
		 * gradient matrix.
		 * 
		 * @param	vx1		x axis vector
		 * @param	vy1		x axis vector
		 * @param	vx2		y axis vector
		 * @param	vy2		y axis vector
		 * @param	cx		center x
		 * @param	cy		center y
		 */
		public function FGradientMatrix( vx1:Number=1, vy1:Number=0, vx2:Number=0, vy2:Number=1, cx:Number=0, cy:Number=0 ) {
			identity();
			appendMatrix( vx1, vy1, vx2, vy2, cx, cy );
		}
		
		/**
		 * initialize gradient matrix.
		 * widht 1.0, height 1.0, center position(0,0).
		 */
		override public function identity():void 
		{
			a = 0.0006103515625;
			b = 0;
			c = 0;
			d = 0.0006103515625;
			tx = 0;
			ty = 0;
		}
		
		//---------------------------------------------------------------------------------------------------
		// create gradient matrix
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * create gradient matrix.
		 * 
		 * @param	vx1		x axis vector
		 * @param	vy1		x axis vector
		 * @param	vx2		y axis vector
		 * @param	vy2		y axis vector
		 * @param	cx		center x
		 * @param	cy		center y
		 */
		public function create( vx1:Number=1, vy1:Number=0, vx2:Number=0, vy2:Number=1, cx:Number=0, cy:Number=0 ):void
		{
			identity();
			appendMatrix( vx1, vy1, vx2, vy2, cx, cy );
		}
		
		/**
		 * create linear gradient matrix.
		 * 
		 * @param	x0	begin x
		 * @param	y0	begin y
		 * @param	x1	end x
		 * @param	y1  end y
		 */
		public function createLinear( x0:Number=0, y0:Number=0, x1:Number=1, y1:Number=0 ):void
		{
			identity();
			appendMatrix( x1 - x0, y1 - y0, y0 - y1, x1 - x0, ( x0 + x1 ) * 0.5, ( y0 + y1 ) * 0.5 );
		}
		
		/**
		 * create skew gradient matrix.
		 * 
		 * @param	x0	begin x
		 * @param	y0	begin y
		 * @param	x1	end x1	
		 * @param	y1	end y1
		 * @param	x2	end x2	
		 * @param	y2	end y2
		 * @param	rotation gradient rotation
		 */
		public function createSkew( x0:Number=0, y0:Number=0, x1:Number=1, y1:Number=0, x2:Number=0, y2:Number=1, rotation:Number=0 ):void
		{
			identity();
			if( rotation != 0 )
				rotate( rotation );
			appendMatrix( x1 - x0, y1 - y0, x2 - x0, y2 - y0, (x1 + x2) * 0.5, (y1 + y2) * 0.5 );
		}
		
		/**
		 * create simple radial gradient matrix.
		 * 
		 * @param	cx	center x
		 * @param	cy	center y
		 * @param	r	radius
		 * @param	fr 	focus pointion angle
		 */
		public function createRadial( cx:Number=0.5, cy:Number=0.5, r:Number=0.5, fr:Number=0 ):void
		{
			identity();
			if ( fr!=0 ) rotate( fr );
			appendMatrix( r*2, 0, 0, r*2, cx, cy );
		}
		
		/**
		 * create skew radial gradient matrix.
		 * 
		 * @param	x0	center x
		 * @param	y0	center y
		 * @param	x1	end x1	
		 * @param	y1	end y1
		 * @param	x2	end x2	
		 * @param	y2	end y2
		 * @param	fr 	focus pointion angle
		 */
		public function createSkewRadial( x0:Number=0.5, y0:Number=0.5, x1:Number=1.0, y1:Number=0.5, x2:Number=0.5, y2:Number=1.0, fr:Number=0 ):void
		{
			identity();
			if ( fr!=0 ) rotate( fr );
			appendMatrix( (x1 - x0)*2, (y1 - y0)*2, (x2 - x0)*2, (y2 - y0)*2, x0, y0 );
		}
		
		/**
		 * 
		 */
		override public function createGradientBox(width:Number, height:Number, rotation:Number=0, tx:Number=0, ty:Number=0 ):void 
		{
			super.createGradientBox(width, height, rotation, tx, ty);
		}
		
		//---------------------------------------------------------------------------------------------------
		// mapping
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * mapping gradient matrix.
		 * 
		 * @param	x		target rect.x
		 * @param	y		target rect.y
		 * @param	width	target rect.width
		 * @param	height	target rect.height
		 */
		public function map( x:Number, y:Number, width:Number, height:Number ):Matrix
		{
			return new Matrix( a * width, b * height, c * width, d * height, tx * width + x, ty * height + y );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * default matrix of Graphics#beginGradientFill
		 */
		public static function defaultGradient():Matrix
		{
			var mat:Matrix = new Matrix();
			mat.createGradientBox( 200, 200, 0, -100, -100 );
			return mat;
		}
		
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* 
		*/
		override public function toString():String
		{
			return "[FGradientMatrix ("+a+","+b+")("+c+","+d+")("+tx+","+ty+")]";
		}
		
	}
	
}