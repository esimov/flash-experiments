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
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.geom.Matrix;
	import frocessing.core.graphics.FPathCommand;
	import frocessing.core.canvas.CanvasStyleAdapter;
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.canvas.ICanvasStroke;
	
	import frocessing.core.canvas.canvasImpl;
	use namespace canvasImpl;
	
	/**
	 * Simple SVG Writer.
	 * 
	 * bitmapfill(image drawing) not supported.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FSVGBuffer extends CanvasStyleAdapter
	{
		//float fix.
		private static const FIX:int = 3;
		private static const TRANSFORM_FIX:int = 4;
		private static const NUM_FIX:int = 4;
		private static const OPA_FIX:int = 3;
		private static const GRAD_OFFST_FIX:int = 4;
		
		//svg container param.
		public var width:Number;
		public var height:Number;
		public var bgColor:uint = 0;
		public var bgEnabled:Boolean = false;
		
		//uniq id : for gradient elements.
		private var _idn:int;
		
		//xml buffer.
		private var _XMLBUF_:String;
		private var _grp:int;
		private var _grp_buf:Array;//String[]
		
		//matrix for as gradient to svg gradient.
		private static var _grad_invert:Matrix = new Matrix( 1638.4, 0, 0, 1638.4, 0, 0 );
		
		/**
		 * Create new FSVGBuffer.
		 * 
		 * @param	width	svg width
		 * @param	height	svg height
		 */
		public function FSVGBuffer( width:Number, height:Number ) 
		{
			this.width = width;
			this.height = height;
			
			clearBuffer();
		}
		
		/**
		 * get current svg xml string.
		 */
		public function getSVGString():String
		{
			if ( _grp >= 0 ) {
				while ( _grp >= 0 ) {
					endGroup();
				}
			}
			var headstr:String = SVG_HEAD;
			var bgstr:String   = "";
			var w:String       = width.toFixed(FIX);
			var h:String       = height.toFixed(FIX);
			if ( width > 0 && height > 0 ) {
				headstr += ' x="0px" y="0px" width="'+w+'px" height="'+h+'px" viewBox="0 0 '+w+' '+h+'" >\n';
				if( bgEnabled ){
					bgstr = '<rect stroke="none" fill="'+strColor(bgColor)+'" x="0" y="0" width="'+w+'" height="'+h+'"/>\n';
				}
			}else {
				headstr += ' >\n';
			}
			return XML_HEAD + DOC_TYPE + headstr + bgstr + _XMLBUF_ + SVG_FOOT;
		}
		
		/**
		 * clear xml string buffer.
		 */
		public function clearBuffer():void 
		{
			_idn = 0;
			_XMLBUF_ = "";
			_grp_buf = [];
			_grp = -1;
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * add shape object to SVG buffer.
		 * 
		 * @param	s		shapedata ex. FShapeSVG
		 * @param	sd		stroke data. if shape style is disabled.
		 * @param	fd		fill data. if shape style is disabled.
		 */
		public function addShape( s:IFShape, sd:ICanvasStroke=null, fd:ICanvasFill=null ):void
		{
			//common: alpha, stroke, fill, transform (name)
			if( s.styleEnabled ){
				sd = (s.strokeEnabled) ? s.stroke : null;
				fd   = (s.fillEnabled) ? s.fill : null;
			}
			if( s.visible ){
				if ( s is FShape ) {
					//path, polygon, polyline
					var s1:FShape = FShape(s);
					addPath( s1.commands, s1.vertices, sd, fd, s.matrix, s1._alpha );
				}else if ( s is FShapeLine ) {
					//line
					var s2:FShapeLine = FShapeLine(s);
					addLine( s2.x1, s2.y1, s2.x2, s2.y2, sd, s2.matrix, s2._alpha );
				}else if ( s is FShapeCircle ) {
					//circle
					var s3:FShapeCircle = FShapeCircle(s);
					addCircle( s3.cx, s3.cy, s3.r, sd, fd, s.matrix, s3._alpha );
				}else if ( s is FShapeEllipse ) {
					//ellipse
					var s4:FShapeEllipse = FShapeEllipse(s);
					addEllipse( s4.cx, s4.cy, s4.rx, s4.ry, sd, fd, s.matrix, s4._alpha );
				}else if ( s is FShapeRect ) {
					//rect
					var s5:FShapeRect = FShapeRect(s);
					addRect( s5.x, s5.y, s5.width, s5.height, s5.rx, s5.ry, sd, fd, s.matrix, s5._alpha );
				}else if ( s is FShapeImage ) {
					//image : not support
					
				}else if ( s is FShapeSVG ) {
					//width = s.width;		//TODO:(3)svg size and viewbox
					//height = s.height;
					add_child_shapes( IFShapeContainer(s), sd, fd );	
				}else if ( s is IFShapeContainer ) {
					beginGroup( s.matrix );
					add_child_shapes( IFShapeContainer(s), sd, fd );
					endGroup();
				}else {
					var s0:FShape = FShape(s);
					addPath( s0.commands, s0.vertices, sd, fd, s.matrix, s0._alpha );
				}
			}
		}
		
		private function add_child_shapes( c:IFShapeContainer, sd:ICanvasStroke=null, fd:ICanvasFill=null  ):void 
		{
			var n:uint = c.getChildCount();
			for ( var i:int = 0; i < n; i++ ) {
				addShape( c.getChildAt(i), sd, fd );
			}
		}
		
		/**
		 * add path element.
		 */
		public function addPath( commands:Array, path:Array, stroke:ICanvasStroke=null, fill:ICanvasFill=null, mat:Matrix=null, alpha:Number=1 ):void
		{
			var data:String = getPathData( commands, path );
			if ( data != "" ) {
				data = 'd="' + data + '" ';
				addSVGElement( "path", data, stroke, fill, mat, alpha );
			}
		}
		
		/**
		 * add line element.
		 */
		public function addLine( x1:Number, y1:Number, x2:Number, y2:Number, stroke:ICanvasStroke=null, mat:Matrix=null, alpha:Number=1 ):void
		{
			var data:String = 'x1="'+x1.toFixed(NUM_FIX)+'" y1="'+y1.toFixed(NUM_FIX)+'" x2="'+x2.toFixed(NUM_FIX)+'" y2="'+y2.toFixed(NUM_FIX)+'" ';
			addSVGElement( "line", data, stroke, null, mat, alpha );
		}
		
		/**
		 * add circle element.
		 */
		public function addCircle( cx:Number, cy:Number, r:Number, stroke:ICanvasStroke=null, fill:ICanvasFill=null, mat:Matrix=null, alpha:Number=1 ):void
		{
			var data:String = 'cx="'+cx.toFixed(NUM_FIX)+'" cy="'+cy.toFixed(NUM_FIX)+'" r="'+r.toFixed(NUM_FIX)+'" ';
			addSVGElement( "circle", data, stroke, fill, mat, alpha );
		}
		
		/**
		 * add ellipse element.
		 */
		public function addEllipse( cx:Number, cy:Number, rx:Number, ry:Number, stroke:ICanvasStroke=null, fill:ICanvasFill=null, mat:Matrix=null, alpha:Number=1 ):void
		{
			var data:String = 'cx="'+cx.toFixed(NUM_FIX)+'" cy="'+cy.toFixed(NUM_FIX)+'" rx="'+rx.toFixed(NUM_FIX)+'" ry="'+ry.toFixed(NUM_FIX)+'" ';
			addSVGElement( "ellipse", data, stroke, fill, mat, alpha );
		}
		
		/**
		 * add rect element.
		 */
		public function addRect( x:Number, y:Number, w:Number, h:Number, rx:Number, ry:Number, stroke:ICanvasStroke=null, fill:ICanvasFill=null, mat:Matrix=null, alpha:Number=1 ):void
		{
			var data:String = 'x="'+x.toFixed(NUM_FIX)+'" y="'+y.toFixed(NUM_FIX)+'" width="'+w.toFixed(NUM_FIX)+'" height="'+h.toFixed(NUM_FIX)+'" ';
			if( rx > 0 && ry > 0 ){
				data += 'rx="'+rx.toFixed(NUM_FIX)+'" ry="'+ry.toFixed(NUM_FIX)+'" ';
			}
			addSVGElement( "rect", data, stroke, fill, mat, alpha );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		
		private var _buffer_stroke:String;
		private var _buffer_fill:String;
		private var _buffer_grad:String;
		private var _buffer_style:String;
		
		/**
		 * make xml element string
		 */
		private function addSVGElement( name:String, dataAttrib:String, stroke:ICanvasStroke = null, fill:ICanvasFill = null, mat:Matrix = null, alpha:Number=1 ):void
		{
			_buffer_stroke = "";
			_buffer_fill   = "";
			_buffer_style  = "";
			_buffer_grad   = "";
			
			//style
			if ( stroke != null ){
				stroke.apply( this );
			}else {
				_buffer_stroke = "none";
			}
			if ( fill != null ){
				fill.apply( this );
			}else {
				_buffer_fill = "none";
			}
			
			//make element string
			var elem:String = '<' + name + ' ';
			
			//common attrib
			if ( alpha < 1.0 && alpha >= 0 ) {
				elem += 'opacity="' + alpha.toFixed(OPA_FIX) + '" ';
			}
			if ( _buffer_style != "" ){
				elem += 'style="' + _buffer_style + '" ';
			}
			if ( _buffer_stroke != "" ){
				elem += 'stroke="' + _buffer_stroke + '" ';
			}
			if ( _buffer_fill != "" ){
				elem += 'fill="' + _buffer_fill + '" ';
			}
			if ( mat != null && ( mat.a!=1 || mat.b!=0 || mat.c!=0 || mat.d!=1 || mat.tx!=0 || mat.ty!=0 ) ){
				elem += 'transform="' + strMatrix( mat, TRANSFORM_FIX ) + '" ';
			}
			elem += dataAttrib + '/>\n';
			
			//add gradient element
			if ( _grp >= 0 ) {
				_grp_buf[_grp] += _buffer_grad + elem;
			}else{
				_XMLBUF_ += _buffer_grad + elem;
			}
		}
		
		/**
		 * begin group element.
		 */
		public function beginGroup( mat:Matrix=null, alpha:Number=1.0 ):void
		{
			_grp++;
			
			var elem:String = '<g';			
			if ( alpha < 1.0 && alpha >= 0 ) {
				elem += ' opacity="' + alpha.toFixed(OPA_FIX) + '"';
			}
			if ( mat != null && ( mat.a!=1 || mat.b!=0 || mat.c!=0 || mat.d!=1 || mat.tx!=0 || mat.ty!=0 ) ){
				elem += ' transform="' + strMatrix( mat, TRANSFORM_FIX ) + '"';
			}
			elem += '>\n';
			
			_grp_buf[_grp] = elem;
		}
		
		/**
		 * end group element.
		 */
		public function endGroup():void
		{
			if( _grp>= 0 ){
				var buf:String = _grp_buf.pop();
				if ( _grp == 0 ) {
					_XMLBUF_ += buf + '</g>\n';
				}else {
					_grp_buf[_grp - 1] += buf + '</g>\n';
				}
				_grp--;//-1:all clear.
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// CANVAS IMPLEMENTS
		//-------------------------------------------------------------------------------------------------------------------
		
		/** @private */
		override canvasImpl function noLineStyle():void {
			_buffer_stroke = "none";
		}
		/** @private */
		override canvasImpl function lineStyle(thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number):void {
			_buffer_style += strStrokeStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		/** @private */
		override canvasImpl function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			var id:String = getUniqID();
			_buffer_stroke = strURL( id );
			_buffer_grad += strGradient( id, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		/** @private */
		override canvasImpl function beginSolidFill(color:uint, alpha:Number):void {
			_buffer_style += strFillStyle( color, alpha );
		}
		/** @private */
		override canvasImpl function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):void {
			var id:String = getUniqID();
			_buffer_fill = strURL( id );
			_buffer_grad += strGradient( id, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		/** @private */
		override canvasImpl function beginBitmapFill(bitmapData:BitmapData, matrix:Matrix, repeat:Boolean, smooth:Boolean):void {
			//_gc.beginBitmapFill(bitmapData, matrix, repeat, smooth);
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// Style
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * convert linestyle to svg style( stroke attrib ).
		 * @return stroke attrib
		 * @private
		 */
		private static function strStrokeStyle( thickness:Number, color:uint, alpha:Number, pixelHinting:Boolean, scaleMode:String, caps:String, joints:String, miterLimit:Number ):String
		{
			var str:String = "stroke:" + strColor(color) + "; ";
			if ( alpha< 1 ) {
				str += "stroke-opacity:" + alpha.toFixed(OPA_FIX) + "; ";
			}
			if( thickness>0.1 ){
				str += "stroke-width:" + thickness.toFixed(FIX) + "; ";
			}else {
				str += "stroke-width:0.1; "
			}
			if( joints != null ){
				str += "stroke-linejoin:" + joints + "; "; //def "miter"?
			}
			if( caps != null ){
				str += "stroke-linecap:" + caps + "; "; //def "none"
			}
			if( miterLimit!= 3 ){
				str += "stroke-miterlimit:" + miterLimit.toFixed(FIX) + "; ";
			}
			return str;
		}
		
		/**
		 * convert solid fill to svg style( fill attrib ).
		 * @return fill attrib
		 * @private
		 */
		private static function strFillStyle( color:uint, alpha:Number ):String
		{
			var str:String = "fill:" + strColor(color) + "; ";
			if ( alpha < 1 ) {
				str += "fill-opacity:" + alpha.toFixed(FIX) + "; ";
			}
			return str;
		}
		
		//------------------------------------------------------------------------------------------------------------------- gradient
		
		/**
		 * convert as gradient to svg gradient element.
		 * @return gradient elements.
		 */
		private static function strGradient( id:String, type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number=0 ):String
		{
			var doc:String;
			if( type == GradientType.LINEAR ){
				doc = '<linearGradient id="'+ id +'" gradientUnits="userSpaceOnUse" x1="-0.5" y1="0" x2="0.5" y2="0" ' + 
					   gradattrib( matrix, spreadMethod, interpolationMethod ) + ' >\n';
				doc += gradstops( colors, alphas, ratios );
				doc += '</linearGradient>\n';
			}else {
				doc = '<radialGradient id="'+ id +'" gradientUnits="userSpaceOnUse"  cx="0.5" cy="0.5" r="0.5" fx="' +focalPointRatio.toFixed(FIX)+ '" fy="0" ' + 
					   gradattrib( matrix, spreadMethod, interpolationMethod ) + ' >\n';
				doc += gradstops( colors, alphas, ratios );
				doc += '</radialGradient>\n';
			}
			return doc;
		}
		
		/**
		 * convert gradient matrix and style.
		 */
		private static function gradattrib( matrix:Matrix, spreadMethod:String, interpolationMethod:String ):String
		{
			var attrib:String = "";
			//spread method  "pad(def) | reflect | repeat"
			if ( spreadMethod != SpreadMethod.PAD ) {
				if ( spreadMethod == SpreadMethod.REFLECT ) {
					attrib += ' spreadMethod="reflect"';
				}else if ( spreadMethod == SpreadMethod.REPEAT ) {
					attrib += ' spreadMethod="repeat"';
				}
			}
			//interpolation "auto | sRGB | linearRGB"
			if ( interpolationMethod == InterpolationMethod.LINEAR_RGB )
				attrib += ' color-interpolation="linearRGB"';
			else if( interpolationMethod == InterpolationMethod.RGB )
				attrib += ' color-interpolation="sRGB"';
			
			//transform
			var mat:Matrix = _grad_invert.clone();
			mat.concat( matrix );
			attrib += ' gradientTransform="' + strMatrix( mat, TRANSFORM_FIX ) + '"';
			
			return attrib;
		}
		
		/**
		 * convert gradient color paramters.
		 */
		private static function gradstops( colors:Array, alphas:Array, ratios:Array ):String
		{
			var stops:String = "";
			var len:int = colors.length;
			for (var i:int = 0; i < len; i++) {
				stops += '<stop offset="' + Number(ratios[i] / 255).toFixed(GRAD_OFFST_FIX) + '" ' + 
				         'style="stop-color:' + strColor(colors[i]) + ';stop-opacity:' + Number(alphas[i]).toFixed(OPA_FIX) + ';" />\n';
			}
			return stops;
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// shapes
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * convert Path to svg data attrib of path element.
		 */
		private static function getPathData( commands:Array, data:Array ):String 
		{
			//PATH
			var len:int = commands.length;
			if ( len == 0 )
				return "";
			
			var buffer:String = "";
			var xi:int    = 0;
			var yi:int    = 1;
			for ( var i:int = 0; i < len ; i++ ){
				var c:int = commands[i];
				if ( c == FPathCommand.LINE_TO ){
					buffer += "L" + strPos(data[xi], data[yi]);
					xi += 2;
					yi += 2;
				}
				else if ( c == FPathCommand.CURVE_TO ) {
					buffer += "Q" + strPos(data[xi], data[yi]) + strPos(data[int(xi + 2)], data[int(yi + 2)]);
					xi += 4;
					yi += 4;
				}
				else if ( c == FPathCommand.BEZIER_TO ) {
					buffer += "C" + strPos(data[xi], data[yi]) + strPos(data[int(xi + 2)], data[int(yi + 2)]) + strPos(data[int(xi + 4)], data[int(yi + 4)]); 
					xi += 6;
					yi += 6;
				}
				else if ( c == FPathCommand.MOVE_TO ) {
					buffer += "M" + strPos(data[xi], data[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( c == FPathCommand.CLOSE_PATH ) {
					buffer += "Z ";
				}
			}
			return buffer;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// COMMON
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * get uniq id string.
		 */
		private function getUniqID():String{
			return "F" + (_idn++).toString(16) + "_";
		}
		
		/**
		 * get svg color.
		 */
		private static function strColor( c:uint ):String {
			return "rgb(" + String(c >> 16 & 0xff) + "," + String(c >> 8 & 0xff) + "," + String(c & 0xff) + ")";
		}
		
		/**
		 * get svg transfrom.
		 */
		private static function strMatrix( m:Matrix, fix:int=3 ):String 
		{
			return "matrix(" + m.a.toFixed(fix) +" "+ m.b.toFixed(fix) +" "+ m.c.toFixed(fix) +" "+ m.d.toFixed(fix) +" "+ m.tx.toFixed(fix) +" "+ m.ty.toFixed(fix) + ")";
		}
		
		/**
		 * get svg url to ident id.
		 */
		private static function strURL( id:String ):String
		{
			return "url(#" + id + ")";
		}
		
		/**
		 * get coordinate.
		 */
		private static function strPos( x:Number, y:Number ):String {
			return x.toFixed(FIX) + "," + y.toFixed(FIX) + " ";
		}
		
		private static const XML_HEAD:String = '<?xml version="1.0"?>\n';
		private static const HEAD_LSC:String = '<!-- Generator:Frocessing -->\n';
		private static const DOC_TYPE:String = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n';
		private static const SVG_HEAD:String = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ';
		private static const SVG_FOOT:String = '</svg>';
	}
	
}