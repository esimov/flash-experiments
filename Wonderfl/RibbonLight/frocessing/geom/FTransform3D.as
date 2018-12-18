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

package frocessing.geom {
	
	/**
	* FTransform3D
	* 
	* @author nutsu
	* @version 0.3
	*/
	public class FTransform3D
	{
		
		//update matrix flg
		private var updated:Boolean;
		
		//transform matrix
		private var _matrix:FMatrix3D;
		
		//position
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		//scale
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _scaleZ:Number;
		
		//rotation
		private var _rotation:FMatrix3D;
		private var _rotationX:Number;
		private var _rotationY:Number;
		private var _rotationZ:Number;
		private var updated_rotation:Boolean;
		private var cal_rotation_flg:Boolean;
		
		/**
		 * ...
		 */
		public function FTransform3D( defaultMatrix_:FMatrix3D=null )
		{
			_matrix    = new FMatrix3D();
			_rotation  = new FMatrix3D();
			_identity();
			
			if ( defaultMatrix_ )
				matrix = defaultMatrix_ ;
		}
		
		public function identity():void
		{
			_matrix.identity();
			_rotation.identity();
			_identity();
		}
		
		private function _identity():void
		{
			_x         = 0.0;
			_y         = 0.0;
			_z         = 0.0;
			_scaleX    = 1.0;
			_scaleY    = 1.0;
			_scaleZ    = 1.0;
			_rotationX = 0.0;
			_rotationY = 0.0;
			_rotationZ = 0.0;
			updated    = false;
			updated_rotation = false;
			cal_rotation_flg = false;
		}
		
		//---------------------------------------------------------------------------------------------------MATRIX
		
		public function get matrix():FMatrix3D
		{
			if ( updated )
			{
				applyRotation();
				_matrix.copyMatrix( _rotation );
				_matrix.prependScale( _scaleX, _scaleY, _scaleZ );
				_matrix.appendTranslation( _x, _y, _z );
				updated = false;
			}
			return _matrix;
		}
		public function set matrix( value:FMatrix3D ):void
		{
			//指定されるMatrixはワールド系を想定
			_rotation.copyMatrix( value );
			_x      = _rotation.m41;
			_y      = _rotation.m42;
			_z      = _rotation.m43;
			_scaleX = Math.sqrt( _rotation.m11 * _rotation.m11 + _rotation.m12 * _rotation.m12 + _rotation.m13 * _rotation.m13 );
			_scaleY = Math.sqrt( _rotation.m21 * _rotation.m21 + _rotation.m22 * _rotation.m22 + _rotation.m23 * _rotation.m23 );
			_scaleZ = Math.sqrt( _rotation.m31 * _rotation.m31 + _rotation.m32 * _rotation.m32 + _rotation.m33 * _rotation.m33 );
			_rotation.m41 = 0.0;
			_rotation.m42 = 0.0;
			_rotation.m43 = 0.0;
			_rotation.prependScale( 1/_scaleX, 1/_scaleY, 1/_scaleZ );
			_matrix.copyMatrix( _rotation );
			_matrix.prependScale( _scaleX, _scaleY, _scaleZ );
			_matrix.appendTranslation( _x, _y, _z );
			updated = false;
		}
		
		//---------------------------------------------------------------------------------------------------
		
		public function transform( v:FNumber3D ):FNumber3D
		{
			return matrix.transform( v );
		}
		
		//--------------------------------------------------------------------------------------------------- POSITION
		
		public function get x():Number{ return _x; }
		public function set x( value:Number ):void
		{
			_x = value;
			updated = true;
		}
		
		public function get y():Number{ return _y; }
		public function set y( value:Number ):void
		{
			_y = value;
			updated = true;
		}
		
		public function get z():Number{ return _z; }
		public function set z( value:Number ):void
		{
			_z = value;
			updated = true;
		}
		
		public function position( x_:Number, y_:Number, z_:Number ):void
		{
			_x = x_;
			_y = y_;
			_z = z_;
			updated = true;
		}
		
		public function translate( tx:Number, ty:Number, tz:Number ):void
		{
			_x += tx;
			_y += ty;
			_z += tz;
			updated = true;
		}
		
		//--------------------------------------------------------------------------------------------------- SCALE
		
		public function get scaleX():Number{ return _scaleX; }
		public function set scaleX( value:Number ):void
		{
			_scaleX = value;
			updated = true;
		}
		
		public function get scaleY():Number{ return _scaleY; }
		public function set scaleY( value:Number ):void
		{
			_scaleY = value;
			updated = true;
		}
		
		public function get scaleZ():Number{ return _scaleZ; }
		public function set scaleZ( value:Number ):void
		{
			_scaleZ = value;
			updated = true;
		}
		
		public function scale( sx:Number, sy:Number, sz:Number ):void
		{
			_scaleX *= sx;
			_scaleY *= sy;
			_scaleZ *= sz;
			updated = true;
		}
		
		//--------------------------------------------------------------------------------------------------- ROTATION
		
		private function applyRotation():void
		{
			if ( updated_rotation )
			{	
				_rotation.identity();
				_rotation.appendRotationZ(-_rotationZ);
				_rotation.appendRotationY(-_rotationY);
				_rotation.appendRotationX(-_rotationX);
				updated_rotation = false;
				cal_rotation_flg = false;
			}
		}
		
		private function updateRotationValues():void
		{
			var tmp:FMatrix3D = _rotation.clone();
			
			if ( Math.abs( tmp.m32 ) > 0.001 )
			{
				_rotationX = Math.atan2( tmp.m32, tmp.m33 );
				if ( tmp.m22 * Math.cos(-_rotationX) + tmp.m23 * Math.sin(-_rotationX) < 0 )
					_rotationX += Math.PI;
				tmp.appendRotationX( -_rotationX );
			}
			else if ( tmp.m22 < 0 )
			{
				_rotationX = Math.PI;
				tmp.appendRotationX( -_rotationX );
			}
			else
			{
				_rotationX = 0;
			}
			
			if ( Math.abs( tmp.m13 ) > 0.001 )
			{
				_rotationY = Math.atan2( tmp.m13, tmp.m11 );
				tmp.appendRotationY( -_rotationY );
			}
			else
			{
				_rotationY = 0;
			}
			
			_rotationZ = Math.atan2( tmp.m21, tmp.m22 );
			cal_rotation_flg = false;
		}
		
		public function rotation( ax:Number, ay:Number, az:Number ):void
		{
			_rotationX = ax;
			_rotationY = ay;
			_rotationZ = az;
			updated_rotation = updated = true;
		}
		
		public function get rotationX():Number
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			return _rotationX;
		}
		public function set rotationX( value:Number ):void
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			_rotationX = value;
			updated_rotation = updated = true;
		}
		
		public function get rotationY():Number
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			return _rotationY;
		}
		public function set rotationY( value:Number ):void
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			_rotationY = value;
			updated_rotation = updated = true;
		}
		
		public function get rotationZ():Number
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			return _rotationZ;
		}
		public function set rotationZ( value:Number ):void
		{
			if ( cal_rotation_flg )
				updateRotationValues();
			_rotationZ = value;
			updated_rotation = updated = true;
		}
		
		public function rotateX( a:Number ):void
		{
			applyRotation();
			_rotation.appendRotationX(-a);
			cal_rotation_flg = updated = true;
		}
		
		public function rotateY( a:Number ):void
		{
			applyRotation();
			_rotation.appendRotationY(-a);
			cal_rotation_flg = updated = true;
		}
		
		public function rotateZ( a:Number ):void
		{
			applyRotation();
			_rotation.appendRotationZ(-a);
			cal_rotation_flg = updated = true;
		}
		
		public function rotateAxis( ux:Number, uy:Number, uz:Number, a:Number ):void
		{
			applyRotation();
			_rotation.appendRotation( ux, uy, uz, a );
			cal_rotation_flg = updated = true;
		}
		
		public function roll( a:Number ):void
		{
			rotateAxis( _rotation.m11, _rotation.m12, _rotation.m13, -a );
		}
		
		public function pitch( a:Number ):void
		{
			rotateAxis( _rotation.m21, _rotation.m22, _rotation.m23, -a );
		}
		
		public function yow( a:Number ):void
		{
			rotateAxis( _rotation.m31, _rotation.m32, _rotation.m33, -a );
		}
		
		/*
		public function lookAt( x:Number, y:Number, z:Number, yup:int ):void{
			
		}
		*/
		
		//--------------------------------------------------------------------------------------------------- POSTURE
		
		public function get postureX():FNumber3D
		{
			return new FNumber3D(_rotation.m11, _rotation.m12, _rotation.m13);
		}
		
		public function get postureY():FNumber3D
		{
			return new FNumber3D(_rotation.m21, _rotation.m22, _rotation.m23);
		}
		
		public function get postureZ():FNumber3D
		{
			return new FNumber3D(_rotation.m31, _rotation.m32, _rotation.m33);
		}
		
	}
}
