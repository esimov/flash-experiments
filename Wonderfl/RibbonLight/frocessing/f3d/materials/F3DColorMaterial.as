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

package frocessing.f3d.materials 
{
	import frocessing.core.canvas.CanvasSolidFill;
	import frocessing.core.canvas.ICanvas3D;	
	/**
	* 3D Material Color
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DColorMaterial extends F3DEmptyMaterial
	{
		public var fill:CanvasSolidFill;
		/**
		 * 
		 */
		public function F3DColorMaterial( color:uint, alpha:Number=1 ) 
		{
			super();
			fill = new CanvasSolidFill( color, alpha );
		}
		
		/**
		 * 
		 */
		public function setColor( color:uint, alpha:Number=1 ):void
		{
			fill.color = color;
			fill.alpha = alpha;
		}
		
		/** @inheritDoc */
		override public function beginMatrial(g:ICanvas3D):void
		{ 
			g.beginFill( fill );
		}
		
		/** @inheritDoc */
		override public function endMatrial(g:ICanvas3D):void
		{
			g.endFill();
		}
		
	}
}