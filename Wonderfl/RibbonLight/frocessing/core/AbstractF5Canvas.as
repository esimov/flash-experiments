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

package frocessing.core {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import frocessing.core.canvas.ICanvas;
	import frocessing.core.canvas.ICanvasRender;
	import frocessing.core.canvas.ICanvasStroke;
	import frocessing.core.canvas.ICanvasStrokeFill;
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.canvas.CanvasStroke;
	import frocessing.core.canvas.CanvasGradientStroke;
	import frocessing.core.canvas.CanvasSolidFill;
	import frocessing.core.canvas.CanvasGradientFill;
	import frocessing.core.canvas.CanvasBitmapFill;
	
	import frocessing.core.utils.TintImageCache;
	import frocessing.color.FColor;
	import frocessing.geom.FMatrix;
	import frocessing.geom.FGradientMatrix;
	import frocessing.shape.IFShape;
	import frocessing.shape.IFShapeContainer;
	import frocessing.shape.IFShapeImage;
	import frocessing.text.IFont;
	import frocessing.text.IBitmapFont;
	import frocessing.text.IPathFont;
	import frocessing.utils.IObjectLoader;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	 * AbstractF5Canvas クラスは、Processing の基本APIを実装した抽象クラスです.
	 * 
	 * <p><b>Processing API</b></p>
	 * <p>
	 * 	<em>2D Primitives</em><br/>
	 * 		point(), line(), triangle(), quad(), ellipse(), rect(), arc(), <i>circle()</i>, <i>pixel()</i><br/>
	 * 	<em>Curves</em><br/>
	 *   	bezier(), bezierDetail(), curve(), curveDetail(), curveTightness()<br/>
	 * 	<em>Attributes</em><br/>
	 * 	  	ellipseMode(), rectMode(), strokeCap(), strokeJoin(), strokeWeight()<br/>
	 *  <em>Vertex</em><br/>
	 * 	  	beginShape(), endShape(), vertex(), bezierVertex(), curveVertex(), texture(), textureMode()
	 * </p>
	 * <p>
	 *  <em>Shape</em><br/>
	 * 		shape(), shapeMode()
	 * </p>
	 * <p>
	 * 	<em>Image</em><br/>
	 * 		image(), imageMode(), noTint(), tint()<br/>
	 * </p>
	 * <p>
	 * 	<em>Text</em><br/>
	 *   	text(), textFont()<br/>
	 * 	<em>Text Attributes</em><br/>
	 * 	  	textSize(), textAlign(), textLeading(), textWidth(), <i>textLetterSpacing()</i><br/>
	 *  <em>Metrics</em><br/>
	 * 	  	textAscent(), textDescent()<br/>
	 * </p>
	 * <p>
	 * 	<em>Color</em><br/>
	 *   	colorMode(), stroke(), noStroke(), fill(), noFill(), background(), color()<br/>
	 *  <em>Style</em><br/>
	 * 		pushStyle(), popStyle()
	 * </p>
	 * <p>
	 * 	<em>Basic</em><br/>
	 *   	size(), beginDraw(), endDraw(), clear()
	 * </p>
	 * 
	 * <p><b>Flash Graphics API</b></p>
	 * <p>
	 * 	<em>Path</em><br/>
	 * 		moveTo(), lineTo(), curveTo(), bezierTo(), splineTo(), arcTo(), arcCurveTo(), closePath(), moveToLast()<br/>
	 * 	<em>Shape</em><br/>
	 *    drawCircle(), drawEllipse(), drawArc(), drawArcCurve(), drawRect(), drawRoundRect(), drawRoundRectComplex(), drawPoly()<br/>
	 *	<em>Style</em><br/>
	 *    lineStyle(), lineGradientStyle()<br/>
	 *    beginFill(), beginGradientFill(), beginBitmapFill(), endFill()
	 * </p>
	 * 
	 * @author nutsu
	 * @version 0.6.1
	 */
	public class AbstractF5Canvas
	{
		// sttyles -------------------------
		/** @private */
		internal var _c:ICanvas;
		
		//style objects
		/** @private */
		internal var $stroke:CanvasStroke;
		/** @private */
		internal var $strokeGradient:CanvasGradientStroke;
		
		/** @private */
		internal var $fill:CanvasSolidFill;
		/** @private */
		internal var $fillBitmap:CanvasBitmapFill;
		/** @private */
		internal var $fillGradient:CanvasGradientFill;
		
		// size -------------------------
		/** @private */
		internal var _width:uint;
		/** @private */
		internal var _height:uint;
		
		// color mode -------------------------
		/** current color mode. @default "rgb" */
		public var colorModeState:String;
		/** current color range of red or hue or grayscale. @default 255 */
		public var colorModeX:Number;
		/** current color range of green or saturation. @default 255 */
		public var colorModeY:Number;
		/** current color range of blue or brightness. @default 255*/
		public var colorModeZ:Number;
		/** current color range of alpha. @default 1.0*/
		public var colorModeA:Number;
		
		// calc -------------------------
		/** @private */
		internal var __calc_color:uint;
		/** @private */
		internal var __calc_alpha:Number;
		
		// Rect Draw Mode -------------------------
		/** @private */
		private var _rect_mode:int;		//@default CORNER
		/** @private */
		private var _ellipse_mode:int;	//@default CENTER
		/** @private */
		internal var _shape_mode:int;	//@default CORNER
		/** @private */
		internal var _image_mode:int;	//@default CORNER
		
		// Tint  -------------------------
		/** @private */
		internal var _tint_color:uint;
		/** @private */
		internal var tintDo:Boolean;
		/** @private */
		internal var tintImageCache:TintImageCache;
		
		// Texture -------------------------
		/** @private */
		internal var _textureDo:Boolean;
		/** @private */
		internal var _texture_mode:int;
		/** @private */
		internal var _texture_width:Number = 1;
		/** @private */
		internal var _texture_height:Number = 1;
		
		// Text ----------------------------
		/** @private */
		private var _font:IFont;
		/** @private */
		private var _fsize:Number;
		/** @private */
		private var _fsizeScale:Number;
		/** @private */
		private var _leading:Number;
		/** @private */
		private var _letterspacing:Number;
		/** @private */
		private var _align:int;
		/** @private */
		private var _valign:int;
		// string buffer
		private var _str_buffer:String;
		private var _str_buffer_length:int;
		// font load check flg
		private var _font_loadcheck:Boolean = false;
		
		// Style -------------------------
		/** @private */
		private var _style_tmp:Array;
		/** @private */
		private var _canvasadapter:F5CanvasAdapter;
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function AbstractF5Canvas( target:ICanvas ) 
		{
			_c = target;
			
			//basic style
			$stroke         = new CanvasStroke(0, 0x000000, 1.0, false, "normal", null, null, 3);
			$strokeGradient = new CanvasGradientStroke( $stroke, null, null, null, null, new FMatrix() );
			$fill           = new CanvasSolidFill(0xffffff, 1.0);
			$fillBitmap     = new CanvasBitmapFill( null, new FMatrix() );
			$fillGradient   = new CanvasGradientFill( null, null, null, null, new FMatrix() );
			
			_c.beginStroke( $stroke );
			_c.currentFill  = $fill;
			
			//default size
			_width 			= 100;
			_height 		= 100;
			
			//cal color
			__calc_color	= 0x000000;
			__calc_alpha	= 1.0;
			
			//mode
			colorModeState	= RGB;
			colorModeX		= colorModeY = colorModeZ = 255;
			colorModeA		= 1.0;
			
			//rect mode
			_rect_mode		= CORNER;
			_ellipse_mode	= CENTER;
			_image_mode     = CORNER;
			_shape_mode     = CORNER;
			
			//vertex texture mode
			_texture_mode   = NORMALIZED;
			
			//tint
			_tint_color		= 0xffffffff;
			tintDo		    = false;
			tintImageCache	= new TintImageCache();
			
			//text
			_fsize          = 12;
			_leading        = 14;
			_letterspacing  = 0;
			_align          = LEFT;
			_valign         = BASELINE;
			_fsizeScale     = 1.0;
			
			//other parameters
			_c.bezierDetail = 20;
			_c.splineDetail = 20;
			_c.splineTightness = 1.0;
			_c.imageSmoothing  = true;
			_c.imageDetail  = 1;
			
			//style buffer
			_style_tmp    	= [];
			
			//canvas adapter
			_canvasadapter  = new F5CanvasAdapter(this);
		}		
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 保持する幅を示します.
		 */
		public function get width():uint { return _width; }
		/**
		 * 保持する高さを示します.
		 */
		public function get height():uint{ return _height; }
		
		/**
		 * 幅と高さを設定します.
		 */
		public function size( width:uint, height:uint ):void
		{
			_width  = width;
			_height = height;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// DRAW
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画されているグラフィックをクリアします.
		 */
		public function clear():void
		{
			_c.clear();
			f5clear();
		}
		/** @private */
		internal function f5clear():void {
			tintImageCache.dispose();
		}
		
		
		/**
		 * 描画を開始するときに実行します.
		 * beginDraw時、graphics は clear() されます.
		 */
		public function beginDraw():void 
		{
			clear();
		}
		
		/**
		 * 描画を終了するときに実行します.
		 */
		public function endDraw():void 
		{
			if ( _c is ICanvasRender ) {
				ICanvasRender(_c).render();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PATH
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の描画位置を指定座標に移動します.
		 */
		public function moveTo( x:Number, y:Number, z:Number = 0 ):void { ; }
		
		/**
		 * 現在の描画位置から指定座標まで描画します.
		 */
		public function lineTo( x:Number, y:Number, z:Number = 0 ):void { ; }
		
		/**
		 * 2次ベジェ曲線を描画します.
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void { ; }
		
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void { ; }
		
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
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void { ; }
		
		/**
		 * 描画しているパスを閉じます.
		 */
		public function closePath():void { ; }
		
		/**
		 * 現在の描画位置に moveTo() します.
		 */
		public function moveToLast():void { ; }
		
		/**
		 * draw path.
		 * 
		 * @param	commands
		 * @param	data
		 * @see frocessing.core.graphics.FPathCommand
		 */
		public function shapePath( commands:Array, data:Array ):void 
		{
			var len:int = commands.length;
			var xi:int  = 0;
			var yi:int  = 1;
			for ( var i:int = 0; i < len ; i++ ){
				var cmd:int = commands[i];
				if ( cmd == 2 ){ //LINE_TO
					lineTo( data[xi], data[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == 10 ){ //BEZIER_TO
					bezierTo( data[xi], data[yi], data[int(xi + 2)], data[int(yi + 2)], data[int(xi + 4)], data[int(yi + 4)] );
					xi += 6;
					yi += 6;
				}
				else if ( cmd == 3 ){ //CURVE_TO
					curveTo( data[xi], data[yi], data[int(xi + 2)], data[int(yi + 2)] );
					xi += 4;
					yi += 4;
				}
				else if ( cmd == 1 ){ //MOVE_TO
					moveTo( data[xi], data[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == 100 ){ //CLOSE_PATH
					closePath();
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
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
		public function arcTo( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			if( rotation==0 ){
				lineTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				__arc( x, y, rx, ry, begin, end, rotation );
			}else{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number = rx*Math.cos(begin);
				var yy:Number = ry*Math.sin(begin);
				lineTo( x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				__arc( x, y, rx, ry, begin, end, rotation );
			}
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
		public function arcCurveTo( x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void { ; }
		
		
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
			moveTo( x0, y0 );
			__arcCurve( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
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
		public function drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, wedge:Boolean=false ):void
		{
			if ( wedge ){
				moveTo( x, y );
				lineTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				__arc( x, y, rx, ry, begin, end );
				closePath();
			}else{
				moveTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				__arc( x, y, rx, ry, begin, end );
			}	
		}
		
		/**
		 * 円を描画します.
		 */
		public function drawCircle( x:Number, y:Number, radius:Number ):void
		{
			__ellipse( x, y, radius, radius );
		}
		
		/**
		 * 楕円を描画します.
		 */
		public function drawEllipse( x:Number, y:Number, width:Number, height:Number ):void
		{
			width  *= 0.5;
			height *= 0.5;
			__ellipse( x + width, y + height, width, height );
		}
		
		/**
		 * 矩形を描画します.
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			__rect( x, y, x + width, y + height );
		}
		
		/**
		 * 角丸矩形を描画します.
		 */
		public function drawRoundRect( x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN ):void
		{
			if( ellipseWidth>width )
				ellipseWidth = width;
			
			if ( isNaN(ellipseHeight) )
				ellipseHeight = ( ellipseWidth > height ) ? height : ellipseWidth;
			else
				ellipseHeight = ( ellipseHeight > height ) ? height : ellipseHeight;
				
			__roundrect( x, y, x + width, y + height, ellipseWidth/2, ellipseHeight/2 );
		}
		
		/**
		 * 各コーナーの半径を指定して、角丸矩形を描画します.
		 */
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var k:Number;
			if ( (topLeftRadius + bottomLeftRadius) > height ){
				k = height / (topLeftRadius + bottomLeftRadius);
				topLeftRadius *= k;
				bottomLeftRadius *= k;
			}
			if ( (topRightRadius + bottomRightRadius) > height ){
				k = height / (topRightRadius + bottomRightRadius);
				topRightRadius *= k;
				bottomRightRadius *= k;
			}
			if ( (topLeftRadius + topRightRadius) > width ){
				k = width / (topLeftRadius + topRightRadius);
				topLeftRadius *= k;
				topRightRadius *= k;
			}
			if ( (bottomLeftRadius + bottomRightRadius) > width ){
				k = width / (bottomLeftRadius + bottomRightRadius);
				bottomLeftRadius *= k;
				bottomRightRadius *= k;
			}
			__complexrect( x, y, x + width, y + height, topLeftRadius, topRightRadius, bottomRightRadius, bottomLeftRadius );
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
		public function drawPoly( x:Number, y:Number, points:int, radius:Number, rotation:Number=0.0, radius2:Number=NaN, burst:Boolean=false ):void
		{
			var dr:Number = 2 * Math.PI / points;
			var i:int;
			rotation -= Math.PI*0.5;
			moveTo( x + Math.cos(rotation) * radius, y + Math.sin(rotation) * radius );
			if ( isNaN(radius2) ) {
				//regular
				for ( i = 1 ; i < points ; i++ ) {
					rotation += dr;
					lineTo( x + Math.cos(rotation) * radius, y + Math.sin(rotation) * radius );
				}
				closePath();
			}else if( !burst ){
				//star
				rotation += dr/2;
				lineTo( x + Math.cos(rotation) * radius2, y + Math.sin(rotation) * radius2 );
				for ( i = 1 ; i < points ; i++ ) {
					rotation += dr/2;
					lineTo( x + Math.cos(rotation) * radius, y + Math.sin(rotation) * radius );
					rotation += dr/2;
					lineTo( x + Math.cos(rotation) * radius2, y + Math.sin(rotation) * radius2 );
				}
				closePath();
			}else {
				//burst
				for ( i = 1 ; i <= points ; i++ ) {
					rotation += dr/2;
					var cx:Number = x + Math.cos(rotation) * radius2;
					var cy:Number = y + Math.sin(rotation) * radius2;
					rotation += dr/2;
					curveTo( cx, cy, x + Math.cos(rotation) * radius, y + Math.sin(rotation) * radius );
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- drawImpl
		
		/** @private */
		private function __ellipse( x:Number, y:Number, rx:Number, ry:Number ):void
		{
			var _P:Number = 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			moveTo( x + rx, y );
			curveTo( x + rx     , y + ry * _T, x + rx * _P, y + ry * _P );
			curveTo( x + rx * _T, y + ry     , x          , y + ry );
			curveTo( x - rx * _T, y + ry     , x - rx * _P, y + ry * _P );
			curveTo( x - rx     , y + ry * _T, x - rx     , y );
			curveTo( x - rx     , y - ry * _T, x - rx * _P, y - ry * _P );
			curveTo( x - rx * _T, y - ry     , x          , y - ry );
			curveTo( x + rx * _T, y - ry     , x + rx * _P, y - ry * _P );
			curveTo( x + rx     , y - ry * _T, x + rx     , y );
		}
		
		/** @private */
		private function __rect( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y0 );
			lineTo( x1, y1 );
			lineTo( x0, y1 );
			closePath();
		}
		
		/** @private */
		private function __roundrect( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number, ry:Number ):void
		{
			var _P:Number = 1 - 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 1 - 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			moveTo( x0 + rx, y0 );
			lineTo( x1 - rx, y0 );  curveTo( x1 - rx * _T, y0          , x1 - rx * _P, y0 + ry * _P );
									curveTo( x1          , y0 + ry * _T, x1          , y0 + ry );
			lineTo( x1, y1 - ry );	curveTo( x1          , y1 - ry * _T, x1 - rx * _P, y1 - ry * _P );
									curveTo( x1 - rx * _T, y1          , x1 - rx     , y1 );
			lineTo( x0 + rx, y1 );	curveTo( x0 + rx * _T, y1          , x0 + rx * _P, y1 - ry * _P );
									curveTo( x0          , y1 - ry * _T, x0          , y1 - ry );
			lineTo( x0, y0 + ry );	curveTo( x0          , y0 + ry * _T, x0 + rx * _P, y0 + ry * _P );
									curveTo( x0 + rx * _T, y0          , x0 + rx     , y0 );
		}
		
		/** @private */
		private function __complexrect( x0:Number, y0:Number, x1:Number, y1:Number, r0:Number, r1:Number, r2:Number, r3:Number ):void
		{
			var _P:Number = 1 - 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 1 - 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			moveTo( x0 + r0, y0 );
			lineTo( x1 - r1, y0 );  
			if ( r1 > 0 ) {
				curveTo( x1 - r1 * _T, y0          , x1 - r1 * _P, y0 + r1 * _P );
				curveTo( x1          , y0 + r1 * _T, x1          , y0 + r1 );
			}
			lineTo( x1, y1 - r2 );
			if ( r2 > 0 ) {
				curveTo( x1          , y1 - r2 * _T, x1 - r2 * _P, y1 - r2 * _P );
				curveTo( x1 - r2 * _T, y1          , x1 - r2     , y1 );
			}
			lineTo( x0 + r3, y1 );
			if ( r3 > 0 ) {
				curveTo( x0 + r3 * _T, y1          , x0 + r3 * _P, y1 - r3 * _P );
				curveTo( x0          , y1 - r3 * _T, x0          , y1 - r3 );
			}
			lineTo( x0, y0 + r0 );
			if ( r0 > 0 ) {
				curveTo( x0          , y0 + r0 * _T, x0 + r0 * _P, y0 + r0 * _P );
				curveTo( x0 + r0 * _T, y0          , x0 + r0     , y0 );
			}
		}
		
		/** @private */
		internal function __arc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			var segmentNum:int = Math.ceil( Math.abs( 4*(end-begin)/Math.PI ) );
			var delta:Number   = (end - begin)/segmentNum;
			var ca:Number      = 1.0/Math.cos( delta*0.5 );
			var t:Number       = begin;
			var ctrl_t:Number  = begin - delta*0.5;
			var i:int;
			if( rotation==0 ){
				for( i=1 ; i<=segmentNum ; i++ ){
					t += delta;
					ctrl_t += delta;
					curveTo( x + rx*ca*Math.cos(ctrl_t), y + ry*ca*Math.sin(ctrl_t), x + rx*Math.cos(t), y + ry*Math.sin(t) );
				}
			}else{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number;
				var yy:Number;
				var cxx:Number;
				var cyy:Number;
				for( i=1 ; i<=segmentNum ; i++ ){
					t += delta;
					ctrl_t += delta;
					xx  = rx*Math.cos(t);
					yy  = ry*Math.sin(t);
					cxx = rx*ca*Math.cos(ctrl_t);
					cyy = ry*ca*Math.sin(ctrl_t);
					curveTo( x + cxx*rc - cyy*rs, y + cxx*rs + cyy*rc , x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				}
			}
		}
		
		/** @private */
		internal function __arcCurve( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{
			var d:Number;
			var m:Number;
			//center coordinate
			var cx:Number;
			var cy:Number;
			//begin radian
			var ba:Number;
			//draw radian
			var ra:Number;
			if ( rx != ry ) {
				//ellipse
				var c:Number = Math.cos( -x_axis_rotation );
				var s:Number = Math.sin( -x_axis_rotation );
				var k:Number = rx / ry;
				var tx0:Number = x0 * c - y0 * s;
				var ty0:Number = k * ( x0 * s + y0 * c );
				var tx1:Number = x1 * c - y1 * s;
				var ty1:Number = k * ( x1 * s + y1 * c );
				d = (tx1 - tx0) * (tx1 - tx0) + (ty1 - ty0) * (ty1 - ty0);
				m = (( large_arc_flag==sweep_flag ) ? 1 : -1 )* Math.sqrt( rx * rx/d - 0.25 );
				d = 0.5 * Math.sqrt(d) / rx;
				if ( d < 1 ) {
					cx = (tx0 + tx1)*0.5 + (ty1 - ty0) * m;
					cy = (ty0 + ty1)*0.5 - (tx1 - tx0) * m;
					ba = Math.atan2( ty0 - cy, tx0 - cx );
					ra = ( large_arc_flag ) ? 2 * (Math.PI - Math.asin( d )) : 2 * Math.asin( d );
					__arc( cx * c + cy * s / k, -cx * s + cy * c / k, rx, ry, ba, (sweep_flag) ? ba + ra : ba - ra, x_axis_rotation );
				}else {
					cx = (tx0 + tx1)*0.5;
					cy = (ty0 + ty1)*0.5;
					ba = Math.atan2( ty0 - cy, tx0 - cx );
					rx *= d;
					ry *= d;
					__arc( cx * c + cy * s / k, -cx * s + cy * c / k, rx, ry, ba, (sweep_flag) ? ba + Math.PI : ba - Math.PI, x_axis_rotation );
				}
			}else {
				//circle
				d = (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0);
				m = (( large_arc_flag == sweep_flag ) ? 1 : -1 ) * Math.sqrt( rx * rx / d - 0.25 );
				d = 0.5 * Math.sqrt(d) / rx;
				if ( d < 1 ) {
					cx = (x0 + x1)*0.5 + (y1 - y0) * m;
					cy = (y0 + y1)*0.5 - (x1 - x0) * m;
					ba = Math.atan2( y0 - cy, x0 - cx );
					ra = (large_arc_flag) ? 2 * (Math.PI - Math.asin( d )) : 2 * Math.asin( d );
					__arc( cx, cy, rx, ry, ba, (sweep_flag) ? ba + ra : ba - ra, 0 );
				} else {
					rx *= d;
					cx = (x0 + x1)*0.5;
					cy = (y0 + y1)*0.5;
					ba = Math.atan2( y0 - cy, x0 - cx );
					__arc( cx, cy, rx, rx, ba, (sweep_flag) ? ba + Math.PI : ba - Math.PI, 0 );
				}
			}
			/*
			var e:Number  = rx/ry;
			var dx:Number = (x - x0)*0.5;
			var dy:Number = (y - y0)*0.5;
			var mx:Number = x0 + dx;
			var my:Number = y0 + dy;
			var rc:Number;
			var rs:Number;
			
			if( x_axis_rotation!=0 )
			{
				rc = Math.cos(-x_axis_rotation);
				rs = Math.sin( -x_axis_rotation);
				var dx_tmp:Number = dx*rc - dy*rs; 
				var dy_tmp:Number = dx*rs + dy*rc;
				dx = dx_tmp;
				dy = dy_tmp;
			}
			
			//transform to circle
			dy *= e;
			
			//
			var len:Number = Math.sqrt( dx*dx + dy*dy );
			var begin:Number;
			
			if( len<rx )
			{
				//center coordinates the arc
				var a:Number  = ( large_arc_flag!=sweep_flag ) ? Math.acos( len/rx ) : -Math.acos( len/rx );
				var ca:Number = Math.tan( a );
				var cx:Number = -dy*ca;
				var cy:Number = dx*ca;
				
				//draw angle
				var mr:Number = Math.PI - 2 * a;
				
				//start angle
				begin = Math.atan2( -dy - cy, -dx - cx );
				
				//deformation back and draw
				cy /= e;
				rc  = Math.cos(x_axis_rotation);
				rs  = Math.sin(x_axis_rotation);
				__arc( mx + cx*rc - cy*rs, my + cx*rs + cy*rc, rx, ry, begin, (sweep_flag) ? begin+mr : begin-(2*Math.PI-mr), x_axis_rotation );
			}
			else
			{
				//half arc
				rx = len;
				ry = rx/e;
				begin = Math.atan2( -dy, -dx );
				__arc( mx, my, rx, ry, begin, (sweep_flag) ? begin+Math.PI : begin-Math.PI, x_axis_rotation );
			}
			*/
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 2D Primitives
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * pixelを描画します.点を描画する色は、線の色が適用されます.
		 */
		public function pixel( x:Number, y:Number, z:Number = 0 ):void { ; }
		
		/**
		 * 点を描画します.点を描画する色は、線の色が適用されます.
		 */
		public function point( x:Number, y:Number, z:Number=0 ):void{ ; }
		
		/**
		 * 現在の線のスタイルを適用し、直線を描画します.
		 */
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 ); lineTo( x1, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x0, y0 ); lineTo( x1, y1 ); lineTo( x2, y2 ); closePath(); 
			_c.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x0, y0 ); lineTo( x1, y1 ); lineTo( x2, y2 ); lineTo( x3, y3 ); closePath();
			_c.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円弧を描画します.
		 * <p>塗りが適用されている場合はパイ型、塗り無しの場合は円弧の線のみが描画されます.</p>
		 */
		public function arc( x:Number, y:Number, width:Number, height:Number, start_radian:Number, stop_radian:Number ):void
		{
			if ( _c.fillEnabled ){
				_c.beginCurrentFill();
				drawArc( x, y, width/2, height/2, start_radian, stop_radian, true );
				_c.endFill();
			}else{
				drawArc( x, y, width/2, height/2, start_radian, stop_radian, false );
			}
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円を描画します.
		 */
		public function circle( x:Number, y:Number, radius:Number ):void
		{
			_c.beginCurrentFill();
			__ellipse( x, y, radius, radius );
			_c.endFill();
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
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			_c.beginCurrentFill();
			if ( _ellipse_mode == CENTER ) {
				__ellipse( x0, y0, x1*0.5, y1*0.5 );
			}else if ( _ellipse_mode == CORNER ) {
				__ellipse( x0+x1/2, y0+y1/2, x1/2, y1/2 );
			}else if ( _ellipse_mode == CORNERS ) {
				__ellipse( x0+(x1 - x0)/2, y0+(y1 - y0)/2, (x1 - x0)/2, (y1 - y0)/2 );
			}else { //RADIUS
				__ellipse( x0, y0, x1, y1 );
			}
			_c.endFill();
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
		public function rect( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number=0, ry:Number=0 ):void
		{
			_c.beginCurrentFill();
			if ( rx <= 0 || ry <= 0 ) {
				if ( _rect_mode == CORNER ) {
					__rect( x0, y0, x0+x1, y0+y1 );
				}else if ( _rect_mode == CENTER ) {
					__rect( x0-=x1/2, y0-=y1/2, x0+x1, y0+y1 );
				}else if ( _rect_mode == CORNERS ) {
					__rect( x0, y0, x1, y1 );
				}else {//RADIUS
					__rect( x0-x1, y0-y1, x0+x1, y0+y1 );
				}
			}else{
				if ( _rect_mode == CORNER ) {
					if ( x1 < 0 ) {  x0 += x1; x1 = -x1; }
					if ( y1 < 0 ) {  y0 += y1; y1 = -y1; }
					__roundrect( x0, y0, x0+x1, y0+y1, ( rx > x1/2 ) ? x1/2:rx, ( ry > y1/2 ) ? y1/2:ry );
				}else if ( _rect_mode == CENTER ) {
					if ( x1 < 0 ) x1 = -x1;
					if ( y1 < 0 ) y1 = -y1;
					__roundrect( x0-=x1/2, y0-=y1/2, x0+x1, y0+y1, ( rx > x1/2 ) ? x1/2:rx, ( ry > y1/2 ) ? y1/2:ry );
				}else if ( _rect_mode == CORNERS ) {
					if ( x1 < x0 ) { var _xt:Number = x0; x0 = x1; x1 = _xt; };
					if ( y1 < y0 ) { var _yt:Number = y0; y0 = y1; y1 = _yt; };
					__roundrect( x0, y0, x1, y1, ( rx > ( x1 - x0 )/2 ) ? ( x1 - x0 )/2:rx, ( ry > ( y1 - y0 )/2 ) ? ( y1 - y0 )/2 :ry );
				}else {//RADIUS
					if ( x1 < 0 ) x1 = -x1;
					if ( y1 < 0 ) y1 = -y1;
					__roundrect( x0-x1, y0-y1, x0+x1, y0+y1, ( rx > x1 ) ? x1:rx, ( ry > y1 ) ? y1:ry );
				}
			}
			_c.endFill();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Curves
		
		/**
		 * 現在の塗りと線のスタイルを適用し、3次ベジェ曲線を描画します.
		 */
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x0, y0 ); bezierTo( cx0, cy0, cx1, cy1, x1, y1 );
			_c.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、スプライン曲線を描画します.
		 */
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			_c.beginCurrentFill();
			moveTo( x1, y1 ); splineTo( x0, y0, x3, y3, x2, y2 );
			_c.endFill();
		}
		
		/**
		 * 3次ベジェ曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function bezierDetail( detail_step:uint ):void
		{
			_c.bezierDetail = detail_step;
		}
		
		/**
		 * スプライン曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function curveDetail( detail_step:uint ):void
		{
			_c.splineDetail = detail_step;
		}
		
		/**
		 * スプライン曲線の曲率を指定します.デフォルト値は 1.0 です.
		 */
		public function curveTightness( tightness:Number ):void
		{
			_c.splineTightness = tightness;
		}
		/** @private */
		f5internal function get splineTightness():Number { return _c.splineTightness; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// VERTEX
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * Vertex描画 を 開始します.
		 * <p>modeを省略した場合は、POLYGON描画となります.</p>
		 * @param	mode	 POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP
		 * @see frocessing.core.constants.F5VertexMode
		 */
		public function beginShape( mode:int = 0 ):void { ; }
		
		/**
		 * Vertex描画 を 終了します.
		 * @param	close_path	POLYGONモードで描画した場合、パスを閉じるかどうかを指定できます.
		 */
		public function endShape( close_path:Boolean = false ):void { ; }
		
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
		public function texture( img:BitmapData ):void 
		{
			_c.beginTexture( ( tintDo ) ? tintImageCache.getTintImage( img, _tint_color ) : img );
			_texture_width  = img.width;
			_texture_height = img.height;
			_textureDo = true;
		}
		
		/**
		 * vertex()　の　UV値モード　を指定します.
		 * <p>
		 * NORMALIZED	UV を 正規化された値( 0.0～1.0 )で指定.<br/>
		 * IMAGE		UV を 実際のピクセル値で指定.
		 * </p>
		 * @param	mode	NORMALIZED, IMAGE
		 * @see	frocessing.core.constants.F5TextureMode
		 */
		public function textureMode( mode:int ):void
		{
			_texture_mode = mode;
		}
		
		/**
		 * Vertex描画 で 座標を追加します.
		 * @param	x
		 * @param	y
		 * @param	u	texture を指定している場合、テクスチャの u 値を指定できます
		 * @param	v	texture を指定している場合、テクスチャの v 値を指定できます
		 */
		public function vertex( x:Number, y:Number, u:Number = 0, v:Number = 0 ):void { ; }
		
		/**
		 * Vertex描画 で ベジェ曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void { ; }
		
		/**
		 *　Vertex描画 で スプライン曲線 を 追加します.
		 * <p>POLYGONモードで描画する場合に有効です.</p>　
		 */
		public function curveVertex( x:Number, y:Number ):void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// SHAPE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * IFShape を描画します.
		 */
		public function shape( s:IFShape, x:Number = 0, y:Number = 0, w:Number = NaN, h:Number = NaN ):void 
		{
			__push_styles_pre_shape();
			__shape( s );
			__pop_styles_pre_shape();
		}
		
		private var _shape_tmp_stroke:ICanvasStroke;
		private var _shape_tmp_fill:ICanvasFill;
		private var _shape_tmp_fill_do :Boolean;
		private var _shape_tmp_stroke_do :Boolean ;
		
		/** @private */
		internal function __push_styles_pre_shape():void
		{
			_shape_tmp_stroke    = _c.currentStroke.clone();
			_shape_tmp_stroke_do = _c.strokeEnabled;
			_shape_tmp_fill      = _c.currentFill.clone();
			_shape_tmp_fill_do   = _c.fillEnabled;
			
		}
		/** @private */
		internal function __pop_styles_pre_shape():void 
		{
			_c.currentFill		 = _shape_tmp_fill;
			_c.fillEnabled       = _shape_tmp_fill_do;
			_c.currentStroke	 = _shape_tmp_stroke;
			if ( _shape_tmp_stroke_do ) {
				_c.beginCurrentStroke();
			}else {
				noStroke();
			}
			_shape_tmp_fill = null;
			_shape_tmp_stroke = null;
		}
		/** @private */
		internal function __shape( s:IFShape ):void 
		{
			if ( s.visible ){
				if ( s is IFShapeContainer ) {
					var cont:IFShapeContainer = IFShapeContainer(s);
					var n:int = cont.getChildCount();
					for ( var i:int = 0; i < n ; i++ ) {
						__shape( cont.getChildAt(i) );
					}
				}else {
					if ( s.styleEnabled ) {
						//pushStyle();
						if ( s.strokeEnabled ) {
							s.stroke.apply( _canvasadapter );
						}else{
							noStroke();
						}
						if ( s is IFShapeImage ) {
							__image( IFShapeImage(s).bitmapData, s.left, s.top, 0, s.width, s.height );
						}else if ( s.fillEnabled ) {
							s.fill.apply( _canvasadapter ); //_c.beginFill( s.fill );
							shapePath( s.commands, s.vertices );
							_c.endFill();
						}else {
							noFill();
							shapePath( s.commands, s.vertices );
						}
						//popStyle();
					}else {
						//TODO:Shape style enableds
						if ( s.strokeEnabled ) {
							_c.beginCurrentStroke();
						}else {
							noStroke();
						}
						if ( s.fillEnabled ) {
							_c.beginCurrentFill();
							shapePath( s.commands, s.vertices );
							_c.endFill();
						}else {
							shapePath( s.commands, s.vertices );
						}
						/*
						_c.beginCurrentFill();
						shapePath( s.commands, s.vertices );
						_c.endFill();
						*/
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		//TODO:(2)IBitmapDataDrawable draw
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
		public function image( img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN ):void
		{
			var dimg:BitmapData = ( tintDo ) ? tintImageCache.getTintImage( img, _tint_color ) : img;
			if ( w>0 && h>0 ){
				if ( _image_mode == CORNER ) {
					__image( dimg, x, y, 0, w, h );
				}else if ( _image_mode == CENTER ) {
					__image( dimg, x - w/2, y - h/2, 0, w, h );
				}else if ( _image_mode == CORNERS ) {
					__image( dimg, x, y, 0, w - x, h - y );
				}else if ( _image_mode == RADIUS ) {
					__image( dimg, x - w, y - h, 0, w*2, h*2 );
				}
			}else if ( _image_mode == CENTER || _image_mode == RADIUS ){
				__image( dimg, x - img.width/2, y - img.height/2, 0, img.width, img.height );
			}else {
				__image( dimg, x, y, 0, img.width, img.height );
			}
		}
		/** @private */
		internal function __image( img:BitmapData, x:Number, y:Number, z:Number, w:Number, h:Number ):void { ; }
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// TEXT
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * フォントとサイズを指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function textFont( font:IFont, fontSize:Number = NaN ):void
		{
			if ( _font !== font ) {
				_font = font;
				_font_loadcheck = ( font is IObjectLoader );
			}else {
				_font_loadcheck = false;
			}
			textSize( ( fontSize > 0 ) ? fontSize : _font.size );
		}
		
		/**
		 * text の　size を指定します.
		 */
		public function textSize( fontSize:Number ):void
		{
			if ( _font != null ){
				_fsize      = fontSize;
				_leading    = fontSize * (_font.ascent + _font.descent) * 1.275;
				_fsizeScale = _fsize / _font.size;
			}
		}
		
		/**
		 * text を描画します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>text( string, x, y )</listing>
		 *　<listing>text( string, x, y, width, height )</listing>
		 * <listing>text( string, x, y, z ) F5Canvas3D</listing>
		 * <listing>text( string, x, y, width, height, z ) F5Canvas3D</listing>
		 */
		public function text( str:String, a:Number, b:Number, c:Number = 0, d:Number = 0, e:Number = 0 ):void 
		{
			if ( _font is IBitmapFont ) {
				var tmp_detail:int = _c.imageDetail;
				var tmp_color:uint = _tint_color;
				_c.imageDetail     = IBitmapFont(_font).imageDetail;
				tintColor          = FColor.toARGB( $fill.color, $fill.alpha );
				_c.endStroke();
				//draw text
				if ( c <= 0 || d <= 0 ){ __text( str, a, b ); }
				else {				     __textArea( str, a, b, c, d ); }
				//
				_c.beginCurrentStroke();
				_c.imageDetail     = tmp_detail;
				tintColor          = tmp_color;
			}else {
				//draw text
				if ( c <= 0 || d <= 0 ){ __text( str, a, b ); }
				else{				     __textArea( str, a, b, c, d ); }
			}
		}
		
		/**
		 * テキストの表示幅を返します.
		 * @param	str
		 * @return
		 */
		public function textWidth( str:String ):Number
		{
			if( _font!=null ){
				var length  :int = str.length;
				var wide :Number = 0;
				var _w:Number    = 0;
				var index   :int = 0;
				var start   :int = 0;
				while (index < length){
					if ( str.charAt(index) == "\r" || str.charAt(index) == "\n"  ){
						_w = _getTextWidth( str, start, index );
						if ( _w > wide )
							wide = _w;
						start = index+1;
					}
					index++;
				}
				if (start < length){
					_w = _getTextWidth(str, start, index);
					if ( _w > wide )
						wide = _w;
				}
				return wide;
			}else {
				return 0;
			}
		}
		
		/** @private */
		private function _getTextWidth( str:String, start:int, stop:int ):Number{
			var wide:Number = 0;
			for ( var i:int = start; i < stop; i++) {
				wide += _font.charWidth( str.charCodeAt(i) ) * _fsize + _letterspacing;
			}
			wide -= _letterspacing;
			return wide;
		}
		
		/**
		 * 行のベースラインから最上部までの値(px)を示します.
		 */
		public function textAscent():Number
		{
			return ( _font != null ) ? _font.ascent * _fsize : NaN;
		}
		
		/**
		 * 行のベースラインから最下部までの値(px)を示します.
		 */
		public function textDescent():Number
		{
			return ( _font != null ) ? _font.descent * _fsize : NaN;
		}
		
		/**
		 * text の align を指定します.
		 * 
		 * @param	align	CENTER,LEFT,RIGHT
		 * @param	valign	BASELINE,TOP,BOTTOM
		 * @see frocessing.core.constants.F5TextAlign 
		 * @see frocessing.core.constants.F5TextVAlign
		 */
		public function textAlign( align:int, valign:int = 0 ):void
		{
			_align  = align;
			_valign = valign;
		}
		
		/**
		 * text の　行高 を指定します.
		 */
		public function textLeading( leading:Number ):void
		{
			_leading = leading;
		}
		
		/**
		 * 文字間をしてします.
		 */
		public function textLetterSpacing( value:Number ):void
		{
			_letterspacing = value;
		}
		
		/**
		 * not implemented.
		 */
		public function textMode( mode:int ):void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		private function bitmapCharImpl(f:IBitmapFont, glyph:int, x:Number, y:Number):void 
		{
			var img:BitmapData = f.getFontImage(glyph);
			__image( ( tintDo ) ? tintImageCache.getTintImage( img, _tint_color ) : img,
					 x + f.getOffsetX(glyph) * _fsizeScale, y  - f.getOffsetY(glyph) * _fsizeScale, 0,
					 f.getWidth( glyph )*_fsizeScale, f.getHeight( glyph )*_fsizeScale );
		}
		
		/** @private  */
		private function pathCharImpl(f:IPathFont, glyph:int, x:Number, y:Number ):void 
		{
			var c:Array   = f.getCommands(glyph);
			var p:Array   = f.getPathData(glyph);
			var clen:int = c.length;
			var xi:int   = 0;
			var yi:int   = 1;
			_c.beginCurrentFill();
			for ( var i:int = 0; i < clen ; i++ ){
				var cmd:int = c[i];
				if ( cmd == 2 ) {      //LINE_TO
					lineTo( x + p[xi] * _fsizeScale, y + p[yi] * _fsizeScale );
					xi += 2;
					yi += 2;
				}else if ( cmd == 3 ) { //CURVE_TO
					curveTo( x + p[xi] * _fsizeScale, y + p[yi] * _fsizeScale, x + p[int(xi+2)] * _fsizeScale, y + p[int(yi+2)] * _fsizeScale );
					xi += 4;
					yi += 4;
				}else if ( cmd == 1 ) { //MOVE_TO
					moveTo( x + p[xi] * _fsizeScale, y + p[yi] * _fsizeScale );
					xi += 2;
					yi += 2;
				}
			}
			_c.endFill();
		}
		
		/** @private */
		private function __textLine( start:int, stop:int, x:Number, y:Number ):void
		{
			if ( _align == CENTER )
				x -= _getTextWidth( _str_buffer, start, stop ) * 0.5;
			else if ( _align == RIGHT )
				x -= _getTextWidth( _str_buffer, start, stop );
			
			var index:int;
			var glyph:int;
			var cc:Number;
			if ( _font is IBitmapFont ){ // use PFont : bitmap font
				var pf:IBitmapFont = IBitmapFont( _font );
				for ( index = start; index < stop; index++ ) {
					cc    = _str_buffer.charCodeAt(index);
					glyph = _font.index( cc );
					if( glyph >= 0 ){
						bitmapCharImpl( pf, glyph, x, y );
					}
					x += _font.charWidth( cc ) * _fsize + _letterspacing;
				}
			}else if ( _font is IPathFont ){ // use FFont : graphic path font
				var ff:IPathFont = IPathFont( _font );
				for ( index = start; index < stop; index++ ) {
					cc    = _str_buffer.charCodeAt(index);
					glyph = _font.index( cc );
					if( glyph >= 0 ){
						pathCharImpl( ff, glyph, x, y );
					}
					x += _font.charWidth( cc ) * _fsize + _letterspacing;
				}
			}
		}
		//------------------------------------------------------------------------------------------------------------------- Draw 
		
		/** @private */
		private function __text( str:String, x:Number, y:Number ):void
		{
			if ( _font == null ){
				throw new Error( "font is not selected." );
			}else if ( _font_loadcheck && _font.size > 0 ) {
				textSize( ( _fsize < 0 ) ? _font.size : _fsize );
				_font_loadcheck = false;
			}
			
			_str_buffer = str;
			_str_buffer_length = _str_buffer.length;
			
			var i:int;
			var high:Number = 0;
			for ( i = 0; i < _str_buffer_length; i++ ){
				if ( _str_buffer.charAt(index) == "\r" || _str_buffer.charAt(index) == "\n" )
					high += _leading;
			}
			
			//Vartical Align
			if ( _valign == CENTER)
				y += ( _font.ascent * _fsize - high )*0.5;
			else if ( _valign == TOP)
				y += _font.ascent * _fsize;
			else if ( _valign == BOTTOM)
				y -= high;
			
			//draw with align
			var start:int;
			var index:int;
			while ( index < _str_buffer_length ){
				if ( _str_buffer.charAt(index) == "\r" || _str_buffer.charAt(index) == "\n" ){
					__textLine( start, index, x, y );
					start = index + 1;
					y += _leading;
				}
				index++;
			}
			if ( start < _str_buffer_length )
				__textLine( start, index, x, y );
			
		}
		
		/** @private */
		private function __textArea( str:String, x:Number, y:Number, w:Number, h:Number ):void
		{
			if ( _font == null ){
				throw new Error( "font is not selected." );
			}else if ( _font_loadcheck && _font.size > 0 ){
				textSize( ( _fsize < 0 ) ? _font.size : _fsize );
				_font_loadcheck = false;
			}
			
			_str_buffer = str;
			_str_buffer_length = _str_buffer.length;
			
			var spaceWidth:Number = _font.charWidth( 32 ) * _fsize;
			var runningX :Number  = x;
			var currentY:Number   = y;
			var x2:Number         = x + w;
			var y2:Number         = y + h;
			
			//行開始位置
			var lineX:Number      = x;
			if ( _align == CENTER )
				lineX = lineX + w*0.5;
			else if ( _align == RIGHT )
				lineX = x2;
			
			currentY += _font.ascent;
			//エリアに一行も入らない場合は終了
			if ( currentY > y2 )
				return;

			var wordStart:int = 0;
			var wordStop:int  = 0;
			var lineStart:int = 0;
			var index:int     = 0;
			
			while ( index < _str_buffer_length ) 
			{
				if ( ( _str_buffer.charAt(index) == " " ) || ( index == _str_buffer_length - 1) ) 
				{	
					// 単語の区切り
					var wordWidth:Number = _getTextWidth( _str_buffer, wordStart, index );
					if ( runningX + wordWidth > x2 ) 
					{
						// out of box
						if ( runningX == x ) 
						{
							do
							{
								index--;
								if (index == wordStart)
								{
									//一文字も入らない
									return;
								}
								wordWidth = _getTextWidth( _str_buffer, wordStart, index );
							} while ( wordWidth > w );
							
							__textLine( lineStart, index, lineX, currentY );
						}
						else
						{
							__textLine( lineStart, wordStop, lineX, currentY );
							index = wordStop;
							while ( ( index < _str_buffer_length ) && ( _str_buffer.charAt(index) == " " )) 
							{
								index++;
							}
						}
						lineStart = index;
						wordStart = index;
						wordStop  = index;
						runningX  = x;
						currentY += _leading;
						
						//これ以上表示アリアに入らない
						if (currentY > y2)
							return;
					} 
					else
					{
						runningX += wordWidth + spaceWidth;
						wordStop  = index;
						wordStart = index + 1;
					}
				} 
				else if ( _str_buffer.charAt(index) == "\r" || _str_buffer.charAt(index) == "\n" ) 
				{	
					//改行
					if (lineStart != index) 
					{
						//空行ではない場合
						__textLine( lineStart, index, lineX, currentY );
					}
					lineStart = index + 1;
					wordStart = lineStart;
					runningX  = x;
					currentY += _leading;
					
					//これ以上表示アリアに入らない
					if (currentY > y2)
						return;
				}
				index++;
			}
			
			if ( (lineStart < _str_buffer_length ) && ( lineStart != index )){
				//空行ではない場合
				__textLine( lineStart, index, lineX, currentY );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在のスタイルを保持します.
		 * 
		 * <p>pushStyle() で保持したスタイルは popStyle() で戻されます.</p>
		 * <p>保持されるスタイル</p>
		 * <ul>
		 * <li>colorMode</li>
		 * <li>fill</li>
		 * <li>stroke</li>
		 * <li>stroke attributes(weight,caps,joints...)</li>
		 * <li>rectMode</li>
		 * <li>ellipseMode</li>
		 * <li>imageMode</li>
		 * <li>textFont</li>
		 * <li>textAlign</li>
		 * <li>textSize</li>
		 * <li>textSize</li>
		 * <li>textLeading</li>
		 * <li>testLetterSpacing</li>
		 * <li>tint</li>
		 * </ul>
		 * 
		 * @see frocessing.core.F5Style
		 */
		public function pushStyle():void
		{
			var s:F5Style = new F5Style();
			
			s.colorMode 	= colorModeState;
			s.colorModeX 	= colorModeX;
			s.colorModeY 	= colorModeY;
			s.colorModeZ 	= colorModeZ;
			s.colorModeA 	= colorModeA;
			
			//TODO:check push pop fill, stroke
			s.fillDo 		= _c.fillEnabled;
			s.fill      	= _c.currentFill.clone();
			s.strokeDo	  	= _c.strokeEnabled;
			s.stroke	 	= _c.currentStroke.clone();
			
			s.rectMode 		= _rect_mode;
			s.ellipseMode 	= _ellipse_mode;
			s.imageMode 	= _image_mode;
			s.shapeMode		= _shape_mode;
			
			s.tintDo 		= tintDo;
			s.tintColor 	= _tint_color;
			
			s.textFont		= _font;
			s.textAlign 	= _align;
			s.textVAlign 	= _valign;
			s.textSize 		= _fsize;
			s.textLeading 	= _leading;
			s.textLetterSpacing = _letterspacing;
			
			_style_tmp.push( s );
		}
		
		/**
		 * pushStyle()で保持されたスタイルに復帰します.
		 * @see frocessing.core.F5Style
		 */
		public function popStyle():void
		{
			var s:F5Style = _style_tmp.pop();
			if ( s == null ) return;
			
			colorModeState	     = s.colorMode;
			colorModeX		     = s.colorModeX;
			colorModeY		     = s.colorModeY;
			colorModeZ 		     = s.colorModeZ;
			colorModeA		     = s.colorModeA;
			
			_c.currentFill		 = s.fill;
			_c.fillEnabled       = s.fillDo;
			_c.currentStroke	 = s.stroke;
			
			_rect_mode		     = s.rectMode;
			_ellipse_mode	     = s.ellipseMode;
			_image_mode          = s.imageMode;
			_shape_mode		     = s.shapeMode;
			_tint_color		     = s.tintColor;
			tintDo		         = s.tintDo;
			
			textFont( s.textFont, s.textSize );
			_align 				 = s.textAlign;
			_valign				 = s.textVAlign;
			_leading  			 = s.textLeading;
			_letterspacing		 = s.textLetterSpacing;
			
			if ( s.strokeDo ) {
				_c.beginCurrentStroke();
			}else {
				noStroke();
			}
			
			if ( s.stroke is CanvasStroke ) {
				$strokeGradient.stroke = $stroke = CanvasStroke(s.stroke);
			}else if ( s.stroke is CanvasGradientStroke ) {
				$strokeGradient = CanvasGradientStroke(s.stroke);
				$stroke = $strokeGradient.stroke;
			}
			
			if ( s.fill is CanvasSolidFill ) {
				$fill = CanvasSolidFill(s.fill);
			}else if ( s.fill is CanvasGradientFill ) {
				$fillGradient = CanvasGradientFill(s.fill);
			}else if ( s.fill is CanvasBitmapFill ) {
				$fillBitmap = CanvasBitmapFill(s.fill);
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- Draw Mode
		
		/**
		 * rect()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 * @see frocessing.core.constants.F5RectMode
		 * @default CORNER
		 */
		public function rectMode( mode:int ):void{
			_rect_mode = mode;
		}
		
		/**
		 * ellipse()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 * @see frocessing.core.constants.F5RectMode
		 * @default	CENTER
		 */
		public function ellipseMode( mode:int ):void{
			_ellipse_mode = mode;
		}
		
		/**
		 * image()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | CENTER
		 * @see frocessing.core.constants.F5RectMode
		 * @default	CORNER
		 */
		public function imageMode( mode:int ):void{
			_image_mode = mode;
		}
		
		/**
		 * shape()　の 描画モードを指定します.
		 * @param	mode 	CORNER | CORNERS | CENTER
		 * @see frocessing.core.constants.F5RectMode
		 * @default	CORNER
		 */
		public function shapeMode( mode:int ):void{
			_shape_mode = mode;
		}
		
		/**
		 * image(), texture() などで画像を描画する場合の Smoothing を設定します.
		 * @default	true
		 */
		public function imageSmoothing( smooth:Boolean ):void{
			_c.imageSmoothing = smooth;
		}
		
		/**
		 * beginShape() のモード QUADS,QUAD_STRIP で画像を変形して描画する際の精度を指定します.
		 * <p>F5Graphics3D#image の描画でも適用されます.</p>
		 * @default	1
		 */
		public function imageDetail( detail:uint ):void{
			_c.imageDetail = detail;
		}
		
		//------------------------------------------------------------------------------------------------------------------- BACKGROUND
		
		/**
		 * 背景を描画します.このメソッドを実行すると、現在の描画内容がクリアされます.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>background( gray )</listing>
		 * <listing>background( gray, alpha )</listing>
		 * <listing>background( hex )</listing>
		 * <listing>background( hex, alpha )</listing>
		 * <listing>background( red, green, blue )</listing>
		 * <listing>background( red, green, blue, alpha )</listing>
		 * <listing>background( hue, saturation, brightness )</listing>
		 * <listing>background( hue, saturation, brightness, alpha )</listing>
		 */
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			if ( _width > 0 && _height > 0 ){
				__calcColor( c1, c2, c3, c4 );
				f5clear();
				_c.background( _width, _height, __calc_color, __calc_alpha );
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- FILL
		
		/**
		 * 塗りの色、透明度を指定します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>fill( gray )</listing>
		 * <listing>fill( gray, alpha )</listing>
		 * <listing>fill( hex )</listing>
		 * <listing>fill( hex, alpha )</listing>
		 * <listing>fill( red, green, blue )</listing>
		 * <listing>fill( red, green, blue, alpha )</listing>
		 * <listing>fill( hue, saturation, brightness )</listing>
		 * <listing>fill( hue, saturation, brightness, alpha )</listing>
		 */
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			__calcColor( c1, c2, c3, c4 );
			$fill.color    = __calc_color;
			$fill.alpha    = __calc_alpha;
			_c.currentFill = $fill;
		}
		
		/**
		 * set gradient to current fill.
		 * 
		 * <p>
		 * LINEAR<br/>
		 * fillGradient( "linear", x0, y0, x1, y1, colors, .. )
		 * </p>
		 * <p>
		 * RADIAL<br/>
		 * fillGradient( "radial", cx, cy, radius, focalAngle, colors, .. )
		 * </p>
		 * @param	type	"linear" or "radial"
		 * @param	a		linear:start x, radial:center x
		 * @param	b		linear:start y, radial:center y
		 * @param	c		linear:end x, radial:radius
		 * @param	d		linear:end y, radial:focalPointAngle
		 */
		public function fillGradient( type:String, a:Number, b:Number, c:Number, d:Number, colors:Array, alphas:Array=null, ratios:Array=null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number=0  ):void
		{
			var gmtx:FGradientMatrix = new FGradientMatrix();
			if ( type == GradientType.RADIAL ) {
				gmtx.createRadial( a, b, c, d );
			}else {
				//GradientType.LINEAR
				gmtx.createLinear( a, b, c, d );
			}
			var n:int = colors.length;
			var i:int;
			if( alphas == null ){
				alphas = [];
				for ( i = 0; i < n ; i++ )
					alphas[i] = 1.0;
			}
			if( ratios == null ){
				ratios = [];
				for ( i = 0; i < n ; i++ )
					ratios[i] = 255*i/(n-1);
			}
			_set_gradientfill( type, colors, alphas, ratios, gmtx, spreadMethod, interpolationMethod, focalPointRatio );
			_c.currentFill = $fillGradient;
		}
		
		/**
		 * set bitmap to current fill.
		 */ 
		public function fillBitmap( bitmapData:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false ):void
		{
			$fillBitmap.bitmapData = ( tintDo ) ? tintImageCache.getTintImage( bitmapData, _tint_color ) : bitmapData;
			$fillBitmap.repeat     = repeat;
			$fillBitmap.smooth     = smooth;
			upadate_draw_matrix( $fillBitmap.matrix, matrix );
			_c.currentFill = $fillBitmap;
		}
		
		
		/**
		 * 塗りが描画されないようにします.
		 */
		public function noFill():void
		{
			_c.fillEnabled = false;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STROKE
		
		/**
		 * 線の色、透明度を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>stroke( gray )</listing>
		 * <listing>stroke( gray, alpha )</listing>
		 * <listing>stroke( hex )</listing>
		 * <listing>stroke( hex, alpha )</listing>
		 * <listing>stroke( red, green, blue )</listing>
		 * <listing>stroke( red, green, blue, alpha )</listing>
		 * <listing>stroke( hue, saturation, brightness )</listing>
		 * <listing>stroke( hue, saturation, brightness, alpha )</listing>
		 */
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__calcColor( c1, c2, c3, c4 );
			$stroke.color = __calc_color;
			$stroke.alpha = __calc_alpha;
			_c.beginStroke( $stroke );
		}
		
		/**
		 * 線が描画されないようにします.
		 */
		public function noStroke():void
		{
			_c.endStroke();
			_c.strokeEnabled = false;
		}
		
		/**
		 * 線の太さを指定します.有効な値は 0～255 です.
		 */
		public function strokeWeight( thickness:Number ):void
		{
			$stroke.thickness = thickness;
			_c.beginCurrentStroke();
		}
		
		/**
		 * 線の角で使用する接合点の外観の種類を指定します.
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void
		{
			$stroke.joints = jointStyle;
			_c.beginCurrentStroke();
		}
		
		/**
		 * 線の終端のキャップの種類を指定します.
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void
		{
			$stroke.caps = capsStyle;
			_c.beginCurrentStroke();
		}
		
		/**
		 * 線をヒンティングするかどうかを示します.
		 */
		public function strokePixelHint( pixelHinting:Boolean ):void
		{
			$stroke.pixelHinting = pixelHinting;
			_c.beginCurrentStroke();
		}
		
		/**
		 * 使用する拡大 / 縮小モードを指定する LineScaleMode クラスの値を示します.
		 * @see flash.display.LineScaleMode
		 */
		public function strokeScaleMode( scaleMode:String ):void
		{ 
			$stroke.scaleMode = scaleMode;
			_c.beginCurrentStroke();
		}
		
		/**
		 * マイターが切り取られる限度を示す数値を示します.
		 */
		public function strokeMiterLimit( miterLimit:Number ):void
		{ 
			$stroke.miterLimit = miterLimit;
			_c.beginCurrentStroke();
		}
		
		//------------------------------------------------------------------------------------------------------------------- TINT
		
		/**
		 * Tint Color を指定します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>tint( gray )</listing>
		 * <listing>tint( gray, alpha )</listing>
		 * <listing>tint( hex )</listing>
		 * <listing>tint( hex, alpha )</listing>
		 * <listing>tint( red, green, blue )</listing>
		 * <listing>tint( red, green, blue, alpha )</listing>
		 * <listing>tint( hue, saturation, brightness )</listing>
		 * <listing>tint( hue, saturation, brightness, alpha )</listing>
		 */
		public function tint( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			__calcColor( c1, c2, c3, c4 );
			_tint_color = FColor.toARGB( __calc_color, __calc_alpha );
			tintDo = ( _tint_color != 0xffffffff );
		}
		
		/**
		 * Tint を無効にします.
		 */
		public function noTint():void
		{
			_tint_color = 0xffffffff;
			tintDo = false;
		}
		
		/**
		 * Tint Color を 32bit Color で示します.
		 */
		public function get tintColor():uint{ return _tint_color; }
		public function set tintColor( value:uint ):void
		{
			_tint_color = value;
			tintDo = ( _tint_color != 0xffffffff );
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// Color Mode
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * カラーモードと、色の有効値を設定します.
		 * 
		 * <p>引数の数により有効値の設定が異なります.</p>
		 * 
		 * <listing>colorMode( RGB, value);</listing>
		 * <p>range1～range4 全てに value が適用されます.</p>
		 *  
		 * <listing>colorMode( RGB, value1, value2, value3 );</listing>
		 * <p>colorModeX に value1、colorModeY に value2、colorModeZ に value3 が適用されます.colorModeAは変更されません.</p>
		 * 
		 * <listing>colorMode( RGB, value1, value2, value3, value4 );</listing>
		 * <p>colorModeX～colorModeA　をそれぞれ個別に指定します.</p>
		 * 
		 * @param	mode	RGB,HSB,HSV
		 * @param	range1	colorModeX
		 * @param	range2	colorModeY
		 * @param	range3	colorModeZ
		 * @param	range4	colorModeA
		 * 
		 * @see frocessing.core.constants.F5ColorMode
		 */
		public function colorMode( mode:String, range1:Number=0xff, range2:Number=NaN, range3:Number=NaN, range4:Number=NaN ):void
		{
			colorModeState = mode;
			if ( range4 > 0 )
			{
				colorModeX = range1;
				colorModeY = range2;
				colorModeZ = range3;
				colorModeA = range4;
			}
			else if ( range3 > 0 )
			{
				colorModeX = range1;
				colorModeY = range2;
				colorModeZ = range3;
			}
			else
			{
				colorModeX = colorModeY = colorModeZ = colorModeA = range1;
			}
		}
		
		/**
		 * 24bit color または 32bit color を取得します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>color( gray )</listing>
		 * <listing>color( gray, alpha )</listing>
		 * <listing>color( hex )</listing>
		 * <listing>color( hex, alpha )</listing>
		 * <listing>color( red, green, blue )</listing>
		 * <listing>color( red, green, blue, alpha )</listing>
		 * <listing>color( hue, saturation, brightness )</listing>
		 * <listing>color( hue, saturation, brightness, alpha )</listing>
		 * 
		 * @param	c1	first value
		 * @param	c2	second value
		 * @param	c3	third value
		 * @param	c4	fourth value
		 */
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint
		{
			if ( c4 >= 0 )
			{
				if ( colorModeState == HSB )
					return FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ, c4/colorModeA );
				else
					return FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff), c4/colorModeA );
			}
			else if ( c3 >= 0 )
			{
				if ( colorModeState == HSB )
					return FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					return FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c2 >= 0 )
			{
				if( uint(c1) <= colorModeX )
					return FColor.GrayToValue( uint(c1/colorModeX*0xff), c2/colorModeA );
				else
					return FColor.toARGB( uint(c1), c2 / colorModeA );	
			}
			else
			{
				if( uint(c1) <= colorModeX )
					return FColor.GrayToValue( uint(c1/colorModeX*0xff) );
				else
					return uint(c1);
			}
		}
		
		/** @private */
		internal function __calcColor( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			//TODO:(2) 色計算はコンクリにしてほうが速いけど、どうするべかね
			if ( c4 >= 0 )
			{
				__calc_alpha = c4 / colorModeA;
				if ( colorModeState == HSB )
					__calc_color = FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					__calc_color = FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c3 >= 0 )
			{
				__calc_alpha = 1.0;
				if ( colorModeState == HSB )
					__calc_color = FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					__calc_color = FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c2 >= 0 )
			{
				__calc_alpha = c2 / colorModeA;
				if( uint(c1) <= colorModeX )
					__calc_color = FColor.GrayToValue( uint(c1 / colorModeX * 0xff) );
				else if ( c1 >>> 24 > 0 )
					__calc_color = c1 & 0xffffff;
				else
					__calc_color = uint(c1);
			}
			else
			{
				__calc_alpha = 1.0;
				if ( uint(c1) <= colorModeX ){
					__calc_color = FColor.GrayToValue( uint(c1 / colorModeX * 0xff) );
				}
				else if ( c1 >>> 24 > 0 ){
					__calc_color = c1 & 0xffffff;
					__calc_alpha = (c1 >>> 24) / 0xff;
				}
				else{
					__calc_color = uint(c1);
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Constants
		//-------------------------------------------------------------------------------------------------------------------
		
		// Color Mode
		/** @private */
		protected static const RGB        :String = F5C.RGB;
		/** @private */
		protected static const HSB        :String = F5C.HSB;
		
		// Rect Mode
		/** @private */
		protected static const CORNER        :int = F5C.CORNER;
		/** @private */
		protected static const CORNERS       :int = F5C.CORNERS;
		/** @private */
		protected static const RADIUS        :int = F5C.RADIUS;
		/** @private */
		protected static const CENTER        :int = F5C.CENTER;
		
		// text align
		private static const LEFT    		 :int = F5C.LEFT;
		private static const RIGHT   		 :int = F5C.RIGHT;
		// text v align
		private static const BASELINE		 :int = F5C.BASELINE;
		private static const TOP     		 :int = F5C.TOP;
		private static const BOTTOM  		 :int = F5C.BOTTOM;
		
		// Texture Mode
		/** @private */
		protected static const NORMALIZED    :int = F5C.NORMALIZED;
		/** @private */
		protected static const IMAGE         :int = F5C.IMAGE;
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * color for fill.
		 */
		public function get fillColor():uint{ return $fill.color; }
		public function set fillColor( value:uint ):void {
			$fill.color    = value;
			_c.currentFill = $fill;
		}
		
		/**
		 * alpha value for fill.
		 */
		public function get fillAlpha():Number{ return $fill.alpha; }
		public function set fillAlpha( value:Number ):void {
			$fill.alpha    = value;
			_c.currentFill = $fill;
		}
		
		/**
		 * color for stroke.
		 */
		public function get strokeColor():uint{ return $stroke.color; }
		public function set strokeColor( value:uint ):void {
			$stroke.color = value;
			_c.beginStroke($stroke);
		}
		
		/**
		 * alpha value for stroke.
		 */
		public function get strokeAlpha():Number{ return $stroke.alpha; }
		public function set strokeAlpha( value:Number ):void {
			$stroke.alpha = value;
			_c.beginStroke($stroke);
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 線のスタイルを指定します.
		 */
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String=null,joints:String=null,miterLimit:Number=3):void
		{
			$stroke.thickness    = thickness;
			$stroke.color        = color;
			$stroke.alpha        = alpha;
			$stroke.pixelHinting = pixelHinting;
			$stroke.scaleMode    = scaleMode;
			$stroke.caps         = caps;
			$stroke.joints       = joints;
			$stroke.miterLimit   = miterLimit;
			_c.beginStroke( $stroke );
		}
		
		/**
		 * 線のグラデーションを指定します.
		 */
		public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0 ):void
		{
			$strokeGradient.type                = type;
			$strokeGradient.colors              = colors;
			$strokeGradient.alphas              = alphas;
			$strokeGradient.ratios              = ratios;
			$strokeGradient.spreadMethod        = spreadMethod;
			$strokeGradient.interpolationMethod = interpolationMethod;
			$strokeGradient.focalPointRatio     = focalPointRatio;
			upadate_draw_matrix( $strokeGradient.matrix, matrix, 0.1220703125, 0, 0, 0.1220703125, 0, 0 );
			_c.beginStroke( $strokeGradient );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の塗り指定で塗りを開始します.
		 */
		public function beginCurrentFill():void
		{
			_c.beginCurrentFill();
		}
		
		/**
		 * 単色塗りを指定します.
		 */
		public function beginFill( color:uint, alpha:Number=1.0 ):void
		{
			$fill.color = color;
			$fill.alpha = alpha;
			_c.beginFill( $fill );
		}
		
		/**
		 * ビットマップイメージ塗りを指定します.
		 */
		public function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			$fillBitmap.bitmapData = bitmapData;
			$fillBitmap.repeat     = repeat;
			$fillBitmap.smooth     = smooth;
			upadate_draw_matrix( $fillBitmap.matrix, matrix );
			_c.beginFill( $fillBitmap );
		}
		
		/**
		 * グラデーション塗りを指定します.
		 */
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
			_set_gradientfill( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
			_c.beginFill( $fillGradient );
		}
		private function _set_gradientfill( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number = 0):void
		{
			$fillGradient.type    			  = type;
			$fillGradient.colors  			  = colors;
			$fillGradient.alphas              = alphas;
			$fillGradient.ratios              = ratios;
			$fillGradient.spreadMethod        = spreadMethod;
			$fillGradient.interpolationMethod = interpolationMethod;
			$fillGradient.focalPointRatio     = focalPointRatio;
			upadate_draw_matrix( $fillGradient.matrix, matrix, 0.1220703125, 0, 0, 0.1220703125, 0, 0 );
		}
		
		/**
		 * 塗りを終了します.
		 */
		public function endFill():void
		{
			_c.endFill();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 * 
		 * @param	matrix	dst matrix
		 * @param	target  src matrix
		 * @param	a0		def params
		 * @param	b0
		 * @param	c0
		 * @param	d0
		 * @param	tx0
		 * @param	ty0
		 */
		internal function upadate_draw_matrix( matrix:Matrix, target:Matrix, a0:Number=1, b0:Number=0, c0:Number=0, d0:Number=1, tx0:Number=0, ty0:Number=0 ):void 
		{
			if( target != null ){
				matrix.a  = target.a;
				matrix.b  = target.b;
				matrix.c  = target.c;
				matrix.d  = target.d;
				matrix.tx = target.tx;
				matrix.ty = target.ty;
			}else {
				matrix.a  = a0;
				matrix.b  = b0;
				matrix.c  = c0;
				matrix.d  = d0;
				matrix.tx = tx0;
				matrix.ty = ty0;
			}
		}
		
	}
}
//-------------------------------------------------------------------------------------------------------------------
// CANVAS IMPLEMENTS
//-------------------------------------------------------------------------------------------------------------------

import flash.geom.Matrix;
import flash.display.BitmapData;
import frocessing.core.AbstractF5Canvas;
import frocessing.core.canvas.CanvasStyleAdapter;
import frocessing.core.canvas.canvasImpl;
use namespace canvasImpl;
	
class F5CanvasAdapter extends CanvasStyleAdapter{
	private var fg:AbstractF5Canvas;
	
	public function F5CanvasAdapter( fg:AbstractF5Canvas ) {
		this.fg = fg;
	}
	override canvasImpl function noLineStyle():void {
		fg.noStroke();
	}
	override canvasImpl function lineStyle(thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number):void {
		fg.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
	}
	override canvasImpl function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
		fg.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
	}
	override canvasImpl function beginSolidFill(color:uint, alpha:Number):void {
		fg.beginFill(color, alpha);
	}
	override canvasImpl function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
		fg.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
	}
	override canvasImpl function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix, repeat:Boolean, smooth:Boolean):void {
		fg.beginBitmapFill(bitmapData, matrix, repeat, smooth);
	}
}