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
	/**
	 * @author nutsu
	 * @version 0.6
	 */
	public interface ICanvas 
	{
		function clear():void;
		
		function get currentFill():ICanvasFill;
		function set currentFill(value:ICanvasFill):void;
		function get currentStroke():ICanvasStroke;
		function set currentStroke(value:ICanvasStroke):void;
		
		function get fillEnabled():Boolean;
		function set fillEnabled(value:Boolean):void;
		function get strokeEnabled():Boolean;
		function set strokeEnabled(value:Boolean):void;
		
		function beginCurrentStroke():void;
		function beginStroke( stroke:ICanvasStroke ):void;
		function endStroke():void;
		
		function beginCurrentFill():void;
		function beginFill( fill:ICanvasFill ):void;
		function endFill():void;
		
		function beginTexture( texture:BitmapData ):void;
		function endTexture():void;
		
		function get imageSmoothing():Boolean;
		function set imageSmoothing( value:Boolean ):void;
		function get imageDetail():uint;
		function set imageDetail( value:uint ):void;
		
		function get bezierDetail():uint;
		function set bezierDetail(value:uint):void;
		function get splineDetail():uint;
		function set splineDetail(value:uint):void;
		function get splineTightness():Number;
		function set splineTightness(value:Number):void;
		
		function background( width:Number, height:Number, color:uint, alpha:Number ):void;
	}
	
}