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
	import flash.geom.Matrix;
	import frocessing.core.canvas.AbstractCanvas2D;
	import frocessing.core.canvas.CanvasNoStroke;
	import frocessing.core.canvas.CanvasStroke;
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.canvas.ICanvasStroke;
	import frocessing.core.canvas.ICanvasStrokeFill;
	import frocessing.core.graphics.FPathCommand;
	
	/**
	 * CanvasOutput2D.
	 * 
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class CanvasOutput2D extends AbstractCanvas2D
	{
		
		/** @private */
		private var paths:Array;
		/** @private */
		private var commands:Array;
		
		private var _bufferedStroke:ICanvasStroke;
		private var _no_stroke:CanvasNoStroke;
		private var _not_empty_path:Boolean;
		private var _stroke_updated:Boolean;
		private var _buffer_stroke_flg:Boolean;
		
		/** @private */
		protected var _canvasWidth:uint;
		/** @private */
		protected var _canvasHeight:uint;
		/** @private */
		protected var _bgColor:uint;
		/** @private */
		protected var _bgAlpha:Number;
		
		/**
		 * 
		 */
		public function CanvasOutput2D( width:Number, height:Number ) 
		{
			super();
			_canvasWidth  = width;
			_canvasHeight = height;
			_bgColor      = 0xffffff;
			_bgAlpha      = 1;
			
			_no_stroke = new CanvasNoStroke();
			reset();
			clear();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * out put path data. for override
		 * @private
		 */
		protected function _outputPathDataImpl( command:Array, data:Array, stroke:ICanvasStroke, fill:ICanvasFill ):void { ; }
		
		/**
		 * reset data. for override
		 * @private
		 */
		protected function _resetImpl():void { ; }
		
		/**
		 * flush data. for override
		 * @private
		 */
		protected function _flushImpl():void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * flush draw data.
		 */
		public function flush():void 
		{
			terminatePath();
			_flushImpl();
			reset();
		}
		
		/**
		 * clear all draw data.
		 */
		public function reset():void
		{
			initPathData();
			_resetImpl();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw Session
		//-------------------------------------------------------------------------------------------------------------------
		
		private function initPathData():void
		{
			paths = [];
			commands = [];
			_stroke_updated = _strokeDo;//TODO: check this
			_not_empty_path = false;
		}
		
		/** buffer stroke */
		private function bufferStroke():ICanvasStroke
		{
			if( _strokeDo ){
				if ( _stroke_updated ) {
					_bufferedStroke = _currentStroke.clone();
					_stroke_updated = false;
				}
				return _bufferedStroke;
			}else{
				return _no_stroke;
			}
		}
		
		/**
		 * start path buffer
		 */
		private function startPath():void
		{
			initPathData();
			bufferStroke();
			_buffer_stroke_flg = _strokeDo; //for terminatePath()
		}
		
		/**
		 * output path data
		 */
		private function terminatePath():void
		{
			if ( _not_empty_path  ){
				_outputPathDataImpl( commands, paths, (_buffer_stroke_flg) ? _bufferedStroke : _no_stroke, (_fillDo) ? _currentFill : null );
			}
			_not_empty_path = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function moveTo( x:Number, y:Number ):void
		{
			// not start shape session, while fill continue.
			if ( !_fillDo ){
				terminatePath();
				startPath();
			}
			
			paths.push( __x = __startX = x, __y = __startY = y );
			commands.push( FPathCommand.MOVE_TO );
		}
		
		/** @inheritDoc */
		override public function lineTo( x:Number, y:Number ):void
		{
			paths.push( __x = x, __y = y );
			commands.push( FPathCommand.LINE_TO );
			
			//add flag
			_not_empty_path = true;	
		}
		
		/** @inheritDoc */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			paths.push( cx, cy, __x = x, __y = y );
			commands.push( FPathCommand.CURVE_TO );
			
			//add flag
			_not_empty_path = true;	
		}
		
		/** @inheritDoc */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void 
		{
			paths.push( cx0, cy0, cx1, cy1,  __x = x, __y = y );
			commands.push( FPathCommand.BEZIER_TO );
			
			//add flag
			_not_empty_path = true;	
		}
		
		/** @inheritDoc */
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			//convert to bezier
			cx0 = __x + _splineTightness/6 * ( x - cx0 );
			cy0 = __y + _splineTightness/6 * ( y - cy0 );
			cx1 =   x - _splineTightness/6 * ( cx1 - __x );
			cy1 =   y - _splineTightness/6 * ( cy1 - __y );
			bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		/** @inheritDoc */
		override public function closePath():void
		{
			__x = __startX;
			__y = __startY;
			commands.push( FPathCommand.CLOSE_PATH );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Primitive
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function pixel(x:Number, y:Number, color:uint, alpha:Number):void 
		{
			point(x, y, color, alpha);
		}
		
		/** @inheritDoc */
		override public function point( x:Number, y:Number, color:uint, alpha:Number ):void 
		{
			/*
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
			*/
			//TODO:(2) point output
			__x = __startX = x;
			__y = __startY = y;
		}
		
		/** @inheritDoc */
		override public function triangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):void 
		{
			terminatePath();
			_outputPathDataImpl( 
			    [FPathCommand.MOVE_TO, FPathCommand.LINE_TO, FPathCommand.LINE_TO, FPathCommand.CLOSE_PATH],
				[__startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2 ],
				bufferStroke(),
				(_fillDo) ? _currentFill : null
			);
		}
		
		/** @inheritDoc */
		override public function quad(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void 
		{
			terminatePath();
			_outputPathDataImpl( 
				[FPathCommand.MOVE_TO, FPathCommand.LINE_TO, FPathCommand.LINE_TO, FPathCommand.LINE_TO, FPathCommand.CLOSE_PATH],
				[__startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, x3, y3 ],
				bufferStroke(),
				(_fillDo) ? _currentFill : null
			);
		}
		
		/** @inheritDoc */
		override public function triangleImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			//TODO:(2) bitmap output
			//_render_bmp.drawTriangle( _texture, __startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
			triangle( x0, y0, x1, y1, x2, y2 );
		}
		
		/** @inheritDoc */
		override public function quadImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{
			//TODO:(2) bitmap output
			//_render_bmp.drawQuad( _texture, __startX = __x = x0, __startY = __y = y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
			quad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		/** @inheritDoc */
		override public function image( matrix:Matrix = null ):void
		{
			//TODO:(2) bitmap output
			/*
			_render_bmp.drawImage( _texture, matrix );
			if( matrix!=null ){
				__x = __startX = matrix.tx;
				__y = __startY = matrix.ty;
			}else {
				__x = __startX = 0;
				__y = __startY = 0;
			}
			*/
		}
		
		/** @inheritDoc */
		/*
		override public function get imageSmoothing():Boolean { return _render_bmp.smoothing; }
		override public function set imageSmoothing(value:Boolean):void 
		{
			_render_bmp.smoothing = value;
		}
		*/
		
		/** @inheritDoc */
		/*
		override public function get imageDetail():uint { return _render_bmp.detail; }
		override public function set imageDetail(value:uint):void 
		{
			_render_bmp.detail= ( value > 0 ) ? value : 1;
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// Styles
		//-------------------------------------------------------------------------------------------------------------------
		
		// Stroke
		
		/** @private */
		override protected function _beginCurrentStroke():void 
		{
			_strokeDo = true;
		}
		
		/** @inheritDoc */
		override public function beginStroke( st:ICanvasStroke ):void
		{
			_currentStroke = st;
			_stroke_setting = ( st is ICanvasStrokeFill ) ? ICanvasStrokeFill(st).stroke : CanvasStroke(st);
			_strokeDo = _strokeEnabled = _stroke_updated = true;
		}
		
		/** @inheritDoc */
		override public function endStroke():void 
		{
			_strokeDo = false;
		}
		
		// Fill
		
		/** @private */
		override protected function _beginCurrentFill():void 
		{
			terminatePath();
			_fill_apply_count = 1;
			_fillDo = true;
			startPath();
		}
		
		/** @inheritDoc */
		override public function beginFill( fill:ICanvasFill ):void 
		{
			terminatePath();
			_currentFill = fill;
			_fill_apply_count = 1;
			_fillDo = true;
			startPath();
		}
		
		/** @private */
		override protected function _endFill():void 
		{
			if ( _fillDo ){
				terminatePath();
				_fillDo = false;
			}
			_fill_apply_count = 0;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// background
		
		/** @inheritDoc */
		override public function background( width:Number, height:Number, color:uint, alpha:Number ):void 
		{
			//_canvasWidth = uint(width);
			//_canvasHeight = uint(height);
			_bgColor = color;
			_bgAlpha = alpha;
			reset();
		}
		
	}
	
}