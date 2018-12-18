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

package frocessing.f3d {
	
	import frocessing.geom.FMatrix3D;
	import frocessing.geom.FVector;
	//import frocessing.f5internal;
	//use namespace f5internal;
	
	/**
	* F3DCamera は、Processing の Camera関連 メソッドを実装したクラスです.
	* 
	* @author nutsu
	* @version 0.3
	*/
	public class F3DCamera {
		
		//camera matrix
		private var _cameraMatrix:FMatrix3D;
		//projection matrix
		private var _projMatrix:FMatrix3D;
		//transform matrix
		private var _matrix:FMatrix3D;
		//invert matrix
		private var _invert_matrix:FMatrix3D;
		
		//screen
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _half_width:Number;
		private var _half_height:Number;
		
		//projection
		private var _projectionScaleX:Number;
		private var _projectionScaleY:Number;
		private var _projectionOffsetX:Number;
		private var _projectionOffsetY:Number;
		private var _frustomMode:Boolean;
		
		//z clipping
		private var _near:Number;
		private var _far:Number;
		
		//camera coordinates
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		//update
		private var _update_transform:Boolean;
		
		/**
		 * 新しく F3DCamera インスタンスを生成します.
		 * 
		 * @param	width	screen width
		 * @param	height	screen height
		 */
		public function F3DCamera( width:Number, height:Number )
		{
			_cameraMatrix     = new FMatrix3D();
			_projMatrix       = new FMatrix3D();
			_matrix           = new FMatrix3D();
			_invert_matrix    = new FMatrix3D();
			_update_transform = true;
			setScreenSize( width, height );
		}
		
		/**
		 * スクリーンサイズを設定します.このメソッドによりカメラが初期化されます.
		 * @param	width	screen width
		 * @param	height	screen height
		 */
		public function setScreenSize( width:Number, height:Number ):void
		{
			_screenWidth  = width;
			_screenHeight = height;
			_half_width   = width * 0.5;
			_half_height  = height * 0.5;
			_projectionScaleX  = 1;
			_projectionScaleY  = 1;
			_projectionOffsetX = 0;
			_projectionOffsetY = 0;
			init();
		}
		
		/**
		 * Camera と Projection を初期化します.
		 */
		public function init():void
		{
			camera();
			perspective();
		}
		
		//--------------------------------------------------------------------------------------------------- CAMERA
		
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
			//initial parameters
			if ( isNaN(eyeX) || isNaN(eyeY) || isNaN(eyeZ) )
			{
				eyeX = _half_width;
				eyeY = _half_height;
				eyeZ = _half_height/Math.tan(Math.PI/6.0);
			}
			if ( isNaN(centerX) || isNaN(centerY) || isNaN(centerZ) )
			{
				centerX = _half_width;
				centerY = _half_height;
				centerZ = 0.0;
			}
			
			//setting camera
			_x = eyeX;
			_y = eyeY;
			_z = eyeZ;
			_cameraMatrix.setMatrix( 1,0,0, 0,1,0, 0,0,1, -_x, -_y, -_z );
			var uz:FVector = new FVector( _x - centerX, _y - centerY, _z - centerZ );
			uz.normalize();
			var ux:FVector = FVector.cross( new FVector(upX, upY, upZ), uz );
			ux.normalize();
			var uy:FVector = FVector.cross( uz, ux );
			uy.normalize();
			
			//invert matrix of [ux.x, ux.y, ux.z, 0, uy.x, uy.y, uy.z, 0, uz.x, uz.y, uz.z, 0,  0, 0, 0, 1]
			_cameraMatrix.appendMatrix( ux.x, uy.x, uz.x, ux.y, uy.y, uz.y, ux.z, uy.z, uz.z, 0, 0, 0 );
			_update_transform = true;
		}
		
		
		/**
		 * カメラを移動します.
		 */
		public function translate( x:Number, y:Number, z:Number=0.0 ):void
		{
			_cameraMatrix.appendTranslation( -x, -y, -z );
			_update_transform = true;
		}
		
		/**
		 * カメラを X軸 で回転します.
		 */
		public function rotateX( angle:Number ):void
		{
			_cameraMatrix.appendRotationX( angle );
			_update_transform = true;
		}
		
		/**
		 * カメラを Y軸 で回転します.
		 */
		public function rotateY( angle:Number ):void
		{
			_cameraMatrix.appendRotationY( angle );
			_update_transform = true;
		}
		
		/**
		 * カメラを Z軸 で回転します.
		 */
		public function rotateZ( angle:Number ):void
		{
			_cameraMatrix.appendRotationZ( angle );
			_update_transform = true;
		}
		
		//--------------------------------------------------------------------------------------------------- PROJECTION
		
		/**
		 * 透視投影変換(パースペクティブ)でプロジェクションを設定します.
		 * @param	fov		field-of-view angle (in radians) for vertical direction
		 * @param	aspect	ratio of width to height
		 * @param	z_near	z-position of nearest clipping plane
		 * @param	z_far	z-position of nearest farthest plane (今は使っていない)
		 */
		public function perspective( fov:Number=NaN, aspect:Number=NaN, z_near:Number=NaN, z_far:Number=NaN ):void
		{
			//initial parameters
			var field_of_view:Number = ( isNaN(fov) )    ? Math.PI/3.0 : fov;
			var camera_aspect:Number = ( isNaN(aspect) ) ? screenAspect : aspect;
			_near					 = ( isNaN(z_near) )  ? _z/10.0 : z_near;
			_far					 = ( isNaN(z_far) )   ? _z*10.0 : z_far;
			
			//setting
			var top:Number    = _near * Math.tan( field_of_view * 0.5 ); //default _z/10 = 0.1*_half_height/Math.tan(fov/2);
			var bottom:Number = -top;
			frustum( bottom*camera_aspect, top*camera_aspect, bottom, top, _near, _far );
		}
		
		/**
		 * プロジェクションを設定します.
		 * @param	left
		 * @param	right
		 * @param	bottom
		 * @param	top
		 * @param	near
		 * @param	far		z far (今は使っていない)
		 */
		public function frustum(left:Number, right:Number, bottom:Number, top:Number, z_near:Number, z_far:Number):void
		{
			var _left:Number   = left;
			var _right:Number  = right;
			var _bottom:Number = bottom;
			var _top:Number    = top;
			_near   = z_near;
			_far    = z_far;
			
			//setting
			var width:Number  = _right - _left;
			var height:Number = _top   - _bottom;
			
			/*_projMatrix.setMatrix(
								2*_near/width,       0,                      0,
								0,                   2*_near/height,         0,
								(_right+_left)/width, (_top+_bottom)/height, -(_far+_near)/(far - near),
								0,                   0,                      -2*far*near/(far - near)
								);*/
			/*
			_projMatrix.setMatrix(
								2/width, 0, 0,
								0, 2/height, 0,
								(_right+_left)/width/_near, (_top+_bottom)/height/_near, -1,
								0, 0, 0
								);
			_projMatrix.appendMatrix( _half_width, 0, 0, 0, _half_height, 0, 0, 0, 1, 0, 0, 0 );
			*/
			var ratio:Number = screenHeight/height;
			_projMatrix.setMatrix( 
								1, 0, 0,
								0, 1, 0,
								0, 0, -1,
								0, 0, 0
								);
			_projectionScaleX  = screenWidth / width; //_near * screenWidth / width;
			_projectionScaleY  = screenHeight / height; //_near * screenHeight / height;
			_projectionOffsetX = -_half_width * (_right + _left) / width;
			_projectionOffsetY = -_half_height * (_top + _bottom) / height;
			_frustomMode       = true;
			_update_transform  = true;
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
		public function ortho(left:Number=NaN, right:Number=NaN, bottom:Number=NaN, top:Number=NaN, z_near:Number=NaN, z_far:Number=NaN):void
		{
			//initial parameters
			var _left:Number   = ( isNaN(left) )  ? 0 : left;
			var _right:Number  = ( isNaN(right) ) ? _screenWidth : right;
			var _bottom:Number = ( isNaN(bottom) )? 0 : bottom;
			var _top:Number    = ( isNaN(top) )   ? _screenHeight : top;
			_near   = ( isNaN(z_near) )  ? -10 : z_near;
			_far    = ( isNaN(z_far) )   ? 10 : z_far;
			
			//setting
			var width:Number  = _right - _left;
			var height:Number = _top   - _bottom;
			
			/*
			_projMatrix.setMatrix(
								2.0/width, 0, 0,
								0, 2.0/height, 0,
								0, 0, -2/(_far-_near),
								-(_right+_left)/width, -(_top+_bottom)/height, -(_far+_near)/(_far-_near)
								);*/
			/*
			_projMatrix.setMatrix(
								2.0/width, 0, 0,
								0, 2.0/height, 0,
								0, 0, -1,
								-(_right + _left)/width, -(_top + _bottom)/height, 0
								);
			_projMatrix.appendMatrix( _half_width, 0, 0, 0, _half_height, 0, 0, 0, 1, 0, 0, 0 );
			*/
			_projMatrix.setMatrix( 1, 0, 0,  0, 1, 0,  0, 0, -1,  0, 0, 0 );
			_projectionScaleX  = screenWidth / width;
			_projectionScaleY  = screenHeight / height;
			_projectionOffsetX = -_half_width * (_right + _left) / width;
			_projectionOffsetY = -_half_height * (_top + _bottom) / height;
			_frustomMode       = false;
			_update_transform  = true;
		}
		
		//--------------------------------------------------------------------------------------------------- CAMERA
		
		/** 
		 * @private
		 */
		private function _updateMatrix():void
		{
			_matrix = _cameraMatrix.product( _projMatrix );
			_invert_matrix.copyMatrix( _matrix );
			_invert_matrix.invert();
			_update_transform = false;
		}
		
		/**
		 * 変換行列 を取得します.
		 */
		public function get matrix():FMatrix3D
		{
			if ( _update_transform )
			{
				_updateMatrix();
				return _matrix.clone();
			}
			else
			{
				return _matrix.clone();
			}
		}
		
		/**
		 * 変換逆行列 を取得します.
		 */
		public function get inversion():FMatrix3D
		{
			if ( _update_transform )
			{
				_updateMatrix();
				return _invert_matrix.clone();
			}
			else
			{
				return _invert_matrix.clone();
			}
		}
		
		/**
		 * Camera の Matrix を取得します.
		 */
		public function get cameraMatrix():FMatrix3D { return _cameraMatrix; }
		
		/**
		 * Projection の Matrix を取得します.
		 */
		public function get projectionMatrix():FMatrix3D { return _projMatrix; }
		
		/**
		 * Cemera の x 座標 を取得します.
		 */
		public function get x():Number { return _x; }
		
		/**
		 * Cemera の y 座標 を取得します.
		 */
		public function get y():Number { return _y; }
		
		/**
		 * Cemera の z 座標 を取得します.
		 */
		public function get z():Number { return _z; }
		
		/**
		 * スクリーンの幅を取得します.
		 */
		public function get screenWidth():Number { return _screenWidth; }
		
		/**
		 * スクリーンの高さを取得します.
		 */
		public function get screenHeight():Number { return _screenHeight; }
		
		/**
		 * スクリーン比を取得します.
		 */
		public function get screenAspect():Number { return _screenWidth / _screenHeight; }
		
		/**
		 * Projection が ortho かどうかを示します.
		 */
		public function get orthoProjection():Boolean { return !_frustomMode; }
		
		/**
		 * Projection が perspective かどうかを示します.
		 */
		public function get isPerspective():Boolean { return _frustomMode; }
		
		/**
		 * 投影面
		 */
		public function get focalLength():Number { return _near; }
		/**
		 * 投影比率
		 */
		public function get projectionScaleX():Number { return _projectionScaleX; }
		/**
		 * 投影比率
		 */
		public function get projectionScaleY():Number { return _projectionScaleY; }
		/**
		 * 投影オフセット
		 */
		public function get projectionOffsetX():Number { return _projectionOffsetX; }
		/**
		 * 投影オフセット
		 */
		public function get projectionOffsetY():Number { return _projectionOffsetY; }
		
	}
	
}