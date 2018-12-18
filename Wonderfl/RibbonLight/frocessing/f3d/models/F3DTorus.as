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
	* 3D Primitive Torus
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DTorus extends F3DModel
	{
		/**
		 * 
		 */
		public function F3DTorus( radiusH:Number, radiusV:Number, segmentH:uint=6, segmentV:uint=6 ) 
		{
			super();
			backFaceCulling = true;
			initModel( radiusH, radiusV, segmentH, segmentV );
		}
		
		/** @private */
		private function initModel( rH:Number, rV:Number, sH:uint, sV:uint ):void
		{
			beginVertex( TRIANGLE_MESH, sV+1 );
			for ( var i:int = 0 ; i <= sH; i++ ) {
				var th:Number = Math.PI * 2 * i / sH;
				var ch:Number = Math.cos(th);
				var sh:Number = Math.sin(th);
				for ( var j:int = 0; j <= sV; j ++ ) {
					var tv:Number = Math.PI + Math.PI * 2 * j / sV;
					var r:Number = Math.cos(tv) * rV + rH;
					addVertex( r*ch, r*sh, -rV*Math.sin(tv), j/sV, i/sH );
				}
			}
			endVertex();
		}
	}
}