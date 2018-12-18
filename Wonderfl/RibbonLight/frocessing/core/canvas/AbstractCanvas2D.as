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
	import flash.geom.Matrix;
	import frocessing.core.F5C;
	
	/**
	 * Abstract Canvas 2D.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class AbstractCanvas2D extends AbstractCanvas implements ICanvas2D
	{
		/*
		 * 拡張する場合は、以下のメソッドを描画ターゲットに合わせて実装します.
		 * 
		 * [AbstractCanvas2D]
		 * moveTo, lineTo, curveTo, bezierTo, splineTo, closePath, path
		 * point, triangle, quad, triangleImage, quadImage, image
		 * pixel
		 * 
		 * [AbstractCanvas]
		 * _beginCurrentStroke, beginStroke, endStroke
		 * _beginCurrentFill, beginFill, _endFill
		 * background
		 * imageSmoothing, imageDetail
		 * 
		 * [CanvasStyleAdapter]
		 * noLineStyle, lineStyle, lineGradientStyle
		 * beginSolidFill, beginBitmapFill, beginGradientFill
		 */
		
		//path status
		/** @private */
		protected var __startX:Number = 0;
		/** @private */
		protected var __startY:Number = 0;
		/** @private */
		protected var __x:Number = 0;
		/** @private */
		protected var __y:Number = 0;
		
		/**
		 * 
		 */
		public function AbstractCanvas2D() 
		{
			super();
		}
		
		/** @inheritDoc */
		override public function clear():void 
		{
			super.clear();
			__x = __y = __startX = __startY = 0;
		}
		
		//------------------------------------------------------------------------------------------------------------------- PATH
		
		/**
		 * 現在の描画位置を (x, y) に移動します.
		 */
		public function moveTo( x:Number, y:Number ):void { ; }
		
		/**
		 * 現在の描画位置から (x, y) まで描画します.
		 */
		public function lineTo( x:Number, y:Number ):void{ ; }
		
		/**
		 * 2次ベジェ曲線を描画します.
		 * @param	cx	control point x
		 * @param	cy	control point y
		 * @param	x	anchor point x
		 * @param	y	anchor point y
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{ ; }
		
		/**
		 * 3次ベジェ曲線を描画します.
		 * @param	cx0	control point x0
		 * @param	cy0	control point y0
		 * @param	cx1	control point x1
		 * @param	cy1 control point y1
		 * @param	x	anchor point x
		 * @param	y	anchor point y
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void{ ; }
		
		/**
		 * スプライン曲線を描画します.
		 * @param	cx0	pre point x
		 * @param	cy0	pre point y
		 * @param	cx1	next point x 
		 * @param	cy1 next point y
		 * @param	x	target point x
		 * @param	y	target point x
		 */
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void{ ; }
		
		/**
		 * 描画しているパスを閉じます.
		 */
		public function closePath():void{ ; }
		
		/**
		 * パス開始座標(X)
		 */
		public function get pathStartX():Number { return __startX; }
		/**
		 * パス開始座標(Y)
		 */
		public function get pathStartY():Number { return __startY; }
		/**
		 * パス座標(X)
		 */
		public function get pathX():Number { return __x; }
		/**
		 * パス座標(Y)
		 */
		public function get pathY():Number { return __y; }
		
		//------------------------------------------------------------------------------------------------------------------- PRIMITIVE
		
		/**
		 * ピクセルを描画します.
		 */
		public function pixel( x:Number, y:Number, color:uint, alpha:Number ):void { ; }
		
		/**
		 * 点を描画します.
		 */
		public function point( x:Number, y:Number, color:uint, alpha:Number ):void { ; }
		
		/**
		 * 三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void { ; }
		
		/**
		 * 四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void { ; }
		
		/**
		 * beginTexture() で指定している texture で三角形を描画します.
		 * uv値は [0.0, 1.0] です.
		 */
		public function triangleImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void { ; }
		
		/**
		 * beginTexture() で指定している texture で四角形を描画します.
		 * uv値は [0.0, 1.0] です.
		 */
		public function quadImage( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void { ; }
		
		/**
		 * beginTexture() で指定している texture を matrix　で変形して描画します.
		 */
		public function image( matrix:Matrix = null ):void { ; }
		
		//------------------------------------------------------------------------------------------------------------------- VERTEX
		
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
		private var _vtu:Array;
		/** @private */
		private var _vtv:Array;
		/** @private */
		private var _cvx:Array;
		/** @private */
		private var _cvy:Array;
		
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
				_svc = 0;
			}
			//if beginTexture() called in beginVertexShape to endVertexShape.
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
		 * @param	u	texture を指定している場合、テクスチャの u 値を指定できます
		 * @param	v	texture を指定している場合、テクスチャの v 値を指定できます
		 */
		public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			_vtx[_vtc] = x;
			_vty[_vtc] = y;
			_vtu[_vtc] = u;
			_vtv[_vtc] = v;
			_vtc++;
			
			var t1:int;
			var t2:int;
			var t3:int;
			
			if ( _mode_POLYGON ) {
				if ( _vtc > 1 || _svc >= 4 ){
					lineTo( x, y );
				}else{
					moveTo( x, y );
				}
				_svc = 0;
			}
			else if ( _mode_TRIANGLES ) {  
				if ( _vtc % 3 == 0 ){
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					if ( _texture_flg ){
						triangleImage( _vtx[t2], _vty[t2], _vtx[t1], _vty[t1], x, y, _vtu[t2], _vtv[t2], _vtu[t1], _vtv[t1], u, v );
					}else {
						beginCurrentFill();
						triangle( _vtx[t2], _vty[t2], _vtx[t1], _vty[t1], x, y );
						endFill();
					}
				}
			}
			else if ( _mode_TRIANGLE_STRIP ) { 
				if ( _vtc >= 3 ){
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					if ( _texture_flg ){
						triangleImage( x, y, _vtx[t1], _vty[t1], _vtx[t2], _vty[t2], u, v, _vtu[t1], _vtv[t1], _vtu[t2], _vtv[t2] );
					}else {
						beginCurrentFill();
						triangle( x, y, _vtx[t1], _vty[t1], _vtx[t2], _vty[t2] );
						endFill();
					}
				}
			}
			else if ( _mode_TRIANGLE_FAN ) { 
				if ( _vtc >= 3 ){
					t1 = _vtc - 2;
					if ( _texture_flg ){
						triangleImage( _vtx[0], _vty[0], _vtx[t1], _vty[t1], x, y, _vtu[0], _vtv[0], _vtu[t1], _vtv[t1], u, v );
					}else {
						beginCurrentFill();
						triangle( _vtx[0], _vty[0], _vtx[t1], _vty[t1], x, y );
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
						quadImage( _vtx[t3], _vty[t3], _vtx[t2], _vty[t2], _vtx[t1], _vty[t1], x, y, _vtu[t3], _vtv[t3], _vtu[t2], _vtv[t2], _vtu[t1], _vtv[t1], u, v );
					}else {
						beginCurrentFill();
						quad( _vtx[t3], _vty[t3], _vtx[t2], _vty[t2], _vtx[t1], _vty[t1], x, y );
						endFill();
					}
				}
			}
			else if ( _mode_QUAD_STRIP ) { 
				if ( _vtc >= 4 && _vtc % 2 == 0 ){
					t1 = _vtc - 2;
					t2 = _vtc - 3;
					t3 = _vtc - 4;
					if ( _texture_flg ){
						quadImage( _vtx[t3], _vty[t3], _vtx[t2], _vty[t2], x, y, _vtx[t1], _vty[t1], _vtu[t3], _vtv[t3], _vtu[t2], _vtv[t2], u, v, _vtu[t1], _vtv[t1] );
					}else {
						beginCurrentFill();
						quad( _vtx[t3], _vty[t3], _vtx[t2], _vty[t2], x, y, _vtx[t1], _vty[t1] );
						endFill();
					}
				}
			}
			else if ( _mode_POINTS ) { 
				point( x, y, _stroke_setting.color, _stroke_setting.alpha );
			}
			else if ( _mode_LINES ) { 
				if ( _vtc % 2 == 0 ) {
					t1 = _vtc - 2;
					moveTo( _vtx[t1], _vty[t1] );
					lineTo( x, y );
				}
			}
		}
		
		/**
		 * Vertex描画 で ベジェ曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			if ( _mode_POLYGON ){
				_vtx[_vtc] = x;
				_vty[_vtc] = y;
				_vtc++;
				_svc = 0;
				bezierTo( cx0, cy0, cx1, cy1, x, y );
			}
		}
		
		/**
		 *　Vertex描画 で スプライン曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function splineVertex( x:Number, y:Number ):void
		{
			if ( _mode_POLYGON ){
				_cvx[_svc] = x;
				_cvy[_svc] = y;
				_svc ++;
				var t1:int = _svc - 2;
				var t3:int = _svc - 4;
				if( _svc>4 ){
					splineTo( _cvx[t3], _cvy[t3], x, y, _cvx[t1], _cvy[t1] );
				}else if ( _svc == 4 ){
					if ( _vtc == 0 ){
						var t2:int = _svc - 3;
						moveTo( _cvx[t2], _cvy[t2] );
					}
					splineTo( _cvx[t3], _cvy[t3], x, y, _cvx[t1], _cvy[t1] );
				}
			}
		}
	}
}