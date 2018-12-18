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

package frocessing.core.canvas.task
{
	import frocessing.core.canvas.AbstractCanvas3D;	
	import frocessing.core.canvas.canvasImpl;
	use namespace canvasImpl;
	/**
	 * @author nutsu
	 * @version 0.6
	 */
	public class CanvasTaskTriangle extends CanvasTask
	{
		public var x0:Number;
		public var y0:Number;
		public var x1:Number;
		public var y1:Number;
		public var x2:Number;
		public var y2:Number;
		
		public function CanvasTaskTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ) 
		{
			this.x0 = x0; this.y0 = y0;
			this.x1 = x1; this.y1 = y1;
			this.x2 = x2; this.y2 = y2;
		}
		
		override public function render( c:AbstractCanvas3D ):void {
			c.canvasImpl::triangleImpl( x0, y0, x1, y1, x2, y2 );
		}
	}
}