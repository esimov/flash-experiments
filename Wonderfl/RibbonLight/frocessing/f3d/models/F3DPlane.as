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
	public class F3DPlane extends F3DModel
	{
		/**
		 * 
		 */
		public function F3DPlane( width:Number, height:Number=NaN, segment:uint=2, segmentH:uint=2 ) 
		{
			super();
			backFaceCulling = false;
			
			if ( isNaN(height) )
				height = width;
			
			if ( segment < 1 )
				segment = 1;
			
			if ( arguments.length<4 )
				segmentH = segment;
			
			initModel( width, height, segment, segmentH );
		}
		
		/** @private */
		private function initModel( w:Number, h:Number, sW:uint, sH:uint ):void
		{
			var x0:Number = - w * 0.5;
			var y0:Number = - h * 0.5;
			beginVertex( TRIANGLE_MESH, sW+1 );
			for ( var i:int = 0 ; i <= sH; i++ ) {
				for ( var j:int = 0; j <= sW; j ++ ) {
					addVertex( x0 + w*j/sW, y0 + h*i/sH, 0, j/sW, i/sH );
				}
			}
			endVertex();
		}
	}
}