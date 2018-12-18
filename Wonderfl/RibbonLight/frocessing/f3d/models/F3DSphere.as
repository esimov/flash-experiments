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
	import frocessing.geom.FNumber3D;
	/**
	* 3D Primitive Sphere
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DSphere extends F3DModel
	{
		/**
		 * 
		 * @param	radius_
		 * @param	detail_	segments minimum 3, default 12
		 */
		public function F3DSphere( radius:Number, segmentH:uint=12, segmentV:uint=12 ) 
		{
			super();
			backFaceCulling = true;
			
			if ( segmentH < 3 ) {
				segmentH = 3;
			}
			if ( isNaN(segmentV) ) {
				segmentV = segmentH;
			}else if ( segmentV < 3 ) {
				segmentV = 3;
			}
			initModel( radius, segmentH, segmentV );
		}
		
		/** @private */
		private function initModel( r:Number, h:uint, v:uint ):void
		{
			//
			beginVertex( TRIANGLE_MESH, v+1 );
			for ( var i:int = 1 ; i < h; i++ ) {
				var th:Number = Math.PI * i/h - Math.PI/2;
				var y:Number  = r * Math.sin(th);
				var r2:Number = r * Math.cos(th);
				for ( var j:int = 0; j <= v; j++ ) {
					var tv:Number = Math.PI + Math.PI * 2 * j / v;
					addVertex( r2*Math.cos(tv), y, -r2*Math.sin(tv), j/v, i/h );
				}
			}
			endVertex();
			
			var len_tmp:int = vertices.length;
			//top
			var top:FNumber3D = new FNumber3D( 0, -r, 0 );
			for ( j = 0; j < v ; j++ ) {
				vertices.push( top );
				uv.push( (j + 0.5) / v, 0.0 );
				faces.push( len_tmp + j, j + 1, j );
			}
			
			//bottom
			len_tmp -= v + 1;
			var len_tmp2:int = vertices.length;
			var btm:FNumber3D = new FNumber3D( 0, r, 0 );
			for ( j = 0; j < v ; j++ ) {
				vertices.push( btm );
				uv.push( (j + 0.5) / v, 1.0 );
				faces.push( len_tmp2 + j, len_tmp + j, len_tmp + j + 1 );
			}
		}
		
	}
	
}