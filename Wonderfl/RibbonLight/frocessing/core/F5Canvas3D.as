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
	
	import frocessing.core.canvas.ICanvas3D;
	import frocessing.geom.FNumber3D;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.FMatrix3D;
	import frocessing.geom.NumberMatrix3D;
	import frocessing.f3d.F3DCamera;
	import frocessing.f3d.F3DObject;
	import frocessing.shape.IFShape;
	import frocessing.core.F5C;
	
	/**
	 * F5Canvas3D クラスは、 Processing 3D の 基本API, 変形API を実装したクラスです.
	 * 
	 * @author nutsu
	 * @version 0.6.1
	 */
	public class F5Canvas3D extends AbstractF5Canvas
	{
		/** @private */
		internal var _c3d:ICanvas3D;
		
		/** @private */
		internal var half_width:Number;
		/** @private */
		internal var half_height:Number;
		
		//Transform ------------------------------
		private var __matrix:FMatrix3D;
		private var __matrix_tmp:Array;
		
		private var m11:Number;
		private var m12:Number;
		private var m13:Number;
		private var m21:Number;
		private var m22:Number;
		private var m23:Number;
		private var m31:Number;
		private var m32:Number;
		private var m33:Number;
		private var tx:Number;
		private var ty:Number;
		private var tz:Number;
		
		//Camera , Projection ------------------------------
		/** @private */
		private var _cameraObject:F3DCamera;
		private var camera_setting:Boolean;
		
		//Sphere ------------------------------
		private var sphere_segments:uint;
		
		//Fill Matrix -------------------------
		public var transformStyleMatrix:Boolean = true;
		private var _stylematrix:Matrix;
		/**
		 * 
		 */
		public function F5Canvas3D( target:ICanvas3D, width:Number, height:Number ) 
		{
			super( _c3d = target );
			
			// init canvas size
			_width      	= width;
			_height     	= height;
			half_width  	= _width * 0.5;
			half_height 	= _height * 0.5;
			
			// camrea and projection
			_cameraObject   = new F3DCamera( _width, _height );
			camera_setting 	= false;
			
			// init g3d value
			init_c3d_projection();
			
			// transfrom init
			resetMatrix();
			__matrix_tmp  = [];
			
			// init sphere
			sphereDetail(12);
			
			//
			_stylematrix    = new Matrix();
		}
		
		/** @inheritDoc */
		override public function size(width:uint, height:uint):void 
		{
			if( _width != width || _height != height ){
				// init canvas size
				super.size( width, height ); //set _width, _height
				half_width  = _width * 0.5;
				half_height = _height * 0.5;
				
				// init camera and projection
				_cameraObject.setScreenSize( _width, _height );
				
				// reset g3d value
				init_c3d_projection();
				
				// reset transform
				resetMatrix();
			}
		}
		
		/**
		 * 描画を開始するときに実行します.
		 */
		override public function beginDraw():void
		{
			clear();
			resetMatrix();
			camera_setting = false;
			//_c3d.perspective = _cameraObject.isPerspective; //TODO:(2) check 3d begindraw
			//_c3d.zNear       = _cameraObject.zNear;
			//gc3d.beginDraw( pers_projection );
			/*
			if ( gc3d.__$stroke )
				gc3d.updateStroke();
			*/
		}
		
		/**
		 * 描画を終了するときに実行します.実際の描画は endDraw() 後に実行されます.
		 */
		override public function endDraw():void
		{
			super.endDraw();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TRANSFORM
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の Transform を行う FMatrix3D を示します.
		 */
		public function get matrix():FMatrix3D { return __matrix;  }
		public function set matrix( value:FMatrix3D ):void {
			__matrix = _cameraObject.matrix;
			__matrix.prependMatrix( value.m11, value.m12, value.m13, value.m21, value.m22, value.m23, value.m31, value.m32, value.m33, value.m41, value.m42, value.m43 );
			update_transform();
		}
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		public function pushMatrix():void
		{
			__matrix_tmp.push( new NumberMatrix3D(m11,m12,m13,m21,m22,m23,m31,m32,m33,tx,ty,tz) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		public function popMatrix():void
		{
			__applyMatrixParam( __matrix_tmp.pop() );
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			__matrix = _cameraObject.matrix;
			update_transform();
		}
		
		/** @private */
		private function __applyMatrixParam( mt:NumberMatrix3D ):void
		{
			__matrix.m11 = m11 = mt.m11;
			__matrix.m12 = m12 = mt.m12;
			__matrix.m13 = m13 = mt.m13;
			__matrix.m21 = m21 = mt.m21;
			__matrix.m22 = m22 = mt.m22;
			__matrix.m23 = m23 = mt.m23;
			__matrix.m31 = m31 = mt.m31;
			__matrix.m32 = m32 = mt.m32;
			__matrix.m33 = m33 = mt.m33;
			__matrix.m41 = tx  = mt.m41;
			__matrix.m42 = ty  = mt.m42;
			__matrix.m43 = tz  = mt.m43;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画する Graphics を移動します.
		 * beginCamera()の後では、カメラの移動になります.
		 */
		public function translate( x:Number, y:Number, z:Number=0.0 ):void
		{
			if ( !camera_setting ){
				__matrix.prependTranslation( x, y, z );
				update_transform();
			}else{
				_cameraObject.translate( x, y, z );
			}
		}
		
		/**
		 * 描画する Graphics を拡大/縮小します.
		 * 
		 * @param	x	x のスケールを指定します. xのみが指定された場合、全体のスケールになります.
		 * @param	y	y のスケールを指定します.
		 * @param	z	z のスケールを指定します.
		 */
		public function scale( x:Number, y:Number=NaN, z:Number=1.0 ):void
		{
			if ( !camera_setting ){
				if ( isNaN(y) )
					__matrix.prependScale( x, x, x );
				else
					__matrix.prependScale( x, y, z );
				update_transform();
			}
		}
		
		/**
		 * 描画する Graphics を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			rotateZ( angle );
		}
		
		/**
		 * 描画する Graphics をX軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateX( angle:Number ):void
		{
			if ( !camera_setting ){
				__matrix.prependRotationX( -angle );//TODO:mirror mat
				update_transform();
			}else{
				_cameraObject.rotateX( angle );
			}
		}
		
		/**
		 * 描画する Graphics をY軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateY( angle:Number ):void
		{
			if ( !camera_setting ){
				__matrix.prependRotationY( -angle );
				update_transform();
			}else{
				_cameraObject.rotateY( angle );
			}
		}
		
		/**
		 * 描画する Graphics をZ軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateZ( angle:Number ):void
		{
			if ( !camera_setting ){
				__matrix.prependRotationZ( -angle );
				update_transform();
			}else{
				_cameraObject.rotateZ( angle );
			}
		}
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 * @private
		 */
		public function applyMatrix(m11:Number, m12:Number, m13:Number, m21:Number, m22:Number, m23:Number, m31:Number, m32:Number, m33:Number, m41:Number, m42:Number, m43:Number):void
		{
			__matrix.prependMatrix( m11,m12,m13, m21,m22,m23, m31,m32,m33, m41,m42,m43);
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
			m11 = __matrix.m11;
			m12 = __matrix.m12;
			m13 = __matrix.m13;
			m21 = __matrix.m21;
			m22 = __matrix.m22;
			m23 = __matrix.m23;
			m31 = __matrix.m31;
			m32 = __matrix.m32;
			m33 = __matrix.m33;
			tx  = __matrix.m41;
			ty  = __matrix.m42;
			tz  = __matrix.m43;
		}
		
		/*
		private function get untransformed():Boolean
		{
			return m11==1 && m12==0 && m13==0 && m21==0 && m22==1 && m23==0 && m31==0 && m32==0 && m33==1 && tx==0 && ty==0 && tz==0;
		}
		*/
		
		//------------------------------------------------------------------------------------------------------------------- COORDINATES
		
		/** @private */
		private function getX( x:Number, y:Number, z:Number ):Number{
			return x * m11 + y * m21 + z * m31 + tx;
		}
		
		/** @private */
		private function getY( x:Number, y:Number, z:Number ):Number{
			return x * m12 + y * m22 + z * m32 + ty;
		}
		
		/** @private */
		private function getZ( x:Number, y:Number, z:Number ):Number{
			return x * m13 + y * m23 + z * m33 + tz;
		}
		
		/** @private */
		private function getX0( x:Number, y:Number ):Number{
			return x * m11 + y * m21 + tx;
		}
		
		/** @private */
		private function getY0( x:Number, y:Number ):Number{
			return x * m12 + y * m22 + ty;
		}
		
		/** @private */
		private function getZ0( x:Number, y:Number ):Number{
			return x * m13 + y * m23 + tz;
		}
		
		/**
		 * スクリーン上の座標を返します.
		 */
		public function screenXYZ( x:Number, y:Number, z:Number ):FNumber3D
		{
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			return _c3d.projectionValue( xx, yy, zz );
		}
		
		/**
		 * ススクリーン上の x 座標を返します.
		 */
		public function screenX( x:Number, y:Number, z:Number ):Number
		{
			return screenXYZ(x, y, z).x;
		}
		
		/**
		 * スクリーン上の y 座標を返します.
		 */
		public function screenY( x:Number, y:Number, z:Number ):Number
		{
			return screenXYZ(x, y, z).y;
		}
		
		/**
		 * スクリーン上の z 座標を返します.
		 */
		public function screenZ( x:Number, y:Number, z:Number ):Number
		{
			return getZ( x, y, z );
		}
		
		/**
		 * Transformを適用した座標を返します.
		 */
		public function modelXYZ( x:Number, y:Number, z:Number ):FNumber3D
		{
			var m:FMatrix3D = _cameraObject.inversion;
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			return new FNumber3D( xx * m.m11 + yy * m.m21 + zz * m.m31 + m.m41,
								  xx * m.m12 + yy * m.m22 + zz * m.m32 + m.m42,
								  xx * m.m13 + yy * m.m23 + zz * m.m33 + m.m43 );
		}
		
		/**
		 * Transformを適用した x 座標を返します.
		 */
		public function modelX( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).x;
		}
		
		/**
		 * Transformを適用した y 座標を返します.
		 */
		public function modelY( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).y;
		}
		
		/**
		 * Transformを適用した z 座標を返します.
		 */
		public function modelZ( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).z;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// CAMERA
		//-------------------------------------------------------------------------------------------------------------------
		
		private function init_c3d_projection():void
		{
			_c3d.setProjection(
				_cameraObject.isPerspective,
				half_width + _cameraObject.projectionOffsetX,
				half_height + _cameraObject.projectionOffsetY,
				_cameraObject.focalLength,
				_cameraObject.projectionScaleX,
				_cameraObject.projectionScaleY
			);
		}
		
		/**
		* 透視投影変換(パースペクティブ)でプロジェクションを設定します.
		* @param	fov		field-of-view angle (in radians) for vertical direction
		* @param	aspect	ratio of width to height
		* @param	near	z-position of nearest clipping plane
		* @param	far	z-position of nearest farthest plane (今は使っていない)
		*/
		public function perspective( fov:Number=NaN, aspect:Number=NaN, near:Number=NaN, far:Number=NaN ):void
		{
			_cameraObject.perspective( fov, aspect, near, far );
			init_c3d_projection();
			resetMatrix();
		}
		
		/**
		 * 透視投影変換でプロジェクションを設定します.
		 * @param	left
		 * @param	right
		 * @param	bottom
		 * @param	top
		 * @param	near
		 * @param	far		z far (今は使っていない)
		 */
		public function frustum(left:Number, right:Number, bottom:Number, top:Number, near:Number=NaN, far:Number=NaN ):void
		{
			_cameraObject.frustum(left, right, bottom, top, near, far);
			init_c3d_projection();
			resetMatrix();
		}
		
		/**
		 * 平行投影変換でプロジェクションを設定します.
		 * @param	left	default 0
		 * @param	right	default width
		 * @param	bottom	default 0
		 * @param	top		default height
		 * @param	near	default -10
		 * @param	far		default 10
		 */
		public function ortho(left:Number=NaN, right:Number=NaN, bottom:Number=NaN, top:Number=NaN, near:Number=NaN, far:Number=NaN):void
		{
			_cameraObject.ortho( left, right, bottom, top, near, far );
			init_c3d_projection();
			resetMatrix();
		}
		
		public function get cameraX():Number { return _cameraObject.x; }
		public function get cameraY():Number { return _cameraObject.y; }
		public function get cameraZ():Number { return _cameraObject.z; }
		
		/**
		* カメラを設定します.
		* @param	eyeX	カメラの座標 x
		* @param	eyeY	カメラの座標 y
		* @param	eyeZ	カメラの座標 z
		* @param	centerX	中心座標 x
		* @param	centerY	中心座標 y
		* @param	centerZ	中心座標 y
		* @param	upX		カメラ姿勢ベクトル x
		* @param	upY		カメラ姿勢ベクトル y
		* @param	upZ		カメラ姿勢ベクトル z
		*/
		public function camera( eyeX:Number=NaN, eyeY:Number=NaN, eyeZ:Number=NaN, centerX:Number=NaN, centerY:Number=NaN, centerZ:Number=NaN, upX:Number=0, upY:Number=1, upZ:Number=0 ):void
		{
			_cameraObject.camera( eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ );
			resetMatrix();
		}
		
		/**
		 * 
		 */
		public function beginCamera():void
		{
			if ( camera_setting == false )
				camera_setting = true;
		}
		
		/**
		 * 
		 */
		public function endCamera():void
		{
			if ( camera_setting ){
				camera_setting = false;
				resetMatrix();
			}
		}
		
		/**
		 * カメラの Matrix を trace() します.
		 */
		public function printCamera():void
		{
			trace( _cameraObject.cameraMatrix );
		}
		
		/**
		 * プロジェクションの Matrix を trace() します.
		 */
		public function printProjection():void
		{
			trace( _cameraObject.projectionMatrix );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 3D PRIMITIVE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function model( modelObject:F3DObject ):void
		{
			modelObject.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, tx, ty, tz );
			var tmp_culling:Boolean = _c3d.backFaceCulling;
			if ( _textureDo ){
				modelObject.draw( _c3d );
				_c.endTexture();
				_textureDo = false;
			}else{
				_c.beginCurrentFill();
				modelObject.draw( _c3d );
				_c.endFill();
			}
			_c3d.backFaceCulling = tmp_culling;
		}
		
		/**
		 * 立方体を描画します.
		 * 
		 * box(size) or box( width, height, depth );
		 * 
		 * @param	w	size or width
		 * @param	h	height
		 * @param	d	depth
		 */
		public function box( w:Number, h:Number=NaN ,d:Number=NaN, x:Number=0, y:Number=0, z:Number=0 ):void
		{
			w *= 0.5;
			if( isNaN(h) ){
				h = w;
				d = w;
			}else{
				h *= 0.5;
				d *= 0.5;
			}
			
			var x0:Number = getX( x-w, y-h, z+d );
			var y0:Number = getY( x-w, y-h, z+d );
			var z0:Number = getZ( x-w, y-h, z+d );
			var x1:Number = getX( x-w, y+h, z+d );
			var y1:Number = getY( x-w, y+h, z+d );
			var z1:Number = getZ( x-w, y+h, z+d );
			var x2:Number = getX( x+w, y-h, z+d );
			var y2:Number = getY( x+w, y-h, z+d );
			var z2:Number = getZ( x+w, y-h, z+d );
			var x3:Number = getX( x+w, y+h, z+d );
			var y3:Number = getY( x+w, y+h, z+d );
			var z3:Number = getZ( x+w, y+h, z+d );
			var x4:Number = getX( x+w, y-h, z-d );
			var y4:Number = getY( x+w, y-h, z-d );
			var z4:Number = getZ( x+w, y-h, z-d );
			var x5:Number = getX( x+w, y+h, z-d );
			var y5:Number = getY( x+w, y+h, z-d );
			var z5:Number = getZ( x+w, y+h, z-d );
			var x6:Number = getX( x-w, y-h, z-d );
			var y6:Number = getY( x-w, y-h, z-d );
			var z6:Number = getZ( x-w, y-h, z-d );
			var x7:Number = getX( x-w, y+h, z-d );
			var y7:Number = getY( x-w, y+h, z-d );
			var z7:Number = getZ( x-w, y+h, z-d );
			
			if ( _c3d.fillEnabled )
			{
				//TODO: box の色 beginCurrentFillでいいのか？
				_c.beginCurrentFill();
				_c3d.quad( x0, y0, z0, x2, y2, z2, x3, y3, z3, x1, y1, z1 );
				_c3d.quad( x2, y2, z2, x4, y4, z4, x5, y5, z5, x3, y3, z3 );
				_c3d.quad( x4, y4, z4, x6, y6, z6, x7, y7, z7, x5, y5, z5 );
				_c3d.quad( x6, y6, z6, x0, y0, z0, x1, y1, z1, x7, y7, z7 );
				_c3d.quad( x6, y6, z6, x4, y4, z4, x2, y2, z2, x0, y0, z0 );
				_c3d.quad( x1, y1, z1, x3, y3, z3, x5, y5, z5, x7, y7, z7 );
				_c.endFill();
			}
			else
			{
				_c3d.moveTo( x0, y0, z0 ); _c3d.lineTo( x2, y2, z2 ); _c3d.lineTo( x3, y3, z3 ); _c3d.lineTo( x1, y1, z1 ); _c3d.closePath();
				_c3d.moveTo( x4, y4, z4 ); _c3d.lineTo( x6, y6, z6 ); _c3d.lineTo( x7, y7, z7 ); _c3d.lineTo( x5, y5, z5 ); _c3d.closePath();
				_c3d.moveTo( x0, y0, z0 ); _c3d.lineTo( x6, y6, z6 );
				_c3d.moveTo( x2, y2, z2 ); _c3d.lineTo( x4, y4, z4 );
				_c3d.moveTo( x3, y3, z3 ); _c3d.lineTo( x5, y5, z5 );
				_c3d.moveTo( x1, y1, z1 ); _c3d.lineTo( x7, y7, z7 );
			}
		}
		
		/**
		 * 球体の分割精度を設定します.
		 * @param	detail	segments minimum 3, default 12
		 */
		public function sphereDetail( detail:uint ):void
		{
			sphere_segments = ( detail > 3 ) ? detail : 3;
		}
		
		/**
		 * 球体を描画します.
		 * @param	radius
		 */
		public function sphere( radius:Number ):void
		{			
			var dh:Number = 2*Math.PI/sphere_segments;
			var dv:Number = Math.PI/sphere_segments;
			var i:int;
			var j:int;
			var h:Number;
			var h2:Number;
			var r:Number;
			var r2:Number;
			
			beginShape( F5C.TRIANGLE_FAN );
			vertex3d( 0, -radius, 0 );
			h = -radius * Math.cos(dv);
			r = radius * Math.sin(dv);
			for ( i = 0; i <=sphere_segments; i++ )
				vertex3d( r * Math.cos( dh * i ), h, r *Math.sin( dh * i ) );
			endShape();
			
			beginShape( F5C.TRIANGLE_FAN );
			vertex3d( 0, radius, 0 );
			h *= -1;
			for ( i = 0; i <=sphere_segments; i++ )
				vertex3d( r * Math.cos( dh * i ), h, -r * Math.sin( dh * i ) );
			endShape();
			
			for ( j = 1; j < sphere_segments-1; j++ )
			{
				var dr:Number = dv * j;
				h  = -radius * Math.cos(dr);
				r  =  radius * Math.sin(dr);
				h2 = -radius * Math.cos(dr + dv );
				r2 =  radius * Math.sin(dr + dv );
				beginShape( F5C.TRIANGLE_STRIP );
				//beginShape( QUAD_STRIP );
				for ( i = 0; i <= sphere_segments; i++ )
				{
					var c:Number = Math.cos( -dh * i );
					var s:Number = Math.sin( -dh * i );
					vertex3d( r*c,  h,  r*s );
					vertex3d( r2*c, h2, r2*s );
				}
				endShape();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/** overwrite to transform @private */
		override public function moveTo( x:Number, y:Number, z:Number = 0 ):void {
			_c3d.moveTo( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/** overwrite to transform @private */
		override public function lineTo(x:Number, y:Number, z:Number=0):void{
			_c3d.lineTo( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/**
		 * 
		 */
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void{
			_c3d.curveTo( getX( cx, cy, cz ), getY( cx, cy, cz ), getZ( cx, cy, cz ), getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** overwrite to transform @private */
		override public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void{
			_c3d.curveTo( getX0( cx, cy ), getY0( cx, cy ), getZ0( cx, cy ), getX0( x, y ), getY0( x, y ), getZ0( x, y ) );
		}
		
		/**
		 * 
		 */
		public function bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void{
			_c3d.bezierTo( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
						   getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
						   getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** overwrite to transform @private */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_c3d.bezierTo( getX0( cx0, cy0 ), getY0( cx0, cy0 ), getZ0( cx0, cy0 ),
						   getX0( cx1, cy1 ), getY0( cx1, cy1 ), getZ0( cx1, cy1 ),
						   getX0( x, y ), getY0( x, y ), getZ0( x, y ) );
		}
		
		/**
		 * 
		 */
		public function splineTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void{
			_c3d.splineTo( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
						   getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
						   getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** overwrite to transform @private */
		override public function splineTo(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_c3d.splineTo( getX0( cx0, cy0 ), getY0( cx0, cy0 ), getZ0( cx0, cy0 ),
						   getX0( cx1, cy1 ), getY0( cx1, cy1 ), getZ0( cx1, cy1 ),
						   getX0( x, y ), getY0( x, y ), getZ0( x, y ) );
		}
		
		/** @private */
		override public function arcCurveTo(x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0):void 
		{
			//TODO:(2) 最適化
			var m:FMatrix3D = __matrix.clone();
			m.invert();
			var px:Number = _c3d.pathX;
			var py:Number = _c3d.pathY;
			var pz:Number = _c3d.pathZ;
			//var zz:Number = px * m.m13 + py* m.m23 + pz * m.m33 + m.m43;
			__arcCurve( px*m.m11 + py*m.m21 + pz*m.m31 + m.m41, px*m.m12 + py*m.m22 + pz*m.m32 + m.m42,
						x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		/** @inheritDoc */
		override public function closePath():void {
			_c3d.closePath();
		}
		
		/** @inheritDoc */
		override public function moveToLast():void {
			_c3d.moveTo( _c3d.pathX, _c3d.pathY, _c3d.pathZ );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 2D Primitive
		//-------------------------------------------------------------------------------------------------------------------
		
		/** overwrite to transform @private */
		override public function pixel(x:Number, y:Number, z:Number = 0):void {
			_c3d.pixel( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), $stroke.color, $stroke.alpha );
		}
		
		/** overwrite to transform @private */
		override public function point(x:Number, y:Number, z:Number = 0):void {
			_c3d.point( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), $stroke.color, $stroke.alpha );
		}
		
		/**
		 * draw line to 3d space.
		 */
		public function line3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):void
		{
			moveTo( x0, y0, z0 );
			lineTo( x1, y1, z1 );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Curves
		
		/**
		 * draw cubic bezier curve(3d).
		 */
		public function bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x0, y0, z0 ); bezierTo3d( cx0, cy0, cz0, cx1, cy1, cz1, x1, y1, z1 );
			_c.endFill();
		}
		
		/**
		 * draw spline curve(3d).
		 */
		public function curve3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x1, y1, z1 ); splineTo3d( x0, y0, z0, x3, y3, z3, x2, y2, z2 );
			_c.endFill();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// VERTEX
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function beginShape( mode:int = 0 ):void {
			_c3d.beginVertexShape( mode );
		}
		
		/** @inheritDoc */
		override public function endShape( close_path:Boolean = false ):void {
			_c3d.endVertexShape( close_path );
			_textureDo = false;
		}
		
		/**
		 * Vertex描画 で 座標を追加します.
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	u	texture を指定している場合、テクスチャの u 値を指定できます
		 * @param	v	texture を指定している場合、テクスチャの v 値を指定できます
		 */
		public function vertex3d( x:Number, y:Number, z:Number, u:Number=0, v:Number=0  ):void{
			if ( _texture_mode == IMAGE ) {
				_c3d.vertex( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), u/_texture_width, v/_texture_height );
			}else {
				_c3d.vertex( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), u, v );
			}
			
		}
		/** @inheritDoc */
		override public function vertex( x:Number, y:Number, u:Number = 0, v:Number = 0 ):void {
			if ( _texture_mode == IMAGE ) {
				_c3d.vertex( getX0( x, y ), getY0( x, y ), getZ0( x, y ), u/_texture_width, v/_texture_height );
			}else {
				_c3d.vertex( getX0( x, y ), getY0( x, y ), getZ0( x, y ), u, v );
			}
		}
		
		/**
		 * Vertex描画 で ベジェ曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function bezierVertex3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void{
			_c3d.bezierVertex( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
							   getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
							   getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** @inheritDoc */
		override public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_c3d.bezierVertex( getX0( cx0, cy0 ), getY0( cx0, cy0 ), getZ0( cx0, cy0 ),
						       getX0( cx1, cy1 ), getY0( cx1, cy1 ), getZ0( cx1, cy1 ),
						       getX0( x, y ), getY0( x, y ), getZ0( x, y ) );
		}
		
		/**
		 *　Vertex描画 で スプライン曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function curveVertex3d( x:Number, y:Number, z:Number ):void{
			_c3d.splineVertex( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** @inheritDoc */
		override public function curveVertex( x:Number, y:Number ):void {
			_c3d.splineVertex( getX0( x, y ), getY0( x, y ), getZ0( x, y ) );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function shape(s:IFShape, x:Number = 0, y:Number = 0, w:Number = NaN, h:Number = NaN):void 
		{
			__push_styles_pre_shape();
			_c3d.beginPathGroup();			
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
			_c3d.endPathGroup();
			__pop_styles_pre_shape();
		}
		
		/** @private */
		override internal function __shape( s:IFShape ):void 
		{
			var mat:Matrix = s.matrix;
			if ( mat != null ){
				pushMatrix();
				//apply shape matrix 2d.
				__matrix.prependMatrix( mat.a, mat.b, 0, mat.c, mat.d, 0, 0, 0, 1, mat.tx, mat.ty, 0);
				update_transform();
				//
				super.__shape(s);
				popMatrix();
			}else {
				super.__shape(s);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Image
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 画像を描画します.
		 * 画像には回転などの変形は適用されません.Z値によるパースペクティブが適用されます.
		 */
		public function image2d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void
		{
			var centerpos:Boolean = ( _image_mode == CENTER || _image_mode == RADIUS );
			if ( w > 0 && h > 0 ) {
				if ( _image_mode == CORNERS ) {
					w = (w - x);
					h = (h - y);
				}else if ( _image_mode == RADIUS ) {
					w = 2*w;
					h = 2*h;
				}
			}else {
				w = img.width;
				h = img.height;
			}
			var dimg:BitmapData = ( tintDo ) ? tintImageCache.getTintImage( img, _tint_color ) : img;
			_c.beginTexture( dimg );
			_c3d.image2d( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), w, h, centerpos );
			_c.endTexture();
		}
		
		/**
		 * 画像を描画します.
		 */
		public function image3d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void
		{
			var dimg:BitmapData = ( tintDo ) ? tintImageCache.getTintImage( img, _tint_color ) : img;
			if ( w>0 && h>0 ){
				if ( _image_mode == CORNER ) {
					__image( dimg, x, y, w, h, z );
				}else if ( _image_mode == CENTER ) {
					__image( dimg, x - w/2, y - h/2, w, h, z );
				}else if ( _image_mode == CORNERS ) {
					__image( dimg, x, y, w - x, h - y, z );
				}else if ( _image_mode == RADIUS ) {
					__image( dimg, x - w, y - h, w*2, h*2, z );
				}
			}else if ( _image_mode == CENTER || _image_mode == RADIUS ){
				__image( dimg, x - img.width/2, y - img.height/2, img.width, img.height, z );
			}else {
				__image( dimg, x, y, img.width, img.height, z );
			}
		}
		/** @private */
		override internal function __image( img:BitmapData, x1:Number, y1:Number, z:Number, w:Number, h:Number ):void
		{
			var x2:Number = x1 + w;
			var y2:Number = y1 + h;
			_c.beginTexture( img );
			_c3d.quadImage( getX( x1, y1, z ), getY( x1, y1, z ), getZ( x1, y1, z ),
					        getX( x2, y1, z ), getY( x2, y1, z ), getZ( x2, y1, z ),
					        getX( x2, y2, z ), getY( x2, y2, z ), getZ( x2, y2, z ),
					        getX( x1, y2, z ), getY( x1, y2, z ), getZ( x1, y2, z ),
					        0, 0, 1, 0, 1, 1, 0, 1 );
			_c.endTexture();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TEXT
		//-------------------------------------------------------------------------------------------------------------------
		
		override public function text(str:String, a:Number, b:Number, c:Number = 0, d:Number = 0, e:Number = 0):void 
		{
			var z:Number = ( c > 0 && d > 0 ) ? e : c;
			tx += z * m31; ty += z * m32; tz += z * m33;
			super.text( str, a, b, c, d, e );
			tx -= z * m31; ty -= z * m32; tz -= z * m33;
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		public function get backFaceCulling():Boolean { return _c3d.backFaceCulling; }
		public function set backFaceCulling( value:Boolean ):void{
			_c3d.backFaceCulling = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 
		//-------------------------------------------------------------------------------------------------------------------
		
		/*
		 * 
		 * @param	bitmapdata
		 * @param	vertices	[x,y,z,...] vertex data
		 */
		/*
		public function drawTriangles( vertices:Array, indices:Array, texture:BitmapData=null ):void
		{
			var len:int = vertices.length;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var vtx:Array = [];
			var i:int = 0;
			var j:int = 1;
			var k:int = 2;
			for ( i = 0; i < len; i+=3 ){
				xx = vertices[i];
				yy = vertices[j];
				zz = vertices[k];
				vtx[i] = getX( xx, yy, zz );
				vtx[j] = getY( xx, yy, zz );
				vtx[k] = getZ( xx, yy, zz );
				j += 3;
				k += 3;
			}
			_c.beginCurrentFill();
			_c3d.drawTriangles( vtx, indices );
			_c.endFill();
		}
		*/
		/*
		 * 
		 * @param	bitmapdata
		 * @param	vertices	[x,y,z,...] vertex data
		 * @param	indices
		 * @param	uvData
		 */
		/*
		public function drawBitmapTriangles( bitmapdata:BitmapData, vertices:Array, indices:Array, uvData:Array ):void
		{
			var len:int = vertices.length;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var vtx:Array = [];
			var i:int = 0;
			var j:int = 1;
			var k:int = 2;
			for ( i = 0; i < len; i+=3 ){
				xx = vertices[i];
				yy = vertices[j];
				zz = vertices[k];
				vtx[i] = getX( xx, yy, zz );
				vtx[i] = getY( xx, yy, zz );
				vtx[k] = getZ( xx, yy, zz );
				j += 3;
				k += 3;
			}
			_c.beginTexture( bitmapdata );
			_c3d.drawTriangles( vtx, indices, uvData );
			_c.endTexture();
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override internal function upadate_draw_matrix( m:Matrix, t:Matrix, a0:Number=1, b0:Number=0, c0:Number=0, d0:Number=1, tx0:Number=0, ty0:Number=0 ):void 
		{
			super.upadate_draw_matrix( m, t, a0, b0, c0, d0, tx0, ty0 );
			if ( transformStyleMatrix ) {
				/*
				var x0:Number = getX( 0, 0, 0 );
				var y0:Number = getY( 0, 0, 0 );
				var x1:Number = getX( 1, 0, 0 );
				var y1:Number = getY( 1, 0, 0 );
				var x2:Number = getX( 0, 1, 0 );
				var y2:Number = getY( 0, 1, 0 );
				_stylematrix.a = x1 - x0;
				_stylematrix.b = y1 - y0;
				_stylematrix.c = x2 - x0;
				_stylematrix.d = y2 - y0;
				_stylematrix.tx = x0 + half_width;
				_stylematrix.ty = y0 + half_height;
				m.concat( _stylematrix );
				*/
				var p0:FNumber3D = screenXYZ( 0, 0, 0 );
				var p1:FNumber3D = screenXYZ( 1, 0, 0 );
				var p2:FNumber3D = screenXYZ( 0, 1, 0 );
				_stylematrix.a = p1.x - p0.x;
				_stylematrix.b = p1.y - p0.y;
				_stylematrix.c = p2.x - p0.x;
				_stylematrix.d = p2.y - p0.y;
				_stylematrix.tx = p0.x;
				_stylematrix.ty = p0.y;
				m.concat( _stylematrix );
			}
		}
		
	}
	
}