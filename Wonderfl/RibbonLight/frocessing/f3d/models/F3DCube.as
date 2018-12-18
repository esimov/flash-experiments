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
	import frocessing.core.canvas.ICanvas3D;
	import flash.display.BitmapData;
	import frocessing.f3d.F3DObject;
	/**
	* 3D Cube
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DCube extends F3DObject
	{
		public var front:F3DPlane;
		public var top:F3DPlane;
		public var bottom:F3DPlane;
		public var left:F3DPlane;
		public var right:F3DPlane;
		public var back:F3DPlane;
		
		public var visible:Boolean = true;
		
		/**
		 * 
		 */
		public function F3DCube( width:Number, height:Number=NaN, depth:Number=NaN, segment:uint=1, segmentH:uint=1, segmentD:uint=1  ) 
		{
			super();
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
		
		//--------------------------------------------------------------------------------------------------- MATERIAL
		
		/**
		 * 
		 */
		public function setColors( front:uint, right:uint, back:uint, left:uint, top:uint, bottom:uint ):void
		{
			this.front.setColor( front );
			this.top.setColor( top );
			this.bottom.setColor( bottom );
			this.left.setColor( left );
			this.right.setColor( right );
			this.back.setColor( back );
		}
		
		/**
		 * 
		 */
		public function setTextures( front:BitmapData, right:BitmapData, back:BitmapData, left:BitmapData, top:BitmapData, bottom:BitmapData ):void
		{
			this.front.setTexture( front );
			this.top.setTexture( top );
			this.bottom.setTexture( bottom );
			this.left.setTexture( left );
			this.right.setTexture( right );
			this.back.setTexture( back );
		}
		
		/**
		 * enable material and backCulling.
		 */
		public function enableStyle():void {
			front.enableStyle();
			top.enableStyle();
			bottom.enableStyle();
			left.enableStyle();
			right.enableStyle();
			back.enableStyle();
		}
		
		/**
		 * disable material and backCulling.
		 */
		public function disableStyle():void {
			front.disableStyle();
			top.disableStyle();
			bottom.disableStyle();
			left.disableStyle();
			right.disableStyle();
			back.disableStyle();
		}
		
		//--------------------------------------------------------------------------------------------------- INIT
		/** @private */
		private function initModel( w:Number, h:Number, d:Number, sW:uint, sH:uint, sD:uint ):void
		{
			front   = new F3DPlane( w, h, sW, sH );
			top     = new F3DPlane( w, d, sW, sD );
			bottom  = new F3DPlane( w, d, sW, sD );
			left    = new F3DPlane( d, h, sD, sH );
			right   = new F3DPlane( d, h, sD, sH );
			back    = new F3DPlane( w, h, sW, sH );
			front.backFaceCulling = true;
			top.backFaceCulling = true;
			bottom.backFaceCulling = true;
			left.backFaceCulling = true;
			right.backFaceCulling = true;
			back.backFaceCulling = true;
			
			front.translate( 0, 0, d * 0.5 );
			
			back.rotateY( Math.PI );
			back.translate( 0, 0, -d/2 );
			
			left.rotateY( Math.PI / 2 );
			left.translate( w/2, 0, 0 );
			
			right.rotateY( -Math.PI / 2 );
			right.translate( -w/2, 0, 0 );
			
			top.rotateX( Math.PI / 2 );
			top.translate( 0, -h/2, 0 );
			
			bottom.rotateX( -Math.PI / 2 );
			bottom.translate( 0, h/2, 0 );
			
		}
		
		//---------------------------------------------------------------------------------------------------
		/** @inheritDoc */
		override public function draw( g:ICanvas3D ):void
		{
			if ( visible ) {
				front.draw(g);
				top.draw(g);
				bottom.draw(g);
				left.draw(g);
				right.draw(g);
				back.draw(g);
			}
		}
		
		/** @inheritDoc */
		override public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
												  m21_:Number, m22_:Number, m23_:Number,
												  m31_:Number, m32_:Number, m33_:Number,
												  m41_:Number, m42_:Number, m43_:Number ):void
		{
			super.updateTransform( m11_, m12_, m13_, m21_, m22_, m23_, m31_, m32_, m33_, m41_, m42_, m43_ );
			front.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			top.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			bottom.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			left.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			right.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			back.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
		}
	}
	
}