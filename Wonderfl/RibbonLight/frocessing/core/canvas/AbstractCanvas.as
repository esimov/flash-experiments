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
	 * Abstract Canvas.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class AbstractCanvas extends CanvasStyleAdapter implements ICanvas
	{
		/*
		 * 拡張する場合は、以下のメソッドを描画ターゲットに合わせて実装します.
		 * 
		 * [AbstractCanvas]
		 * _beginCurrentStroke, beginStroke, endStroke
		 * _beginCurrentFill, beginFill, _endFill
		 * background
		 * imageSmoothing, imageDetail
		 * 
		 * [CanvasStyleAdapter]
		 * noLineStyle, lineStyle, lineGradientStyle
		 * beginSolidFill, beginBitmapFill, beginGradientFill
		 */
		
		//style status
		/** @private */
		protected var _strokeDo:Boolean;
		/** @private */
		protected var _fillDo:Boolean;
		/** @private */
		protected var _fill_apply_count:int = 0;
		
		/** @private */
		protected var _texture_flg:Boolean = false;
		/** @private */
		protected var _texture:BitmapData;
		
		/** @private */
		protected var _currentFill:ICanvasFill;
		/** @private */
		protected var _currentStroke:ICanvasStroke;
		/** @private */
		protected var _fillEnabled:Boolean;
		/** @private */
		protected var _strokeEnabled:Boolean;
		
		/** @private */
		protected var _stroke_setting:CanvasStroke; //currentStrokeの基本パラメータ
		
		/** @private */
		protected var _bezierDetail:uint = 20;
		/** @private */
		protected var _splineDetail:uint = 20;
		/** @private */
		protected var _splineTightness:Number = 1.0;
		
		/**
		 * 
		 */
		public function AbstractCanvas() 
		{
			//default styles
			_strokeDo      = true
			_strokeEnabled = true;
			_currentStroke = _stroke_setting = new CanvasStroke( 0, 0, 1.0, false, "none", "none", "round", 3 );
			_fillDo        = false;
			_fillEnabled   = true;
			_currentFill   = new CanvasSolidFill( 0xffffff, 1.0 );
		}
		
		/**
		 * グラフィックをクリアします.
		 */
		public function clear():void 
		{
			_fill_apply_count = 0;
			_texture_flg      = false;
			_texture   		  = null;
			_fillDo           = false;
			beginCurrentStroke();
		}
		
		//------------------------------------------------------------------------------------------------------------------- STYLE
		
		/**
		 * 現在の塗りを示します.
		 */
		public function get currentFill():ICanvasFill { return _currentFill; }
		public function set currentFill(value:ICanvasFill):void {
			_currentFill = value;
			_fillEnabled = true;
		}
		
		/**
		 * 現在のストロークをしめします.
		 */
		public function get currentStroke():ICanvasStroke { return _currentStroke; }
		public function set currentStroke(value:ICanvasStroke):void {
			_currentStroke = value;
			_strokeEnabled = true;
		}
		
		/**
		 * 
		 */
		public function get fillEnabled():Boolean { return _fillEnabled; }
		public function set fillEnabled(value:Boolean):void {
			_fillEnabled = value;
		}
		
		/**
		 * 
		 */
		public function get strokeEnabled():Boolean { return _strokeEnabled; }
		public function set strokeEnabled(value:Boolean):void {
			_strokeEnabled = value;
		}
		//------------------------------------------
		
		/**
		 * strokeEnabled　が true の場合、直前のストロークを再開します.
		 */
		public function beginCurrentStroke():void{
			if ( strokeEnabled ) _beginCurrentStroke();
		}
		/** @private */
		protected function _beginCurrentStroke():void { ; }
		
		/**
		 * ストロークを開始します.
		 * strokeEnabled　が true になります.
		 */
		public function beginStroke( stroke:ICanvasStroke ):void { ; }
		
		/**
		 * ストロークを終了します.
		 */
		public function endStroke():void { ; }
		
		//------------------------------------------
		/**
		 * fillEnabled　が true の場合、直前の塗りを開始します.
		 */
		public function beginCurrentFill():void {
			if ( fillEnabled && _fill_apply_count<1 ){
				_fill_apply_count = 1;
				_beginCurrentFill();
			}else{
				_fill_apply_count++;
			}
		}
		/** @private */
		protected function _beginCurrentFill():void { ; }
		
		/**
		 * 塗りを開始します.
		 * fillEnabled　が true になります.
		 */
		public function beginFill( fill:ICanvasFill ):void { ; }
		
		/**
		 * 塗りを終了します.
		 */
		public function endFill():void {
			if ( _fill_apply_count == 1 ){
				_endFill();
				_fill_apply_count = 0;
			}else{
				_fill_apply_count--;
			}
		}
		/** @private */
		protected function _endFill():void { ; }
		
		//-------------------------------------------
		
		/**
		 * 描画する テクスチャ(画像) を設定します.
		 */
		public function beginTexture( texture:BitmapData ):void {
			_texture      = texture;
			_texture_flg  = true;
		}
		
		/**
		 * テクスチャの終了.
		 */
		public function endTexture():void {
			_texture_flg  = false;
			_texture      = null;
		}
		
		/**
		 * texture を描画する場合の Smoothing を指定します.
		 */
		public function get imageSmoothing():Boolean { return true; }
		public function set imageSmoothing( value:Boolean ):void { ; }
		
		/**
		 * 変形 texture を描画する場合の 精度 を指定します.
		 * ポリゴン数は 2 * (imageDetail^2) になる.
		 */
		public function get imageDetail():uint { return 1; }
		public function set imageDetail( value:uint ):void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/** 
		 * bezierTo（）メソッドで描画する曲線の精度.
		 */
		public function get bezierDetail():uint { return _bezierDetail; }
		public function set bezierDetail(value:uint):void {
			_bezierDetail = value;
		}
		/**
		 * splineTo（）メソッドで描画する曲線の精度.
		 */
		public function get splineDetail():uint { return _splineDetail; }
		public function set splineDetail(value:uint):void{
			_splineDetail = value;
		}
		/**
		 * スプライン曲線の曲率を指定します.
		 */
		public function get splineTightness():Number { return _splineTightness; }
		public function set splineTightness(value:Number):void {
			_splineTightness = value;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		/**
		 * 背景を描画します.描画内容はクリアされます.
		 */
		public function background( width:Number, height:Number, color:uint, alpha:Number ):void { ; }
		
		
	}
	
}