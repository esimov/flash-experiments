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

package frocessing.shape 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import frocessing.core.canvas.ICanvasStroke;
	import frocessing.core.canvas.ICanvasFill;
	
	/**
	* Interface of shape object.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public interface IFShape 
	{
		//information
		function get name():String;
		
		//visible of shape
		function get visible():Boolean;
		
		//parent container
		function get parent():IFShapeContainer;
		function set parent( container:IFShapeContainer ):void;
		
		//path
		function get commands():Array;
		function get vertices():Array;
		
		//style
		function get styleEnabled():Boolean;
		function get strokeEnabled():Boolean;
		function set strokeEnabled( value:Boolean ):void;
		function get fillEnabled():Boolean;
		function set fillEnabled( value:Boolean ):void;
		function enableStyle():void;
		function disableStyle():void;
		
		//stroke style
		function get stroke():ICanvasStroke;
		function get strokeColor():uint;
		function set strokeColor(value:uint):void;
		function get strokeAlpha():Number;
		function set strokeAlpha(value:Number):void;
		function get thickness():Number;
		function set thickness(value:Number):void;
		function get caps():String;
		function set caps(value:String):void ;
		function get joints():String;
		function set joints(value:String):void;
		function get pixelHinting():Boolean;
		function set pixelHinting(value:Boolean):void;
		function get scaleMode():String;
		function set scaleMode(value:String):void;
		function get miterLimit():Number;
		function set miterLimit(value:Number):void;
		
		//fill style
		function get fill():ICanvasFill;
		function get fillColor():uint;
		function set fillColor(value:uint):void;
		function get fillAlpha():Number;
		function set fillAlpha(value:Number):void;
		
		//geom
		function get left():Number;
		function get top():Number;
		function get width():Number;
		function get height():Number;
		function get matrix():Matrix;
		
		//create
		function toSprite():Sprite;
	}
	
}