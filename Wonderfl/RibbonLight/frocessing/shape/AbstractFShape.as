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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	
	import frocessing.core.canvas.CanvasStyleAdapter;
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.canvas.ICanvasStroke;
	import frocessing.core.canvas.ICanvasStrokeFill;
	import frocessing.core.canvas.CanvasSolidFill;
	import frocessing.core.canvas.CanvasNormalGradientFill;
	import frocessing.core.canvas.CanvasStroke;
	import frocessing.core.canvas.CanvasNormalGradientStroke;
	import frocessing.core.graphics.FPath;
	import frocessing.geom.FMatrix2D;
	
	import frocessing.core.canvas.canvasImpl;
	use namespace canvasImpl;
	
	/**
	* Abstract Shape Object.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class AbstractFShape extends CanvasStyleAdapter implements IFShape
	{		
		/**
		 * 
		 */
		public var userData:Object = {};
		
		//core ----------------------------------------
		/** @private */
		internal var _sysData:Object;
		/** @private */
		internal var _name:String = "";
		/** @private */
		internal var _parent:IFShapeContainer;
		
		//attributes -----------------------------------
		/** @private */
		internal var _visible:Boolean = true;
		/** @private */
		internal var _alpha:Number;
		/** @private */
		internal var _styleEnabled:Boolean = true;
		/** @private */
		internal var _strokeEnabled:Boolean;
		/** @private */
		internal var _fillEnabled:Boolean;
		/** @private */
		internal var _stroke_setting:CanvasStroke;
		/** @private */
		internal var _fill_setting:CanvasSolidFill;
		/** @private */
		internal var _stroke:ICanvasStroke;
		/** @private */
		internal var _fill:ICanvasFill;
		
		//geometory ------------------------------------
		/** @private */
		internal var _matrix:FMatrix2D;
		/** @private */
		internal var _left:Number = 0;
		/** @private */
		internal var _top:Number = 0;
		/** @private */
		internal var _width:Number = 1;
		/** @private */
		internal var _height:Number = 1;
		/** @private */
		internal var _geom_changed:Boolean = false;
		
		/** @private */
		protected var _path:FPath;
		
		/**
		 * 
		 */
		public function AbstractFShape( parent_group:IFShapeContainer=null ) 
		{
			_parent = parent_group;
			_defaultSetting();
		}
		
		/**
		 * parent shape container.
		 */
		public function get parent():IFShapeContainer { return _parent; }
		public function set parent( container:IFShapeContainer ):void {
			//TODO:test shape container
			var tmp:IFShapeContainer = _parent;
			if ( container != tmp ) {
				if ( container == null ) {
					_parent = null;
					tmp.removeChild( this );
				}else {
					if( tmp != null ){
						_parent = null;
						tmp.removeChild( this );
					}
					_parent = container;
					container.addChild( this );
				}
			}
		}
		
		/**
		 * shape object name(id).
		 */
		public function get name():String { return _name; }
		public function set name( value:String ):void { 
			_name = value;
		}
		
		/**
		 * shape visible.
		 */
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Path
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * shape path commands.
		 */
		public function get commands():Array { return _path.commands;; }
		
		/**
		 * shape path data.
		 */
		public function get vertices():Array { return _path.data; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// Style
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		protected function _defaultSetting():void
		{
			_alpha = 1.0;
			if ( _parent == null ){
				//follow SVG initial setting
				_strokeEnabled  = false;
				_stroke_setting = new CanvasStroke( 0, 0, 1, false, "normal", "none", "round", 3 );
				_stroke		    = _stroke_setting;
				
				_fillEnabled    = true;
				_fill_setting   = new CanvasSolidFill( 0, 1 );
				_fill           = _fill_setting;
				
				_styleEnabled   = true;
			} else {
				//copy parent setting
				_strokeEnabled  = _parent.strokeEnabled;
				var st:ICanvasStroke = _parent.stroke.clone();
				if ( st is ICanvasStrokeFill ) {
					_stroke = st;
					_stroke_setting = ICanvasStrokeFill(_stroke).stroke;
				}else {
					_stroke = _stroke_setting = CanvasStroke(st);
				}
				
				_fillEnabled    = _parent.fillEnabled;
				var f:ICanvasFill = _parent.fill.clone();
				if ( f is CanvasSolidFill ) {
					_fill = _fill_setting = CanvasSolidFill(f);
				}else {
					_fill = f;
					_fill_setting = new CanvasSolidFill( _parent.fillColor, _parent.fillAlpha );
				}
				_styleEnabled   = _parent.styleEnabled;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * enable stroke and fill styles.
		 */
		public function enableStyle():void {
			_styleEnabled = true;
		}
		
		/**
		 * disable stroke and fill styles.
		 */
		public function disableStyle():void {
			_styleEnabled = false;
		}
		
		public function get styleEnabled():Boolean { return _styleEnabled; }
		
		/**
		 * stroke style enabled.
		 */
		public function get strokeEnabled():Boolean { return _strokeEnabled; }
		public function set strokeEnabled( value:Boolean ):void {
			_strokeEnabled = value;
		}
		
		/**
		 * fill style enabled.
		 */
		public function get fillEnabled():Boolean { return _fillEnabled; }
		public function set fillEnabled( value:Boolean ):void {
			_fillEnabled = value;
		}
		
		/**
		 * stroke style object.
		 */
		public function get stroke():ICanvasStroke { return _stroke; }
		public function set stroke(value:ICanvasStroke):void {
			_stroke = value;
			if ( _stroke is CanvasNormalGradientStroke ) {
				updateShapeGeom();
			}
		}
		
		/**
		 * fill stye object.
		 */
		public function get fill():ICanvasFill { return _fill; }
		public function set fill(value:ICanvasFill):void {
			_fill = value;
			if ( _fill is CanvasNormalGradientFill ) {
				updateShapeGeom();
			}
		}
		
		/**
		 * stroke color. 
		 */
		public function get strokeColor():uint { return _stroke_setting.color; }
		public function set strokeColor(value:uint):void {
			_stroke_setting.color = value;
		}
		/**
		 * stroke alpha. 
		 */
		public function get strokeAlpha():Number { return _stroke_setting.alpha; }
		public function set strokeAlpha(value:Number):void {
			_stroke_setting.alpha = value;
		}
		/**
		 * fill color.
		 * solid fill is applyed.
		 */
		public function get fillColor():uint { return _fill_setting.color; }
		public function set fillColor(value:uint):void {
			_fill_setting.color = value;
			_fill = _fill_setting;
		}
		/**
		 * fill alpha.
		 * solid fill is applyed.
		 */
		public function get fillAlpha():Number { return _fill_setting.alpha; }
		public function set fillAlpha(value:Number):void {
			_fill_setting.alpha = value;
			_fill = _fill_setting;
		}
		
		/** stroke thickness. */
		public function get thickness():Number { return _stroke_setting.thickness; }
		public function set thickness(value:Number):void {
			_stroke_setting.thickness = value;
		}
		/** 
		 * stroke caps.
		 * @see flash.display.CapsStyle
		 */
		public function get caps():String { return _stroke_setting.caps; }
		public function set caps(value:String):void {
			_stroke_setting.caps = value;
		}
		/** 
		 * stroke joints.
		 * @see flash.display.JointStyle
		 */
		public function get joints():String { return _stroke_setting.joints; }
		public function set joints(value:String):void {
			_stroke_setting.joints = value;
		}
		/** stroke pixelHinting */
		public function get pixelHinting():Boolean { return _stroke_setting.pixelHinting; }
		public function set pixelHinting(value:Boolean):void {
			_stroke_setting.pixelHinting = value;
		}
		/** 
		 * stroke scaleMode.
		 * @see flash.display.LineScaleMode
		 */
		public function get scaleMode():String { return _stroke_setting.scaleMode; }
		public function set scaleMode(value:String):void {
			_stroke_setting.scaleMode = value;
		}
		/** stroke miterLimit. */
		public function get miterLimit():Number { return _stroke_setting.miterLimit; }
		public function set miterLimit(value:Number):void {
			_stroke_setting.miterLimit = value;
		}
		
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// Transform
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * transform matrix( not clone ).
		 */
		public function get matrix():Matrix { return _matrix; }
		public function set matrix( value:Matrix ):void {
			if( value != null ){
				if ( _matrix == null )
					_matrix = new FMatrix2D();
				else
					_matrix.identity();
				_matrix.prepend( value );
			}else {
				_matrix = null;
			}
		}
		
		/**
		 * reset transfrom.
		 */
		public function resetMatrix():void
		{
			if ( _matrix == null )
				_matrix = new FMatrix2D();
			else
				_matrix.identity();
		}
		
		/**
		 * translate shape.
		 */
		public function translate( x:Number, y:Number ):void
		{
			if ( _matrix == null ) _matrix = new FMatrix2D();
			_matrix.prependTranslation( x, y );
		}
		
		/**
		 * scale shape.
		 */
		public function scale( x:Number, y:Number = NaN ):void
		{
			if ( _matrix == null ) _matrix = new FMatrix2D();
			_matrix.prependScale( x,  isNaN(y) ? x : y );
		}
		
		/**
		 * rotate shape.
		 */
		public function rotate( angle:Number ):void
		{
			if ( _matrix == null ) _matrix = new FMatrix2D();
			_matrix.prependRotation( angle );
		}
		
		/**
		 * apply matrix( prepend mat to current matrix ).
		 */
		public function applyMatrix( mat:Matrix ):void
		{
			if ( _matrix == null ) _matrix = new FMatrix2D();
			_matrix.prepend( mat );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw Graphics
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		protected var target_gc:Graphics;
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		protected function _draw_to_graphics( gc:Graphics ):void { ; }
		
		/**
		 * draw the shape to graphics.
		 */
		public function drawGraphics( gc:Graphics ):void
		{
			target_gc = gc;
			if ( _styleEnabled ) {
				//check geom for normal gradient
				_check_geom();
				//stroke setting
				if ( _strokeEnabled ) {
					_stroke.apply( this );
				}else{
					target_gc.lineStyle();
				}
				//fill setting and draw
				if ( _fillEnabled ){
					_fill.apply( this );
					_draw_to_graphics( target_gc );
					target_gc.endFill();
				}else{
					_draw_to_graphics( target_gc );
				}
			}else{
				_draw_to_graphics( target_gc );
			}
			target_gc = null;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Sprite
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * make new Sprite instance.
		 */
		public function toSprite():Sprite
		{
			if ( _visible == false ) return new Sprite();
			
			var target:Sprite = new Sprite();
			if ( _matrix != null )
				target.transform.matrix = _matrix;
			
			//APPLY GRAPHICS
			drawGraphics( target.graphics );
			
			//TODO:(2)BlendMode Layer
			target.alpha = _alpha;
			return target;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		public function get left():Number { return _left; }
		public function get top():Number { return _top; }
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		/**
		 * update shape rectangle.( left, top, width, height )
		 */
		public function updateShapeGeom():void 
		{
			//TODO:update parent geom flg
			//updateNormalGradient
			if ( _fill is CanvasNormalGradientFill ) {
				CanvasNormalGradientFill(_fill).setRect( _left, _top, _width, _height );
			}
			if ( _stroke is CanvasNormalGradientStroke ) {
				CanvasNormalGradientStroke(_stroke).setRect( _left, _top, _width, _height );
			}
			_geom_changed = false;
		}
		
		/** @private */
		protected function _check_geom():void {
			if ( _geom_changed ) {
				updateShapeGeom();
			}
		}
		
		/**
		 * check path vertices in parent coordinates.
		 * @private
		 */
		internal function _check_total_rect( m:FMatrix2D, r:Rectangle ):Rectangle 
		{
			if ( _visible == false )
				return r;
			
			if ( _matrix != null )
				m.prepend( _matrix );
			
			_check_geom();
			return FPath.getRect( _path.commands, FPath.transform(_path.data, m.a, m.b, m.c, m.d, m.tx, m.ty), r );
		}
		
		/**
		 * get transformed path vertices.
		 * @private
		 */
		internal function _create_transformed_path_data( m:FMatrix2D, c:Array ):void 
		{
			if ( _visible != false ){
				if ( _matrix != null ) 
					m.prepend( _matrix );
					
				c.push.apply(null, FPath.transform(_path.data, m.a, m.b, m.c, m.d, m.tx, m.ty) );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// reg point
		//-------------------------------------------------------------------------------------------------------------------
		/**
		 * @private
		 * change reg point
		 */
		/*
		public function zeroPoint( x:Number=0, y:Number=0, normal:Boolean=true ):void
		{
			_checkmatrix();
			_check_geom();
			if ( normal ){
				_matrix.prependTranslation( -_left - _width * x,  -_top - _height * y );
				_left = - _width * x;
				_top  = - _height * y;
			}else{
				_matrix.prependTranslation( -x, -y );
				_left -= x;
				_top  -= y;
			}
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// CANVAS IMPLEMENTS : for create Sprite
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override canvasImpl function noLineStyle():void {
			target_gc.lineStyle();
		}
		/** @private */
		override canvasImpl function lineStyle(thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number):void {
			target_gc.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		/** @private */
		override canvasImpl function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			target_gc.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginSolidFill(color:uint, alpha:Number):void {
			target_gc.moveTo(0,0); //reset point for player 9 bug
			target_gc.beginFill(color, alpha);
		}
		/** @private */
		override canvasImpl function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			target_gc.moveTo(0, 0); //reset point for player 9 bug
			target_gc.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		/** @private */
		override canvasImpl function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix, repeat:Boolean, smooth:Boolean):void {
			target_gc.moveTo(0,0); //reset point for player 9 bug
			target_gc.beginBitmapFill(bitmapData, matrix, repeat, smooth);
		}
	}
	
}