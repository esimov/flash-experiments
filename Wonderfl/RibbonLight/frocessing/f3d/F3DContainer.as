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

package frocessing.f3d
{
	import frocessing.core.canvas.ICanvas3D;
	import frocessing.geom.FMatrix3D;
	
	/**
	* 3D Group
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DContainer extends F3DObject
	{
		/**
		 * @private
		 */
		protected var childs:Array;
		/**
		 * @private
		 */
		protected var child_number:uint;
		
		/**
		 * 
		 * @param	defaultMatrix
		 */
		public function F3DContainer( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			
			childs       = [];
			child_number = 0;
		}
		
		public function get childrenNum():uint { return child_number; }
		
		/**
		 * 
		 */
		public function addChild( f3dobj:F3DObject ):void
		{
			childs[child_number] = f3dobj;
			child_number++;
		}
		
		/**
		 * 
		 */
		public function removeChild( f3dobj:F3DObject ):void
		{
			var i:int = childs.indexOf( f3dobj );
			if ( i != -1 ){
				childs.splice( i, 1 );
				child_number--;
			}
		}
		
		/**
		 * 
		 */
		public function removeAllChilds():void
		{
			childs       = [];
			child_number = 0;
		}
		
		/**
		 * 
		 * @param	n
		 */
		public function getChildAt( i:uint ):F3DObject
		{
			if ( i < childs.length )
				return childs[i];
			else
				return null;
		}
		
		//--------------------------------------------------------------------------------------------------- Override F3DObject
		
		/**
		 * 
		 */
		override public function draw( g:ICanvas3D ):void
		{
			if ( child_number != 0 ){
				for ( var n:int=0 ; n < child_number; n++ ){
					F3DObject( childs[n] ).draw( g );
				}
			}
		}
		
		/**
		 * 
		 */
		override public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
												  m21_:Number, m22_:Number, m23_:Number,
												  m31_:Number, m32_:Number, m33_:Number,
												  m41_:Number, m42_:Number, m43_:Number ):void
		{
			super.updateTransform( m11_, m12_, m13_, m21_, m22_, m23_, m31_, m32_, m33_, m41_, m42_, m43_ );
			
			if ( child_number != 0 ){
				for ( var n:int=0 ; n < child_number; n++ ){
					F3DObject( childs[n] ).updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
				}
			}
		}
	}
	
}