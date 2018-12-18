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

package frocessing.core.canvas.out 
{
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.canvas.ICanvasStroke;
	import frocessing.shape.FSVGBuffer;
	/**
	 * ...
	 * @author nutsu
	 * @version 0.6
	 */
	public class SVGOutput2D extends CanvasOutput2D
	{
		private var _writer:FSVGBuffer;
		public var svg:String;
		
		/**
		 * 
		 */
		public function SVGOutput2D( width:Number, height:Number ) 
		{
			_writer = new FSVGBuffer( width, height );
			svg = "";
			super( width, height );
		}
		
		/** @private */
		override protected function _flushImpl():void 
		{
			_writer.width = _canvasWidth;
			_writer.height = _canvasHeight;
			_writer.bgEnabled = true;
			_writer.bgColor = _bgColor;
			svg = _writer.getSVGString();
		}
		
		/** @private */
		override protected function _resetImpl():void 
		{
			_writer.clearBuffer();
		}
		
		/** @private */
		override protected function _outputPathDataImpl( command:Array, data:Array, stroke:ICanvasStroke, fill:ICanvasFill ):void 
		{
			_writer.addPath( command, data, stroke, fill );
		}
		
	}
	
}