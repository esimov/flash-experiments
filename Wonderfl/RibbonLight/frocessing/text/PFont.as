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

package frocessing.text 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	/**
	* Processing形式(vlw)用　の Font クラスです.
	* @author nutsu
	*/
	public class PFont implements IBitmapFont
	{  
		private var data_input:IDataInput;
		
		public var charCount:int;
		
		private var images:Array;
		private var imgdat:ByteArray;
		private var imginx:Array;
		
		// Name of the font as seen by Java when it was created.
		// If the font is available, the native version will be used.
		public var name:String;
		
		//Postscript name of the font that this bitmap was created from.
		public var psname:String;
		
		public var twidth:int;
		public var theight:int;
		
		public var fwidth:Number;
		public var fheight:Number;
		
		private var _size:int;	//original size
		public var mbox2:int;
		
		public var value:Array; 	//int[] chracodes
		public var height:Array;	//int[]
		public var width:Array;		//int[]
		public var setWidth:Array;	//int[]
		public var topExtent:Array;	//int[]
		public var leftExtent:Array;//int[]	
		
		private var _ascent:int;
		private var _descent:int;
		
		private var ascii:Array;	//int[]
		
		private var char_i:uint  = String("i").charCodeAt(0);
		private var temprect:Rectangle = new Rectangle(0,0,0,0);
		private var temppixels:ByteArray = new ByteArray();
		
		//draw segment number
		private var _imageDetail:uint = 1;
		
		/**
		 * 
		 * @param	dataInput	vlw形式 を 読み込む IDataInput
		 */
		public function PFont( dataInput:IDataInput ) 
		{
			if( dataInput != null )
				__init( dataInput );
			else
				__init_empty();
		}
		
		/**
		 * @private
		 */
		protected function __init( dataInput:IDataInput ):void
		{
			var i:int;
			
			data_input = dataInput;
			// number of character images stored in this font
			charCount = data_input.readInt();
			
			// version 8 is any font before 69, so 9 is anything from 83+
			// 9 was buggy so gonna increment to 10.
			var version:int = data_input.readInt();
			
			// this was formerly ignored, now it's the actual font size
			_size = data_input.readInt();
			
			// this was formerly mboxY, the one that was used
			// this will make new fonts downward compatible
			mbox2 = data_input.readInt();
			
			fwidth  = _size;
			fheight = _size;
			
			// size for image ("texture") is next power of 2
			// over the font size. for most vlw fonts, the size is 48
			// so the next power of 2 is 64.
			// double-check to make sure that mbox2 is a power of 2
			// there was a bug in the old font generator that broke this
			mbox2 = int( Math.pow(2, Math.ceil(Math.log(mbox2) / Math.log(2))) );
			// size for the texture is stored in the font
			twidth = theight = mbox2;
			
			_ascent  = data_input.readInt();  // formerly baseHt (zero/ignored)
			_descent = data_input.readInt();  // formerly ignored struct padding
			
			// allocate enough space for the character info
			value       = new Array(charCount);	//int[]
			height      = new Array(charCount);	//int[]
			width       = new Array(charCount);	//int[]
			setWidth    = new Array(charCount);	//int[]
			topExtent   = new Array(charCount);	//int[]
			leftExtent  = new Array(charCount);	//int[]
			
			ascii = new Array( 128 );
			for ( i = 0; i < 128; i++)
				ascii[i] = -1;
			
			// read the information about the individual characters
			for ( i = 0; i < charCount; i++) 
			{
				value[i]      = data_input.readInt();
				height[i]     = data_input.readInt();
				width[i]      = data_input.readInt();
				setWidth[i]   = data_input.readInt();
				topExtent[i]  = data_input.readInt();
				leftExtent[i] = data_input.readInt();
				
				// pointer in the c version, ignored
				data_input.readInt();
				
				// cache locations of the ascii charset
				if (value[i] < 128)
					ascii[value[i]] = i;
				
				// the values for getAscent() and getDescent() from FontMetrics
				// seem to be way too large.. perhaps they're the max?
				// as such, use a more traditional marker for ascent/descent
				if (value[i] == 'd')
				{
					if ( _ascent == 0)
						_ascent = topExtent[i];
				}
				if (value[i] == 'p')
				{
					if ( _descent == 0)
						_descent = -topExtent[i] + height[i];
				}
			}

			// not a roman font, so throw an error and ask to re-build.
			// that way can avoid a bunch of error checking hacks in here.
			if (( _ascent == 0) && ( _descent == 0)) {
				throw new Error("Please use \"Create Font\" to " + "re-create this font.");
			}
			
			//bitmap font data
			images = [];
			imgdat = new ByteArray();
			imginx = new Array(charCount);
			var dat_index:uint = 0;
			for ( i = 0; i < charCount; i++) 
			{
				imginx[i]  = dat_index;
				dat_index += width[i] * height[i];
			}
			data_input.readBytes( imgdat, 0, dat_index );
			
			if (version >= 10)
			{  // includes the font name at the end of the file
				name   = data_input.readUTF();
				psname = data_input.readUTF();
			}
			
			/*
			if (version == 11)
			{
				smooth = data_input.readBoolean();
			}
			*/
		}
		
		/**
		 * @private
		 */
		private function __init_empty():void
		{
			charCount = 0;
			_size = -1;
			_ascent = 1;
			_descent = 1;
			fwidth = 1;
			fheight = 1;
			images = [];
		}
		
		
		public function get size():int
		{
			return _size;
		}
		
		/**
		* Get index for the char (convert from unicode to bagel charset).
		* @return index into arrays or -1 if not found
		*/
		public function index( c:uint ):int
		{
			if ( charCount == 0 )
				return -1;
				
			// quicker lookup for the ascii fellers
			if (c < 128)
				return ascii[c];
			
			// some other unicode char, hunt it out
			return indexHunt(c, 0, charCount-1 );
		}
		
		/**
		 * @private
		 */
		private function indexHunt( c:uint, start:int, stop:int) :int
		{
			var pivot:int = (start + stop) >> 1;
			
			// if this is the char, then return it
			if (c == value[pivot])
				return pivot;
			
			// char doesn't exist, otherwise would have been the pivot
			if (start >= stop)
				return -1;
			
			// if it's in the lower half, continue searching that
			if (c < value[pivot])
				return indexHunt(c, start, pivot-1);
			
			// if it's in the upper half, continue there
			return indexHunt(c, pivot+1, stop);
		}
		
		/**
		 * ascent
		 */
		public function get ascent():Number 
		{
			return _ascent / fheight ;
		}
		
		/**
		 * descent
		 */
		public function get descent():Number
		{
			return _descent / fheight;
		}	
		
		/**
		 * width of char
		 * @param	c	charcode
		 */
		public function charWidth( c:uint ):Number
		{
			if (c == 32)
				return charWidth(char_i);
			
			var cc:int = index(c);
			if (cc == -1)
				return 0;
			else
				return setWidth[cc] / fwidth;
		}
		
		/**
		 * not implemented
		 */
		public function kern( a:uint, b:uint ):Number
		{
			return 0;
		}
		
		/**
		 * 文字の BitmapData を取得します.
		 * 
		 * <p>
		 * 使用した文字(BitmapData)は cache が保持されます．dispose する場合は、dipose() メソッドを実行します.
		 * </p>
		 * 
		 * @param	index
		 */
		public function getFontImage( image_index:uint ):BitmapData
		{
			if ( image_index < charCount )
			{
				var img:BitmapData = images[image_index];
				if ( img == null )
				{
					var w:Number    = width[image_index];
					var h:Number    = height[image_index];
					temprect.width  = w;
					temprect.height = h;
					img = new BitmapData( w, h, true, 0x00000000 );
					var len:int = w * h;
					temppixels.length = len * 4;
					temppixels.position = 0;
					imgdat.position = uint(imginx[image_index]);
					for ( var p:uint = 0 ; p < len ; p++ )
						temppixels.writeUnsignedInt( imgdat.readByte() << 24 | 0xffffff );
					temppixels.position = 0;
					img.setPixels( temprect, temppixels );
					images[image_index] = img;
					return img;
				}
				else
				{
					return 	img;
				}
			}
			else
			{
				return null;
			}
		}
		public function getOffsetX( glyph_index:uint ):Number {
			return leftExtent[glyph_index];
		}
		public function getOffsetY( glyph_index:uint ):Number {
			return topExtent[glyph_index];
		}
		public function getWidth( glyph_index:uint ):Number {
			return width[glyph_index];
		}
		public function getHeight( glyph_index:uint ):Number {
			return height[glyph_index];
		}
		public function get imageDetail():uint { return _imageDetail; }
		public function set imageDetail(value:uint):void 
		{
			_imageDetail = value;
		}
		
		/**
		 * 使用した font image ( BitmapData ) を dispose します.
		 */
		public function dispose():void
		{
			for each( var img:BitmapData in images )
			{
				img.dispose();
			}
			images = [];
		}
	}
	
}