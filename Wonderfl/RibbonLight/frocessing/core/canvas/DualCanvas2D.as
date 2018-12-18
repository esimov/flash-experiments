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
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author nutsu
	 * @version 0.6
	 */
	public class DualCanvas2D implements ICanvas2D, ICanvasRender
	{
		private var _c1:ICanvas2D;
		private var _c2:ICanvas2D;
		
		public function DualCanvas2D( canvas1:ICanvas2D, canvas2:ICanvas2D ) 
		{
			_c1 = canvas1;
			_c2 = canvas2;
			if ( _c1 === _c2 ) {
				throw new ArgumentError("DualCanvas2D#constract: same instance.");
			}
		}
		
		/* INTERFACE frocessing.core.canvas.ICanvas2D */
		
		public function moveTo(x:Number, y:Number):void
		{
			_c1.moveTo( x, y );
			_c2.moveTo( x, y );
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_c1.lineTo( x, y );
			_c2.lineTo( x, y );
		}
		
		public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void
		{
			_c1.curveTo( cx, cy, x, y );
			_c2.curveTo( cx, cy, x, y );
		}
		
		public function bezierTo(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number):void
		{
			_c1.bezierTo( cx0, cy0, cx1, cy1, x, y );
			_c2.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		public function splineTo(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number):void
		{
			_c1.splineTo( cx0, cy0, cx1, cy1, x, y );
			_c2.splineTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		public function closePath():void
		{
			_c1.closePath();
			_c2.closePath();
		}
		
		public function get pathStartX():Number{ 	return _c1.pathStartX; }
		
		public function get pathStartY():Number{	return _c1.pathStartY; }
		
		public function get pathX():Number{			return _c1.pathX; }
		
		public function get pathY():Number{			return _c1.pathY; }
		
		public function pixel(x:Number, y:Number, color:uint, alpha:Number):void
		{
			_c1.pixel( x, y, color, alpha );
			_c2.pixel( x, y, color, alpha );
		}
		
		public function point(x:Number, y:Number, color:uint, alpha:Number):void
		{
			_c1.point( x, y, color, alpha );
			_c2.point( x, y, color, alpha );
		}
		
		public function triangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			_c1.triangle( x0, y0, x1, y1, x2, y2 );
			_c2.triangle( x0, y0, x1, y1, x2, y2 );
		}
		
		public function quad(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			_c1.quad( x0, y0, x1, y1, x2, y2, x3, y3 );
			_c2.quad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		public function triangleImage(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number):void
		{
			_c1.triangleImage( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
			_c2.triangleImage( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
		}
		
		public function quadImage(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number):void
		{
			_c1.quadImage( x0, y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
			_c2.quadImage( x0, y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
		}
		
		public function image(matrix:Matrix = null):void
		{
			_c1.image( matrix );
			_c2.image( matrix );
		}
		
		public function beginVertexShape(mode:int = 0):void
		{
			_c1.beginVertexShape( mode );
			_c2.beginVertexShape( mode );
		}
		
		public function endVertexShape(close_path:Boolean = false):void
		{
			_c1.endVertexShape();
			_c2.endVertexShape();
		}
		
		public function vertex(x:Number, y:Number, u:Number = 0, v:Number = 0):void
		{
			_c1.vertex( x, y, u, v );
			_c2.vertex( x, y, u, v );
		}
		
		public function bezierVertex(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number):void
		{
			_c1.bezierVertex( cx0, cy0, cx1, cy1, x, y );
			_c2.bezierVertex( cx0, cy0, cx1, cy1, x, y );
		}
		
		public function splineVertex(x:Number, y:Number):void
		{
			_c1.splineVertex( x, y );
			_c2.splineVertex( x, y );
		}
		
		public function clear():void
		{
			_c1.clear();
			_c2.clear();
		}
		
		public function get currentFill():ICanvasFill{ 	return _c1.currentFill; }
		public function set currentFill(value:ICanvasFill):void
		{
			_c1.currentFill = value;
			_c2.currentFill = value;
		}
		
		public function get currentStroke():ICanvasStroke{ 	return _c1.currentStroke; }
		public function set currentStroke(value:ICanvasStroke):void
		{
			_c1.currentStroke = value;
			_c2.currentStroke = value;
		}
		
		public function get fillEnabled():Boolean{ 	return _c1.fillEnabled; }
		public function set fillEnabled(value:Boolean):void
		{
			_c1.fillEnabled = value;
			_c2.fillEnabled = value;
		}
		
		public function get strokeEnabled():Boolean{ 	return _c1.strokeEnabled; }
		public function set strokeEnabled(value:Boolean):void
		{
			_c1.strokeEnabled = value;
			_c2.strokeEnabled = value;
		}
		
		public function beginCurrentStroke():void
		{
			_c1.beginCurrentStroke();
			_c2.beginCurrentStroke();
		}
		
		public function beginStroke(stroke:ICanvasStroke):void
		{
			_c1.beginStroke( stroke );
			_c2.beginStroke( stroke );
		}
		
		public function endStroke():void
		{
			_c1.endStroke();
			_c2.endStroke();
		}
		
		public function beginCurrentFill():void
		{
			_c1.beginCurrentFill();
			_c2.beginCurrentFill();
		}
		
		public function beginFill(fill:ICanvasFill):void
		{
			_c1.beginFill( fill );
			_c2.beginFill( fill );
		}
		
		public function endFill():void
		{
			_c1.endFill();
			_c2.endFill();
		}
		
		public function beginTexture(texture:BitmapData):void
		{
			_c1.beginTexture( texture );
			_c2.beginTexture( texture );
		}
		
		public function endTexture():void
		{
			_c1.endTexture();
			_c2.endTexture();
		}
		
		public function get imageSmoothing():Boolean {	return _c1.imageSmoothing; }
		public function set imageSmoothing(value:Boolean):void
		{
			_c1.imageSmoothing = value;
			_c2.imageSmoothing = value;
		}
		
		public function get imageDetail():uint{	return _c1.imageDetail; }
		public function set imageDetail(value:uint):void
		{
			_c1.imageDetail = value;
			_c2.imageDetail = value;
		}
		
		public function get bezierDetail():uint{	return _c1.bezierDetail; }
		public function set bezierDetail(value:uint):void
		{
			_c1.bezierDetail = value;
			_c2.bezierDetail = value;
		}
		
		public function get splineDetail():uint{	return _c1.splineDetail; }
		public function set splineDetail(value:uint):void
		{
			_c1.splineDetail = value;
			_c2.splineDetail = value;
		}
		
		public function get splineTightness():Number{	return _c1.splineTightness; }
		public function set splineTightness(value:Number):void
		{
			_c1.splineTightness = value;
			_c2.splineTightness = value;
		}
		
		public function background(width:Number, height:Number, color:uint, alpha:Number):void
		{
			_c1.background( width, height, color, alpha );
			_c2.background( width, height, color, alpha );
		}
		
		/* INTERFACE frocessing.core.canvas.ICanvasRender */
		
		public function render():void
		{
			if ( _c1 is ICanvasRender ) {
				ICanvasRender(_c1).render();
			}
			if ( _c2 is ICanvasRender ) {
				ICanvasRender(_c2).render();
			}
		}
		
	}
	
}