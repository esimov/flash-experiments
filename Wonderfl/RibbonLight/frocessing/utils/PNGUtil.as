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

package frocessing.utils 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * PNG Utility.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class PNGUtil 
	{
		
		/**
		 * Create empty PNG Data.
		 */
		public static function createEmpty( width:int, height:int ):ByteArray
		{
			var img:ByteArray  = new ByteArray();
			for (var i:int = 0; i < height; i++) {
	            img.writeByte(0);
	            for ( var j:int = 0; j < width; j+=8) {
					img.writeByte(0);
				}
	        }
			return createPNG( width, height, 0x01000000, img ); //1bit gray(1,0,0,0)
		}
		
		/**
		 * Create PNG Data.
		 */
		public static function create( bitmapData:BitmapData ):ByteArray
		{
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			var img:ByteArray  = new ByteArray();
			var i:int;
			var j:int;
			if ( bitmapData.transparent ) {
				var c:uint;
				for ( i = 0; i < height; i++) {
					img.writeByte(0);
					for ( j = 0; j < width; j++ ) {
						c = bitmapData.getPixel32(j, i);
						img.writeUnsignedInt( (c<<8) | (c>>>24) );
					}
				}
			}else {
				for ( i = 0; i < height; i++) {
					img.writeByte(0);
					for ( j = 0; j < width; j++) {
						img.writeUnsignedInt( (bitmapData.getPixel(j,i)<<8) | 0xff );
					}
				}
			}
			return createPNG( width, height, 0x08060000, img ); //RGBA( 8, 6, 0, 0 )
		}
		
		/** @private */
		private static function createPNG( width:int, height:int, colorInfo:uint, imgDat:ByteArray ):ByteArray
		{
			var _b:ByteArray = new ByteArray();
			
			//png signeture
			_b.writeUnsignedInt( 0x89504E47 );
			_b.writeUnsignedInt( 0x0D0A1A0A );
			
			//IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeUnsignedInt( 0x49484452 ); //IHDR
			IHDR.writeInt( width );
			IHDR.writeInt( height );
			IHDR.writeUnsignedInt(colorInfo);   // gray(1,0,0,0) 32bit RGBA( 8, 6, 0, 0 )
			IHDR.writeByte( 0 ); //no interrace
			
			_b.writeUnsignedInt( 13 ); 			//length
			_b.writeBytes( IHDR );				//DATA
			_b.writeUnsignedInt( crc( IHDR ) );	//CRC
			
			//IDAT
			var IDAT:ByteArray = new ByteArray();
			IDAT.writeUnsignedInt( 0x49444154 ); //IDAT
			imgDat.compress();
			IDAT.writeBytes( imgDat );
			
			_b.writeUnsignedInt( imgDat.length );  //length
			_b.writeBytes( IDAT );				//DATA
			_b.writeUnsignedInt( crc( IDAT ) );	//CRC
			
			//IEND
			var IEND:ByteArray = new ByteArray();
			IEND.writeUnsignedInt( 0x49454E44 ); //IEND
			
			_b.writeUnsignedInt( 0 );   	     //length
			_b.writeBytes( IEND );				 //DATA
			_b.writeUnsignedInt( crc( IEND ) );  //CRC
			
			return _b;
		}
		
		//-------------------------------------------------------------------------------------------------------------------  CRC
		
		private static var crc_table:Array; //[256]
		private static var crc_table_computed:Boolean = false;
		
		private static function make_crc_table():void
		{
			var c:uint;
			crc_table = [];
			for ( var n:uint = 0; n < 256; n++) {
				c = n;
				for ( var k:uint = 0; k < 8; k++) {
					if (c & 1)
						c = 0xedb88320 ^ (c >>> 1);
					else
						c = c >>> 1;
				}
				crc_table[n] = c;
			}
			crc_table_computed = true;
		}
		
		private static function crc( buf:ByteArray ):uint
		{
			var c:uint = 0xffffffff;
			if (!crc_table_computed)
				make_crc_table();
			
			buf.position = 0;
			var len:uint = buf.length;
			for ( var n:uint = 0; n < len; n++) {
				c = crc_table[(c ^ buf.readUnsignedByte()) & 0xff] ^ (c >>> 8);
			}
			return c ^ 0xffffffff;
		}
		
	}
	
}