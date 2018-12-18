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
	 * Matrix for draw BitmapData.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class FMatrixMap extends FMatrix
	{
		
		public function FMatrixMap( a:Number=1.0, b:Number=0.0, c:Number=0.0, d:Number=1.0, tx:Number=0.0, ty:Number=0.0 ){
			super( a, b, c, d, tx, ty );
		}
		
		/**
		 * 
		 */
		public function createRectBox( x:Number, y:Number, width:Number, height:Number, 
									   u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=1,
									   srcWidth:Number=1, srcHeight:Number=1 ):void 
		{
			a = ((u1 - u0)!=0) ? width/(u1 - u0)/srcWidth : width;
			b = 0;
			c = 0;
			d = ((v1 - v0)!=0) ? height/(v1 - v0)/srcHeight: height;
			tx = -u0 * srcWidth  * a + x; 
			ty = -v0 * srcHeight * d + y;
		}
		
		/**
		 * UV値から任意の三角形に座標を移す変換を設定します. 
		 * 
		 * この変換により、画像内の任意の区画(Triangle)を、任意の座標で描画する Matrix を設定できます.
		 * 
		 * <listing>
		 * var bitmapdata:BitmapData = new BitmapData(...);
		 * var matrix    :FMatrixMap = new FMatrixMap();
		 * 
		 * //描画座標値とUV値
		 * matrix.createTriangleBox( 100, 100, 150, 80, 120, 200, 0.5, 0.5, 1.0, 0.5, 1.0, 0.5, bitmapdata.width, bitmapdata.height );
		 * 
		 * graphics.beingBitmapFill( bitmapdata, matrix );
		 * graphics.moveTo( 100, 100 );
		 * graphics.lineTo( 150, 80 );
		 * graphics.lineTo( 120, 200 );
		 * graphics.endFill();
		 * </listing>
		 * 
		 * UV値を正規化された値ではなく実際の座標値で指定する場合、srcWidth, srcHeight の指定は必要ありません.
		 */
		public function createTriangleBox( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
										   u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number,
									       srcWidth:Number=1, srcHeight:Number=1 ):void
		{
			createMap( srcWidth*(u1-u0), srcHeight*(v1-v0), srcWidth*(u2-u0), srcHeight*(v2-v0), srcWidth*u0, srcHeight*v0,
					   x1 - x0, y1 - y0, x2 - x0, y2 - y0, x0, y0 );
		}
		
		/**
		 * Matrix0(a0,b0,c0,d0,x0,y0) から Matrix1(a1,b1,c1,d1,x1,y1) への変換
		 */
		public function createMap( a0:Number, b0:Number, c0:Number, d0:Number, x0:Number, y0:Number,
								   a1:Number, b1:Number, c1:Number, d1:Number, x1:Number, y1:Number ):void
		{
			var det:Number = a0 * d0 - b0 * c0;
			if ( det == 0 ) {
				/*
				if ( a0 == 0 && b0 == 0 )
					a0 = 1;
				else if ( c0 == 0 && d0 == 0 )
					d0 = 1;
				else if( a0 ==0 && c0==0 )
					c0 += 1;
				else
					d0 += 1;
				det = 	a0 * d0 - b0 * c0;
				*/
				det = 1;
			}
			a  = (a1 * d0 - b0 * c1) / det;
			b  = (b1 * d0 - b0 * d1) / det;
			c  = (a0 * c1 - a1 * c0) / det;
			d  = (a0 * d1 - b1 * c0) / det;
			tx = ( a1 * (c0 * y0 - d0 * x0) + c1 * (b0 * x0 - a0 * y0) ) / det + x1;
			ty = ( b1 * (c0 * y0 - d0 * x0) + d1 * (b0 * x0 - a0 * y0) ) / det + y1;
		}
		/*
		public function createTriangleBox( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
										   u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number,
									       srcWidth:Number=1, srcHeight:Number=1 ):void
		{			
			//uv transform
			u0 *= srcWidth;
			v0 *= srcHeight;
			var a0:Number = srcWidth*u1  - u0;
			var b0:Number = srcHeight*v1 - v0;
			var c0:Number = srcWidth*u2  - u0;
			var d0:Number = srcHeight*v2 - v0;
			var det0:Number = a0 * d0 - b0 * c0;
			if ( det0 == 0 )
			{
				if ( a0 == 0 && b0 == 0 )
					a0 = 1;
				else if ( c0 == 0 && d0 == 0 )
					d0 = 1;
				else if( a0 ==0 && c0==0 )
					c0 += 1;
				else
					d0 += 1;
				det0 = 	a0 * d0 - b0 * c0;
			}
			//invert matrix
			a  =  d0 / det0;
			b  = -b0 / det0;
			c  = -c0 / det0;
			d  =  a0 / det0;
			tx = ( c0 * v0 - d0 * u0 ) / det0;
			ty = ( b0 * u0 - a0 * v0 ) / det0;
			//apply view transform
			appendMatrix( x1 - x0, y1 - y0, x2 - x0, y2 - y0, x0, y0 );
		}
		*/
		
	}
	
}