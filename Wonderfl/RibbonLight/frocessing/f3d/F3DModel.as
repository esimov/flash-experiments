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

package frocessing.f3d 
{
	import frocessing.core.canvas.ICanvas3D;
	import frocessing.core.canvas.ICanvasFill;
	import frocessing.core.F5C;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.materials.F3DFillMaterial;
	import frocessing.f3d.materials.IF3DMaterial;
	import frocessing.f3d.materials.F3DEmptyMaterial;
	import frocessing.f3d.materials.F3DBmpMaterial;
	import frocessing.geom.FMatrix3D;
	import frocessing.geom.FNumber3D;
	import flash.display.BitmapData;
	
	/**
	* Abstract 3D Model Data Class (Test).
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class F3DModel extends F3DObject
	{
		public static const TRIANGLES     :int = 9;
		public static const TRIANGLE_STRIP:int = 10;
		public static const TRIANGLE_FAN  :int = 11;
		public static const TRIANGLE_MESH :int = 12;
		
		/**
		 * original vertex : FNumber3D[]
		 */
		public var vertices:Array;
		
		/**
		 * transformed vertex : Number[]
		 */
		public var $vertices:Array;
		
		/**
		 * indexes of polygon vertex :uint[]
		 */
		public var faces:Array;
		
		/**
		 * uv of each faces : Number[]
		 */
		public var uv:Array;
		
		//material
		/** @private */
		protected var _material:IF3DMaterial;
		
		//
		public var visible:Boolean = true;
		public var backFaceCulling:Boolean = true;
		
		//
		private var _styleEnabled:Boolean;
		
		/**
		 * 
		 * @param	defaultMatrix
		 */
		public function F3DModel( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			_styleEnabled = true;
			clear();
		}
		
		/**
		 * clear vertex, uv, faces, matrial
		 */
		public function clear():void
		{
			vertices  = [];
			$vertices = [];
			faces     = [];
			uv        = [];
			_material = new F3DEmptyMaterial();
		}
		
		public function get vertexNum():uint {	return vertices.length; }
		
		/**
		 * 
		 * @param	vertices
		 * @param	faces
		 * @param	uv
		 */
		public function setMesh( vertices:Array, faces:Array, uv:Array=null ):void
		{
			this.vertices  = vertices;
			this.faces     = faces;
			this.uv        = ( uv ) ? uv : [];
			updateTransform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 );
		}
		
		//--------------------------------------------------------------------------------------------------- Vertex
		
		private var _mode_def:Boolean;
		private var _mode_strip:Boolean;
		private var _mode_fan:Boolean;
		private var _mode_mesh:Boolean;
		private var _mesh_h:uint
		private var _vertex_flg:Boolean = false;
		private var _vtc:int;  //add vertex count
		private var _vi:int;  //append vertices index
		
		/**
		 * begin vertex. 
		 * @param	mode	TRIANGLES(default), TRIANGLE_STRIP, TRIANGLE_FAN, TRIANGLE_MESH.
		 * @param	meshNum	
		 */
		public function beginVertex( mode:int, meshNum:uint=0 ):void
		{
			_mode_def = _mode_strip = _mode_fan = _mode_mesh = false;
			if ( mode == TRIANGLE_STRIP ) {
				_mode_strip = true;
			}else if ( mode == TRIANGLE_FAN ) {
				_mode_fan = true;
			}else if ( mode == TRIANGLE_MESH ) {
				_mode_mesh = true;
				_mesh_h = meshNum;
			}else {
				_mode_def = true;
			}
			_vtc = 0;
			_vi  = vertices.length;
			_vertex_flg = true;
		}
		
		/**
		 * end vertex;
		 */
		public function endVertex():void
		{
			_vertex_flg = false;
		}
		
		/**
		 * append vertex by triagnle mode.
		 */
		public function addVertex( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void
		{
			if( _vertex_flg ){
				_vtc++;
				vertices[_vi] = new FNumber3D( x, y, z ); _vi++;
				uv.push( u, v );
				
				if ( _mode_def ) {
					if ( _vtc % 3 == 0 ) {
						faces.push( _vi - 1, _vi - 2, _vi - 3 );
					}
				}else if ( _mode_mesh ) {
					if ( _vtc > _mesh_h && _vtc >= 3 ) {
						var _mi:int = _vtc % _mesh_h;
						if ( _mi > 0 ) {
							faces.push( _vi - 1, _vi - _mesh_h - 1, _vi - _mesh_h );
						}
						if ( _mi != 1 ) {
							faces.push( _vi - 1, _vi - 2, _vi - _mesh_h - 1 );
						}
					}
				}else if ( _mode_strip ) {
					if ( _vtc >= 3 ) {
						if ( _vtc & 0x1 > 0 ) {
							faces.push( _vi - 1, _vi - 2, _vi - 3 );
						}else {
							faces.push( _vi - 1, _vi - 3, _vi - 2 );
						}
					}
				}else{ //_mode_fan
					if ( _vtc >= 3 ){
						faces.push( _vi - _vtc, _vtc - 2, _vtc - 1 );
					}
				}
			}else {
				vertices.push( new FNumber3D( x, y, z ) );
				uv.push( u, v );
			}
		}
		
		//--------------------------------------------------------------------------------------------------- Material
		
		public function get material():IF3DMaterial { return _material; }
		public function set material(value:IF3DMaterial):void 
		{
			if ( value == null )
				_material = new F3DEmptyMaterial();
			else
				_material = value;
		}
		
		/**
		 * 
		 */
		public function noMaterial():void {
			_material = new F3DEmptyMaterial();
		}
		
		/**
		 * enable material and backCulling.
		 */
		public function enableStyle():void {
			_styleEnabled = true;
		}
		
		/**
		 * disable material and backCulling.
		 */
		public function disableStyle():void {
			_styleEnabled = false;
		}
		
		/**
		 * 
		 */
		public function setColor( color:uint, alpha:Number=1 ):void {
			_material = new F3DColorMaterial( color, alpha );
		}
		
		/**
		 * 
		 */
		public function setTexture( texture:BitmapData, backTexture:BitmapData=null ):void{
			_material = new F3DBmpMaterial( texture, backTexture );
		}
		
		/*
		public function setFill( fill:ICanvasFill ):void{
			_material = new F3DFillMaterial( fill );
		}
		*/
		
		//---------------------------------------------------------------------------------------------------
		
		/*
		 * face, uv は共有でコピー
		 */
		public function copy():F3DModel
		{
			var fm:F3DModel = new F3DModel(matrix);
			var cv:Array = [];
			var len:int = vertices.length;
			for (var i:int = 0; i < len; i++) {
				var v:FNumber3D = vertices[i];
				cv[i] = new FNumber3D( v.x, v.y, v.z );
			}
			fm.setMesh( cv, faces, uv );
			fm.material = material;
			return fm;
		}
		
		//--------------------------------------------------------------------------------------------------- Override F3DObject
		
		/** @inheritDoc */
		override public function draw( g:ICanvas3D ):void 
		{
			if ( visible ) {
				if( _styleEnabled ){
					g.backFaceCulling = backFaceCulling;
					_material.beginMatrial( g );
					g.drawTriangles( $vertices, faces, uv );
					_material.endMatrial( g );
				}else {
					g.drawTriangles( $vertices, faces, uv );
				}
			}
		}
		
		/** @inheritDoc */
		override public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
												  m21_:Number, m22_:Number, m23_:Number,
												  m31_:Number, m32_:Number, m33_:Number,
												  m41_:Number, m42_:Number, m43_:Number ):void
		{
			super.updateTransform( m11_, m12_, m13_, m21_, m22_, m23_, m31_, m32_, m33_, m41_, m42_, m43_ );
			
			var len:int = vertices.length;
			var vt:FNumber3D;
			var c:int = 0;
			for ( var i:int = 0; i < len; i ++ ){
				vt = vertices[i];
				$vertices[c] = vt.x * m11 + vt.y * m21 + vt.z * m31 + m41;  c++;
				$vertices[c] = vt.x * m12 + vt.y * m22 + vt.z * m32 + m42;  c++;
				$vertices[c] = vt.x * m13 + vt.y * m23 + vt.z * m33 + m43;  c++;
			}
		}
	}
	
}