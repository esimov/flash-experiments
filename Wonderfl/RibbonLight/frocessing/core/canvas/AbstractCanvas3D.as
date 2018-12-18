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
	import flash.display.BitmapData;
	import frocessing.core.F5C;
	import frocessing.core.canvas.task.*;
	import frocessing.geom.FNumber3D;
	//import frocessing.f3d.lights.F3DLight;
	use namespace canvasImpl;
	/**
	 * Abstract Canvas 3D.
	 * 
	 * @author nutsu
	 * @version 0.6.1
	 */
	public class AbstractCanvas3D extends AbstractCanvas implements ICanvas3D, ICanvasRender
	{
		/*
		 * 拡張する場合は、以下のメソッドを描画ターゲットに合わせて実装します.
		 * 
		 * [AbstractCanvas3D]
		 * pointImpl, pathSegmentImpl, tariangleImpl, triangleImageImpl, rectImageImpl
		 * pixelImpl
		 * 
		 * [AbstractCanvas]
		 * background
		 * 
		 * [CanvasStyleAdapter]
		 * noLineStyle, lineStyle, lineGradientStyle
		 * beginSolidFill, beginBitmapFill, beginGradientFill
		 */
		
		/*
		 *implemented 
		 *[AbstractCanvas] 
		 * _beginCurrentStroke, beginStroke, endStroke
		 * _beginCurrentFill, beginFill, _endFill
		 * imageSmoothing, imageDetail
		 */
		
		//--------------------------------------------------- path
		//path status
		/** @private */
		protected var __startX:Number = 0;
		/** @private */
		protected var __startY:Number = 0;
		/** @private */
		protected var __startZ:Number = 0;
		/** @private */
		protected var __x:Number = 0;
		/** @private */
		protected var __y:Number = 0;
		/** @private */
		protected var __z:Number = 0;
		
		//--------------------------------------------------- projection
		//center coordinates
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		
		//projection
		private var _perspective:Boolean = true;
		private var _focalLength:Number = 400;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _ratioX:Number = 1;
		private var _ratioY:Number = 1;
		
		//--------------------------------------------------- culling
		//culling
		private var _backFaceCulling:Boolean = true;
		
		//texture back
		private var _texture_back:BitmapData;
		
		//--------------------------------------------------- buffer
		//task
		/** @private */
		protected var TASK_DAT:Array;
		/** @private */
		protected var task_count:uint;
		
		//--------------------------------------------------- buffer path
		//path datas
		/** @private */
		protected var paths:Array;
		/** @private */
		protected var commands:Array;
		//
		private var path_count:int;
		private var cmd_count:int;
		
		//current path status
		private var _current_pathIndex:int;  //index of paths
		private var _current_cmdIndex:int;   //index of commands
		private var _current_vertexNum:int;  //vertex count
		private var _current_zSum:Number;    //z sum
		private var _buffer_path_flg:Boolean;//flg for buffer path data.
		private var _not_empty_path:Boolean; //path includes lineTo, curveTo
		private var _path_skiped:Boolean;    //
		
		//path grouping
		private var _path_group:CanvasTaskGroup;
		private var _path_group_flg:Boolean = false;
		
		//--------------------------------------------------- buffer styles
		//flgs
		private var _buffer_stroke_flg:Boolean; //flg of apply stroke to tasks( path ).
		
		//stroke status
		/** @private */
		private var _stroke_updated:Boolean;  //
		//current style for buffer task
		private var _bufferedStroke:ICanvasStroke; //update when path determined.
		
		//--------------------------------------------------- init objects
		//no style
		private var _no_stroke:CanvasNoStroke;
		private var _no_fill:CanvasNoFill;
		
		//
		private var _smoothing:Boolean;
		private var _detail:uint;
		
		//---------------------------------------------------- light test
		//private var _light:F3DLight = new F3DLight();
		//private var _lightDo:Boolean = true;
		
		/**
		 * 
		 */
		public function AbstractCanvas3D() 
		{
			super();
			
			//
			_bufferedStroke = _no_stroke = new CanvasNoStroke();
			_no_fill        = new CanvasNoFill();
			
			//texture
			_smoothing = true;
			_detail = 1;
			
			//
			resetBuffer();
		}
		
		/** @private */
		private function resetBuffer():void 
		{
			//initilize status
			TASK_DAT           = [];
			task_count         = 0;
			
			_stroke_updated    = _strokeDo;
			_fillDo            = false;
			
			//path init
			paths              = [];
			commands           = [];
			path_count         = 0;
			cmd_count          = 0;
			
			//path buf
			_current_pathIndex = 0;
			_current_cmdIndex  = 0;
			_current_vertexNum = 0;
			_current_zSum      = 0;
			_buffer_path_flg   = false;
			_not_empty_path    = false;
			_path_skiped       = false;
		}
		
		/** @inheritDoc */
		override public function clear():void 
		{
			super.clear();
			//path
			__x = __y = __z = __startX = __startY = __startZ = 0;
			_texture_back = null;
			
			resetBuffer();
			
			//if ( _strokeDo ) beginCurrentStroke();
		}
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * projection center X
		 */
		public function get centerX():Number { return _centerX; }
		
		/**
		 * projection center Y
		 */
		public function get centerY():Number { return _centerY; }
		
		/**
		 * is perspective projection.
		 */
		public function get perspective():Boolean { return _perspective; }
		
		/**
		 * focal length.
		 */
		public function get focalLength():Number { return _focalLength; }
		
		/*
		public function set perspective(value:Boolean):void {
			_perspective = value;
			if ( _perspective ) {
				_ratioX = _scaleX*_focalLength;
				_ratioY = _scaleY*_focalLength;
			}else {
				_ratioX = _scaleX;
				_ratioY = _scaleY;
			}
		}
		*/
		
		/**
		 * projection setting
		 * 
		 * @param	perspective		do perspective projection.
		 * @param	centerX			center of projection.
		 * @param	centerY			center of projection.
		 * @param	focalLength		focal length of projection.
		 * @param	scaleX			projection scale.
		 * @param	scaleY			projection scale.
		 */
		public function setProjection( perspective:Boolean, centerX:Number, centerY:Number, focalLength:Number, scaleX:Number=1, scaleY:Number=1 ):void
		{
			_perspective = perspective;
			_centerX     = centerX;
			_centerY     = centerY;
			_focalLength = focalLength;
			_scaleX = _ratioX = scaleX;
			_scaleY = _ratioY = scaleY;
			if ( _perspective ) {
				_ratioX *= _focalLength;
				_ratioY *= _focalLength;
			}
		}
		
		/**
		 * get projection result.
		 */
		public function projectionValue( x:Number, y:Number, z:Number ):FNumber3D {
			if ( _perspective ) {
				return new FNumber3D( x*_ratioX/z + _centerX, y*_ratioY/z + _centerY, z );
			}else {
				return new FNumber3D( x*_ratioX + _centerX, y*_ratioY + _centerY, z );
			}
		}
		
		/**
		 * 
		 */
		public function get backFaceCulling():Boolean { return _backFaceCulling; }
		public function set backFaceCulling(value:Boolean):void {
			_backFaceCulling = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// BUFFER
		//-------------------------------------------------------------------------------------------------------------------
		
		/** buffer stroke session */
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
		 * start shape draw session.
		 * at moveTo, beginFill, beginBitmapFill, beginGradientFill
		 */
		private function startPathSegment():void
		{
			//init path parameters
			_current_pathIndex = path_count;
			_current_cmdIndex  = cmd_count;
			_current_vertexNum = 0;
			_current_zSum      = 0;
			_buffer_path_flg   = true;
			_not_empty_path    = false;
			
			//buffer stroke
			bufferStroke();
			_buffer_stroke_flg = _strokeDo; //for terminatePathSegment()
		}
		
		/**
		 * terminate shape draw session.
		 * @private
		 */
		private function terminatePathSegment():void
		{
			if ( _not_empty_path && _buffer_path_flg )
			{
				var task:CanvasTaskPathSegment = new CanvasTaskPathSegment( _current_cmdIndex, _current_pathIndex, cmd_count - _current_cmdIndex );
				task.z      = _current_zSum / _current_vertexNum;
				task.fill   = ( _fillDo ) ? _currentFill : null;
				task.stroke = ( _buffer_stroke_flg ) ? _bufferedStroke : _no_stroke;
				//append task buffer
				if ( !_path_group_flg ){
					TASK_DAT[task_count] = task;
					task_count++;
				}else{
					_path_group.tasks.push( task );
					_path_group.z += task.z;
				}
			}
			_not_empty_path = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PATH
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の描画位置を (x, y, z) に移動します.
		 */
		public function moveTo( x:Number, y:Number, z:Number ):void 
		{
			// not start shape session, while fill continue.
			if ( !_fillDo ){
				terminatePathSegment();
				startPathSegment(); //START TASK_STROKE 
			}
			
			if ( _perspective ){
				x *= _ratioX/z;
				y *= _ratioY/z;
			}else {
				x *= _ratioX;
				y *= _ratioY;
			}
			__startX = __x = x;
			__startY = __y = y;
			__startZ = __z = z;
			
			//check z out
			if ( z <= 0 ) {
				commands[cmd_count] = 0; //NO_OP
				_buffer_path_flg = !_fillDo;
				_path_skiped = true;
			}else {
				// path coordinates
				paths[ path_count ] = __startX + _centerX; path_count++;
				paths[ path_count ] = __startY + _centerY; path_count++;
				// commands
				commands[cmd_count] = 1; //MOVE_TO
				_path_skiped = false;
			}
			//total command count
			cmd_count++;
			
			//current shape parameter
			_current_vertexNum++;
			_current_zSum += z;
		}
		
		/**
		 * 現在の描画位置から (x, y, z) まで描画します.
		 */
		public function lineTo( x:Number, y:Number, z:Number ):void 
		{
			if ( _perspective ){
				x *= _ratioX/z;
				y *= _ratioY/z;
			}else {
				x *= _ratioX;
				y *= _ratioY;
			}
			__x = x;
			__y = y;
			__z = z;
			//check z out
			if ( z <= 0 ) {
				commands[cmd_count] = 0; //NO_OP
				_buffer_path_flg = !_fillDo;
				_path_skiped = true;
			}else {
				// path coordinates
				paths[ path_count ] = __x + _centerX; path_count++;
				paths[ path_count ] = __y + _centerY; path_count++;
				// commands
				commands[cmd_count] = ( _path_skiped ) ? 1 : 2; //MOVE_TO : LINE_TO
				_path_skiped = false;
			}
			//total command count
			cmd_count++;
			
			//current shape parameter
			_current_vertexNum++;
			_current_zSum += z;
			
			//add flag
			_not_empty_path = true;	
		}
		
		/**
		 * 2次ベジェ曲線を描画します.
		 * @param	cx	control point x
		 * @param	cy	control point y
		 * @param	cz	control point z
		 * @param	x	anchor point x
		 * @param	y	anchor point y
		 * @param	z	anchor point z
		 */
		public function curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void 
		{
			if ( _perspective ){
				cx *= _ratioX/cz;
				cy *= _ratioY/cz;
				x  *= _ratioX/z;
				y  *= _ratioY/z;
			}else {
				cx *= _ratioX;
				cy *= _ratioY;
				x  *= _ratioX;
				y  *= _ratioY;
			}
			__x = x;
			__y = y;
			__z = z;
			
			//check z out
			if ( z <= 0 || cz <= 0 ) {
				commands[cmd_count] = 0; //NO_OP
				_buffer_path_flg = !_fillDo;
				_path_skiped = true;
			}else {
				if ( _path_skiped ) {
					// path coordinates
					paths[ path_count ] = __x + _centerX; path_count++;
					paths[ path_count ] = __y + _centerY; path_count++;
					// commands
					commands[cmd_count] = 1; //MOVE_TO
				}else{
					// path coordinates
					paths.push( cx + _centerX, cy + _centerY, __x + _centerX,  __y + _centerY );
					path_count += 4;
					// commands
					commands[cmd_count] = 3; //CURVE_TO
				}
				_path_skiped = false;
			}
			//total command count
			cmd_count++;
			
			//current shape parameter
			_current_vertexNum++;
			_current_zSum += z;
			
			//add flag
			_not_empty_path = true;
		}
		
		/**
		 * 3次ベジェ曲線を描画します.
		 * @param	cx0	control point x0
		 * @param	cy0	control point y0
		 * @param	cz0	control point z0
		 * @param	cx1	control point x1
		 * @param	cy1 control point y1
		 * @param	cz1 control point z1
		 * @param	x	anchor point x
		 * @param	y	anchor point y
		 * @param	z	anchor point z
		 */
		public function bezierTo( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			//transform to before projected.
			var x0:Number = __x/_ratioX;
			var y0:Number = __y/_ratioY;
			var z0:Number = __z;
			if ( _perspective ){
				x0 *= z0;
				y0 *= z0;
			}
			x0  -= x; y0  -= y; z0  -= z;
			cx0 -= x; cy0 -= y; cz0 -= z;
			cx1 -= x; cy1 -= y; cz1 -= z;
			var k:Number = 1.0/_bezierDetail;
			var t:Number = 0;
			for ( var i:int = 1; i <= _bezierDetail; i++ ){
				t += k;
				lineTo( x0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cx0*t*(1.0 - t)*(1.0 - t) + 3*cx1*t*t*(1.0 - t) + x, 
						y0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cy0*t*(1.0 - t)*(1.0 - t) + 3*cy1*t*t*(1.0 - t) + y,
						z0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cz0*t*(1.0 - t)*(1.0 - t) + 3*cz1*t*t*(1.0 - t) + z );
			}
		}
		
		/**
		 * スプライン曲線を描画します.
		 * @param	cx0	pre point x
		 * @param	cy0	pre point y
		 * @param	cz0	pre point z
		 * @param	cx1	next point x 
		 * @param	cy1 next point y
		 * @param	cz1 next point z
		 * @param	x	target point x
		 * @param	y	target point x
		 * @param	z	target point z
		 */
		public function splineTo( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			//transform to before projected.
			var x0:Number = __x/_ratioX;
			var y0:Number = __y/_ratioY;
			var z0:Number = __z;
			if ( _perspective ){
				x0 *= z0;
				y0 *= z0;
			}
			var k:Number = 1.0 / _splineDetail;
			var t:Number = 0;
			//convert to bezier
			cx0 = x0 + _splineTightness/6 * ( x - cx0 ) - x;
			cy0 = y0 + _splineTightness/6 * ( y - cy0 ) - y;
			cz0 = z0 + _splineTightness/6 * ( z - cz0 ) - z;
			cx1 =    - _splineTightness/6 * ( cx1 - x0 );
			cy1 =    - _splineTightness/6 * ( cy1 - y0 );
			cz1 =    - _splineTightness / 6 * ( cz1 - z0 );
			x0 -= x;
			y0 -= y;
			z0 -= z;
			for ( var i:int = 1; i <= _splineDetail; i++ ){
				t += k;
				lineTo( x0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cx0*t*(1.0 - t)*(1.0 - t) + 3*cx1*t*t*(1.0 - t) + x,
						y0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cy0*t*(1.0 - t)*(1.0 - t) + 3*cy1*t*t*(1.0 - t) + y, 
						z0*(1.0 - t)*(1.0 - t)*(1.0 - t) + 3*cz0*t*(1.0 - t)*(1.0 - t) + 3*cz1*t*t*(1.0 - t) + z );
			}
		}
		
		/**
		 * 描画しているシェイプを閉じます.
		 */
		public function closePath():void
		{
			__x = __startX;
			__y = __startY;
			__z = __startZ;
			//check z out
			if ( __z <= 0 ) {
				commands[cmd_count] = 0; //NO_OP
				_path_skiped = true;
			}else {
				// path coordinates
				paths[ path_count ] = __x + _centerX; path_count++;
				paths[ path_count ] = __y + _centerY; path_count++;
				// commands
				commands[cmd_count] = ( _path_skiped ) ? 1 : 2; //MOVE_TO : LINE_TO
				_path_skiped = false;
			}
			//total command count
			cmd_count++;
		}
		
		/**
		 * begin path group( moveTo,lineTo,curveTo,bezierTo,splineTo ).
		 */
		public function beginPathGroup():void
		{
			if ( _path_group_flg )
				endPathGroup();
			_path_group = new CanvasTaskGroup();
			_path_group_flg = true;
		}
		
		/**
		 * end path group( moveTo,lineTo,curveTo,bezierTo,splineTo ).
		 */
		public function endPathGroup():void
		{
			if( _path_group_flg ){
				terminatePathSegment(); //TODO:(2) check this
				var len:int = _path_group.tasks.length;
				if ( len > 0 ){
					_path_group.z /= len;
					TASK_DAT[task_count] = _path_group;
					task_count++;
				}
				_path_group_flg = false;
			}
		}
		
		/**
		 * パス開始座標(X)
		 */
		public function get pathStartX():Number { return (_perspective) ? __startX*__startZ/_ratioX : __startX/_ratioX; }
		/**
		 * パス開始座標(Y)
		 */
		public function get pathStartY():Number { return (_perspective) ? __startY*__startZ/_ratioY : __startY/_ratioY; }
		/**
		 * パス開始座標(Z)
		 */
		public function get pathStartZ():Number { return __startZ; }
		/**
		 * パス座標(X)
		 */
		public function get pathX():Number { return (_perspective) ? __x*__z/_ratioX : __x/_ratioX; }
		/**
		 * パス座標(Y)
		 */
		public function get pathY():Number { return (_perspective) ? __y*__z/_ratioY : __y/_ratioY; }
		/**
		 * パス座標(Z)
		 */
		public function get pathZ():Number { return __z; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// PRIMITIVE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 点を描画します.
		 */
		public function pixel( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void
		{
			terminatePathSegment();
			// check out of render
			//if ( _strokeDo && z > 0 ){
			if ( z > 0 ){
				if ( _perspective ){
					x *= _ratioX/z;
					y *= _ratioY/z;
				}else {
					x *= _ratioX;
					y *= _ratioY;
				}
				__x = __startX = x;
				__y = __startY = y;
				__z = __startZ = z;
				// add task
				var task:CanvasTaskPixel = new CanvasTaskPixel( x + _centerX, y + _centerY, color, alpha );
				task.z     = z;
				task.stroke = _no_stroke;
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 点を描画します.
		 */
		public function point( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void
		{
			terminatePathSegment();
			// check out of render
			//if ( _strokeDo && z > 0 ){
			if ( z > 0 ){
				if ( _perspective ){
					x *= _ratioX/z;
					y *= _ratioY/z;
				}else {
					x *= _ratioX;
					y *= _ratioY;
				}
				__x = __startX = x;
				__y = __startY = y;
				__z = __startZ = z;
				// add task
				var task:CanvasTaskPoint = new CanvasTaskPoint( x + _centerX, y + _centerY, color, alpha );
				task.z     = z;
				task.stroke = _no_stroke;
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			terminatePathSegment();
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 && z3 > 0 )
			{
				if ( _perspective ){
					x0 *= _ratioX/z0;
					y0 *= _ratioY/z0;
					x1 *= _ratioX/z1;
					y1 *= _ratioY/z1;
					x2 *= _ratioX/z2;
					y2 *= _ratioY/z2;
					x3 *= _ratioX/z3;
					y3 *= _ratioY/z3;
				}else {
					x0 *= _ratioX;
					y0 *= _ratioY;
					x1 *= _ratioX;
					y1 *= _ratioY;
					x2 *= _ratioX;
					y2 *= _ratioY;
					x3 *= _ratioX;
					y3 *= _ratioY;
				}
				__x = __startX = x0;
				__y = __startY = y0;
				__z = __startZ = z0;
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0;
				var v1x:Number = x2 - x0;
				var v1y:Number = y2 - y0;
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				_current_pathIndex = path_count;
				_current_cmdIndex  = cmd_count;
				// path coordinates
				paths.push( x0 + _centerX, y0 + _centerY, x1 + _centerX, y1 + _centerY, x2 + _centerX, y2 + _centerY, x3 + _centerX, y3 + _centerY, x0 + _centerX, y0 + _centerY );
				path_count += 10;
				// commands
				commands.push( 1, 2, 2, 2, 2 );
				cmd_count += 5;
				
				// add task
				var task:CanvasTaskPathSegment = new CanvasTaskPathSegment( _current_cmdIndex, _current_pathIndex, 5 );
				task.z      = (z0 + z1 + z2 + z3) / 4;
				task.stroke = bufferStroke();
				task.fill   = ( _fillDo ) ? _currentFill : null;
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void
		{
			terminatePathSegment();
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 )
			{
				if ( _perspective ){
					x0 *= _ratioX/z0;
					y0 *= _ratioY/z0;
					x1 *= _ratioX/z1;
					y1 *= _ratioY/z1;
					x2 *= _ratioX/z2;
					y2 *= _ratioY/z2;
				}else {
					x0 *= _ratioX;
					y0 *= _ratioY;
					x1 *= _ratioX;
					y1 *= _ratioY;
					x2 *= _ratioX;
					y2 *= _ratioY;
				}
				__x = __startX = x0;
				__y = __startY = y0;
				__z = __startZ = z0;
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0;
				var v1x:Number = x2 - x0;
				var v1y:Number = y2 - y0;
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				// add task
				var task:CanvasTaskTriangle = new CanvasTaskTriangle( x0+_centerX, y0+_centerY, x1+_centerX, y1+_centerY, x2+_centerX, y2+_centerY );
				task.z      = (z0 + z1 + z2) / 3;
				task.stroke = bufferStroke();
				task.fill   = ( _fillDo ) ? _currentFill : null;
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		 
		/**
		 * beginTexture() で指定している texture で三角形を描画します.
		 * uv値は [0.0, 1.0] です.
		 */
		public function triangleImage( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			terminatePathSegment();
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 )
			{
				if ( _perspective ){
					x0 *= _ratioX/z0;
					y0 *= _ratioY/z0;
					x1 *= _ratioX/z1;
					y1 *= _ratioY/z1;
					x2 *= _ratioX/z2;
					y2 *= _ratioY/z2;
				}else {
					x0 *= _ratioX;
					y0 *= _ratioY;
					x1 *= _ratioX;
					y1 *= _ratioY;
					x2 *= _ratioX;
					y2 *= _ratioY;
				}
				__x = __startX = x0;
				__y = __startY = y0;
				__z = __startZ = z0;
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0; 
				var v1x:Number = x2 - x0; 
				var v1y:Number = y2 - y0; 
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				// add task
				var task:CanvasTaskTriangleImage = new CanvasTaskTriangleImage(
					(cross_value>0) ? _texture : _texture_back,
					x0 + _centerX, y0 + _centerY, x1 + _centerX, y1 + _centerY, x2 + _centerX, y2 + _centerY,
					u0, v0, u1, v1, u2, v2, _smoothing );
				task.z      = (z0 + z1 + z2) / 3;
				task.stroke = bufferStroke();
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * beginTexture() で指定している texture で四角形を描画します.
		 * uv値は [0.0, 1.0] です.
		 */
		public function quadImage( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{
			var tmp_stroke:Boolean = _strokeDo;
			_strokeDo = false;// stop stroke.
			
			var u:Number;
			var v:Number;
			
			var v0x0:Number = x0;
			var v0y0:Number = y0;
			var v0z0:Number = z0;
			var v0x1:Number = x1;
			var v0y1:Number = y1;
			var v0z1:Number = z1;
			var v1x0:Number;
			var v1y0:Number;
			var v1z0:Number;
			var v1x1:Number;
			var v1y1:Number;
			var v1z1:Number;
			
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
			var h0z0:Number;
			var h0x1:Number;
			var h0y1:Number;
			var h0z1:Number;
			var h1x0:Number;
			var h1y0:Number;
			var h1z0:Number;
			var h1x1:Number;
			var h1y1:Number;
			var h1z1:Number;
			
			var h0u0:Number;
			var h0v0:Number;
			var h0u1:Number;
			var h0v1:Number;
			var h1u0:Number;
			var h1v0:Number;
			var h1u1:Number;
			var h1v1:Number;
			
			var d:Number = 1 / _detail;
			for( var i:int=1; i<=_detail; i++ )
			{
				v = i * d;
				v1x0 = x0 + (x3 - x0) * v;
				v1y0 = y0 + (y3 - y0) * v;
				v1z0 = z0 + (z3 - z0) * v;
				v1x1 = x1 + (x2 - x1) * v;
				v1y1 = y1 + (y2 - y1) * v;
				v1z1 = z1 + (z2 - z1) * v;
				v1u0 = u0 + (u3 - u0) * v;
				v1v0 = v0 + (v3 - v0) * v;
				v1u1 = u1 + (u2 - u1) * v;
				v1v1 = v1 + (v2 - v1) * v;
				
				h0x0 = v0x0; h0y0 = v0y0; h0z0 = v0z0;
				h0x1 = v1x0; h0y1 = v1y0; h0z1 = v1z0;
				h0u0 = v0u0; h0v0 = v0v0;
				h0u1 = v1u0; h0v1 = v1v0;
				
				for ( var j:int = 1; j <=_detail; j++ )
				{
					u = j * d;
					h1x0 = v0x0 + (v0x1 - v0x0) * u;
					h1y0 = v0y0 + (v0y1 - v0y0) * u;
					h1z0 = v0z0 + (v0z1 - v0z0) * u;
					h1x1 = v1x0 + (v1x1 - v1x0) * u;
					h1y1 = v1y0 + (v1y1 - v1y0) * u;
					h1z1 = v1z0 + (v1z1 - v1z0) * u;
					h1u0 = v0u0 + (v0u1 - v0u0) * u;
					h1v0 = v0v0 + (v0v1 - v0v0) * u;
					h1u1 = v1u0 + (v1u1 - v1u0) * u;
					h1v1 = v1v0 + (v1v1 - v1v0) * u;
					
					triangleImage( h0x0, h0y0, h0z0,  h1x0, h1y0, h1z0,  h0x1, h0y1, h0z1, h0u0, h0v0, h1u0, h1v0, h0u1, h0v1 );
					triangleImage( h1x0, h1y0, h1z0,  h1x1, h1y1, h1z1,  h0x1, h0y1, h0z1, h1u0, h1v0, h1u1, h1v1, h0u1, h0v1 );
					
					h0x0 = h1x0; h0y0 = h1y0; h0z0 = h1z0;
					h0x1 = h1x1; h0y1 = h1y1; h0z1 = h1z1; 
					h0u0 = h1u0; h0v0 = h1v0;
					h0u1 = h1u1; h0v1 = h1v1;
				}
				
				v0x0 = v1x0; v0y0 = v1y0; v0z0 = v1z0;
				v0x1 = v1x1; v0y1 = v1y1; v0z1 = v1z1;
				v0u0 = v1u0; v0v0 = v1v0;
				v0u1 = v1u1; v0v1 = v1v1;
			}
			
			//draw border line.
			if ( tmp_stroke ) {
				_strokeDo = tmp_stroke;
				var tmp:Boolean = _fillDo;
				_fillDo = false;
				quad( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
				_fillDo = tmp;
			}
		}
		
		/**
		 * 
		 */
		public function image2d( x:Number, y:Number, z:Number, w:Number, h:Number, center:Boolean ):void
		{
			terminatePathSegment();
			
			// check out of render
			if ( z > 0 )
			{
				if ( _perspective ){
					x *= _ratioX/z;
					y *= _ratioY/z;
					w *= _ratioX/z;
					h *= _ratioY/z;
				}else {
					x *= _ratioX;
					y *= _ratioY;
					w *= _ratioX;
					h *= _ratioY;
				}
				__x = __startX = x;
				__y = __startY = y;
				__z = __startZ = z;
				if ( center ){
					x -= w * 0.5;
					y -= h * 0.5;
				}
				// add task
				var task:CanvasTaskImage = new CanvasTaskImage( _texture, x + _centerX, y + _centerY, w, h, _smoothing );
				task.z      = z;
				task.stroke = bufferStroke();
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------
		
		
		/**
		 * 
		 */
		public function drawTriangles( vertices:Array, indices:Array, uvData:Array=null ):void
		{			
			var i:int = 0;
			var len:int = indices.length;
			
			var i0:int;
			var i1:int;
			var i2:int;
			var i0y:int;
			var i0z:int;
			var i1y:int;
			var i1z:int;
			var i2y:int;
			var i2z:int;
			
			if ( _texture_flg ){
				var u0:int;
				var u1:int;
				var u2:int;
				var v0:int;
				var v1:int;
				var v2:int;
				for ( i = 0; i < len; i++ ){
					i0 = indices[i]; i++;
					i1 = indices[i]; i++;
					i2 = indices[i];
					u0 = i0 * 2;  v0 = u0 + 1;
					u1 = i1 * 2;  v1 = u1 + 1;
					u2 = i2 * 2;  v2 = u2 + 1;
					i0 *= 3;
					i1 *= 3;
					i2 *= 3;
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					triangleImage( vertices[i0], vertices[i0y], vertices[i0z], vertices[i1], vertices[i1y], vertices[i1z], vertices[i2], vertices[i2y], vertices[i2z], uvData[u0], uvData[v0], uvData[u1], uvData[v1], uvData[u2], uvData[v2] );
				}
			}else{
				for ( i = 0; i < len; i++ ){
					i0 = 3 * indices[i]; i++;
					i1 = 3 * indices[i]; i++;
					i2 = 3 * indices[i];
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					triangle( vertices[i0], vertices[i0y], vertices[i0z], vertices[i1], vertices[i1y], vertices[i1z], vertices[i2], vertices[i2y], vertices[i2z] );
				}
			}
		}
		
		/*
		public function drawMesh( vertices:Array, faces:Array, uvData:Array=null ):void
		{			
			var i:int = 0;
			var len:int = faces.length;
			
			var i0:int;
			var i1:int;
			var i2:int;
			var i0y:int;
			var i0z:int;
			var i1y:int;
			var i1z:int;
			var i2y:int;
			var i2z:int;
			
			if ( _texture_flg ){
				var u0:Number;
				var u1:Number;
				var u2:Number;
				var v0:Number;
				var v1:Number;
				var v2:Number;
				for ( i = 0; i < len; i++ ){
					i0 = faces[i]; 
					u0 = uvData[int(i * 2)];
					v0 = uvData[int(i * 2 + 1)];
					i++;
					i1 = faces[i]; 
					u1 = uvData[int(i * 2)];
					v1 = uvData[int(i * 2 + 1)];
					i++;
					i2 = faces[i];
					u2 = uvData[int(i * 2)];
					v2 = uvData[int(i * 2 + 1)];
					i0 *= 3;
					i1 *= 3;
					i2 *= 3;
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					triangleImage( vertices[i0], vertices[i0y], vertices[i0z], vertices[i1], vertices[i1y], vertices[i1z], vertices[i2], vertices[i2y], vertices[i2z], u0, v0, u1, v1, u2, v2 );
				}
			}else{
				for ( i = 0; i < len; i++ ){
					i0 = 3 * faces[i]; i++;
					i1 = 3 * faces[i]; i++;
					i2 = 3 * faces[i];
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					triangle( vertices[i0], vertices[i0y], vertices[i0z], vertices[i1], vertices[i1y], vertices[i1z], vertices[i2], vertices[i2y], vertices[i2z] );
				}
			}
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// VERTEX
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		private var _mode_POLYGON:Boolean;
		/** @private */
		private var _mode_POINTS:Boolean;
		/** @private */
		private var _mode_LINES:Boolean;;
		/** @private */
		private var _mode_TRIANGLES:Boolean;;
		/** @private */
		private var _mode_TRIANGLE_FAN:Boolean;;
		/** @private */
		private var _mode_TRIANGLE_STRIP:Boolean;;
		/** @private */
		private var _mode_QUADS:Boolean;;
		/** @private */
		private var _mode_QUAD_STRIP:Boolean;;
		
		// Vertex Status
		/** @private */
		private var _vtc:int; //vertex count
		/** @private */
		private var _svc:int; //curve(spline) vertex count
		/** @private */
		private var _vertex_end_texture_flg:Boolean;
		
		/** @private */
		private var _vtx:Array;
		/** @private */
		private var _vty:Array;
		/** @private */
		private var _vtz:Array;
		/** @private */
		private var _vtu:Array;
		/** @private */
		private var _vtv:Array;
		/** @private */
		private var _cvx:Array;
		/** @private */
		private var _cvy:Array;
		/** @private */
		private var _cvz:Array;
		
		/**
		 * Vertex描画 を 開始します.
		 * <p>modeを省略した場合は、POLYGON描画となります.</p>
		 * 
		 * <p>以下のモードでは、beginTexture() で　指定している texture が有効になります.</p>
		 * <ul>
		 * <li>TRIANGLES</li><li>TRIANGLE_FAN</li><li>TRIANGLE_STRIP</li><li>QUADS</li><li>QUAD_STRIP</li>
		 * </ul>
		 * 
		 * @param	mode	 POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP
		 * @see frocessing.core.constants.F5VertexMode
		 */
		public function beginVertexShape(mode:int = 0):void 
		{
			_vtc = 0;
			_vtx = [];
			_vty = [];
			_vtz = [];
			_vtu = [];
			_vtv = [];
			_mode_POLYGON        = ( mode == 0 );
			_mode_TRIANGLES      = ( mode == F5C.TRIANGLES );
			_mode_TRIANGLE_STRIP = ( mode == F5C.TRIANGLE_STRIP );
			_mode_TRIANGLE_FAN   = ( mode == F5C.TRIANGLE_FAN );
			_mode_QUADS 		 = ( mode == F5C.QUADS );
			_mode_QUAD_STRIP     = ( mode == F5C.QUAD_STRIP );
			_mode_POINTS         = ( mode == F5C.POINTS );
			_mode_LINES          = ( mode == F5C.LINES );
			if ( _mode_POLYGON ) {
				_svc = 0;
				_cvx = [];
				_cvy = [];
				_cvz = [];
				beginCurrentFill();
			}
			_vertex_end_texture_flg = !_texture_flg;
		}
		
		/**
		 * Vertex描画 を 終了します.
		 * <p>beginVertexShape()、endVertexShape() の間で beginTexture() を行った場合、endTexture() が 実行されます.</p>
		 * 
		 * @param	close_path	POLYGONモードで描画した場合、パスを閉じるかどうかを指定できます.
		 */
		public function endVertexShape( close_path:Boolean=false ):void
		{
			if ( _mode_POLYGON ){
				if ( close_path )
					closePath();
				endFill();
			}
			if ( _texture_flg && _vertex_end_texture_flg ){
				endTexture();
			}
			_vtc = _svc = 0;
			_mode_POLYGON = _mode_POINTS = _mode_TRIANGLES = _mode_TRIANGLE_FAN = _mode_TRIANGLE_STRIP = _mode_QUADS = _mode_QUAD_STRIP = false;
		}
		
		/**
		 * Vertex描画 で 座標を追加します.
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	u	texture を指定している場合、テクスチャの u 値を指定できます
		 * @param	v	texture を指定している場合、テクスチャの v 値を指定できます
		 */
		public function vertex( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void
		{
			_vtx[_vtc] = x;
			_vty[_vtc] = y;
			_vtz[_vtc] = z;
			_vtu[_vtc] = u;
			_vtv[_vtc] = v;
			_vtc++;
			
			var t1:int;
			var t2:int;
			var t3:int;
			
			if ( _mode_POLYGON ) {
				if ( _vtc > 1 || _svc >= 4 )
					lineTo( x, y, z );
				else
					moveTo( x, y, z );
				_svc = 0;
			}
			else if ( _mode_TRIANGLES ) {
				if ( _vtc % 3 == 0 ){
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					if ( _texture_flg ){
						triangleImage( _vtx[t2], _vty[t2], _vtz[t2], _vtx[t1], _vty[t1], _vtz[t1], x, y, z, _vtu[t2], _vtv[t2], _vtu[t1], _vtv[t1], u, v );
					}else {
						beginCurrentFill();
						triangle( _vtx[t2], _vty[t2], _vtz[t2], _vtx[t1], _vty[t1], _vtz[t1], x, y, z );
						endFill();
					}
				}
			}
			else if ( _mode_TRIANGLE_STRIP ) {
				if ( _vtc >= 3 ){
					if ( _vtc % 2 ){
						t1 = _vtc - 2;
						t2 = _vtc - 3;
					}else{
						t2 = _vtc - 2;
						t1 = _vtc - 3;
					}
					if ( _texture_flg ){
						triangleImage( _vtx[t2], _vty[t2], _vtz[t2], x, y, z, _vtx[t1], _vty[t1], _vtz[t1], _vtu[t2], _vtv[t2], u, v, _vtu[t1], _vtv[t1]);
					}else {
						beginCurrentFill();
						triangle( _vtx[t2], _vty[t2], _vtz[t2], x, y, z, _vtx[t1], _vty[t1], _vtz[t1] );
						endFill();
					}
				}
			}
			else if ( _mode_TRIANGLE_FAN ) {
				if ( _vtc >= 3 ){
					t1 = _vtc - 2;
					if ( _texture_flg ){
						triangleImage( _vtx[0], _vty[0], _vtz[0], _vtx[t1], _vty[t1], _vtz[t1], x, y, z, _vtu[0], _vtv[0], _vtu[t1], _vtv[t1], u, v );
					}else{
						beginCurrentFill();
						triangle( _vtx[0], _vty[0], _vtz[0], _vtx[t1], _vty[t1], _vtz[t1], x, y, z );
						endFill();
					}
				}
			}
			else if ( _mode_QUADS ) {
				if ( _vtc % 4 == 0 ){
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					t3 = _vtc - 4;
					if ( _texture_flg ){
						quadImage( _vtx[t3], _vty[t3], _vtz[t3], _vtx[t2], _vty[t2], _vtz[t2], _vtx[t1], _vty[t1], _vtz[t1], x, y, z, _vtu[t3], _vtv[t3], _vtu[t2], _vtv[t2], _vtu[t1], _vtv[t1], u, v );
					}else {
						beginCurrentFill();
						quad( _vtx[t3], _vty[t3], _vtz[t3], _vtx[t2], _vty[t2], _vtz[t2], _vtx[t1], _vty[t1], _vtz[t1], x, y, z );
						endFill();
					}
				}
			}
			else if ( _mode_QUAD_STRIP ) {
				if ( _vtc >= 4 && _vtc % 2 == 0 )
				{
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					t3 = _vtc - 4;
					if ( _texture_flg ){
						quadImage( _vtx[t3], _vty[t3], _vtz[t3], _vtx[t2], _vty[t2], _vtz[t2], x, y, z, _vtx[t1], _vty[t1], _vtz[t1], _vtu[t3], _vtv[t3], _vtu[t2], _vtv[t2], u, v, _vtu[t1], _vtv[t1] );
					}else {
						beginCurrentFill();
						quad( _vtx[t3], _vty[t3], _vtz[t3], _vtx[t2], _vty[t2], _vtz[t2], x, y, z, _vtx[t1], _vty[t1], _vtz[t1] );
						endFill();
					}
				}
			}
			else if ( _mode_POINTS ) {
				point( x, y, z, _stroke_setting.color, _stroke_setting.alpha );
			}
			else if ( _mode_LINES ) {
				if ( _vtc % 2 == 0 ){
					t1 = _vtc - 2;
					moveTo( _vtx[t1], _vty[t1], _vtz[t1] );
					lineTo( x, y, z );
				}
			}
		}
		
		/**
		 * Vertex描画 で ベジェ曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			if ( _mode_POLYGON ){
				_vtx[_vtc] = x;
				_vty[_vtc] = y;
				_vtz[_vtc] = z;
				_vtc++;
				_svc = 0;
				bezierTo( cx0, cy0, cz0, cx1, cy1, cz1, x, y, z );
			}
		}
		
		/**
		 *　Vertex描画 で スプライン曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function splineVertex( x:Number, y:Number, z:Number ):void
		{
			if ( _mode_POLYGON ){
				_cvx[_svc] = x;
				_cvy[_svc] = y;
				_cvz[_svc] = z;
				_svc++;
				var t1:int = _svc - 2;
				var t3:int = _svc - 4;
				if( _svc>4 ){
					splineTo( _cvx[t3], _cvy[t3], _cvz[t3], x, y, z, _cvx[t1], _cvy[t1], _cvz[t1] );
				}else if ( _svc == 4 ){
					if ( _vtc == 0 ) {
						var t2:int = _svc - 3;
						moveTo( _cvx[t2], _cvy[t2], _cvz[t2] );
					}
					splineTo( _cvx[t3], _cvy[t3], _cvz[t3], x, y, z, _cvx[t1], _cvy[t1], _cvz[t1] );
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// render
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function render():void
		{
			// add last buffer
			terminatePathSegment();
			
			TASK_DAT.sortOn("z", Array.DESCENDING | Array.NUMERIC );
			
			//start render
			noLineStyle();
			var task:CanvasTask;
			var tmp_stroke:ICanvasStroke;
			for ( var i:int = 0; i < task_count; i++ ){	
				task = TASK_DAT[i];
				if ( task is CanvasTaskGroup ) {
					var subtask:Array = CanvasTaskGroup(task).tasks;
					var len:int = subtask.length;
					for ( var j:int = 0; j < len; j++ ) {
						task = subtask[j];
						if ( task.stroke != tmp_stroke ) {
							( tmp_stroke = task.stroke ).apply( this );
						}
						if ( task.fill != null ) {
							task.fill.apply( this );
							task.render(this);
							endFillImpl();
						}else {
							task.render(this);
						}
					}
				}else {
					if ( task.stroke != tmp_stroke ) {
						( tmp_stroke = task.stroke ).apply( this );
					}
					if ( task.fill != null ) {
						task.fill.apply( this );
						task.render(this);
						endFillImpl();
					}else {
						task.render(this);
					}
					
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		// Stroke
		
		/** @private */
		override protected function _beginCurrentStroke():void 
		{
			_strokeDo = true;
		}
		
		/** @inheritDoc */
		override public function beginStroke( stroke:ICanvasStroke ):void 
		{
			_currentStroke = stroke;
			_stroke_setting = ( stroke is ICanvasStrokeFill ) ? ICanvasStrokeFill(stroke).stroke : CanvasStroke(stroke);
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
			terminatePathSegment();
			_fill_apply_count = 1;
			_fillDo = true;
			startPathSegment();
		}
		
		/** @inheritDoc */
		override public function beginFill( fill:ICanvasFill ):void 
		{
			terminatePathSegment();
			_currentFill = fill.clone();
			_fill_apply_count = 1;
			_fillDo = true;
			startPathSegment();
		}
		
		/** @inheritDoc */
		override public function set currentFill(fill:ICanvasFill):void {
			_currentFill = fill.clone();
			_fillEnabled = true;
		}
		
		/** @private */
		override protected function _endFill():void
		{
			if ( _fillDo ){
				terminatePathSegment();
				_fillDo = false;
			}
			_fill_apply_count = 0;
		}
		
		// Texture
		
		/** @inheritDoc */
		public function beginTextures( texture:BitmapData, backfaceTexture:BitmapData ):void 
		{
			_texture      = texture;
			_texture_back = backfaceTexture;
			_texture_flg  = true;
		}
		
		/** @inheritDoc */
		override public function beginTexture(texture:BitmapData):void 
		{
			_texture = _texture_back = texture;
			_texture_flg  = true;
		}
		
		/** @inheritDoc */
		override public function endTexture():void
		{
			_texture_flg  = false;
			_texture      = null;
			_texture_back = null;
		}
		
		/** @inheritDoc */
		override public function get imageSmoothing():Boolean { return _smoothing; }
		override public function set imageSmoothing(value:Boolean):void {
			_smoothing = value;
		}
		
		/** @inheritDoc */
		override public function get imageDetail():uint { return _detail; }
		override public function set imageDetail(value:uint):void {
			_detail= ( value > 0 ) ? value : 1;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Impliments
		//-------------------------------------------------------------------------------------------------------------------
		/** @private */
		protected function endFillImpl():void { ; }
		/** @private */
		canvasImpl function pixelImpl( x:Number, y:Number, color:uint, alpha:Number ):void { ; }
		/** @private */
		canvasImpl function pointImpl( x:Number, y:Number, color:uint, alpha:Number ):void { ; }
		/** @private */
		canvasImpl function pathSegmentImpl( commandIndex:int, pathIndex:int, commandNum:int ):void { ; }
		/** @private */
		canvasImpl function triangleImpl( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void { ; }
		/** @private */
		canvasImpl function triangleImageImpl( img:BitmapData, x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, smooth:Boolean ):void { ; }
		/** @private */
		canvasImpl function rectImageImpl( img:BitmapData, x:Number, y:Number, width:Number, height:Number, smooth:Boolean ):void { ; }
	}
	
}