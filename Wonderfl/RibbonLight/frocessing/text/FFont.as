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
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	/**
	* ベクターで描画する為の Font クラスです.
	* 
	* @author nutsu
	* @version 0.2
	*/
	public class FFont implements IPathFont
	{
		
		public var charCount:int;
		
		public var commands:Array;
		public var paths:Array;
		
		//public var name:String;
		
		private var _size:int;	//original size
		public var height:int;
		
		public var value:Array; 	//int[] chracodes
		public var setWidth:Array;	//int[]
		public var cmdLen:Array;	//int[]
		public var pathLen:Array;	//int[]
		
		private var _ascent:Number;
		private var _descent:Number;
		
		private var ascii:Array;	//int[]
		
		private var char_i:uint  = String("i").charCodeAt(0);
		
		/**
		 * 
		 * @param	ba
		 */
		public function FFont( ba:IDataInput ) 
		{
			var i:int;
			
			charCount = ba.readInt();
			
			var version:int = ba.readInt();
			
			_size    = ba.readInt();
			height   = ba.readInt();
			
			_ascent  = ba.readFloat();
			_descent = ba.readFloat();
			
			// allocate enough space for the character info
			value       = new Array(charCount);	//int[]
			setWidth    = new Array(charCount);	//int[]
			cmdLen      = new Array(charCount);	//int[]
			pathLen     = new Array(charCount);	//int[]
			
			ascii = new Array( 128 );
			for ( i = 0; i < 128; i++)
				ascii[i] = -1;
			
			for ( i = 0; i < charCount; i++) 
			{
				value[i]    = ba.readInt();
				setWidth[i] = ba.readInt();
				cmdLen[i]   = ba.readInt();
				pathLen[i]  = ba.readInt();
				
				if (value[i] < 128)
					ascii[value[i]] = i;
				
				/*
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
				*/
			}
			
			//vector font data
			commands = [];
			paths    = [];
			for ( i = 0; i < charCount; i++) 
			{
				var cmd_count:int  = cmdLen[i];
				var path_count:int = pathLen[i];
				
				var cmd:Array      = [];
				var path:Array     = [];
				
				for ( var m:int = 0; m < cmd_count; m++ )
					cmd[m] = ba.readByte();
				
				for ( var n:int = 0; n < path_count; n++ )
					path[n] = ba.readFloat();
				
				commands[i] = cmd;
				paths[i]    = path;
			}
		}
		
		public function get size():int
		{
			return _size;
		}
		
		/**
		 * 
		 * @param	c
		 */
		public function index( c:uint ):int
		{
			if ( charCount == 0 )
				return -1;
				
			if (c < 128)
				return ascii[c];
			
			return indexHunt(c, 0, charCount-1 );
		}
		
		/**
		 * @private
		 */
		private function indexHunt( c:uint, start:int, stop:int) :int
		{
			var pivot:int = (start + stop) >> 1;
			
			if (c == value[pivot])
				return pivot;
			
			if (start >= stop)
				return -1;
			
			if (c < value[pivot])
				return indexHunt(c, start, pivot-1);
			
			return indexHunt(c, pivot+1, stop);
		}
		
		/**
		 * 
		 */
		public function get ascent():Number
		{
			return _ascent;
		}
		
		/**
		 * 
		 */
		public function get descent():Number
		{
			return _descent;
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
				return setWidth[cc] / _size;
		}
		
		/**
		 * not implemented
		 */
		public function kern( a:uint, b:uint ):Number
		{
			return 0;
		}
		
		/* INTERFACE frocessing.text.IPathFont */
		
		public function getCommands(glyph:int):Array{
			return commands[glyph];
		}
		public function getPathData(glyph:int):Array{
			return paths[glyph];
		}
		
	}
	
}