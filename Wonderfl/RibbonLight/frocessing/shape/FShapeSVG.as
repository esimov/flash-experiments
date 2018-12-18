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
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	import frocessing.color.ColorKey;
	import frocessing.utils.FUtil;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.FGradientMatrix;
	import frocessing.geom.FViewBox;
	
	import frocessing.core.canvas.CanvasNormalGradientFill;
	import frocessing.core.canvas.CanvasNormalGradientStroke;
	
	/**
	* Simple SVG Shape.
	* 
	* <p>Elements supported.</p>
	* <ul>
	* 	<li>Structure<br/>
	* 		svg,g,defs,symbol,use,image
	* 	</li>
	* 	<li>Basic shape and path<br/>
	* 		path, line, rect, circle, ellipse, polyline, polygon
	* 	</li>
	* 	<li>Gradient<br/>
	* 		linearGradient, radialGradient
	* 	</li>
	* </ul>
	* 
	* <p>not supported.</p>
	* <p>
	* text module, font module, animation module, style module,
	* clip module, mask modlue, filter module, color profile module,
	* event, script, view, a, pattern, marker
	* </p>
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class FShapeSVG extends FShapeContainer
	{
		// element type
		private static const ELEMENT_NOT_SUPPORT:int = -1;
		private static const ELEMENT_STRUCTURE:int = 0;
		private static const ELEMENT_SHAPE:int = 10;
		private static const ELEMENT_GRADIENT:int = 20;
		
		// path command 
		private static const MOVE_TO    :int = 1;
		private static const LINE_TO    :int = 2;
		private static const CURVE_TO   :int = 3;
		private static const BEZIER_TO  :int = 10;
		private static const CLOSE_PATH :int = 100;
		
		// objects defined in SVG Documnet
		private static var _REG_ID:Object = { }; //collect elements that had id.
		
		// namespace
		private static var _ns:Namespace;
		private static var _xlink:Namespace;
		
		/**
		 * 
		 * 
		 * @param	doc		structure or shape xml document.
		 * @param	parent	parent container
		 */
		public function FShapeSVG( doc:XML, parent:IFShapeContainer=null ) 
		{
			super( parent );
			if ( doc != null )
				_parse_svg_document( doc );
		}
		
		/** @private */
		protected function _parse_svg_document( doc:XML ):void
		{
			_sysData = { };
			_REG_ID = _sysData;
			
			//namespace
			_ns = doc.namespace();
			_xlink = doc.namespace("xlink");
			
			//var elements:XMLList = doc.._ns::*.(attribute("id").toString() != "");
			
			//parse element
			var ename:String = String( doc.localName() );
			
			var kind:int = ELEMENT_TYPE[ename];
			if ( kind == ELEMENT_SHAPE )
			{
				//parse root element
				var obj:AbstractFShape = parseShapeElement( doc, this );
				if ( obj != null )
					addChild( obj );
			}
			else if ( kind == ELEMENT_STRUCTURE )
			{
				//init paint objects
				var grad_doc:XML;
				for each( grad_doc in doc.._ns::linearGradient ){
					parseLinearGradient( grad_doc ); //regist by parseCoreAttrib()
				}
				for each( grad_doc in doc.._ns::radialGradient ){
					parseRadialGradient( grad_doc ); //regist by parseCoreAttrib()
				}
				
				//parse root element
				parseStructureElement( doc, null, this );
			}
			else
			{
				_err("<" + ename + "> element can not be root object.");
			}
			
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// parse
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * parse ELEMENT_SHAPE
		 */
		private static function parseShapeElement( doc:XML, parent:FShapeContainer=null ):AbstractFShape
		{
			var ename:String = String( doc.localName() );
			switch( ename )
			{
				case "path":
					return parsePath( doc, parent );
				case "line":
					return parseLine( doc, parent );
				case "circle": 
					return parseCircle( doc, parent );
				case "ellipse":
					return parseEllipse( doc, parent );
				case "rect":
					return parseRect( doc, parent );
				case "polygon":
					return parsePolygon( doc, parent );					
				case "polyline":
					return parsePolyline( doc, parent );
				case "image":
					return parseImage( doc, parent );
				default:
					return null;
			}
		}
		
		/**
		 * parse ELEMENT_STRUCTURE
		 */
		private static function parseStructureElement( doc:XML, parent:FShapeContainer=null, target:FShapeContainer=null ):FShapeContainer
		{
			var ename:String = String( doc.localName() );
			switch( ename )
			{
				case "svg":
					return parseSVG( doc, parent, target );
				case "g":
					return parseGroup( doc, parent, target );
				case "symbol": 
					return parseSymbol( doc, parent, target );
				case "use":
					if ( target == null ) {
						//use not root container
						target = new FShapeUse( parent );
					}
					return parseUse( doc, parent, target );
				case "defs":
					return parseDefs( doc, parent, target );
				default:
					return null;
			}
		}
		
		/**
		 * parse structure children
		 */
		private static function parseStructureChildren( doc:XML, target:FShapeContainer ):void
		{
			for each( var child:XML in doc.children() )
			{
				var ename:String = String( child.localName() );
				var kind:int = ELEMENT_TYPE[ename];
				if ( kind == ELEMENT_SHAPE )
				{
					var obj:AbstractFShape = parseShapeElement( child, target );
					if ( obj != null )
						target.addChild( obj );
				}
				else if ( kind == ELEMENT_STRUCTURE )
				{
					var objcont:FShapeContainer = parseStructureElement( child, target );
					if ( objcont != null )
						target.addChild( objcont );
				}
				else if ( kind == ELEMENT_GRADIENT )
				{
					//nothing
				}
				else
				{
					_err("<" + ename + "> element is not supported.");
				}
			}
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse structure
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * init structure module
		 * 
		 * TODO:(2)http://www.w3.org/TR/SVG11/styling.html#UsingPresentationAttributes
		 */
		private static function __initStructureModule( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			if ( target == null )
				target = new FShapeContainer(parent);
			
			//Core.attrib
			parseCoreAttrib( doc, target );
			
			//Graphics.attrib
			parseGraphicsAttrib( doc, target );
			
			//Paint.attrib,Style.attrib,Opacity.attrib
			parseStylesAttrib( doc, target );
			
			//transform
			target.matrix = parseTransform( doc.@transform );
			
			//not support
			//Conditional.attrib, GraphicalEvents.attrib, Cursor.attrib,
			//Filter.attrib, Mask.attrib, Clip.attrib
			
			return target;
		}
		
		/**
		 * parse svg element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#SVGElement</p>
		 * 
		 * @see frocessing.shape.FShapeContainer
		 */
		public static function parseSVG( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			target = __initStructureModule(doc, parent, target);
			var x:Number  = parseLength( String(doc.@x), 0 );
			var y:Number  = parseLength( String(doc.@y), 0 );
			var w:Number  = parseLength( String(doc.@width), 0 );
			var h:Number  = parseLength( String(doc.@height), 0 );
			target.viewbox = parseViewBox( doc );
			parseStructureChildren( doc, target );
			return target;
		}
		
		/**
		 * parse g element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#Groups</p>
		 * 
		 * @see frocessing.shape.FShapeContainer
		 */
		public static function parseGroup( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			target = __initStructureModule(doc, parent, target);
			parseStructureChildren( doc, target );
			return target;
		}
		
		/**
		 * parse defs element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#Heads</p>
		 * 
		 * @see frocessing.shape.FShapeContainer
		 */
		public static function parseDefs( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			target = __initStructureModule(doc, parent, target);
			parseStructureChildren( doc, target );
			target.visible = false;
			return target;
		}
		
		/**
		 * parse symbol element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#SymbolElement</p>
		 * 
		 * @see frocessing.shape.FShapeContainer
		 */
		public static function parseSymbol( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			target = __initStructureModule(doc, parent, target);
			target.viewbox = parseViewBox( doc );
			parseStructureChildren( doc, target );
			target.visible = false;
			return target;
		}
		
		/**
		 * parse use element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#UseElement</p>
		 * 
		 * @see frocessing.shape.FShapeContainer
		 */
		public static function parseUse( doc:XML, parent:FShapeContainer = null, target:FShapeContainer=null ):FShapeContainer
		{
			target = __initStructureModule(doc, parent, target);
			var x:Number  = parseLength( String(doc.@x), 0 );
			var y:Number  = parseLength( String(doc.@y), 0 );
			var w:Number  = parseLength( String(doc.@width), 0 );
			var h:Number  = parseLength( String(doc.@height), 0 );
			var href:String = (_xlink != null) ? doc.@_xlink::href : doc.@href;
			
			if ( target.matrix == null )
				target.matrix = new FMatrix2D();
			
			var obj:* = getObjectById( href.substring(1) );
			if ( obj is FShapeContainer ){
				var cont:FShapeContainer = FShapeContainer(obj);
				var ci:int = cont.getChildCount();
				for ( var k:int = 0; k < ci; k++ ){
					target.addChild( AbstractFShape(cont.getChildAt(k)) );
				}
				if ( cont.viewbox != null ){
					if ( w!=0 && h != 0 ){
						target._matrix.prepend( cont.viewbox.getTransformMatrix(x, y, w, h) );
					}else if ( cont.viewbox.x != 0 && cont.viewbox.y != 0 ){
						target._matrix.prependTranslation( x, y );
						target._matrix.prependTranslation( -cont.viewbox.x, -cont.viewbox.y );
					}
				}else{
					target._matrix.prependTranslation( x, y );
				}
			}else if ( obj is AbstractFShape ){
				target._matrix.prependTranslation( x, y );
				target.addChild( AbstractFShape(obj) );
			}else{
				return null;
			}
			return target;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse image
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * init shape module
		 * 
		 * %SVG.Core.attrib;
		 * //%SVG.Conditional.attrib;
		 * %SVG.Style.attrib;
		 * %SVG.Viewport.attrib;
		 * %SVG.Color.attrib;
		 * %SVG.Opacity.attrib;
		 * %SVG.Graphics.attrib;
		 * %SVG.ColorProfile.attrib;
		 * %SVG.Clip.attrib;
		 * %SVG.Mask.attrib;
		 */
		private static function __initImageModule( doc:XML, target:AbstractFShape ):void
		{
			//Core.attrib
			parseCoreAttrib( doc, target );
			
			//Graphics.attrib
			parseGraphicsAttrib( doc, target );
			
			//Paint.attrib,Style.attrib,Opacity.attrib
			parseStylesAttrib( doc, target );
			
			//transform
			target.matrix = parseTransform( doc.@transform );
			
			//not support
			//Conditional.attrib, GraphicalEvents.attrib, Cursor.attrib,
			//Filter.attrib, Mask.attrib, Clip.attrib
		}
		
		/**
		 * parse image element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/struct.html#ImageElement</p>
		 * 
		 * @see frocessing.shape.FShapeImageLoader
		 */
		public static function parseImage( doc:XML, parent:FShapeContainer=null ):AbstractFShape
		{
			var x:Number  = parseLength( String(doc.@x), 0 );
			var y:Number  = parseLength( String(doc.@y), 0 );
			var w:Number  = parseLength( String(doc.@width), 0 );
			var h:Number  = parseLength( String(doc.@height), 0 );
			var href:String = (_xlink != null) ? doc.@_xlink::href : doc.@href;
			
			if ( w<=0 || h<=0 ) return null;
			//TODO:(2)preserveAspectRatio
			
			var obj:FShapeImageLoader = new FShapeImageLoader( href, null, null, x, y, w, h, parent );
			__initImageModule( doc, obj );
			return obj;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse basic shapes
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * init shape module
		 */
		private static function __initShapeModule( doc:XML, target:AbstractFShape ):void
		{
			//Core.attrib
			parseCoreAttrib( doc, target );
			
			//Graphics.attrib
			parseGraphicsAttrib( doc, target );
			
			//Paint.attrib,Style.attrib,Opacity.attrib
			parseStylesAttrib( doc, target );
			
			//transform
			target.matrix = parseTransform( doc.@transform );
			
			//not support
			//Conditional.attrib, GraphicalEvents.attrib, Cursor.attrib,
			//Filter.attrib, Mask.attrib, Clip.attrib
		}
		
		/**
		 * parse rect element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#RectElement</p>
		 * 
		 * @see frocessing.shape.FShapeRect
		 */
		public static function parseRect( doc:XML, parent:FShapeContainer=null ):FShapeRect
		{
			//<rect x="20" y="20" width="30" height="10" rx="10" ry="10" stroke="#0000ff" fill="none"/>
			
			var x:Number  = parseLength( String(doc.@x), 0 );
			var y:Number  = parseLength( String(doc.@y), 0 );
			var w:Number  = parseLength( String(doc.@width), 1 );
			var h:Number  = parseLength( String(doc.@height), 1 );
			var rx:Number = parseLength( String(doc.@rx), 0 );
			var ry:Number = parseLength( String(doc.@ry), 0 );
			
			var obj:FShapeRect = new FShapeRect( x, y, w, h, rx, ry, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		/**
		 * parse circle element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#CircleElement</p>
		 * 
		 * @see frocessing.shape.FShapeCircle
		 */
		public static function parseCircle( doc:XML, parent:FShapeContainer=null ):FShapeCircle
		{
			//<circle cx="10" cy="10" r="40" fill="red" stroke="blue"/>
			
			var cx:Number = parseLength( String(doc.@cx), 0 );
			var cy:Number = parseLength( String(doc.@cy), 0 );
			var r:Number  = parseLength( String(doc.@r), 1 );
			
			var obj:FShapeCircle = new FShapeCircle( cx, cy, r, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		/**
		 * parse ellipse element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#EllipseElement</p>
		 * 
		 * @see frocessing.shape.FShapeEllipse
		 */
		public static function parseEllipse( doc:XML, parent:FShapeContainer=null ):FShapeEllipse
		{
			//<ellipse transform="rotate(-30)" rx="100" ry="50" fill="none" stroke="#00ff00"/>
			
			var cx:Number = parseLength( String(doc.@cx), 0 );
			var cy:Number = parseLength( String(doc.@cy), 0 );
			var rx:Number = parseLength( String(doc.@rx), 1 );
			var ry:Number = parseLength( String(doc.@ry), 1 );
			
			var obj:FShapeEllipse = new FShapeEllipse( cx, cy, rx, ry, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		/**
		 * parse line element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#LineElement</p>
		 * 
		 * @see frocessing.shape.FShapeLine
		 */
		public static function parseLine( doc:XML, parent:FShapeContainer=null ):FShapeLine
		{
			//<line x1="0" y1="0" x2="10" y2="10" stroke="#FF0000" stroke-width="2" transform="scale(2)"/>
			
			var x1:Number = parseLength( String(doc.@x1), 0 );
			var y1:Number = parseLength( String(doc.@y1), 0 );
			var x2:Number = parseLength( String(doc.@x2), 0 );
			var y2:Number = parseLength( String(doc.@y2), 0 );
			
			var obj:FShapeLine = new FShapeLine( x1, y1, x2, y2, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		/**
		 * parse polyline element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#PolylineElement</p>
		 * 
		 * @see frocessing.shape.FShape
		 */
		public static function parsePolyline( doc:XML, parent:FShapeContainer=null ):FShape
		{
			//<polyline fill="none" stroke="blue" stroke-width="10" points="50,375 150,375 150,325 250,325" />
			
			var obj:FShape = __make_path_shape( parsePoints(String(doc.@points)), false, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		/**
		 * parse polygon element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#PolygonElement</p>
		 * 
		 * @see frocessing.shape.FShape
		 */
		public static function parsePolygon( doc:XML, parent:FShapeContainer=null ):FShape
		{
			//<polygon fill="none" stroke="blue" stroke-width="10" points="50,375 150,375 150,325 250,325" />
			
			var obj:FShape = __make_path_shape( parsePoints(String(doc.@points)), true, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		private static function __make_path_shape( points:Array, close_path:Boolean, parent:FShapeContainer=null ):FShape
		{
			if ( points == null )
				return null;
			
			var vertex_count:int = points.length;
			if ( vertex_count>4 && vertex_count % 2 == 0 )
			{
				var commands:Array = [];
				var command_count:int = vertex_count / 2;
				commands[0] = MOVE_TO;
				for ( var i:int = 1; i < command_count; i++ )
					commands[i] = LINE_TO;
				
				if ( close_path )
					commands[command_count] = CLOSE_PATH;
				
				return new FShape( commands, points, parent );
			}
			else
			{
				return null;
			}
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse paths
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * parse path element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/paths.html</p>
		 * 
		 * @see frocessing.shape.FShape
		 */
		public static function parsePath( doc:XML, parent:FShapeContainer=null ):FShape
		{
			var data:String = String(doc.@d);
			var d:Array = data.match( /[MmZzLlHhVvCcSsQqTtAa]|-?[\d.]+/g );
			
			var len:int   = d.length;
			var pcm:String = ""; //pre command
			var px:Number = 0;  //pre x
			var py:Number = 0;  //pre y
			var cx:Number;
			var cy:Number;
			var cx0:Number;
			var cy0:Number;
			var x0:Number;
			var y0:Number;
			var rx:Number;
			var ry:Number;
			var rote:Number;
			var large:Boolean;
			var sweep:Boolean;
			
			var _commands:Array = [];
			var _vertices:Array = [];
			
			for ( var i:int = 0; i < len; i++ )
			{
				var c:String = d[i];
				if ( c.charCodeAt(0) > 64 ) {
					pcm = c;
				}else {
					i--;
				}
				switch( pcm )
				{
					case "M":
						px = Number( String(d[int(i + 1)]) );
						py = Number( String(d[int(i + 2)]) );
						_commands.push( MOVE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "m":
						px += Number( String(d[int(i + 1)]) );
						py += Number( String(d[int(i + 2)]) );
						_commands.push( MOVE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "L":
						px = Number( String(d[int(i + 1)]) );
						py = Number( String(d[int(i + 2)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "l":
						px += Number( String(d[int(i + 1)]) );
						py += Number( String(d[int(i + 2)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "H":
						px = Number( String(d[int(i + 1)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "h":
						px += Number( String(d[int(i + 1)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "V":
						py = Number( String(d[int(i + 1)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "v":
						py += Number( String(d[int(i + 1)]) );
						_commands.push( LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "C": //cubic bezier curve
						cx0 = Number( String(d[int(i + 1)]) );
						cy0 = Number( String(d[int(i + 2)]) );
						cx = Number( String(d[int(i + 3)]) );
						cy = Number( String(d[int(i + 4)]) );
						px = Number( String(d[int(i + 5)]) );
						py = Number( String(d[int(i + 6)]) );
						_commands.push( BEZIER_TO );
						_vertices.push( cx0, cy0, cx, cy, px, py );
						i += 6;
						break;
					case "c":
						cx0 = px + Number( String(d[int(i + 1)]) );
						cy0 = py + Number( String(d[int(i + 2)]) );
						cx = px + Number( String(d[int(i + 3)]) );
						cy = py + Number( String(d[int(i + 4)]) );
						px += Number( String(d[int(i + 5)]) );
						py += Number( String(d[int(i + 6)]) );
						_commands.push( BEZIER_TO );
						_vertices.push( cx0, cy0, cx, cy, px, py );
						i += 6;
						break;
					case "S": //short hand cubic bezier curve
						cx0 = px + px - cx;
						cy0 = py + py - cy;
						cx = Number( String(d[int(i + 1)]) );
						cy = Number( String(d[int(i + 2)]) );
						px = Number( String(d[int(i + 3)]) );
						py = Number( String(d[int(i + 4)]) );
						_commands.push( BEZIER_TO );
						_vertices.push( cx0, cy0, cx, cy, px, py );
						i += 4;
						break;
					case "s":
						cx0 = px + px - cx;
						cy0 = py + py - cy;
						cx = px + Number( String(d[int(i + 1)]) );
						cy = py + Number( String(d[int(i + 2)]) );
						px += Number( String(d[int(i + 3)]) );
						py += Number( String(d[int(i + 4)]) );
						_commands.push( BEZIER_TO );
						_vertices.push( cx0, cy0, cx, cy, px, py );
						i += 4;
						break;
					case "Q": //quadratic bezier curve
						cx = Number( String(d[int(i + 1)]) );
						cy = Number( String(d[int(i + 2)]) );
						px = Number( String(d[int(i + 3)]) );
						py = Number( String(d[int(i + 4)]) );
						_commands.push( CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 4;
						break;
					case "q":
						cx = px + Number( String(d[int(i + 1)]) );
						cy = px + Number( String(d[int(i + 2)]) );
						px += Number( String(d[int(i + 3)]) );
						py += Number( String(d[int(i + 4)]) );
						_commands.push( CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 4;
						break;
					case "T": //short hand quadratic bezier curve
						cx = 2*px - cx;;
						cy = 2*py - cy;
						px = Number( String(d[int(i + 1)]) );
						py = Number( String(d[int(i + 2)]) );
						_commands.push( CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 2;
						break;
					case "t":
						cx = 2*px - cx;;
						cy = 2*py - cy;
						px += Number( String(d[int(i + 1)]) );
						py += Number( String(d[int(i + 2)]) );
						_commands.push( CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 2;
						break;
					case "A": //arc to
						x0    = px;
						y0    = py;
						rx    = Number( String(d[int(i + 1)]) );
						ry    = Number( String(d[int(i + 2)]) );
						rote  = Number( String(d[int(i + 3)]) )*Math.PI/180;
						large = ( String(d[int(i + 4)])=="1" );
						sweep = ( String(d[int(i + 5)])=="1" );
						px    = Number( String(d[int(i + 6)]) );
						py    = Number( String(d[int(i + 7)]) );
						__arc_curve( x0, y0, px, py, rx, ry, large, sweep, rote, _commands, _vertices );
						i += 7;
						break;
					case "a": //arc to
						x0    = px;
						y0    = py;
						rx    = Number( String(d[int(i + 1)]) );
						ry    = Number( String(d[int(i + 2)]) );
						rote  = Number( String(d[int(i + 3)]) )*Math.PI/180;
						large = ( String(d[int(i + 4)])=="1" );
						sweep = ( String(d[int(i + 5)])=="1" );
						px   += Number( String(d[int(i + 6)]) );
						py   += Number( String(d[int(i + 7)]) );
						__arc_curve( x0, y0, px, py, rx, ry, large, sweep, rote, _commands, _vertices );
						i += 7;
						break;
					case "Z":
						_commands.push( CLOSE_PATH );
						break;
					case "z":
						_commands.push( CLOSE_PATH );
						break;
					default:
						break;
				}
			}
			
			var obj:FShape = new FShape( _commands, _vertices, parent );
			__initShapeModule( doc, obj );
			return obj;
		}
		
		//TODO:(2)__arc_curve 最適化
		private static function __arc_curve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number,
										    large_arc_flag:Boolean, sweep_flag:Boolean, x_axis_rotation:Number,
											cmd:Array, path:Array ):void
		{			
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
				__arc( mx + cx*rc - cy*rs, my + cx*rs + cy*rc, rx, ry, begin, (sweep_flag) ? begin+mr : begin-(2*Math.PI-mr), x_axis_rotation, cmd, path );
			}
			else
			{
				//half arc
				rx = len;
				ry = rx/e;
				begin = Math.atan2( -dy, -dx );
				__arc( mx, my, rx, ry, begin, (sweep_flag) ? begin+Math.PI : begin-Math.PI, x_axis_rotation, cmd, path );
			}
		}
		
		private static function __arc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number, cmd:Array, path:Array ):void
		{
			var segmentNum:int = Math.ceil( Math.abs( 4*(end-begin)/Math.PI ) );
			var delta:Number   = (end - begin)/segmentNum;
			var ca:Number      = 1.0/Math.cos( delta*0.5 );
			var t:Number       = begin;
			var ctrl_t:Number  = begin - delta*0.5;
			var i:int;
			
			if( rotation==0 )
			{
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					cmd.push( CURVE_TO );
					path.push( x + rx*ca*Math.cos(ctrl_t), y + ry*ca*Math.sin(ctrl_t), x + rx*Math.cos(t), y + ry*Math.sin(t) );
				}
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number;
				var yy:Number;
				var cxx:Number;
				var cyy:Number;
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					xx  = rx*Math.cos(t);
					yy  = ry*Math.sin(t);
					cxx = rx*ca*Math.cos(ctrl_t);
					cyy = ry*ca*Math.sin(ctrl_t);
					cmd.push( CURVE_TO );
					path.push( x + cxx*rc - cyy*rs, y + cxx*rs + cyy*rc , x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				}
			}
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse gradient
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * http://www.w3.org/TR/SVG11/pservers.html#Gradients
		 */
		private static function __initGradientModule( doc:XML, kind:String, mat:FGradientMatrix ):FShapeGradient
		{
			var colors:Array = [];
			var alphas:Array = [];
			var ratios:Array = [];
			var spreadMethod:String;
			var interpolationMethod:String;
			
			//gradientUnits = "userSpaceOnUse | objectBoundingBox" default="objectBoundingBox"
			var _bounding:Boolean = ( String( doc.@gradientUnits ) != "userSpaceOnUse" );
			
			//spread method
			var sm:String = String(doc.@spreadMethod); // "pad | reflect | repeat"
			if ( sm == "reflect" )
				spreadMethod = SpreadMethod.REFLECT;
			else if ( sm == "repeat")
				spreadMethod = SpreadMethod.REPEAT;
			else
				spreadMethod = SpreadMethod.PAD; //default
			
			//interpolation
			var ip:String = String(doc.@["color-interpolation"]); // "auto | sRGB | linearRGB"
			if ( ip == "linearRGB" )
				interpolationMethod = InterpolationMethod.LINEAR_RGB;
			else
				interpolationMethod = InterpolationMethod.RGB;
			
			//parse colors
			for each ( var stop_elm:XML in doc.children() )
			{
				if ( String(stop_elm.localName()) == "stop" )
				{
					var c:uint   = parseColor( String( stop_elm.@["stop-color"] ) );
					var a:Number = parseNumber( String(stop_elm.@["stop-opacity"]), 1 );
					var s:String = String( stop_elm.@style );
					if ( s != "" ){
						var styleTokens:Array = FUtil.splitTokens( s, ";" );
						var styleNum:int = styleTokens.length;
						for ( var i:int = 0; i < styleNum; i++ ){
							var tokens:Array = FUtil.splitTokens( styleTokens[i], ":" );
							var sname:String = FUtil.trim(tokens[0]);
							if ( sname=="stop-color" )
								c = parseColor(tokens[1]);
							else if(sname=="stop-opacity")
								a = parseNumber(tokens[1],1);
						}
					}
					ratios.push( uint( 255 * __parse_grad_offset( stop_elm.@offset )) );
					colors.push( c );
					alphas.push( a );
				}
			}
			
			//parse transfrom
			var transform:FMatrix2D = parseTransform( String(doc.@gradientTransform) );
			if ( transform != null )
				mat.concat( transform );
			
			return new FShapeGradient( _bounding, kind, colors, alphas, ratios, mat, spreadMethod, interpolationMethod );;
		}
		
		
		/**
		 * parse linearGradient element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/pservers.html#LinearGradients</p>
		 */
		public static function parseLinearGradient( doc:XML ):FShapeGradient
		{
			//parse xml attributes
			var x0:Number = parseLength( String(doc.@x1), 0 );
			var y0:Number = parseLength( String(doc.@y1), 0 );
			var x1:Number = parseLength( String(doc.@x2), 1 );
			var y1:Number = parseLength( String(doc.@y2), 0 );
			
			var mat:FGradientMatrix = new FGradientMatrix();
			mat.createLinear( x0, y0, x1, y1 );
			
			var obj:FShapeGradient = __initGradientModule( doc, GradientType.LINEAR, mat );
			parseCoreAttrib( doc, obj );
			return obj;
		}
		
		/**
		 * parse radialGradient element.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/pservers.html#RadialGradients</p>
		 */
		public static function parseRadialGradient( doc:XML ):FShapeGradient
		{
			//parse xml attributes
			var cx:Number = parseLength( String(doc.@cx), 0.5 );
			var cy:Number = parseLength( String(doc.@cy), 0.5 );
			var r:Number  = parseLength( String(doc.@r), 0.5 );
			var fx:Number = parseLength( String(doc.@fx), cx );
			var fy:Number = parseLength( String(doc.@fy), cy );
			
			fx -= cx;
			fy -= cy;
			//var fr:Number = Math.atan2( -fy, fx ); //illustrator svg loader has bug , fy be reflected.
			var fr:Number = Math.atan2( fy, fx );
			var focalPointRatio:Number = Math.sqrt( fx * fx + fy * fy ) / r;
			
			var mat:FGradientMatrix = new FGradientMatrix();
			mat.createRadial( cx, cy, r, fr );
			
			var obj:FShapeGradient = __initGradientModule( doc, GradientType.RADIAL, mat );
			obj.focalPointRatio = focalPointRatio;
			parseCoreAttrib( doc, obj );
			return obj;
		}
		
		/**
		 * @return 0 to 1
		 * @private
		 */
		private static function __parse_grad_offset( str:String ):Number
		{
			var i:int = str.indexOf("%");
			if ( i > -1 )
				return Number( str.substring( 0, i ) ) / 100;
			else
			{
				return Number( str );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PARSE ATTRIB
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * Core.attrib
		 * 
		 * http://www.w3.org/TR/SVG11/struct.html#core-att-mod
		 * 
		 * not support:
		 * xml:base, xml:lang, xml:space
		 */
		private static function parseCoreAttrib( doc:XML, target:* ):void
		{
			var id:String = String(doc.@id);
			try{
				target["name"] = id;
				if( id != "" )
					registID( id, target );
			}catch ( e:Error ){
				_err( e.getStackTrace() );
			}
		}
		
		/**
		 * Graphics.attrib
		 * 
		 * http://www.w3.org/TR/SVG11/painting.html#graphics-att-mod
		 * 
		 * not support:
		 * image-rendering
		 * pointer-events
		 * shape-rendering
		 * text-rendering
		 * visibility
		 */
		private static function parseGraphicsAttrib( doc:XML, target:AbstractFShape ):void
		{
			//display
			target.visible = !( String(doc.@display) == "none");
		}
		
		/**
		 * Paint.attrib, Style.attrib, Opacity.attrib
		 * 
		 * http://www.w3.org/TR/SVG11/painting.html#paint-att-mod
		 * http://www.w3.org/TR/SVG11/painting.html#opacity-att-mod
		 * http://www.w3.org/TR/SVG11/styling.html#id5189379
		 * 
		 * support:
		 * opacity
		 * fill
		 * fill-opacity
		 * stroke
		 * stroke-opacity
		 * stroke-width
		 * stroke-linejoin
		 * stroke-linecap
		 * stroke-miterlimit
		 * style
		 * 
		 * not supported:
		 * fill-rule
		 * stroke-dasharray
		 * stroke-dashoffset
		 * color-interpolation
		 * color-rendering
		 * class
		 * 
		 * @private
		 */
		private static function parseStylesAttrib( doc:XML, target:AbstractFShape ):void
		{
			var val:String;
			
			//fill and stroke
			setFill( doc.@fill, target );
			setStroke( doc.@stroke, target );
			
			val = String(doc.@opacity);
			if ( val != "" ) target._alpha = opacity(val);
			
			val = String(doc.@["fill-opacity"]);
			if ( val != "" ) target._fill_setting.alpha = opacity(val);
			
			val = String(doc.@["stroke-opacity"]);
			if ( val != "" ) target._stroke_setting.alpha = opacity(val);
				
			val = String(doc.@["stroke-width"]);
			if ( val != "" ) target._stroke_setting.thickness = strokeWeight(val);
			
			val = String(doc.@["stroke-linejoin"]);
			if ( val != "" ) target._stroke_setting.joints = strokeJoin(val);
			
			val = String(doc.@["stroke-linecap"]);
			if ( val != "" ) target._stroke_setting.caps = strokeCap(val);
				
			val = String(doc.@["stroke-miterlimit"]);
			if ( val != "" ) target._stroke_setting.miterLimit = strokeMiterLimit(val);
			
			//Style.attrib
			val = String(doc.@style);
			if ( val != "" )
			{
				var styleTokens:Array = FUtil.splitTokens( val, ";" );
				var styleNum:int = styleTokens.length;
				for ( var i:int = 0; i < styleNum; i++ )
				{
					var tokens:Array = FUtil.splitTokens( styleTokens[i], ":" );
					var sname:String = FUtil.trim(tokens[0]);
					switch( sname )
					{
						case "fill":
							setFill( tokens[1], target );
							break;
						case "stroke":
							setStroke( tokens[1], target );
							break;
						case "fill-opacity":
							target._fill_setting.alpha = opacity(tokens[1]);
							break;
						case "stroke-opacity":
							target._stroke_setting.alpha = opacity(tokens[1]);
							break;
						case "stroke-width":
							target._stroke_setting.thickness = strokeWeight(tokens[1]);
							break;
						case "stroke-linecap":
							target._stroke_setting.caps = strokeCap(tokens[1]);
							break;
						case "stroke-linejoin":
							target._stroke_setting.joints= strokeJoin(tokens[1]);
							break;
						case "stroke-miterlimit":
							target._stroke_setting.miterLimit = strokeMiterLimit(tokens[1]);
							break;
						case "opacity":
							target._alpha = opacity(tokens[1]);
							break;
						default:
							// Other attributes are not yet implemented
							break;
					}
				}
			}
		}
		
		/** @private */
		private static function setStroke( strokeText:String, target:AbstractFShape ):void
		{
			var url:String;
			if ( strokeText == "" ){
				return;
			}
			else if ( strokeText == "none" ){
				target._strokeEnabled = false;
			}
			else if ( (url = parseUrl(strokeText)) != "" ) {
				var dat:* = getObjectById( url );
				if ( dat is FShapeGradient ) {
					var gd:FShapeGradient = dat;
					target._strokeEnabled = true;
					target._stroke = new CanvasNormalGradientStroke( target._stroke_setting, gd.isNormal, gd.type, gd.colors.concat(), gd.alphas.concat(), gd.ratios.concat(), gd.matrix.clone(), gd.spreadMethod, gd.interpolationMethod, gd.focalPointRatio );
					 //TODO:(2)opacity to gradient
					if ( gd.isNormal ) {
						CanvasNormalGradientStroke(target._stroke).setRect( target._left, target._top, target._width, target._height );//update
					}
				}else{
					_err("url " + url + " refers to unexpected data");
				}
			}
			else{
				target._strokeEnabled  = true;
				target.strokeColor = parseColor( strokeText );
			}
		}
		
		/** @private */
		private static function setFill( fillText:String, target:AbstractFShape ):void
		{
			var url:String;
			if ( fillText == "" || target is FShapeImage ){
				return;
			}
			else if ( fillText == "none" ){
				target._fillEnabled = false;
			}
			else if ( (url = parseUrl(fillText)) != "" ) {
				var dat:* = getObjectById( url );
				if ( dat is FShapeGradient ) {
					var gd:FShapeGradient = dat;
					target._fillEnabled = true;
					target._fill = new CanvasNormalGradientFill( gd.isNormal, gd.type, gd.colors.concat(), gd.alphas.concat(), gd.ratios.concat(), gd.matrix.clone(), gd.spreadMethod, gd.interpolationMethod, gd.focalPointRatio );
					 //TODO:(2)gradient opacity
					if ( gd.isNormal ) {
						CanvasNormalGradientFill(target._fill).setRect( target._left, target._top, target._width, target._height );//update
					}
				}else{
					_err("url " + url + " refers to unexpected data");
				}
			}else{
				target._fillEnabled  = true;
				target.fillColor = parseColor( fillText );
			}
		}
		
		private static function opacity( opacityText:String ):Number
		{
			return Number(opacityText);
		}

		private static function strokeWeight( lineweight:String ):Number
		{
			var t:Number = parseLength(lineweight,0);
			if ( t <= 0.5 )
				return 0;
			else
				return t;
		}
		
		private static function strokeCap( linecap:String ):String
		{
			if ( linecap=="butt" )
				return CapsStyle.NONE;
			else if ( linecap=="round" )
				return CapsStyle.ROUND;
			else if ( linecap=="square" )
				return CapsStyle.SQUARE;
			else
				return CapsStyle.NONE;
		}
		
		private static function strokeJoin( linejoin:String ):String
		{
			if ( linejoin=="miter" )
				return JointStyle.MITER;
			else if ( linejoin=="round" )
				return JointStyle.ROUND;
			else if ( linejoin=="bevel" )
				return JointStyle.BEVEL;
			else
				return JointStyle.MITER;
		}
		
		private static function strokeMiterLimit( attr:String ):Number
		{
			return Number(attr);
		}
		
		
		//------------------------------------------------------------------------------------------------------------------- 
		// parse attributes
		//------------------------------------------------------------------------------------------------------------------- 
		
		//--------------------------------------------------------------------------- ViewBox
		
		/**
		 * viewbox and preserveAspectRatio attribute.
		 * 
		 * http://www.w3.org/TR/SVG11/coords.html#ViewBoxAttribute
		 * http://www.w3.org/TR/SVG11/coords.html#PreserveAspectRatioAttribute 
		 */
		private static function parseViewBox( doc:XML ):FViewBox
		{
			var viewbox:FViewBox;
			
			var attr:String = String( doc.@viewBox );
			if ( attr != "" )
			{
				//make viewbox
				var viewbox_param:Array = FUtil.splitTokens(attr);
				if ( viewbox_param.length == 4 )
				{
					viewbox = new FViewBox( viewbox_param[0], viewbox_param[1], viewbox_param[2], viewbox_param[3] );
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}
			
			
			//preserveAspectRatio
			parsePreserveAspectRatio( String( doc.@preserveAspectRatio ), viewbox );
			
			return viewbox;
		}
		
		/**
		 * @private
		 */
		private static function parsePreserveAspectRatio( attr:String, viewbox:FViewBox ):void
		{
			//default ratio
			viewbox.align     = FViewBox.CENTER;	//xMidYMid
			viewbox.scaleMode = FViewBox.SHOW_ALL;	//meet
			
			if ( attr != "" )
			{
				var param:Array = FUtil.splitTokens(attr);
				if ( param.length > 0 )
				{
					if ( param[0] == "defer" )
						param.shift();
					
					if ( param.length > 1 && param[1] == "slice" )
						viewbox.scaleMode = FViewBox.NO_BORDER;
					
					var p:String = param[0];
					switch( p )
					{
						case "none":
							viewbox.scaleMode = FViewBox.EXACT_FIT;
							break;
						case "xMinYMin":
							viewbox.align = FViewBox.TOP_LEFT;
							break;
						case "xMinYMid":
							viewbox.align = FViewBox.LEFT;
							break;
						case "xMinYMax":
							viewbox.align = FViewBox.BOTTOM_LEFT;
							break;
						case "xMidYMin":
							viewbox.align = FViewBox.TOP;
							break;
						case "xMidYMid":
							viewbox.align = FViewBox.CENTER;
							break;
						case "xMidYMax":
							viewbox.align = FViewBox.BOTTOM;
							break;
						case "xMaxYMin":
							viewbox.align = FViewBox.TOP_RIGHT;
							break;
						case "xMaxYMid":
							viewbox.align = FViewBox.RIGHT;
							break;
						case "xMaxYMax":
							viewbox.align = FViewBox.BOTTOM_RIGHT;
							break;
					}
				}
			}
		}
		
		//--------------------------------------------------------------------------- Color
		/**
		 * parse color attribute.
		 * 
		 * <p>色指定を行う文字列を 24bit color に変換します.</p>
		 * <ul>
		 * <li>"#RRGGBB"</li>
		 * <li>"#RGB" ( convert to #RRGGBB )</li>
		 * <li>"rgb(255,255,255)"</li>
		 * <li>color key word</li>
		 * </ul>
		 * 
		 * <p>http://www.w3.org/TR/SVG11/types.html#DataTypeColor</p>
		 * <p>http://www.w3.org/TR/SVG11/types.html#ColorKeywords</p>
		 * 
		 * @see frocessing.color.ColorKey
		 */
		public static function parseColor( attr:String ):uint
		{
			if( attr.charAt(0)==" " )
				attr = FUtil.trim(attr);
			
			if ( attr.charAt(0)=="#" )
			{
				if ( attr.length == 4 )
				{
					var r:String = attr.charAt(1);
					var g:String = attr.charAt(2);
					var b:String = attr.charAt(3);
					return parseInt( r+r+g+g+b+b, 16 ) & 0xFFFFFF;
				}
				else
				{
					return parseInt( attr.substring(1), 16 ) & 0xFFFFFF;
				}
			}
			else if ( attr.indexOf("rgb")==0 )
			{
				var leftParen:int  = attr.indexOf("(") + 1;
				var rightParen:int = attr.indexOf(")");
				var values:Array = FUtil.splitTokens( attr.substring(leftParen, rightParen), ", ");
				return ( uint(values[0]) << 16) | ( uint(values[1]) << 8) | uint(values[2]);
			}
			else
			{
				return ColorKey[attr];
			}
		}
		
		//--------------------------------------------------------------------------- Points
		/**
		 * parse list of points attribute.
		 * 
		 * <p>http://www.w3.org/TR/SVG11/shapes.html#PointsBNF</p>
		 */
		public static function parsePoints( points:String ):Array
		{
			if ( points != "" )
			{
				//#x20 (space) #x09 (tab) #x0A (LF) #x0D (CR)
				var p:Array = FUtil.splitTokens( FUtil.trim(points), ",\x20\x09\x0A\x0D" );
				var len:int = p.length;
				var coordinates:Array = [];
				for ( var i:int = 0; i < len; i++ )
				{
					coordinates[i] = Number(p[i]);
				}
				return coordinates;
			}
			else
			{
				return null;
			}
		}
		
		//--------------------------------------------------------------------------- TRANSFORM
		/**
		 * parse transform("transforms-list") attribute.
		 * 
		 * <p>transform 属性の値(変換定義のリスト"transforms-list")を、Matrix に変換します.</p>
		 * <ul>
		 * <li>"matrix(a,b,c,d,tx,ty)"</li>
		 * <li>"translate(x,y)"</li>
		 * <li>"scale(sx,sy)"</li>
		 * <li>"rotate(degree)"</li>
		 * <li>"skewX(degree)"</li>
		 * <li>"skewY(degree)"</li>
		 * </ul>
		 * 
		 * <p>http://www.w3.org/TR/SVG11/coords.html#TransformAttribute</p>
		 */
		public static function parseTransform( attr:String ):FMatrix2D
		{
			if ( attr == "" )
				return null;
			
			var trans:Array = attr.match(/\w+\(.*?\)/g); //TODO: "funcname" whitespace* "("
			var len:int = trans.length;
			if ( len > 0 )
			{
				var mat:FMatrix2D = new FMatrix2D();
				for ( var i:int = 0; i < len; i++ )
				{
					var t:String = trans[i];
					var k:int    = t.indexOf("(");
					var m:String = t.substring( 0, k );
					var v:Array  = FUtil.splitTokens( t.substring( k+1, t.length-1), ", ");
					if ( m == "matrix" )
					{
						mat.prependMatrix( Number(v[0]), Number(v[1]), 
										   Number(v[2]), Number(v[3]),
										   Number(v[4]), Number(v[5]) );
					}
					else if ( m == "translate" )
					{
						var tx:Number = Number(v[0]);
						var ty:Number = ( v.length == 2 )? Number(v[1]) : tx;
						mat.prependTranslation( tx, ty ); 
					}
					else if ( m == "scale" )
					{
						var sx:Number = Number(v[0]);
						var sy:Number = ( v.length == 2 )? Number(v[1]) : sx;
						mat.prependScale( sx, sy ); 
					}
					else if ( m == "rotate" )
					{
						if ( v.length == 1 )
						{
							mat.prependRotation( _deg_to_radian(v[0]) );
						}
						else if ( v.length == 3 )
						{
							var txx:Number = Number(v[1]);
							var tyy:Number = Number(v[2]);
							mat.prependTranslation( txx, tyy );
							mat.prependRotation( _deg_to_radian(v[0]) );
							mat.prependTranslation( -txx, -tyy );
						}
					}
					else if ( m == "skewX" )
					{
						mat.prependMatrix( 1, 0, Math.tan( _deg_to_radian(v[0]) ), 1, 0, 0 );
					}
					else if ( m == "skewY" )
					{
						mat.prependMatrix( 1, Math.tan( _deg_to_radian(v[0]) ), 0, 1, 0, 0 );
					}
				}
				return mat;
			}
			return null;
		}
		
		//--------------------------------------------------------------------------- Number
		/**
		 * parse "length" attribute.
		 * 
		 * "length" is a "number" optionally followed immediately by a unit identifier.
		 * 
		 * <p>単位付の数値をピクセル値に換算します.換算率はSVG仕様によります.</p>
		 * <ul>
		 * <li>"1pt" equals "1.25px"</li>
		 * <li>"1pc" equals "15px"</li>
		 * <li>"1mm" would be "3.543307px"</li>
		 * <li>"1cm" equals "35.43307px"</li>
		 * <li>"1in" equals "90px"</li>
		 * </ul>
		 * 
		 * <p>http://www.w3.org/TR/SVG11/types.html#DataTypeLength</p>
		 * <p>http://www.w3.org/TR/SVG11/coords.html#Units</p>
		 * 
		 * @return pixel value
		 */
		public static function parseLength( attr:String, defaultValue:Number=0 ):Number
		{
			if ( attr != "" )
			{
				var len:int  = attr.length - 2;
				var u:String = attr.substr( len );
				switch( u )
				{
					case "pt":
						return Number(attr.substring(0, len)) * 1.25;
					case "pc":
						return Number(attr.substring(0, len)) * 15;
					case "mm":
						return Number(attr.substring(0, len)) * 3.543307;
					case "cm":
						return Number(attr.substring(0, len)) * 35.43307;
					case "in":
						return Number(attr.substring(0, len)) * 90;
					case "px":
						return Number(attr.substring(0, len));
					default:
						return Number( attr );
				}
			}
			else
			{
				return defaultValue;
			}
		}
		
		//---------------------------------------------------------------------------
		
		private static function parseNumber( attr:String, defaultValue:Number = 0 ):Number
		{
			if ( attr != "" )
				return Number(attr);
			else
				return defaultValue;
		}
		
		private static function parseUrl( str:String ):String
		{
			var i0:int = str.indexOf("url(#");
			if ( i0 >= 0 )
				return str.substring( i0 + 5, str.indexOf(")") );
			else
				return "";
		}
		
		private static function _deg_to_radian( str:String ):Number
		{
			return Number(str) * Math.PI / 180;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// register
		//-------------------------------------------------------------------------------------------------------------------
		
		private static function registID( id:String, target:* ):void
		{
			_REG_ID[id] = target;
		}
		
		private static function getObjectById( id:String ):*
		{
			return _REG_ID[id];
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Util
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * get root SVG Element
		 */
		public static function findSVGRoot( doc:XML ):XML
		{
			if( String(doc.localName()) == "svg" )
			{
				return doc;
			}
			for each ( var elem:XML in doc.* )
			{
				var res:XML = findSVGRoot( elem );
				if( res != null )
				{
					return res;
				}
			}
			return null;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// SVG Elements
		//-------------------------------------------------------------------------------------------------------------------
		
		private static var _etypes:Object;
		
		private static function get ELEMENT_TYPE():Object
		{
			if ( _etypes != null )
				return _etypes;
			
			_etypes = { };
			_etypes["svg"] 					= ELEMENT_STRUCTURE;
			_etypes["g"] 					= ELEMENT_STRUCTURE;
			_etypes["defs"] 				= ELEMENT_STRUCTURE;
			_etypes["desc"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["title"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["metadata"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["symbol"] 				= ELEMENT_STRUCTURE;
			_etypes["use"] 					= ELEMENT_STRUCTURE;
			_etypes["image"]				= ELEMENT_SHAPE;
			_etypes["switch"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["style"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["path"]					= ELEMENT_SHAPE;
			_etypes["line"]					= ELEMENT_SHAPE;
			_etypes["circle"]				= ELEMENT_SHAPE;
			_etypes["ellipse"]				= ELEMENT_SHAPE;
			_etypes["rect"]					= ELEMENT_SHAPE;
			_etypes["polygon"]				= ELEMENT_SHAPE;
			_etypes["polyline"]				= ELEMENT_SHAPE;
			_etypes["text"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["tspan"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["tref"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["textPath"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["altGlyph"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["altGlyphDef"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["altGlyphItem"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["glyphRef"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["marker"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["color-profile"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["radialGradient"]		= ELEMENT_GRADIENT;
			_etypes["linearGradient"]		= ELEMENT_GRADIENT;
			_etypes["stop"]					= ELEMENT_GRADIENT;
			_etypes["pattern"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["clipPath"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["mask"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["filter"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feBlend"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feColorMatrix"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["feComponentTransfer"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["feComposite"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["feConvolveMatrix"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["feDiffuseLighting"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["feDisplacementMap"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["feFlood"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feGaussianBlur"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["feImage"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feMerge"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feMergeNode"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["feMorphology"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["feOffset"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["feSpecularLighting"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["feTile"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feTurbulence"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["feDistantLight"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["fePointLight"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["feSpotLight"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["feFuncR"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feFuncG"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feFuncB"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["feFuncA"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["cursor"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["view"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["a"] 					= ELEMENT_NOT_SUPPORT;
			_etypes["script"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["animate"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["set"] 					= ELEMENT_NOT_SUPPORT;
			_etypes["animateMotion"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["animateTransform"] 	= ELEMENT_NOT_SUPPORT;
			_etypes["animateColor"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["mpath"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["font"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["font-face"] 			= ELEMENT_NOT_SUPPORT;
			_etypes["glyph"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["missing-glyph"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["hkern"] 				= ELEMENT_NOT_SUPPORT;
			_etypes["font-face-src"] 		= ELEMENT_NOT_SUPPORT;
			_etypes["font-face-name"] 		= ELEMENT_NOT_SUPPORT;
			
			return _etypes;			
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		private static function _err( err_str:String ):void
		{
			//trace( "SVG>>", err_str );
		}
		
	}
	
}