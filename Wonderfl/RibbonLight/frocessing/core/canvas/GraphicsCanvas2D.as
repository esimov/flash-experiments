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
	 * Canvas2D for Graphics.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class GraphicsCanvas2D extends AbstractCanvas2D
	{
		private var _gc:Graphics;
		
		private var _render_bmp:FBitmapGraphics;
		
		/**
		 * 
		 */
		public function GraphicsCanvas2D( graphics:Graphics ) 
		{
			super();
			
			//graphics
			_gc = graphics;
			
			//render
			_render_bmp   = new FBitmapGraphics( _gc );
			
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
		// Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function moveTo( x:Number, y:Number ):void
		{
			_gc.moveTo( __x = __startX = x, __y = __startY = y );
		}
		
		/** @inheritDoc */
		override public function lineTo( x:Number, y:Number ):void
		{
			_gc.lineTo( __x = x, __y = y );
		}
		
		/** @inheritDoc */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			_gc.curveTo( cx, cy, __x = x, __y = y );
		}
		
		/** @inheritDoc */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void 
		{
			__x -= x; __y -= y;
			cx0 -= x; cy0 -= y;
			cx1 -= x; cy1 -= y;
			var k:Number = 1.0/_bezierDetail;
			var t:Number = 0;
			for ( var i:int = 1; i <= _bezierDetail; i++ ){
				t += k;
				_gc.lineTo( __x*(1-t)*(1-t)*(1-t) + 3*cx0*t*(1-t)*(1-t) + 3*cx1*t*t*(1-t) + x, __y*(1-t)*(1-t)*(1-t) + 3*cy0*t*(1-t)*(1-t) + 3*cy1*t*t*(1-t) + y );
				//_gc.lineTo( __x*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x*t*t*t, __y*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y*t*t*t );
			}
			__x = x;
			__y = y;
		}
		
		/** @inheritDoc */
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var k:Number = 1.0 / _splineDetail;
			var t:Number = 0;
			
			//convert to bezier
			cx0 = __x + _splineTightness/6 * ( x - cx0 ) - x;
			cy0 = __y + _splineTightness/6 * ( y - cy0 ) - y;
			cx1 =     - _splineTightness/6 * ( cx1 - __x );
			cy1 =     - _splineTightness/6 * ( cy1 - __y );
			__x -= x;
			__y -= y;
			for ( var i:int = 1; i <= _splineDetail; i++ ){
				t += k;
				_gc.lineTo( __x*(1-t)*(1-t)*(1-t) + 3*cx0*t*(1-t)*(1-t) + 3*cx1*t*t*(1-t) + x, 
						    __y*(1-t)*(1-t)*(1-t) + 3*cy0*t*(1-t)*(1-t) + 3*cy1*t*t*(1-t) + y );
			}
			__x = x;
			__y = y;
			
			/* 
			// Catmull-Rom Spline Curve ( x0, y0, x1, y1, x2, y2, x3, y3 )
			var v0x:Number = splineTightness*( x - cx0 )*0.5;
			var v0y:Number = splineTightness*( y - cy0 )*0.5;
			var v1x:Number = splineTightness*( cx1 - __x )*0.5;
			var v1y:Number = splineTightness*( cy1 - __y )*0.5;
			for ( var i:int = 1; i <= splineDetail;  i++ ){
				t = i*k;
				_gc.lineTo( t*t*t*( 2*__x - 2*x + v0x + v1x ) + t*t*( -3*__x + 3*x - 2*v0x - v1x ) + v0x*t + __x,
						t*t*t*( 2*__y - 2*y + v0y + v1y ) + t*t*( -3*__y + 3*y - 2*v0y - v1y ) + v0y*t + __y );
			}
			//*/
		}
		
		/** @inheritDoc */
		override public function closePath():void
		{
			_gc.lineTo( __x = __startX, __y = __startY );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Primitive
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * ピクセルを描画します.
		 */
		override public function pixel(x:Number, y:Number, color:uint, alpha:Number):void 
		{
			point(x, y, color, alpha);
		}
		
		/** @inheritDoc */
		override public function point( x:Number, y:Number, color:uint, alpha:Number ):void 
		{
			if ( _strokeDo ) {
				_gc.lineStyle();
				_gc.beginFill( color, alpha );
				_gc.drawRect( x, y, 1, 1 );
				_gc.endFill();
				_currentStroke.apply(this);
			}else {
				_gc.beginFill( color, alpha );
				_gc.drawRect( x, y, 1, 1 );
				_gc.endFill();
			}
			__x = __startX = x;
			__y = __startY = y;
		}
		
		/** @inheritDoc */
		override public function triangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):void 
		{
			_gc.moveTo( __startX = __x = x0, __startY = __y = y0 );
			_gc.lineTo( x1, y1 );
			_gc.lineTo( x2, y2 );
			_gc.lineTo( __startX, __startY );
		}
		
		/** @inheritDoc */
		override public function quad(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void 
		{
			_gc.moveTo( __startX = __x = x0, __startY = __y = y0 );
			_gc.lineTo( x1, y1 );
			_gc.lineTo( x2, y2 );
			_gc.lineTo( x3, y3 );
			_gc.lineTo( __startX, __startY );
		}
		
		/** @inheritDoc */
		override public function triangleImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			_render_bmp.drawTriangle( _texture, __startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
		}
		
		/** @inheritDoc */
		override public function quadImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{
			if ( _strokeDo ) {
				_gc.lineStyle();
				_render_bmp.drawQuad( _texture, __startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
				_currentStroke.apply( this );
				_gc.moveTo( x0, y0 ); 
				_gc.lineTo( x1, y1 );
				_gc.lineTo( x2, y2 );
				_gc.lineTo( x3, y3 );
				_gc.lineTo( __startX, __startY );
			}else {
				_render_bmp.drawQuad( _texture, __startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
			}
		}
		
		/** @inheritDoc */
		override public function image( matrix:Matrix = null ):void
		{
			_render_bmp.drawImage( _texture, matrix );
			if( matrix!=null ){
				__x = __startX = matrix.tx;
				__y = __startY = matrix.ty;
			}else {
				__x = __startX = 0;
				__y = __startY = 0;
			}
		}
		
		/** @inheritDoc */
		override public function get imageSmoothing():Boolean { return _render_bmp.smoothing; }
		override public function set imageSmoothing(value:Boolean):void 
		{
			_render_bmp.smoothing = value;
		}
		
		/** @inheritDoc */
		override public function get imageDetail():uint { return _render_bmp.detail; }
		override public function set imageDetail(value:uint):void 
		{
			_render_bmp.detail= ( value > 0 ) ? value : 1;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Styles
		//-------------------------------------------------------------------------------------------------------------------
		
		// Stroke
		
		/** @private */
		override protected function _beginCurrentStroke():void 
		{
			_currentStroke.apply( this );
			_strokeDo = true;
		}
		
		/** @inheritDoc */
		override public function beginStroke( st:ICanvasStroke ):void
		{
			(_currentStroke = st).apply( this );
			_stroke_setting = ( st is ICanvasStrokeFill ) ? ICanvasStrokeFill(st).stroke : CanvasStroke(st);
			_strokeDo = _strokeEnabled = true;
		}
		
		/** @inheritDoc */
		override public function endStroke():void 
		{
			_gc.lineStyle();
			_strokeDo = false;
		}
		
		// Fill
		
		/** @private */
		override protected function _beginCurrentFill():void 
		{
			_currentFill.apply( this );
			_fill_apply_count = 1;
			_fillDo = true;
		}
		
		/** @inheritDoc */
		override public function beginFill( fill:ICanvasFill ):void 
		{
			(_currentFill = fill).apply( this );
			_fill_apply_count = 1;
			_fillDo = true;
		}
		
		/** @private */
		override protected function _endFill():void 
		{
			_gc.endFill();
			_fill_apply_count = 0;
			_fillDo = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// CANVAS IMPLEMENTS
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override canvasImpl function noLineStyle():void {
			_gc.lineStyle();
		}
		/** @private */
		override canvasImpl function lineStyle(thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number):void {
			_gc.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		/** @private */
		override canvasImpl function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			_gc.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginSolidFill(color:uint, alpha:Number):void {
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginFill(color, alpha);
		}
		/** @private */
		override canvasImpl function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix, repeat:Boolean, smooth:Boolean):void {
			_gc.moveTo(0,0); //reset point for player 9 bug
			_gc.beginBitmapFill(bitmapData, matrix, repeat, smooth);
		}
		
		//-------------------------------------------------------------------------------------------------------------------
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