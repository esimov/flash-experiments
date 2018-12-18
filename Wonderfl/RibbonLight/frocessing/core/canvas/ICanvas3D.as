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
	import frocessing.geom.FNumber3D;
	
	/**
	 * @author nutsu
	 * @version 0.6
	 */
	public interface ICanvas3D extends ICanvas
	{
		function setProjection( perspective:Boolean, centerX:Number, centerY:Number, focalLength:Number, scaleX:Number=1, scaleY:Number=1 ):void;
		function projectionValue( x:Number, y:Number, z:Number ):FNumber3D;
		
		function get backFaceCulling():Boolean;
		function set backFaceCulling(value:Boolean):void;
		
		function moveTo( x:Number, y:Number, z:Number ):void;
		function lineTo( x:Number, y:Number, z:Number ):void;
		function curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void;
		function bezierTo( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void;
		function splineTo( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void;
		function closePath():void;
		function beginPathGroup():void;
		function endPathGroup():void;
		
		function get pathStartX():Number;
		function get pathStartY():Number;
		function get pathStartZ():Number;
		function get pathX():Number;
		function get pathY():Number;
		function get pathZ():Number;
		
		function pixel( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void;
		function point( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void;
		function quad( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void;
		function triangle( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void;
		function triangleImage( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void;
		function quadImage( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void;
		function image2d( x:Number, y:Number, z:Number, w:Number, h:Number, center:Boolean ):void;
		
		function drawTriangles( vertices:Array, indices:Array, uvData:Array = null ):void;
		
		function beginVertexShape(mode:int = 0):void;
		function endVertexShape( close_path:Boolean = false ):void;
		function vertex( x:Number, y:Number, z:Number, u:Number = 0, v:Number = 0 ):void;
		function bezierVertex( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void;
		function splineVertex( x:Number, y:Number, z:Number ):void;
		
		function beginTextures( texture:BitmapData, backFaceTexture:BitmapData ):void;
	}
	
}