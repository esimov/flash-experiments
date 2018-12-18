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

package frocessing.f3d.models
{	
	import frocessing.f3d.F3DModel;
	/**
	* 3D Primitive Plane
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DSimpleCube extends F3DModel
	{
		/**
		 * 
		 */
		public function F3DSimpleCube( width:Number, height:Number=NaN, depth:Number=NaN, segment:uint=1, segmentH:uint=1, segmentD:uint=1 ) 
		{
			super();
			backFaceCulling = true;
			
			if ( isNaN(height) )
				height = width;
			
			if ( isNaN(depth) )
				depth = width;
			
			if ( segment < 1 )
				segment = 1;
			
			var alen:int = arguments.length;
			if ( alen < 5 )
				segmentH = segmentD = segment;
			else if ( alen < 6 )
				segmentD = segment;
			
			initModel( width, height, depth, segment, segmentH, segmentD );
		}
		
		/** @private */
		private function initModel( w:Number, h:Number, d:Number, sW:uint, sH:uint, sD:uint ):void
		{
			var x0:Number;
			var y0:Number;
			var z0:Number;
			
			//top,front,bottom
			beginVertex( TRIANGLE_MESH, sW + 1 );
			x0 = - w/2;
			y0 = - h/2;
			z0 = - d/2;
			for ( var i:int = 0 ; i <= sD; i++ ) {
				for ( var j:int = 0; j <= sW; j ++ ) {
					addVertex( x0 + w*j/sW, y0, z0 + d*i/sD, j/sW/2, i/sD/3 );
				}
			}
			z0 = d / 2;
			for ( i = 1 ; i <= sH; i++ ) {
				for ( j = 0; j <= sW; j ++ ) {
					addVertex( x0 + w*j/sW, y0 + h*i/sH, z0, j/sW/2, 1/3+i/sH/3 );
				}
			}
			y0 = h/2;
			for ( i = 1 ; i <= sD; i++ ) {
				for ( j = 0; j <= sW; j ++ ) {
					addVertex( x0 + w*j/sW, y0, z0 - d*i/sD, j/sW/2, 2/3 + i/sD/3 );
				}
			}
			endVertex();
			
			//left,back,right
			beginVertex( TRIANGLE_MESH, sH + 1 );
			x0 = w/2;
			y0 = h/2;
			z0 = d/2;
			for ( i = 0 ; i <= sD; i++ ) {
				for ( j = 0; j <= sH; j ++ ) {
					addVertex( x0, y0 - h*j/sH, z0 - d*i/sD, 0.5+j/sH/2, i/sD/3 );
				}
			}
			x0 = w/2;
			y0 = h/2;
			z0 = -d/2;
			for ( i = 1 ; i <= sW; i++ ) {
				for ( j = 0; j <= sH; j ++ ) {
					addVertex( x0 - w*i/sW, y0 - h*j/sH, z0, 0.5+j/sH/2, 1/3+i/sW/3 );
				}
			}
			x0 = -w/2;
			y0 = h/2;
			z0 = -d/2;
			for ( i = 1 ; i <= sD; i++ ) {
				for ( j = 0; j <= sH; j ++ ) {
					addVertex( x0, y0 - h*j/sH, z0 + d*i/sD, 0.5+j/sH/2, 2/3+i/sD/3 );
				}
			}
			endVertex();
		}
		
	}
}