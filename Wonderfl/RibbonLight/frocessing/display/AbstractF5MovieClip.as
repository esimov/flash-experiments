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

package frocessing.display 
{
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.geom.Matrix;
	
	import frocessing.core.F5C;
	import frocessing.core.AbstractF5Canvas;
	
	import frocessing.color.FColor;
	import frocessing.color.ColorLerp;
	import frocessing.color.ColorBlend;
	import frocessing.text.IFont;
	import frocessing.text.PFontLoader;
	import frocessing.shape.IFShape;
	import frocessing.shape.FShapeSVGLoader;
	import frocessing.bmp.FImageLoader;
	import frocessing.utils.FStringLoader;
	import frocessing.math.FMath;
	import frocessing.math.FCurveMath;
	import frocessing.math.PerlinNoise;
	import frocessing.utils.FUtil;
	import frocessing.utils.FDate;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	 * AbstractF5MovieClip.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public dynamic class AbstractF5MovieClip extends FMovieClip
	{
		// constants
		public static const RGB        :String = F5C.RGB;
		public static const HSB        :String = F5C.HSB;
		public static const HSV        :String = F5C.HSV;
		
		public static const CORNER        :int = F5C.CORNER;
		public static const CORNERS       :int = F5C.CORNERS;
		public static const RADIUS        :int = F5C.RADIUS;
		public static const CENTER        :int = F5C.CENTER;
		
		public static const LEFT    	  :int = F5C.LEFT;
		public static const RIGHT   	  :int = F5C.RIGHT;
		public static const BASELINE	  :int = F5C.BASELINE;
		public static const TOP     	  :int = F5C.TOP;
		public static const BOTTOM  	  :int = F5C.BOTTOM;
		
		public static const POLYGON       :int = F5C.POLYGON;
		public static const POINTS        :int = F5C.POINTS;
		public static const LINES         :int = F5C.LINES; 
		public static const TRIANGLES     :int = F5C.TRIANGLES;
		public static const TRIANGLE_FAN  :int = F5C.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = F5C.TRIANGLE_STRIP;
		public static const QUADS         :int = F5C.QUADS;
		public static const QUAD_STRIP    :int = F5C.QUAD_STRIP;
		
		public static const OPEN      :Boolean = F5C.OPEN;
		public static const CLOSE     :Boolean = F5C.CLOSE;
		
		public static const NORMALIZED    :int = F5C.NORMALIZED;
		public static const IMAGE         :int = F5C.IMAGE;
		
		public static const PI         :Number = Math.PI;
		public static const TWO_PI     :Number = Math.PI*2;
		public static const HALF_PI    :Number = Math.PI/2;
		
		public static const NORMAL     :String = ColorBlend.NORMAL;
		public static const ADD        :String = ColorBlend.ADD;
		public static const SUBTRACT   :String = ColorBlend.SUBTRACT;
		public static const DARKEN     :String = ColorBlend.DARKEN;
		public static const LIGHTEN    :String = ColorBlend.LIGHTEN;
		public static const DIFFERENCE :String = ColorBlend.DIFFERENCE;
		public static const MULTIPLY   :String = ColorBlend.MULTIPLY;
		public static const SCREEN     :String = ColorBlend.SCREEN;
		public static const OVERLAY    :String = ColorBlend.OVERLAY;
		public static const HARDLIGHT  :String = ColorBlend.HARDLIGHT;
		public static const SOFTLIGHT  :String = ColorBlend.SOFTLIGHT;
		public static const DODGE      :String = ColorBlend.DODGE;
		public static const BURN       :String = ColorBlend.BURN;
		public static const EXCLUSION  :String = ColorBlend.EXCLUSION;
		
		/** @private */
		private var __fg:AbstractF5Canvas;
		/** @private */
		private var __draw_target:DisplayObject;
		/** @private */
		private var __viewport:Sprite;
		
		// noise
		private var __perlin_noise:PerlinNoise;
		
		/**
		 * 
		 */
		public function AbstractF5MovieClip( f5canvas:AbstractF5Canvas, target:DisplayObject=null, useStageEvent:Boolean=true  ) 
		{
			__fg = f5canvas;
			__viewport = new Sprite();
			if( target !=null ) __draw_target = target;
			super( (useStageEvent) ? null : __viewport );
			
			addChild( __viewport );
			
			//init perlin noise
			__perlin_noise = new PerlinNoise();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override internal function __init_draw():void {
			//TODO:(2) set default size if stage size is buggy.
			if ( __draw_target != null )
				__viewport.addChild( __draw_target );
		}
		
		/** @private */
		override internal function __pre_draw():void {
			__fg.beginDraw();
		}
		/** @private */
		override internal function __post_draw():void {
			__fg.endDraw();
		}
		
		/**
		 * view object (draw target container).
		 * 
		 * <p>
		 * F5MovieClip,F5MovieClip2D,F5MovieClip3D has Shape<br/>
		 * F5MovieClip2DBmp,F5MovieClip3DBmp has Bitmap
		 * </p>
		 */
		public function get viewport():Sprite { return __viewport; }
		
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function size( width_:uint, height_:uint ):void {
			__fg.size( width_, height_ );
		}
		
		/**
		 * 
		 */
		public function clear():void{
			__fg.clear();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Color
		//-------------------------------------------------------------------------------------------------------------------
		
		public function colorMode( mode:String, range1:Number = 0xff, range2:Number = NaN, range3:Number = NaN, range4:Number = NaN ):void {
			__fg.colorMode( mode, range1, range2, range3, range4 );
		}
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint{
			return __fg.color( c1, c2, c3, c4 );
		}
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.background( c1, c2, c3, c4 );
		}
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.stroke( c1, c2, c3, c4 );
		}
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.fill( c1, c2, c3, c4 );
		}
		public function fillGradient( type:String, a:Number, b:Number, c:Number, d:Number, colors:Array, alphas:Array = null, ratios:Array = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0 ):void {
			__fg.fillGradient( type, a, b, c, d, colors, alphas, ratios, spreadMethod, interpolationMethod, focalPointRatio );
		}
		public function fillBitmap( bitmapData:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false ):void {
			__fg.fillBitmap( bitmapData, matrix, repeat, smooth );
		}
		public function noStroke():void{
			__fg.noStroke();
		}
		public function noFill():void{
			__fg.noFill();
		}
		public function tint( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.tint( c1, c2, c3, c4 );
		}
		public function noTint():void{
			__fg.noTint();
		}
		
		// Color Creating & Reading
		
		public function red( c:uint ):Number{
			return __fg.colorModeX * FColor.red( c )/0xff;
		}
		public function green( c:uint ):Number{
			return __fg.colorModeY * FColor.green( c )/0xff;
		}
		public function blue( c:uint ):Number{
			return __fg.colorModeZ * FColor.blue( c )/0xff;
		}
		public function hue( c:uint ):Number{
			return __fg.colorModeX * FColor.hue( c )/360;
		}
		public function saturation( c:uint ):Number{
			return __fg.colorModeY * FColor.saturation( c );
		}
		public function brightness( c:uint ):Number{
			return __fg.colorModeZ * FColor.brightness( c );
		}
		public function f5_alpha( c:uint ):Number{
			return __fg.colorModeA * FColor.alpha( c );
		}
		public function lerpColor( c1:uint, c2:uint, amt:Number ):uint{
			ColorLerp.mode = __fg.colorModeState;
			return ColorLerp.lerp( c1, c2, amt );
		}
		public function blendColor( c1:uint, c2:uint, blend_mode:String ):uint{
			return ColorBlend.blend( c1, c2, blend_mode );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Attribute
		//-------------------------------------------------------------------------------------------------------------------
		
		public function strokeWeight( thickness:Number ):void{
			__fg.strokeWeight( thickness );
		}
		/**
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void{
			__fg.strokeJoin( jointStyle );
		}
		/**
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void{
			__fg.strokeCap( capsStyle );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Style
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function pushStyle():void{
			__fg.pushStyle();
		}
		
		/**
		 * 
		 */
		public function popStyle():void{
			__fg.popStyle();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Shape
		
		/**
		 * rect()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function rectMode( mode:int ):void {
			__fg.rectMode( mode );
		}
		
		/**
		 * ellipse()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function ellipseMode( mode:int ):void {
			__fg.ellipseMode( mode );
		}
		
		/**
		 * image()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function imageMode( mode:int ):void {
			__fg.imageMode( mode );
		}
		
		/**
		 * shape()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function shapeMode( mode:int ):void {
			__fg.shapeMode( mode );
		}
		
		/**
		 * image(), texture() などで画像を描画する場合の Smoothing を設定します.
		 * @default	true
		 */
		public function imageSmoothing( smooth:Boolean ):void {
			__fg.imageSmoothing( smooth );
		}
		
		/**
		 * beginShape() のモード QUADS,QUAD_STRIP で画像を変形して描画する際の精度を指定します.
		 * <p>3D#image の描画でも適用されます.</p>
		 * @default	1
		 */
		public function imageDetail( segmentNumber:uint ):void {
			__fg.imageDetail( segmentNumber );
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// PATH
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の描画位置を指定座標に移動します.
		 */
		public function moveTo( x:Number, y:Number, z:Number=0 ):void{
			__fg.moveTo( x, y, z );
		}
		/**
		 * 現在の描画位置から指定座標まで描画します.
		 */
		public function lineTo( x:Number, y:Number, z:Number=0 ):void{
			__fg.lineTo( x, y, z );
		}
		/**
		 * 2次ベジェ曲線を描画します.
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{
			__fg.curveTo( cx, cy, x, y );
		}
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			__fg.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		/**
		 * スプライン曲線を描画します.
		 * 
		 * @param	cx0		pre point x
		 * @param	cy0		pre point y
		 * @param	cx1		next point x 
		 * @param	cy1 	next point y
		 * @param	x		target point x
		 * @param	y		target point x
		 */
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			__fg.splineTo( cx0, cy0, cx1, cy1, x, y );
		}
		/**
		 * 現在の位置から指定の円弧を描きます.
		 * 
		 * @param	x			center x
		 * @param	y			center y
		 * @param	rx			radius x
		 * @param	ry			radius y
		 * @param	begin		begin radian
		 * @param	end			end radian
		 * @param	rotation
		 */
		public function arcTo( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void {
			__fg.arcTo( x, y, rx, ry, begin, end, rotation );
		}
		/**
		 * 現在の位置から指定座標まで、円弧を描画します.
		 * 
		 * <p>
		 * 円弧には、通常4つの描画候補があります.描画する円弧は、<code>large_arg_flg</code>、<code>sweep_flag</code>により指定されます.
		 * </p>
		 * 
		 * @param	x					target x
		 * @param	y					target y
		 * @param	rx					radius x
		 * @param	ry					radius y
		 * @param	large_arc_flag		大きい方の円弧を描画するかを指定します
		 * @param	sweep_flag			円弧の描画方向の正負を指定します
		 * @param	x_axis_rotation		rotation of ellipse(radian)
		 */
		public function arcCurveTo( x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void {
			__fg.arcCurveTo( x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		/**
		 * 描画しているパスを閉じます.
		 */
		public function closePath():void {
			__fg.closePath();
		}
		/**
		 * 現在の描画位置に moveTo() します.
		 */
		public function moveToLast():void {
			__fg.moveToLast();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Draw Shape
		
		/**
		 * 始点と終点を指定して円弧を描画します.
		 * 
		 * <p>
		 * 始点と終点を指定した円弧には、通常4つの描画候補があります.描画する円弧は、<code>large_arg_flg</code>、<code>sweep_flag</code>により指定されます.
		 * </p>
		 * 
		 * @param	x0					start x
		 * @param	y0					start y
		 * @param	x					end x
		 * @param	y					end y
		 * @param	rx					radius x
		 * @param	ry					radius y
		 * @param	large_arc_flag		大きい方の円弧を描画するかを指定します
		 * @param	sweep_flag			円弧の描画方向の正負を指定します
		 * @param	x_axis_rotation		rotation of ellipse(radian)
		 */
		public function drawArcCurve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{
			__fg.drawArcCurve( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		/**
		 * 円弧を描画します.
		 * 
		 * @param	x		中心座標 x
		 * @param	y		中心座標 y
		 * @param	rx		半径 x
		 * @param	ry		半径 y
		 * @param	begin	描画開始角度(radian)
		 * @param	end		描画終了角度(radian)
		 * @param	wedge	くさび形で描画
		 */
		public function drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, pie:Boolean=false ):void {
			__fg.drawArc( x, y, rx, ry, begin, end, pie );
		}
		/**
		 * 円を描画します.
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			__fg.drawCircle( x, y, radius );
		}
		/**
		 * 楕円を描画します.
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
			__fg.drawEllipse( x, y, width, height );
		}
		/**
		 * 矩形を描画します.
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
			__fg.drawRect( x, y, width, height );
		}
		/**
		 * 角丸矩形を描画します.
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number):void {
			__fg.drawRoundRect( x, y, width, height, ellipseWidth, ellipseHeight );
		}
		/**
		 * 各コーナーの半径を指定して、角丸矩形を描画します.
		 */
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void {
			__fg.drawRoundRectComplex( x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
		}
		/**
		 * 正多角形を描画します.
		 * 
		 * @param	x			center x.
		 * @param	y			center y.
		 * @param	points		vertex number.
		 * @param	radius		distance from center point.
		 * @param	rotation	rotation of shape.
		 * @param	radius2		2nd distance for star or burst shape.
		 * @param	burst		burst shape. required radius2.
		 */
		public function drawPoly( x:Number, y:Number, points:int, radius:Number, rotation:Number=0.0, radius2:Number=NaN, burst:Boolean=false ):void {
			__fg.drawPoly( x, y, points, radius, rotation, radius2, burst );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 2D Primitives
		
		/**
		 * ピクセルを描画します.描画する色は、線の色が適用されます.
		 */
		public function pixel( x:Number, y:Number, z:Number = 0 ):void{
			__fg.pixel( x, y, z );
		}
		
		/**
		 * 点を描画します.点を描画する色は、線の色が適用されます.
		 */
		public function point( x:Number, y:Number, z:Number = 0 ):void{
			__fg.point( x, y, z );
		}
		
		/**
		 * 現在の線のスタイルを適用し、直線を描画します.
		 */
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			__fg.line( x0, y0, x1, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void{
			__fg.triangle( x0, y0, x1, y1, x2, y2 ); 
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			__fg.quad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円弧を描画します.
		 * <p>塗りが適用されている場合はパイ型、塗り無しの場合は円弧の線のみが描画されます.</p>
		 */
		public function arc( x:Number, y:Number, width:Number, height:Number, start_radian:Number, stop_radian:Number ):void{
			__fg.arc( x, y, width, height, start_radian, stop_radian );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円を描画します.
		 */	
		public function circle( x:Number, y:Number, radius:Number ):void{
			__fg.circle( x, y, radius );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、楕円を描画します.
		 * 
		 * <p>
		 * ellipse()メソッドの引数は、ellipseMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CENTER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CENTER  : ellipse( center x, center y, width, height )</li>
		 * <li>mode CORNERS ： ellipse( left, top, right, bottom )</li>
		 * <li>mode CORNER  : ellipse( left, top, width, height )</li>
		 * <li>mode RADIUS  : ellipse( center x, center y, radius x, radius y )</li>
		 * </ul>
		 */
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			__fg.ellipse( x0, y0, x1, y1);
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、矩形を描画します.
		 * 
		 * <p>
		 * rect()メソッドの引数は、rectMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : rect( left, top, width, height )</li>
		 * <li>mode CORNERS ： rect( left, top, right, bottom )</li>
		 * <li>mode RADIUS  : rect( center x, center y, radius x, radius y )</li>
		 * <li>mode CENTER  : rect( center x, center y, width, height )</li>
		 * </ul>
		 * 
		 * @param rx	radius x (round rect).
		 * @param rx	radius y (round rect).
		 */
		public function rect( x:Number, y:Number, x1:Number, y1:Number, rx:Number=0, ry:Number=0 ):void{
			__fg.rect( x, y, x1, y1, rx, ry );
		}
		
		/**
		 * draw path.
		 * 
		 * @param	commands
		 * @param	data
		 * @see		frocessing.core.graphics.FPath
		 */
		public function shapePath( commands:Array, data:Array ):void {
			__fg.shapePath( commands, data );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Curves
		
		/**
		 * 現在の塗りと線のスタイルを適用し、3次ベジェ曲線を描画します.
		 */
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			__fg.bezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、スプライン曲線を描画します.
		 */
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			__fg.curve( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		/**
		 * 3次ベジェ曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function bezierDetail( detail_step:uint ):void{
			__fg.bezierDetail(detail_step);
		}
		
		/**
		 * スプライン曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function curveDetail( detail_step:uint ):void{
			__fg.curveDetail(detail_step);
		}
		
		/**
		 * スプライン曲線の曲率を指定します.デフォルト値は 1.0 です.
		 */
		public function curveTightness( t:Number ):void {
			__fg.curveTightness( t );
		}
		
		/**
		 * 
		 */
		public function qbezierPoint( a:Number, b:Number, c:Number, t:Number ):Number {
			return FCurveMath.qbezierPoint( a, b, c, t );
		}
		/**
		 * 
		 */
		public function bezierPoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.bezierPoint( a, b, c, d, t );
		}
		/**
		 * 
		 */
		public function curvePoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.curvePoint( a, b, c, d, t, __fg.f5internal::splineTightness );
		}
		/**
		 * 
		 */
		public function qbezierTangent( a:Number, b:Number, c:Number, t:Number ):Number {
			return FCurveMath.qbezierTangent( a, b, c, t );
		}
		/**
		 * 
		 */
		public function bezierTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.bezierTangent( a, b, c, d, t );
		}
		/**
		 * 
		 */
		public function curveTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.curveTangent( a, b, c, d, t, __fg.f5internal::splineTightness );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// VERTEX
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * Vertex描画 を 開始します.
		 * <p>modeを省略した場合は、POLYGON描画となります.</p>
		 * @param	mode	 POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP
		 * @see frocessing.core.constants.F5VertexMode
		 */
		public function beginShape( mode:int=0 ):void{
			__fg.beginShape( mode );
		}
		
		/**
		 * Vertex描画 を 終了します.
		 * @param	close_path	POLYGONモードで描画した場合、パスを閉じるかどうかを指定できます.
		 */
		public function endShape( close_path:Boolean=false ):void {
			__fg.endShape( close_path );
		}
		
		/**
		 * vertex() で 描画する テクスチャ(画像) を設定します.
		 * <p>
		 * texture が適用されるのは、 beginShape() メソッドで以下のモードを指定した場合になります.<br/>
		 * TRIANGLES,　TRIANGLE_FAN,　TRIANGLE_STRIP,　QUADS,　QUAD_STRIP
		 * </p>
		 * <p>
		 * vertex() メソッドで、　u, v 値を指定する必要があります.
		 * </p>
		 */
		public function texture( textureData:BitmapData ):void {
			__fg.texture( textureData );
		}
		
		/**
		 * vertex()　の　UV値モード　を指定します.
		 * <p>
		 * NORMALIZED	UV を 正規化された値( 0.0～1.0 )で指定.<br/>
		 * IMAGE		UV を 実際のピクセル値で指定.
		 * </p>
		 * @param	mode	NORMALIZED, IMAGE
		 */
		public function textureMode( mode:int ):void {
			__fg.textureMode( mode );
		}
		
		/**
		 * Vertex描画 で 座標を追加します.
		 * @param	x
		 * @param	y
		 * @param	u	texture を指定している場合、テクスチャの u 値を指定できます
		 * @param	v	texture を指定している場合、テクスチャの v 値を指定できます
		 */
		public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void {
			__fg.vertex( x, y, u, v );
		}
		
		/**
		 * Vertex描画 で ベジェ曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			__fg.bezierVertex( cx0, cy0, cx1, cy1, x1, y1 );
		}
		
		/**
		 *　Vertex描画 で スプライン曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function curveVertex( x:Number, y:Number ):void {
			__fg.curveVertex( x, y );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * IFShape を描画します.
		 * paratmeters(x,y,w,h) is applyed in F5MovieClip2D or F5MovieClip3D
		 */
		public function shape( s:IFShape, x:Number=NaN, y:Number=NaN, w:Number = NaN, h:Number = NaN ):void {
			__fg.shape( s, x, y, w, h );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 画像を描画します.
		 * 
		 * <p>
		 * image()メソッドの引数は、imageMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : image( left, top, width, height )</li>
		 * <li>mode CORNERS ： image( left, top, right, bottom )</li>
		 * <li>mode CENTER  : image( center x, center y, width, height )</li>
		 * </ul>
		 * 
		 * <p>w、h を省略した場合は、bitmapdata の width と hight が適用されます.</p>
		 */
		public function image( img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN ):void {
			__fg.image( img, x, y, w, h );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TEXT
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画する font を指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function textFont( font:IFont, fontSize:Number=NaN ):void{
			__fg.textFont( font, fontSize );
		}
		
		/**
		 * text を描画します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>text( string, x, y )</listing>
		 * <listing>text( string, x, y, z ) when 3D</listing>
		 * <listing>text( string, x, y, width, height )</listing>
		 * <listing>text( string, x, y, width, height, z ) when 3D</listing>
		 */
		public function text( str:String, a:Number, b:Number, c:Number=0, d:Number=0, e:Number=0 ):void{
			__fg.text( str, a, b, c, d, e );
		}
		
		/**
		 * text の　size を指定します.
		 * @param	fontSize
		 */
		public function textSize( fontSize:Number ):void {
			__fg.textSize( fontSize );
		}
		
		/**
		 * 文字列の幅を取得します.
		 */
		public function textWidth( str:String ):Number{
			return __fg.textWidth( str );
		}
		
		/**
		 * 行のベースラインから最上部までの値(px)を示します.
		 */
		public function textAscent():Number{
			return __fg.textAscent();
		}
		
		/**
		 * 行のベースラインから最下部までの値(px)を示します.
		 */
		public function textDescent():Number{
			return __fg.textDescent();
		}
		
		/**
		 * text の align を指定します.
		 * 
		 * @param	align	CENTER,LEFT,RIGHT
		 * @param	valign	BASELINE,TOP,BOTTOM
		 */
		public function textAlign( align:int, valign:int = 0 ):void {
			__fg.textAlign( align, valign );
		}
		
		/**
		 * text の　行高 を指定します.
		 */
		public function textLeading( leading:Number ):void {
			__fg.textLeading( leading );
		}
		
		/**
		 * 文字間をしてします.
		 */
		public function textLetterSpacing( spacing:Number ):void
		{
			__fg.textLetterSpacing( spacing );
		}
		
		/**
		 * not implemented
		 */
		public function textMode( mode:int ):void {
			;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String=null, joints:String=null, miterLimit:Number=3 ):void{
			__fg.lineStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number=0.0 ):void{
			__fg.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		public function beginFill(color:uint, alpha:Number=1.0):void{
			__fg.beginFill( color, alpha );
		}
		public function beginBitmapFill( bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void{
			__fg.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void{
			__fg.beginGradientFill( type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		public function endFill():void{
			__fg.endFill();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// FILE/LOAD
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * SVG Shape を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var shapedata:FShapeSVG;
		 * function setup():void{
		 *   shapedata = loadShape("sample.svg");
		 * }
		 * function draw():void{
		 *   shape( shapedata );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.shape.FShapeSVGLoader
		 */
		public function loadShape( url:String, loader:URLLoader = null ):FShapeSVGLoader {
			if ( !__setup_done && syncSetup ){
				var s:FShapeSVGLoader = new FShapeSVGLoader( url, loader, __setup_load_callback );
				__setup_load_objects.push( s );
				return s;
			}else{
				return new FShapeSVGLoader( url, loader );
			}
		}
		
		/**
		 * Image を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var imgdata:FImage;
		 * function setup():void{
		 *   imgdata = loadImage("sample.jpg");
		 * }
		 * function draw():void{
		 *   image( imgdata.bitmapData );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.bmp.FImageLoader
		 */
		public function loadImage( url:String, loader:Loader = null ):FImageLoader
		{
			if ( !__setup_done && syncSetup ){
				var s:FImageLoader = new FImageLoader( url, loader, __setup_load_callback );
				__setup_load_objects.push( s );
				return s;
			}else{
				return new FImageLoader( url, loader );
			}
		}
		
		/**
		 * PFont を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var font:PFont;
		 * function setup():void{
		 *   font = loadFont("sample.vlw");
		 * }
		 * function draw():void{
		 *   textFont( font, 24 );
		 *   text( "Sample", 100, 100 );
		 * }
		 * </listing>
		 * 
		 * @param	url		vlw file
		 * @param	loader
		 * @see frocessing.text.PFontLoader
		 */
		public function loadFont( font_url:String, loader:URLLoader = null ):PFontLoader
		{
			if ( !__setup_done && syncSetup ){
				var s:PFontLoader = new PFontLoader( font_url, loader, __setup_load_callback );
				__setup_load_objects.push( s );
				return s;
			}else{
				return new PFontLoader( font_url, loader );
			}
		}
		
		/**
		 * String を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var strloader:FStringLoader;
		 * function setup():void{
		 *   strloader = loadString("sample.txt");
		 * }
		 * function draw():void{
		 *   trace( strloader.toString() );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.utils.FStringLoader
		 */
		public function loadString( url:String, loader:URLLoader = null ):FStringLoader 
		{
			if ( !__setup_done && syncSetup ){
				var s:FStringLoader = new FStringLoader( url, loader, __setup_load_callback );
				__setup_load_objects.push( s );
				return s;
			}else{
				return new FStringLoader( url, loader );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// MATH
		//-------------------------------------------------------------------------------------------------------------------
		
		// Calculation
		public static function min( a:Number, b:Number ):Number     { return (a < b) ? a : b; }
		public static function max( a:Number, b:Number ):Number     { return (a > b) ? a : b; }
		public static function round( a:Number ):Number             { return Math.round(a); }
		public static function floor( a:Number ):Number             { return Math.floor(a); }
		public static function ceil( a:Number ):Number              { return Math.ceil(a); }
		public static function pow( num:Number, exp:Number ):Number{ return Math.pow(num, exp); }
		public static function exp( val:Number ):Number             { return Math.exp(val); }
		public static function sqrt( val:Number ):Number            { return Math.sqrt(val); }
		public static function abs( val:Number ):Number             { return (val < 0) ? -val : val; }
		public static function log( val:Number ):Number             { return Math.log(val); }
		
		/**
		 * @see frocessing.math.FMath
		 */
		public static function dist( x0:Number, y0:Number, x1:Number, y1:Number ):Number{
			return FMath.dist( x0, y0, x1, y1 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function mag( a:Number, b:Number ):Number {
			return FMath.mag(a, b);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function constrain( val:Number, min_value:Number, max_value:Number ):Number {
			return FMath.constrain( val, min_value, max_value );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function sq( val:Number ):Number {
			return FMath.sq(val);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function norm( val:Number, low:Number, high:Number ):Number {
			return FMath.norm(val, low, high);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function lerp( a:Number, b:Number, amt:Number ):Number {
			return FMath.lerp( a, b, amt );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function map( val:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return FMath.map( val, low1, high1, low2, high2 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function quant( val:Number, tick:Number):Number {
			return FMath.quant( val, tick );
		}
		
		// Trigonometry
		public static function sin( val:Number ):Number              	{ return Math.sin(val); }
		public static function cos( val:Number ):Number              	{ return Math.cos(val); }
		public static function tan( val:Number ):Number              	{ return Math.tan(val); }
		public static function asin( val:Number ):Number             	{ return Math.asin(val); }
		public static function acos( val:Number ):Number             	{ return Math.acos(val); }
		public static function atan( val:Number ):Number             	{ return Math.atan(val); }
		public static function atan2( y:Number, x:Number):Number   		{ return Math.atan2(y, x); }
		
		/**
		 * @see frocessing.math.FMath
		 */
		public static function degrees( rad:Number ):Number {
			return FMath.degrees( rad );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function radians( deg:Number ):Number {
			return FMath.radians( deg );
		}
		
		//Random
		
		/**
		 * @see frocessing.math.FMath
		 * @see frocessing.math.SFMTRandom
		 */
		public function random( high:Number, low:Number = 0 ):Number{
			return FMath.random( high, low );
		}
		
		/**
		 * @see frocessing.math.FMath
		 * @see frocessing.math.SFMTRandom
		 */
		public function randomSeed( seed:uint ):void{
			FMath.randomSeed( seed );
		}
		
		/**
		 * note that fallout value greater than 0.5 might result in greater than 1.0 values returned by noise().
		 * @param	lod
		 * @param	falloff
		 * @see		frocessing.math.PerlinNoise
		 */
		public function noiseDetail( lod:uint, falloff:Number = 0):void{
			__perlin_noise.noiseDetail( lod, falloff );
		}
		
		/**
		 * 
		 * @see frocessing.math.PerlinNoise
		 */
		public function noise( x:Number, y:Number = 0.0, z:Number = 0.0 ):Number{
			return __perlin_noise.noise( x, y, z );
		}
		
		/**
		 * 
		 * @see frocessing.math.PerlinNoise
		 */
		public function noiseSeed( seed:uint ):void{
			__perlin_noise.noiseSeed( seed );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// UTILS
		//-------------------------------------------------------------------------------------------------------------------
		
		public static function splitTokens( str:String, tokens:String=" "):Array {
			return FUtil.splitTokens( str, tokens );
		}
		
		public static function trim( str:String ):String {
			return FUtil.trim( str );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nf( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nf( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfs( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nfs( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfp( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nfp( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfc( value:Number, right:uint = 0 ):String{
			return FUtil.nfc( value, right );
		}
		
		//------------------------------------------------
		
		/**
		 * 数字 を 2進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil
		 */
		public static function binary( value:int, digits:int=0 ):String{
			return FUtil.binary( value, digits );
		}
		
		/**
		 * 2進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil
		 */
		public static function unbinary( binstr:String ):uint{
			return FUtil.unbinary( binstr );
		}
		
		/**
		 * 数字 を 16進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil
		 */
		public static function hex( value:int, digits:int=0 ):String {
			return FUtil.hex( value, digits );
		}
		
		/**
		 * 16進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil
		 */
		public static function unhex( hexstr:String ):uint {
			return FUtil.unhex( hexstr );
		}
		
		//------------------------------------------------
		
		/**
		 * 年 (2000 などの 4 桁の数字) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function year():Number { 		return FDate.year(); }
		
		/**
		 * 月 (1 月は 1、2 月は 2 など) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function month():Number {		return FDate.month(); }
		
		/**
		 * 日付 (1 ～ 31) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function day():Number	{		return FDate.day(); }
		
		/**
		 * 曜日 (日曜日は 0、月曜日は 1 など) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function weekday():Number {	return FDate.weekday(); }
		
		/**
		 * 時 (0 ～ 23) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function hour():Number { 		return FDate.hour(); }
		
		/**
		 * 分 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function minute():Number {	return FDate.minute(); }
		
		/**
		 * 秒 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function second():Number { 	return FDate.second(); }
		
		/**
		 * ミリ秒 (0 ～ 999) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function millis():Number { 	return FDate.millis(); }
		
		//------------------------------------------------
		
		/**
		 * 
		 */
		public function smooth():void{ 	QHigh(); }
		
		/**
		 * 
		 */
		public function noSmooth():void{ QLow(); }
		
	}
	
}