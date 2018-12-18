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

package frocessing.core 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.core.canvas.ICanvas2D;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.NumberMatrix;
	import frocessing.shape.IFShape;
	
	/**
	 * F5Canvas2D クラスは、 Processing 2D の 基本API, 変形API を実装したクラスです.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class F5Canvas2D extends F5Canvas
	{
		// Transfrom
		private var __matrix:FMatrix2D;
		private var __matrix_tmp:Array;
		private var a:Number;
		private var b:Number;
		private var c:Number;
		private var d:Number;
		private var tx:Number;
		private var ty:Number;
		
		//
		private var __invert_x:Number;
		private var __invert_y:Number;
		
		/**
		 * GradientFill, BitmapFill に キャンバスの変形を適用するかを示します.
		 */
		public var transformStyleMatrix:Boolean = true;
		
		/**
		 * 新しい F5Canvas2D クラスのインスタンスを生成します.
		 * 
		 * @param	target	描画対象となる ICanvas2D を指定します
		 */
		public function F5Canvas2D( target:ICanvas2D ) 
		{
			super( target );
			
			//transform 2D
			__matrix     = new FMatrix2D();
			__matrix_tmp = [];
			
			resetMatrix();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画を開始するときに実行します.
		 */
		override public function beginDraw():void
		{
			super.beginDraw();
			resetMatrix();
		}
		
		/**
		 * 描画を終了するときに実行します.
		 */
		override public function endDraw():void
		{
			super.endDraw();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TRANSFORM
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		public function pushMatrix():void
		{
			__matrix_tmp.push( new NumberMatrix( a, b, c, d, tx, ty ) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		public function popMatrix():void
		{
			var mt:NumberMatrix =  __matrix_tmp.pop();
			__matrix.a  = a  = mt.a;
			__matrix.b  = b  = mt.b;
			__matrix.c  = c  = mt.c;
			__matrix.d  = d  = mt.d;
			__matrix.tx = tx = mt.tx;
			__matrix.ty = ty = mt.ty;
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			__matrix.a  = a  = 1.0;
			__matrix.b  = b  = 0.0;
			__matrix.c  = c  = 0.0;
			__matrix.d  = d  = 1.0;
			__matrix.tx = tx = 0.0;
			__matrix.ty = ty = 0.0;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の Transform を行う FMatrix2D を示します.
		 */
		public function get matrix():FMatrix2D { return __matrix;  }
		public function set matrix( value:FMatrix2D ):void
		{
			__matrix.setMatrix( value.a, value.b, value.c, value.d, value.tx, value.ty );
			update_transform();
		}
		
		/**
		 * キャンバス を移動します.
		 */
		public function translate( x:Number, y:Number ):void
		{
			__matrix.prependTranslation( x, y );
			update_transform();
		}
		
		/**
		 * キャンバス を拡大/縮小します.
		 * 
		 * @param	x	x のスケールを指定します. xのみが指定された場合、全体のスケールになります.
		 * @param	y	y のスケールを指定します.
		 */
		public function scale( x:Number, y:Number = NaN ):void
		{
			if ( isNaN(y) )
				__matrix.prependScale( x, x );
			else
				__matrix.prependScale( x, y );
			update_transform();
		}
		
		/**
		 * キャンバス を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			__matrix.prependRotation( angle );
			update_transform();
		}
		
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 * @private
		 */
		public function applyMatrix( a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number ):void
		{
			__matrix.prependMatrix( a, b, c, d, tx, ty );
			update_transform();
		}
		
		/**
		 * 変換 Matrix の行列値を <code>trace</code> します.
		 */
		public function printMatrix():void
		{
			trace( __matrix );
		}
		
		/** @private */
		private function update_transform():void
		{
			a = __matrix.a; b = __matrix.b; c = __matrix.c; d = __matrix.d; tx = __matrix.tx; ty = __matrix.ty;
		}
		
		/** @private */
		private function get untransformed():Boolean
		{
			return a==1 && b==0 && c==0 && d==1 && tx==0 && ty==0;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * 現在の Transform で座標を変換し、その X 座標を返します.
		 * @param	x
		 * @param	y
		 */
		public function screenX( x:Number, y:Number ):Number
		{
			return x * a + y * c + tx;
		}
		
		/**
		 * 現在の Transform で座標を変換し、その Y 座標を返します.
		 * @param	x
		 * @param	y
		 */
		public function screenY( x:Number, y:Number ):Number
		{
			return x * b + y * d + ty;
		}
		
		/** @private */
		private function _invertXY( screenX:Number, screenY:Number ):void 
		{
			var det:Number = a * d - b * c;
			__invert_x = ( screenX * d - screenY * c + (c * ty - d * tx) )/det;
			__invert_y = (-screenX * b + screenY * a + (b * tx - a * ty) )/det;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PATH
		//-------------------------------------------------------------------------------------------------------------------
		
		/** overwrite to transform @private */
		override public function moveTo( x:Number, y:Number, z:Number=0 ):void{
			_c2d.moveTo( x * a + y * c + tx, x * b + y * d + ty );
		}
		
		/** overwrite to transform @private */
		override public function lineTo( x:Number, y:Number, z:Number=0 ):void{
			_c2d.lineTo( x * a + y * c + tx, x * b + y * d + ty );
		}
		
		/** overwrite to transform @private */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{
			_c2d.curveTo( cx * a + cy * c + tx, cx * b + cy * d + ty, x * a + y * c + tx, x * b + y * d + ty );
		}
		
		/** overwrite to transform @private */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void{
			_c2d.bezierTo( cx0 * a + cy0 * c + tx, cx0 * b + cy0 * d + ty,
						 cx1 * a + cy1 * c + tx, cx1 * b + cy1 * d + ty,
						 x * a + y * c + tx, x * b + y * d + ty);
		}
		
		/** overwrite to transform @private */
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_c2d.splineTo( cx0 * a + cy0 * c + tx, cx0 * b + cy0 * d + ty,
						 cx1 * a + cy1 * c + tx, cx1 * b + cy1 * d + ty,
						 x * a + y * c + tx, x * b + y * d + ty);
		}
		
		/** overwrite to transform @private */
		override public function arcCurveTo(x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0):void {
			_invertXY( _c2d.pathX, _c2d.pathY );
			__arcCurve( __invert_x, __invert_y, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		/** overwrite to transform @private */
		override public function point(x:Number, y:Number, z:Number = 0):void {
			_c2d.point( x * a + y * c + tx, x * b + y * d + ty, $stroke.color, $stroke.alpha );
		}
		
		/** overwrite to transform @private */
		override public function pixel(x:Number, y:Number, z:Number = 0):void {
			_c2d.pixel( x * a + y * c + tx, x * b + y * d + ty, $stroke.color, $stroke.alpha );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// VERTEX
		//-------------------------------------------------------------------------------------------------------------------
		
		/** overwrite to transform @private */
		override public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void{
			super.vertex( x * a + y * c + tx, x * b + y * d + ty, u, v );
		}
		
		/** overwrite to transform @private */
		override public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			super.bezierVertex( cx0 * a + cy0 * c + tx, 
								cx0 * b + cy0 * d + ty,
								cx1 * a + cy1 * c + tx,
								cx1 * b + cy1 * d + ty,
								x * a + y * c + tx,
								x * b + y * d + ty );
		}
		
		/** overwrite to transform @private */
		override public function curveVertex( x:Number, y:Number ):void
		{
			super.curveVertex( x * a + y * c + tx, x * b + y * d + ty );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// SHAPE
		//-------------------------------------------------------------------------------------------------------------------
		
		/** overwrite to transform @private */
		override public function shape( s:IFShape, x:Number=NaN, y:Number=NaN, w:Number = NaN, h:Number = NaN ):void
		{
			__push_styles_pre_shape();
			if ( !isNaN(x * y) ){
				pushMatrix();
				if ( w>0 && h>0 ){
					if( _shape_mode==CENTER ){
						x -= w * 0.5;
						y -= h * 0.5;
					}else if ( _shape_mode == CORNERS ){
						w -= x;
						h -= y;
					}
					translate( x, y );
					scale( w / s.width, h / s.height );
				}else if( _shape_mode==CENTER ){
					x -= s.width * 0.5;
					y -= s.height * 0.5;
					translate( x, y );
				}else{
					translate( x, y );
				}
				translate( -s.left, -s.top );
				__shape(s);
				popMatrix();
			}else{
				__shape(s);
			}
			__pop_styles_pre_shape();
		}
		
		/** @private */
		override internal function __shape( s:IFShape ):void 
		{
			if ( s.matrix != null ){
				pushMatrix();
				__matrix.prepend( s.matrix );//apply shape matrix 2d.
				update_transform();
				super.__shape(s);
				popMatrix();
			}else {
				super.__shape(s);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override internal function __image( img:BitmapData, x:Number, y:Number, z:Number, w:Number, h:Number ):void 
		{
			_img_matrix.setMatrix( w / img.width, 0, 0, h / img.height, x, y );
			_img_matrix.appendMatrix( a, b, c, d, tx, ty );
			_c.beginTexture( img );
			_c2d.image( _img_matrix );
			_c.endTexture();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override internal function upadate_draw_matrix( m:Matrix, t:Matrix, a0:Number=1, b0:Number=0, c0:Number=0, d0:Number=1, tx0:Number=0, ty0:Number=0 ):void 
		{
			super.upadate_draw_matrix( m, t, a0, b0, c0, d0, tx0, ty0 );
			if( transformStyleMatrix ){
				m.concat( __matrix );
			}
		}
		
		/**
		 * 現在の Transform を DisplayObject に適用します.
		 * @param	displayObj
		 * @param	x
		 * @param	y
		 */
		/*
		public function applyTransform( displayObj:DisplayObject, x:Number=0, y:Number=0 ):void
		{
			var mt:Matrix = new Matrix();
			mt.translate( x, y );
			mt.concat( __matrix );
			displayObj.transform.matrix = mt;
		}
		*/
		
	}
	
}