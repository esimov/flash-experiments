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

package frocessing.display {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import frocessing.f3d.F3DObject;
	import frocessing.geom.FNumber3D;
	import frocessing.core.F5Canvas3D;
	import frocessing.math.FMath;
	
	/**
	* F5CanvasMovieClip3D
	* 
	* @author nutsu
	* @version 0.6
	* 
	* @see frocessing.core.F5Canvas3D
	*/
	public dynamic class F5CanvasMovieClip3D extends AbstractF5MovieClip
	{
		
		public var fg:F5Canvas3D;
		
		/**
		 * 
		 */
		public function F5CanvasMovieClip3D( f5Canvas3D:F5Canvas3D, target:DisplayObject=null, useStageEvent:Boolean=true ) 
		{
			super( fg = f5Canvas3D, target, useStageEvent );
		}
		
		//------------------------------------------------------------------------------------------------------------------- TRANSFORM
		
		/**
		 * 
		 */
		public function translate( tx:Number, ty:Number, tz:Number=0.0 ):void{
			fg.translate( tx, ty, tz );
		}
		/**
		 * 
		 */
		public function scale( sx:Number, sy:Number = NaN, sz:Number=1.0 ):void{
			fg.scale( sx, sy, sz );
		}
		/**
		 * 
		 */
		public function rotate( angle:Number ):void{
			fg.rotate( angle );
		}
		/**
		 * 
		 */
		public function rotateX( angle:Number ):void{
			fg.rotateX( angle );
		}
		/**
		 * 
		 */
		public function rotateY( angle:Number ):void{
			fg.rotateY( angle );
		}
		/**
		 * 
		 */
		public function rotateZ( angle:Number ):void{
			fg.rotateZ( angle );
		}
		/**
		 * 
		 */
		public function pushMatrix():void{
			fg.pushMatrix();
		}
		/**
		 * 
		 */
		public function popMatrix():void{
			fg.popMatrix();
		}
		/**
		 * 
		 */
		public function resetMatrix():void{
			fg.resetMatrix();
		}
		/**
		 * 
		 */
		public function printMatrix():void {
			fg.printMatrix();
		}
		/**
		 * 
		 */
		public function screenXYZ( x:Number, y:Number, z:Number ):FNumber3D{
			return fg.screenXYZ( x, y, z );
		}
		/**
		 * 
		 */
		public function screenX( x:Number, y:Number, z:Number ):Number{
			return fg.screenX( x, y, z );
		}
		/**
		 * 
		 */
		public function screenY( x:Number, y:Number, z:Number ):Number{
			return fg.screenY( x, y, z );
		}
		/**
		 * 
		 */
		public function screenZ( x:Number, y:Number, z:Number ):Number{
			return fg.screenZ( x, y, z );
		}
		/**
		 * 
		 */
		public function modelXYZ( x:Number, y:Number, z:Number ):FNumber3D{
			return fg.modelXYZ( x, y, z );
		}
		/**
		 * 
		 */
		public function modelX( x:Number, y:Number, z:Number ):Number{
			return fg.modelX( x, y, z );
		}
		/**
		 * 
		 */
		public function modelY( x:Number, y:Number, z:Number ):Number{
			return fg.modelY( x, y, z );
		}
		/**
		 * 
		 */
		public function modelZ( x:Number, y:Number, z:Number ):Number{
			return fg.modelZ( x, y, z );
		}
		
		//------------------------------------------------------------------------------------------------------------------- CAMERA, PROJECTION
		
		/**
		 * 
		 */
		public function perspective( fov:Number=NaN, aspect:Number=NaN, near:Number=NaN, far:Number=NaN ):void{
			fg.perspective( fov, aspect, near, far );
		}
		/**
		 * 
		 */
		public function frustum(left:Number, right:Number, bottom:Number, top:Number, near:Number, far:Number):void{
			fg.frustum(left, right, bottom, top, near, far);
		}
		/**
		 * 
		 */
		public function ortho(left:Number=NaN, right:Number=NaN, bottom:Number=NaN, top:Number=NaN, near:Number=NaN, far:Number=NaN):void{
			fg.ortho(left, right, bottom, top, near, far);
		}
		/**
		 * 
		 */
		public function printProjection():void{
			fg.printProjection();
		}
		
		/**
		 * 
		 */
		public function camera( eyeX:Number = NaN, eyeY:Number = NaN, eyeZ:Number = NaN, centerX:Number = NaN, centerY:Number = NaN, centerZ:Number = NaN, upX:Number = 0, upY:Number = 1, upZ:Number = 0 ):void{
			fg.camera( eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ );
		}
		/**
		 * 
		 */
		public function beginCamera():void{
			fg.beginCamera();
		}
		/**
		 * 
		 */
		public function endCamera():void{
			fg.endCamera();
		}
		/**
		 * 
		 */
		public function printCamera():void{
			fg.printCamera();
		}
		
		//------------------------------------------------------------------------------------------------------------------- 3D Obj
		
		/**
		 * 
		 */
		public function box( w:Number, h:Number = NaN , d:Number = NaN ):void {
			fg.box( w, h, d );
		}
		
		/**
		 * 
		 */
		public function sphereDetail( detail:uint ):void {
			fg.sphereDetail( detail );
		}
		
		/**
		 * 
		 */
		public function sphere( radius:Number ):void {
			fg.sphere( radius );
		}
		
		/**
		 * 
		 */
		public function model( model_:F3DObject ):void{
			fg.model( model_ );
		}
		
		//------------------------------------------------------------------------------------------------------------------- PATH
		
		/**
		 * 
		 */
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void {
			fg.curveTo3d( cx, cy, cz, x, y, z );
		}
		/**
		 * 
		 */
		public function bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void{
			fg.bezierTo3d( cx0, cy0, cz0, cx1, cy1, cz1, x, y, z );
		}
		/**
		 * 
		 */
		public function splineTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void{
			fg.splineTo3d( cx0, cy0, cz0, cx1, cy1, cz1, x, y, z );
		}
		
		//------------------------------------------------------------------------------------------------------------------- PRIMITIVE
		
		/**
		 * 
		 */
		public function line3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):void{
			fg.line3d( x0, y0, z0, x1, y1, z1 );
		}
		/**
		 * 
		 */
		public function bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number ):void{
			fg.bezier3d( x0, y0, z0, cx0, cy0, cz0, cx1, cy1, cz1, x1, y1, z1 );
		}
		/**
		 * 
		 */
		public function curve3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void{
			fg.curve3d( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
		}
		
		//------------------------------------------------------------------------------------------------------------------- VERTEX
		
		/**
		 * 
		 */
		public function vertex3d( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void {
			fg.vertex3d( x, y, z, u, v );
		}
		/**
		 * 
		 */
		public function bezierVertex3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void {
			fg.bezierVertex3d( cx0, cy0, cz0, cx1, cy1, cz1, x, y, z );
		}
		/**
		 * 
		 */
		public function curveVertex3d( x:Number, y:Number, z:Number ):void {
			fg.curveVertex3d( x, y, z );
		}
		
		//------------------------------------------------------------------------------------------------------------------- IMAGE
		
		/**
		 * 
		 */
		public function image3d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void {
			fg.image3d( img, x, y, z, w, h );
		}
		/**
		 * 
		 */
		public function image2d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void {
			fg.image2d( img, x, y, z, w, h );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Math
		
		/**
		 * @see frocessing.math.FMath
		 */
		public static function dist3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):Number{
			return FMath.dist3d( x0, y0, z0, x1, y1, z1 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function mag3d( a:Number, b:Number, c:Number ):Number {
			return FMath.mag3d(a, b, c);
		}
	}
	
}