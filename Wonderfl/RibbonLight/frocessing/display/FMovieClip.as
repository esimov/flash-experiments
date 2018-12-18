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

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import frocessing.utils.FLoadUtil;
	import frocessing.utils.IObjectLoader;
	
	/**
	* FMovieClip.
	* 
	* Event handler
	* setup()
	* predraw()
	* draw()
	* 
	* Mouse events
	* mousePressed()
	* mouseReleased()
	* mouseClicked()
	* mouseMoved()
	* 
	* Keyboard events
	* keyPressed()
	* keyReleased()
	* 
	* @author nutsu
	* @version 0.6
	*/
	public dynamic class FMovieClip extends MovieClip
	{
		// loop -----------------------------------------
		private var __loop_on_start_draw:Boolean;
		private var __loop:Boolean;
		private var __frameCount:uint;
		
		// event handling
		private var __eo:InteractiveObject;
		
		// setting function -----------------------------
		private var __draw:Function;
		private var __setup:Function;
		private var __predraw:Function;
		private var __mouseClicked:Function;
		private var __mouseMoved:Function;
		private var __mousePressed:Function;
		private var __mouseReleased:Function;
		private var __keyPressed:Function;
		private var __keyReleased:Function;
		//private var __keyTyped:Function;
		
		// mouse and key status -------------------------
		private var __pmouseX:Number;
		private var __pmouseY:Number;
		private var __isMousePressed:Boolean;
		private var __isKeyPressed:Boolean;
		private var __keyCode:uint;
		
		// setup flg ------------------------------------
		/** @private */
		internal var __setup_done:Boolean;
		/** @private */
		internal var __setup_load_objects:Array;
		//
		private var __now_on_stage:Boolean;
		/**
		 * setup() 内の読み込み(loadURL,loadShape,loadImage,loadFont,loadString)を待つかどうか指定します.
		 */
		public var syncSetup:Boolean = true;
		
		/**
		 * @param	eventHandleObject	handling object for mouse,key evnet. (default null to stage)
		 */
		public function FMovieClip( eventHandleObject:InteractiveObject=null )
		{
			__eo             = eventHandleObject;
			
			__pmouseX        = 0;
			__pmouseY        = 0;
			__isMousePressed = false;
			__isKeyPressed   = false;
			__keyCode        = 0;
			
			__loop_on_start_draw = true;
			__loop           = false;
			__frameCount     = 0;
			
			__setup_load_objects = [];
			__setup_done     = false;
			__now_on_stage   = false;
			
			//check setup() and draw()
			__setup          = __getfunction(F5EventHandler.SETUP);
			__draw           = __getfunction(F5EventHandler.DRAW);
			__predraw		 = __getfunction(F5EventHandler.PRE_DRAW);
			__mouseClicked   = __getfunction(F5EventHandler.MOUSE_CLICK);
			__mouseMoved     = __getfunction(F5EventHandler.MOUSE_MOVE);
			__mousePressed   = __getfunction(F5EventHandler.MOUSE_DOWN);
			__mouseReleased  = __getfunction(F5EventHandler.MOUSE_UP);
			__keyPressed     = __getfunction(F5EventHandler.KEY_DOWN);
			__keyReleased    = __getfunction(F5EventHandler.KEY_UP);
			
			//TODO:(3)ther initialize trigger
			addEventListener( Event.ADDED_TO_STAGE, __on_added_to_stage );
			
			// for draw script in constract and framescript
			__pre_draw(); 
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		//f5 draw target setting
		/** @private */
		internal function __init_draw():void { ; }
		/** @private */
		internal function __pre_draw():void { ; }
		/** @private */
		internal function __post_draw():void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		internal function get __stage_width():Number{
			return ( stage != null && stage.stageWidth > 0 ) ? stage.stageWidth : 100;
		}
		
		/** @private */
		internal function get __stage_height():Number{
			return ( stage != null && stage.stageHeight > 0 ) ? stage.stageHeight : 100;
		}
		
		/** @private */
		private function __getfunction( functionName:String ):Function {
			try {
				return ( this[functionName] is Function ) ? this[functionName] : null;
			}catch( e:Error ){
				;
			}
			return null;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * setup and start draw.
		 * @private
		 */
		private function __on_added_to_stage(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, __on_added_to_stage );
			__now_on_stage = true;
			addEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
			
			if(__eo == null ) __eo = stage; //TODO: re added to stage
			stage.stageFocusRect = false;
			
			__init_draw();
			
			addEventListener( Event.ENTER_FRAME, __on_framescript_draw );
		}
		
		/** apply drawing writen in frame scrpit */
		private function __on_framescript_draw( e:Event ):void
		{
			removeEventListener( Event.ENTER_FRAME, __on_framescript_draw );
			__post_draw();
			__start_setup();
		}
		
		private function __start_setup():void
		{
			//begin set up ( how ever removed from stage )
			__setup_done = false;
			__setup_load_objects = [];
			
			//setup()
			if ( __setup != null )
				__setup.apply(this,null);
			
			//draw() or wait loading
			if ( __setup_load_objects.length == 0 )
				__on_setup_done();
		}
		
		/** @private */
		internal function __setup_load_callback():void
		{
			//TODO:(2)exception handling
			__setup_load_objects.pop();
			if ( __setup_load_objects.length == 0 )
				__on_setup_done();
		}
		
		private function __on_setup_done():void
		{
			__setup_done = true;
			__setup_load_objects = null;
			
			//call predraw
			if ( __predraw != null )
				__predraw.apply( this, null );
			
			//for noLoop() called.
			if ( !__loop_on_start_draw )
				redraw();
			
			//start drawing
			__start_draw();
		}
		
		private function __start_draw():void
		{
			if ( stage != null ) {
				//event handlers init.
				__eo.addEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
				__eo.addEventListener( KeyboardEvent.KEY_UP,   _keyReleased );
				__eo.addEventListener( MouseEvent.MOUSE_DOWN,  _mousePressed );
				__eo.addEventListener( MouseEvent.MOUSE_UP,    _mouseReleased );
				if ( __mouseClicked  != null ) __eo.addEventListener( MouseEvent.CLICK, _mouseClicked );
				if ( __mouseMoved    != null ) __eo.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved );
				
				//ui parameter reset
				__pmouseX        = mouseX;
				__pmouseY        = mouseY;
				__isMousePressed = false;
				__isKeyPressed   = false;
				__keyCode        = 0;
			
				//draw start
				__loop = false;
				if ( __loop_on_start_draw )
					loop();
			}
		}
		
		private function __stop_draw():void
		{
			//event handlers remove.
			__eo.removeEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
			__eo.removeEventListener( KeyboardEvent.KEY_UP,  _keyReleased );
			__eo.removeEventListener( MouseEvent.MOUSE_DOWN, _mousePressed );
			__eo.removeEventListener( MouseEvent.MOUSE_UP,   _mouseReleased );
			if ( __mouseClicked  != null ) __eo.removeEventListener( MouseEvent.CLICK, _mouseClicked );
			if ( __mouseMoved    != null ) __eo.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved );
			
			//tmp loop status for re added to stage
			__loop_on_start_draw = __loop;
			//stop loop
			noLoop();
		}
		
		/**
		 * re added to stage
		 */
		private function __on_re_added_to_stage(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, __on_re_added_to_stage );
			__now_on_stage = true;
			__start_draw();
			addEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
		}
		
		/**
		 * removed from stage
		 */
		private function __on_removed_from_stage(e:Event):void
		{
			//TODO:check remove on setup
			removeEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
			__now_on_stage = false;
			__stop_draw();
			addEventListener( Event.ADDED_TO_STAGE, __on_re_added_to_stage );
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		private function __on_enter_frame( e:Event ):void
		{
			__frameCount++;
			__pre_draw();
			__draw();
			__post_draw();
			//mouse coordinates
			__pmouseX = mouseX;
			__pmouseY = mouseY;
		}
		
		/**
		 * frame count from start drawing.
		 */
		public function get frameCount():uint { return __frameCount; }
		
		/**
		 * apply draw() on enterframe.
		 */
		public function loop():void 
		{
			if ( __setup_done ) {
				if ( __loop == false && __draw != null ){
					addEventListener( Event.ENTER_FRAME, __on_enter_frame );
					__loop = true;
					__pmouseX = mouseX;
					__pmouseY = mouseY;
				}
			}else {
				__loop_on_start_draw = true;
			}
		}
		
		/**
		 * stop draw() on enterframe.
		 */
		public function noLoop():void
		{
			if ( __setup_done ) {
				if ( __loop ){
					removeEventListener( Event.ENTER_FRAME, __on_enter_frame );
					__loop = false;
				}
			}else{
				__loop_on_start_draw = false;
			}
		}
		
		/**
		 * apply draw().
		 */
		public function redraw():void
		{
			if ( __draw != null )
				__on_enter_frame(null);
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// INPUT
		//-------------------------------------------------------------------------------------------------------------------
		
		private function _mousePressed( e:MouseEvent ):void
		{
			__isMousePressed = true;
			if ( __mousePressed != null ) __mousePressed();
			if ( stage != null && __eo != stage && __eo != stage.focus ) {
				stage.focus = __eo;
			}
		}
		private function _mouseReleased( e:MouseEvent ):void
		{
			__isMousePressed = false;
			if( __mouseReleased!=null ) __mouseReleased(); 
		}
		private function _keyPressed( e:KeyboardEvent ):void
		{
			__isKeyPressed = true;
			__keyCode = e.keyCode;
			if( __keyPressed!=null ) __keyPressed();
		}
		private function _keyReleased( e:KeyboardEvent ):void 
		{
			__isKeyPressed = false;
			if( __keyReleased!=null ) __keyReleased();
		}
		private function _mouseClicked( e:MouseEvent ):void 
		{
			__mouseClicked();
		}
		private function _mouseMoved( e:MouseEvent ):void
		{
			__mouseMoved();
		}
		
		/**
		 * pre mouseX. 
		 */
		public function get pmouseX():Number { return __pmouseX; }
		/**
		 * pre mouseY.
		 */
		public function get pmouseY():Number { return __pmouseY; }
		/**
		 * is mouse pressed.
		 */
		public function get isMousePressed():Boolean { return __isMousePressed; }
		/**
		 * is key pressed.
		 */
		public function get isKeyPressed():Boolean { return __isKeyPressed; }
		/**
		 * the keycode of last key pressed.
		 */
		public function get keyCode():uint { return __keyCode; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// Event Handler
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * Change the event handler, or handling non public function.
		 *  
		 * @param	handlerName
		 * @param	handler
		 * @see		frocessing.display.F5EventHandler
		 */
		public function event( handlerName:String, handler:Function ):void
		{
			switch( handlerName ) {
				case F5EventHandler.SETUP:		__setup = handler;			break;
				case F5EventHandler.DRAW:		__draw = handler;			break;
				case F5EventHandler.PRE_DRAW:	__predraw = handler;		break;
				case F5EventHandler.MOUSE_DOWN:	__mousePressed = handler; 	break;
				case F5EventHandler.MOUSE_UP:	__mouseReleased = handler;	break;
				case F5EventHandler.KEY_DOWN:	__keyPressed = handler;		break;
				case F5EventHandler.KEY_UP:		__keyReleased = handler;	break;
				case F5EventHandler.MOUSE_CLICK:
					__mouseClicked = handler;
					if ( __eo.hasEventListener( MouseEvent.MOUSE_DOWN ) && !__eo.hasEventListener( MouseEvent.CLICK ) ) { 
						//handling events now
						__eo.addEventListener( MouseEvent.CLICK, _mouseClicked );
					}
					break;
				case F5EventHandler.MOUSE_MOVE:
					__mouseMoved = handler;
					if ( __eo.hasEventListener( MouseEvent.MOUSE_DOWN ) && !__eo.hasEventListener( MouseEvent.MOUSE_MOVE ) ) { 
						//handling events now
						__eo.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved );
					}
					break;
				default:
					break;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// LOAD
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * URL を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * 
		 * @param	url
		 * @param	loader	URLLoader or Loader or Sound( null　to new URLLoader )
		 * @return	loader
		 * 
		 * @see frocessing.utils.FLoadUtil#load
		 */
		public function loadURL( url:String, loader:EventDispatcher = null ):EventDispatcher 
		{
			var _loader:EventDispatcher = FLoadUtil.load( url, loader, __setup_load_callback, __setup_load_callback );
			if ( !__setup_done && syncSetup ) {
				__setup_load_objects.push( _loader );	
			}
			return _loader;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// UTIL
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * StageQuality to LOW.
		 */
		public function QLow():void{
			if ( stage!=null ) stage.quality = StageQuality.LOW;
		}
		
		/**
		 * StageQuality to MEDIUM.
		 */
		public function QMedium():void{
			if ( stage!=null ) stage.quality = StageQuality.MEDIUM;
		}
		
		/**
		 * StageQuality to HIGH.
		 */
		public function QHigh():void{
			if ( stage!=null ) stage.quality = StageQuality.HIGH;
		}
		
		/**
		 * StageQuality to BEST.
		 */
		public function QBest():void{
			if ( stage!=null ) stage.quality = StageQuality.BEST;
		}
	}
}
