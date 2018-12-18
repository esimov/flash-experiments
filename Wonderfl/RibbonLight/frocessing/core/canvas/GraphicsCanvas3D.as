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

package frocessing.core.canvas 
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.core.graphics.FBitmapGraphics;
	
	use namespace canvasImpl;
	/**
	 * Canvas3D for Graphics.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class GraphicsCanvas3D extends AbstractCanvas3D implements ICanvasRender
	{
		private var _gc:Graphics;
		private var _render_bmp:FBitmapGraphics;
		
		public function GraphicsCanvas3D( graphics:Graphics ) 
		{
			//graphics
			_gc = graphics;
			
			//render
			_render_bmp = new FBitmapGraphics( _gc );
			
			//
			clear();
		}
		
		/** @inheritDoc */
		override public function clear():void 
		{
			_gc.clear();
			super.clear();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// CANVAS IMPLEMENTS
		//-------------------------------------------------------------------------------------------------------------------
		
		//Rener Canvas3DData
		
		/** @private */
		override canvasImpl function pointImpl(x:Number, y:Number, color:uint, alpha:Number):void 
		{
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginFill( color, alpha );
			_gc.drawRect( x, y, 1, 1 );
			_gc.endFill();
		}
		
		/** @private */
		override canvasImpl function pathSegmentImpl( commandIndex:int, pathIndex:int, commandNum:int):void 
		{
			var endIndex:int = commandIndex + commandNum;
			var xi:int       = pathIndex;
			var yi:int       = xi + 1;
			for ( var i:int=commandIndex; i<endIndex; i++ ){
				var cmd:int = commands[i];
				if ( cmd == 2 ){ //LINE_TO
					_gc.lineTo( paths[xi], paths[yi] );
					xi += 2;
					yi += 2;
				}else if ( cmd == 3 ){ //CUREVE_TO
					_gc.curveTo( paths[xi], paths[yi], paths[int(xi+2)], paths[int(yi+2)] );
					xi += 4;
					yi += 4;
				}else if ( cmd == 1 ){ //MOVE_TO
					_gc.moveTo( paths[xi], paths[yi] );
					xi += 2;
					yi += 2;
				}
			}
		}
		
		/** @private */
		override canvasImpl function triangleImpl(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			_gc.moveTo( x0, y0 );
			_gc.lineTo( x1, y1 );
			_gc.lineTo( x2, y2 );
			_gc.lineTo( x0, y0 );
		}
		
		/** @private */
		override canvasImpl function triangleImageImpl(img:BitmapData, x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, smooth:Boolean):void
		{
			_render_bmp.smoothing = smooth;
			_render_bmp.drawTriangle( img, x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
		}
		
		/** @private */
		override canvasImpl function rectImageImpl(img:BitmapData, x:Number, y:Number, width:Number, height:Number, smooth:Boolean):void 
		{
			_render_bmp.smoothing = smooth;
			_render_bmp.drawRect( img, x, y, width, height );
		}
		
		
		//Styles
		/** @private */
		override protected function endFillImpl():void 
		{
			_gc.endFill();
		}
		
		/** @private */
		override canvasImpl function noLineStyle():void 
		{
			_gc.lineStyle();
		}
		/** @private */
		override canvasImpl function lineStyle(thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number):void 
		{
			_gc.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		/** @private */
		override canvasImpl function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void 
		{
			_gc.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginSolidFill(color:uint, alpha:Number):void 
		{
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginFill(color, alpha);
		}
		/** @private */
		override canvasImpl function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void 
		{
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix, repeat:Boolean, smooth:Boolean):void 
		{
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginBitmapFill(bitmapData, matrix, repeat, smooth);
		}
		
		// background
		/** @inheritDoc */
		override public function background( width:Number, height:Number, color:uint, alpha:Number ):void 
		{
			clear();
			if ( _strokeDo ) {
				_gc.lineStyle();
				_gc.beginFill( color, alpha );
				_gc.drawRect( 0, 0, width, height );
				_gc.endFill();
				_currentStroke.apply(this);
			}else {
				_gc.beginFill( color, alpha );
				_gc.drawRect( 0, 0, width, height );
				_gc.endFill();
			}
		}
	}
	
}