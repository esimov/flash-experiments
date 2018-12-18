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

package frocessing.display {
	
	import flash.display.DisplayObject;
	import frocessing.core.F5Canvas2D;
	
	/**
	* F5MovieClip2D.
	* 
	* @author nutsu
	* @version 0.6
	* 
	* @see frocessing.core.F5Canvas2D
	*/
	public dynamic class F5CanvasMovieClip2D extends AbstractF5MovieClip
	{
		public var fg:F5Canvas2D;
		
		/**
		 * 
		 */
		public function F5CanvasMovieClip2D( f5Canvas2D:F5Canvas2D, target:DisplayObject=null, useStageEvent:Boolean=true ) 
		{
			super( fg = f5Canvas2D, target, useStageEvent );
		}
		
		//------------------------------------------------------------------------------------------------------------------- TRANSFORM
		
		/**
		 * 
		 */
		public function translate( tx:Number, ty:Number ):void {
			fg.translate( tx, ty );
		}
		/**
		 * 
		 */
		public function scale( sx:Number, sy:Number = NaN ):void{
			fg.scale( sx, sy );
		}
		/**
		 * 
		 */
		public function rotate( angle:Number ):void{
			fg.rotate( angle );
		}
		/**
		 * 
		 */
		public function pushMatrix():void{
			fg.pushMatrix();
		}
		/**
		 * 
		 */
		public function popMatrix():void{
			fg.popMatrix();
		}
		/**
		 * 
		 */
		public function resetMatrix():void{
			fg.resetMatrix();
		}
		/**
		 * 
		 */
		public function printMatrix():void {
			fg.printMatrix();
		}
		/**
		 * 
		 */
		public function screenX( x:Number, y:Number ):Number{
			return fg.screenX( x, y );
		}
		/**
		 * 
		 */
		public function screenY( x:Number, y:Number ):Number{
			return fg.screenY( x, y );
		}
		/*
		public function applyTransform( displayObj:DisplayObject, x:Number=0, y:Number=0 ):void{
			fg.applyTransform( displayObj, x, y );
		}
		*/
	}
}
