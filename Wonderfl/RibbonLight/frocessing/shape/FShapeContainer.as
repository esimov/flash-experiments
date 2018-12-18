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
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.FViewBox;
	
	/**
	* Shape Container.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeContainer extends AbstractFShape implements IFShapeContainer
	{
		/** @private */
		protected var _children:Array; //AbstractFShape[]
		/** @private */
		protected var _childCount:int;
		
		//
		public var viewbox:FViewBox;
		
		/**
		 * 
		 */
		public function FShapeContainer( parent_group:IFShapeContainer=null ) 
		{
			super( parent_group );
			
			_children   = [];
			_childCount = 0;
		}
		
		/**
		 * get childs path commannds.
		 */
		override public function get commands():Array {
			var c:Array = [];
			_createPathCommands( this, c );
			return c;
		}
		/**
		 * get childs path data.
		 */
		override public function get vertices():Array { 
			var c:Array = [];
			_create_transformed_path_data( new FMatrix2D(), c );
			//_createPathDatas( this, c );
			return c;
		}
		/** @private */
		private function _createPathCommands( s:IFShape, c:Array ):void {
			if ( s is IFShapeContainer ) {
				var sc:IFShapeContainer = IFShapeContainer(s);
				var n:uint = sc.getChildCount();
				for (var i:int = 0; i < n; i++) {
					_createPathCommands( sc.getChildAt(i), c );
				}
			}else {
				c.push.apply(null, s.commands );
			}
		}
		/** @private */
		/*
		private function _createPathDatas( s:IFShape, c:Array ):void {
			if ( s is IFShapeContainer ) {
				var sc:IFShapeContainer = IFShapeContainer(s);
				var n:uint = sc.getChildCount();
				for (var i:int = 0; i < n; i++) {
					_createPathDatas( sc.getChildAt(i), c );
				}
			}else {
				c.push.apply(null, s.vertices );
			}
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// Styles
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function enableStyle():void
		{
			_styleEnabled = true;
			for ( var i:int = 0; i < _childCount ; i++ ){
				IFShape(_children[i]).enableStyle();
			}
		}
		
		/** @inheritDoc */
		override public function disableStyle():void
		{
			_styleEnabled = false;
			for ( var i:int = 0; i < _childCount ; i++ ){
				IFShape(_children[i]).disableStyle();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Container
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * get children number.
		 */
		public function getChildCount():uint
		{
			return _childCount;
		}
		
		/**
		 * get child by index.
		 */
		public function getChildAt( index:int ):IFShape
		{
			return ( index < _childCount ) ? _children[index] : null;
		}
		
		/**
		 * get child by name.
		 */
		public function getChild( target:String ):IFShape 
		{
			if ( _name == target ) 
				return this;
				
			for ( var i:int = 0; i < _childCount; i++ ){
				var c:IFShape = _children[i];
				if ( c.name == target ){
					return c;
				}else if ( c is IFShapeContainer ){
					var d:IFShape = IFShapeContainer(c).getChild( target );
					if ( d != null )
						return d;
				}
			}
			return null;
		}
		
		/**
		 * find child by name. findChild() seek in parent container too.
		 */
		public function findChild( target:String ):IFShape 
		{
			if ( _parent == null )
				return getChild(target);
			else
				return _parent.findChild(target);
		}
		
		//for addChild , removeChild
		private var _recall_flg:Boolean = false;

		/**
		 * add shape object to the container.
		 */
		public function addChild( shape:IFShape ):IFShape
		{
			if ( !_recall_flg ) {
				var tmp:IFShapeContainer = shape.parent;
				if ( tmp != null ) {
					if ( tmp === this ) {
						var index:int = _children.indexOf( shape );
						if ( index > -1 ) {
							_children.splice( index, 1 );
							_childCount--;
						}
					}else{
						tmp.removeChild( shape );
					}
				}
				_children[_childCount] = shape;
				_childCount++;
				_geom_changed = true;
				if (tmp !== this) {
					_recall_flg = true;
					shape.parent = this;
					_recall_flg = false;
				}
				return shape;
			}
			return null;
		}
		
		/**
		 * remove shape object from the container.
		 */
		public function removeChild( shape:IFShape ):IFShape
		{
			if( !_recall_flg ){
				var index:int = _children.indexOf( shape );
				if ( index > -1 ){
					_children.splice( index, 1 );
					_childCount--;
					_geom_changed = true;
					if( shape.parent != null ){
						_recall_flg = true;
						shape.parent = null;
						_recall_flg = false;
					}
					return shape;
				}
			}
			return null;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw Graphics
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * the container does not draw anything.
		 */
		override public function drawGraphics(gc:Graphics):void {
			//_draw_to_graphics( gc );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Sprite
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * make Sprite instance　including child shapes.
		 */
		override public function toSprite():Sprite
		{
			if ( visible == false ) return null;
			
			var target:Sprite = new Sprite();
			if ( _matrix != null )
				target.transform.matrix = _matrix;
			
			//APPLY GRAPHICS
			for ( var i:int = 0; i < _childCount; i++ ) {
				var child_shape:AbstractFShape = _children[i];
				var s:DisplayObject = child_shape.toSprite();
				if ( s != null )
					target.addChild(s);
			}
			
			//TODO:(2)BlendMode
			target.alpha = _alpha;
			return target;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @inheritDoc */
		override public function get left():Number{
			_check_geom();
			return _left;
		}
		/** @inheritDoc */
		override public function get top():Number {
			_check_geom();
			return _top;
		}
		/** @inheritDoc */
		override public function get width():Number {
			_check_geom();
			return _width;
		}
		/** @inheritDoc */
		override public function get height():Number {
			_check_geom();
			return _height;
		}
		
		/** @private */
		override public function updateShapeGeom():void 
		{
			var r:Rectangle = _check_total_rect( new FMatrix2D(), null );
			if( r!=null ){
				_left   = r.x;
				_top    = r.y;
				_width  = r.width;
				_height = r.height;
				_geom_changed = false;
			}
		}
		
		/** @private */
		override internal function _check_total_rect( m:FMatrix2D, r:Rectangle ):Rectangle 
		{
			if ( visible == false )
				return r;
			
			if ( _matrix != null )
				m.prepend( _matrix );
			
			var m2:FMatrix2D = new FMatrix2D();
			for ( var i:int = 0; i < _childCount; i++ ) {
				m2.setMatrix( m.a, m.b, m.c, m.d, m.tx, m.ty);
				r = AbstractFShape(_children[i])._check_total_rect( m2, r );
			}
			return r;
		}
		
		/** @private */
		override internal function _create_transformed_path_data( m:FMatrix2D, c:Array ):void
		{
			if ( _visible != false ){
				if ( _matrix != null )
					m.prepend( _matrix );
					
				var m2:FMatrix2D = new FMatrix2D();
				for ( var i:int = 0; i < _childCount; i++ ) {
					m2.setMatrix( m.a, m.b, m.c, m.d, m.tx, m.ty);
					AbstractFShape(_children[i])._create_transformed_path_data( m2, c );
				}
			}
		}
	}
	
}