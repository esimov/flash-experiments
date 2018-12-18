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

package frocessing.core.graphics 
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.geom.FMatrixMap;
	/**
	 * @author nutsu
	 * @version 0.6
	 */
	public class FBitmapGraphics
	{
		public var graphics:Graphics;
		
		/** @private */
		private var _matrix:FMatrixMap;
		
		/**
		 * 画像描画のスムーシング.
		 */
		public var smoothing:Boolean = true;
		
		/**
		 * drawQuad()時の描画ポリゴン分割数.
		 * ポリゴン数は 2 * (detail^2) になる.
		 */
		public var detail:int = 1;
		
		/**
		 * 
		 * @param	graphics	target Graphics.
		 */
		public function FBitmapGraphics( graphics:Graphics ) 
		{
			this.graphics = graphics;
			_matrix = new FMatrixMap();
		}
		
		/**
		 * BitmapData を 描画します.
		 * 
		 * @param	image	BitmapData
		 * @param	mtx		transform matrix
		 */
		public function drawImage( image:BitmapData, mtx:Matrix=null ):void
		{
			graphics.moveTo(0,0); //reset point for player 9 bug
			if ( mtx == null ) {
				graphics.beginBitmapFill( image, null, false, smoothing );
				graphics.drawRect( 0, 0, image.width, image.height );
				graphics.endFill();
			}
			else if ( mtx.b != 0 || mtx.c != 0 ) {
				graphics.beginBitmapFill( image, mtx, false, smoothing );
				graphics.moveTo( mtx.tx, mtx.ty );
				graphics.lineTo( mtx.a * image.width + mtx.tx, mtx.b * image.width + mtx.ty );
				graphics.lineTo( mtx.a * image.width + mtx.c * image.height + mtx.tx, mtx.b * image.width + mtx.d * image.height + mtx.ty );
				graphics.lineTo( mtx.c * image.height + mtx.tx, mtx.d * image.height + mtx.ty );
				graphics.endFill();
			}
			else {
				//only scaling
				graphics.beginBitmapFill( image, mtx, false, smoothing );
				graphics.drawRect( mtx.tx, mtx.ty, mtx.a*image.width, mtx.d*image.height );
				graphics.endFill();
			}
		}
		
		/**
		 * BitmapData を 矩形領域に描画します.
		 */
		public function drawRect( image:BitmapData, x:Number, y:Number, width:Number, height:Number ):void 
		{
			graphics.moveTo(0,0); //reset point for player 9 bug
			_matrix.setMatrix( width / image.width, 0, 0, height / image.height, x, y );
			graphics.beginBitmapFill( image, _matrix, false, smoothing );
			graphics.drawRect( x, y, width, height );
			graphics.endFill();
		}
		
		/**
		 * BitmapData を Triangle の領域に描画します.
		 */
		public function drawTriangle( image:BitmapData, 
									  x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
									  u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			graphics.moveTo(0,0); //reset point for player 9 bug
			var w:Number = image.width;
			var h:Number = image.height;
			//_matrix.createTriangleBox( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, w, h );
			_matrix.createMap( w * (u1 - u0), h * (v1 - v0), w * (u2 - u0), h * (v2 - v0), w * u0, h * v0, x1 - x0, y1 - y0, x2 - x0, y2 - y0, x0, y0 );
			graphics.beginBitmapFill( image, _matrix, false, smoothing && ( (x1 - x0) * (y2 - y0) - (y1 - y0) * (x2 - x0) > 255 ) );
			graphics.moveTo( x0, y0 );
			graphics.lineTo( x1, y1 );
			graphics.lineTo( x2, y2 );
			graphics.endFill();
		}
		
		
		/**
		 * BitmapData を Quad の領域に描画します.
		 */
		public function drawQuad( image:BitmapData, 
								  x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
								  u0:Number = 0, v0:Number = 0, u1:Number = 1, v1:Number = 0, u2:Number = 1, v2:Number = 1, u3:Number = 0, v3:Number = 1 ):void
		{
			graphics.moveTo(0,0); //reset point for player 9 bug
			var w:Number = image.width;
			var h:Number = image.height;
			var u:Number;
			var v:Number;
			
			var v0x0:Number = x0;
			var v0y0:Number = y0;
			var v0x1:Number = x1;
			var v0y1:Number = y1;
			var v1x0:Number;
			var v1y0:Number;
			var v1x1:Number;
			var v1y1:Number;
			
			var v0u0:Number = u0;
			var v0v0:Number = u0;
			var v0u1:Number = u1;
			var v0v1:Number = v1;
			var v1u0:Number;
			var v1v0:Number;
			var v1u1:Number;
			var v1v1:Number;
			
			var h0x0:Number;
			var h0y0:Number;
			var h0x1:Number;
			var h0y1:Number;
			var h1x0:Number;
			var h1y0:Number;
			var h1x1:Number;
			var h1y1:Number;
			
			var h0u0:Number;
			var h0v0:Number;
			var h0u1:Number;
			var h0v1:Number;
			var h1u0:Number;
			var h1v0:Number;
			var h1u1:Number;
			var h1v1:Number;
			
			var d:Number = 1 / detail;
			for( var i:int=1; i<=detail; i++ )
			{
				v = i * d;
				v1x0 = x0 + (x3 - x0) * v;
				v1y0 = y0 + (y3 - y0) * v;
				v1x1 = x1 + (x2 - x1) * v;
				v1y1 = y1 + (y2 - y1) * v;
				v1u0 = u0 + (u3 - u0) * v;
				v1v0 = v0 + (v3 - v0) * v;
				v1u1 = u1 + (u2 - u1) * v;
				v1v1 = v1 + (v2 - v1) * v;
				
				h0x0 = v0x0; h0y0 = v0y0;
				h0x1 = v1x0; h0y1 = v1y0;
				h0u0 = v0u0; h0v0 = v0v0;
				h0u1 = v1u0; h0v1 = v1v0;
				for ( var j:int = 1; j <=detail; j++ )
				{
					u = j * d;
					h1x0 = v0x0 + (v0x1 - v0x0) * u;
					h1y0 = v0y0 + (v0y1 - v0y0) * u;
					h1x1 = v1x0 + (v1x1 - v1x0) * u;
					h1y1 = v1y0 + (v1y1 - v1y0) * u;
					h1u0 = v0u0 + (v0u1 - v0u0) * u;
					h1v0 = v0v0 + (v0v1 - v0v0) * u;
					h1u1 = v1u0 + (v1u1 - v1u0) * u;
					h1v1 = v1v0 + (v1v1 - v1v0) * u;
					
					_matrix.createMap( w * (h1u0 - h0u0), h * (h1v0 - h0v0), w * (h0u1 - h0u0), h * (h0v1 - h0v0), w * h0u0, h * h0v0, h1x0 - h0x0, h1y0 - h0y0, h0x1 - h0x0, h0y1 - h0y0, h0x0, h0y0 );
					//_matrix.createTriangleBox( h0x0, h0y0, h1x0, h1y0, h0x1, h0y1, h0u0, h0v0, h1u0, h1v0, h0u1, h0v1, w, h );
					graphics.beginBitmapFill( image, _matrix, false, smoothing && ( (h1x0 - h0x0) * (h0y1 - h0y0) - (h1y0 - h0y0) * (h0x1 - h0x0) > 255 ) );
					graphics.moveTo( h0x0, h0y0 );
					graphics.lineTo( h1x0, h1y0 );
					graphics.lineTo( h0x1, h0y1 );
					graphics.endFill();
					
					_matrix.createMap( w * (h1u1 - h1u0), h * (h1v1 - h1v0), w * (h0u1 - h1u0), h * (h0v1 - h1v0), w * h1u0, h * h1v0, h1x1 - h1x0, h1y1 - h1y0, h0x1 - h1x0, h0y1 - h1y0, h1x0, h1y0 );
					//_matrix.createTriangleBox( h1x0, h1y0, h1x1, h1y1, h0x1, h0y1, h1u0, h1v0, h1u1, h1v1, h0u1, h0v1, w, h );
					graphics.beginBitmapFill( image, _matrix, false, smoothing && ( (h1x1 - h1x0) * (h0y1 - h1y0) - (h1y1 - h1y0) * (h0x1 - h1x0) > 255 ) );
					graphics.moveTo( h1x0, h1y0 );
					graphics.lineTo( h1x1, h1y1 );
					graphics.lineTo( h0x1, h0y1 );
					graphics.endFill();
					
					h0x0 = h1x0; h0y0 = h1y0;
					h0x1 = h1x1; h0y1 = h1y1;
					h0u0 = h1u0; h0v0 = h1v0;
					h0u1 = h1u1; h0v1 = h1v1;
				}
				v0x0 = v1x0; v0y0 = v1y0;
				v0x1 = v1x1; v0y1 = v1y1;
				v0u0 = v1u0; v0v0 = v1v0;
				v0u1 = v1u1; v0v1 = v1v1;
			}
		}
	}
}