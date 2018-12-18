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

package frocessing.core {
	
	import flash.display.Graphics;
	import frocessing.core.canvas.GraphicsCanvas3D;
	
	/**
	* F5Graphics3D は Processing の 3D API を実装したクラスです.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F5Graphics3D extends F5Canvas3D
	{
		/**
		 * 新しい F5Graphics3D クラスのインスタンスを生成します.
		 * 
		 * @param	graphics	描画対象となる Graphics を指定します
		 */
		public function F5Graphics3D( graphics:Graphics, width:Number, height:Number )
		{
			super( new GraphicsCanvas3D( graphics ), width, height );
		}
	}
}

