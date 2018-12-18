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
	import frocessing.core.canvas.ICanvas2D;
	import frocessing.geom.FMatrix;
	import frocessing.shape.IFShape;
	
	/**
	 * F5Canvas クラスは、 Processing の基本API(2D)を実装したクラスです.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class F5Canvas extends AbstractF5Canvas
	{
		/** @private */
		internal var _c2d:ICanvas2D;
		
		//image draw matrix
		/** @private */
		internal var _img_matrix:FMatrix;
		
		/**
		 * 新しい F5Canvas クラスのインスタンスを生成します.
		 * 
		 * @param	target	描画対象となる ICanvas2D を指定します
		 */
		public function F5Canvas( target:ICanvas2D ) 
		{
			super( _c2d = target );
			_img_matrix = new FMatrix();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Path
		
		/** @inheritDoc */
		override public function moveTo( x:Number, y:Number, z:Number = 0 ):void{
			_c2d.moveTo( x, y );
		}
		
		/** @inheritDoc */
		override public function lineTo( x:Number, y:Number, z:Number = 0 ):void{
			_c2d.lineTo( x, y );
		}
		
		/** @inheritDoc */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{
			_c2d.curveTo( cx, cy, x, y );
		}
		
		/** @inheritDoc */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void{
			_c2d.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		//** @inheritDoc */
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void{
			_c2d.splineTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		/** @inheritDoc */
		override public function closePath():void{
			_c2d.closePath();
		}
		
		/** @inheritDoc */
		override public function moveToLast():void{
			_c2d.moveTo( _c2d.pathX, _c2d.pathY );
		}
		
		/** @inheritDoc */
		override public function arcCurveTo( x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void {
			__arcCurve( _c2d.pathX, _c2d.pathY, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 2D Primitives
		
		/** @inheritDoc */
		override public function pixel(x:Number, y:Number, z:Number = 0):void {
			_c2d.pixel( x, y, $stroke.color, $stroke.alpha );
		}
		
		/** @inheritDoc */
		override public function point(x:Number, y:Number, z:Number = 0):void {
			_c2d.point( x, y, $stroke.color, $stroke.alpha );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Vertex
		
		/** @inheritDoc */
		override public function beginShape( mode:int = 0 ):void {
			_c2d.beginVertexShape( mode );
		}
		
		/** @inheritDoc */
		override public function endShape( close_path:Boolean = false ):void {
			_c2d.endVertexShape( close_path );
			_textureDo = false;
		}
		
		/** @inheritDoc */
		override public function vertex( x:Number, y:Number, u:Number = 0, v:Number = 0 ):void {
			if ( _texture_mode == IMAGE ) {
				_c2d.vertex( x, y, u/_texture_width, v/_texture_height );
			}else {
				_c2d.vertex( x, y, u, v );
			}
		}
		
		/** @inheritDoc */
		override public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_c2d.bezierVertex( cx0, cy0, cx1, cy1, x, y );
		}
		
		/** @inheritDoc */
		override public function curveVertex( x:Number, y:Number ):void {
			_c2d.splineVertex( x, y );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Shape
		
		
		//------------------------------------------------------------------------------------------------------------------- Image
		/** @private */
		override internal function __image( img:BitmapData, x:Number, y:Number, z:Number, w:Number, h:Number ):void
		{
			_img_matrix.setMatrix( w / img.width, 0, 0, h / img.height, x, y );
			_c.beginTexture( img );
			_c2d.image( _img_matrix );
			_c.endTexture();
		}
		
	}
	
}