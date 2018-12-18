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

package frocessing.utils {
	
	/**
	* Utility
	* 
	* @author nutsu
	* @version 0.5.9
	*/
	public class FUtil
	{
		
		//---------------------------------------------------------------------------------------------------
		// String Functions
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * @return String[]
		 */
		public static function splitTokens( str:String, tokens:String=" "):Array
		{
			var pattern:RegExp = new RegExp( "[" + tokens + "]+" );
			return trim(str).split(pattern);
		}
		
		/**
		 * 
		 */
		public static function trim( str:String ):String
		{
			return str.replace(/^\s+|\s+$/g, '');
		}
		
		//--------------------------------------------------------------------------------------------------- FORMAT
		
		/**
		 * Utility function for formatting numbers into strings
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 */
		public static function nf( value:Number, left:uint, right:uint=0 ):String
		{
			var pre:String = "";
			if ( value < 0 )
			{
				value *= -1;
				pre = "-";
			}
			var s:String = value.toFixed(right);
			var len:int  = ( right > 0 ) ? s.length - right - 1 : s.length;
			if ( left < len )
				return pre + s.substring( len - left );
			else if ( left > len )
				return pre + __zero( left-len ) + s;
			else
				return pre + s;
		}
		
		/**
		 * formatting numbers.
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 */
		public static function nfs( value:Number, left:uint, right:uint = 0 ):String
		{
			if ( value >= 0 )
				return " " + nf( value, left, right );
			else
				return nf( value, left, right );
		}
		
		/**
		 * formatting numbers.
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 */
		public static function nfp( value:Number, left:uint, right:uint = 0 ):String
		{
			if ( value >= 0 )
				return "+" + nf( value, left, right );
			else
				return nf( value, left, right );
		}
		
		/**
		 * formatting numbers.
		 * 
		 * @param	value
		 * @param	right	right digits
		 */
		public static function nfc( value:Number, right:uint = 0 ):String
		{
			var pre:String = "";
			if ( value < 0 )
			{
				value *= -1;
				pre = "-";
			}
			var s:String = value.toFixed(right);
			var i:int = s.indexOf(".");
			if ( i <0 )
				i = s.length;
			for( var k:int=i-3 ; k>0 ; k-=3 )
				s = insert( s , k , "," );
			return pre + s;
		}
		
		//---------------------------------------------------------------------------------------------------
		// Conversion
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * int を 2進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 */
		public static function binary( value:int, digits:int=0 ):String
		{
			return uint2str( value, digits, 2 );
		}
		
		/**
		 * 2進数の文字列を uint に変換します.
		 */
		public static function unbinary( binstr:String ):uint
		{
			return parseInt( binstr, 2 );
		}
		
		/**
		 * int を 16進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 */
		public static function hex( value:int, digits:int=0 ):String
		{
			return uint2str( value, digits, 16 );
		}
		
		/**
		 * 16進数の文字列を uint に変換します.
		 */
		public static function unhex( hexstr:String ):uint
		{
			return parseInt( hexstr, 16 );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @param	radix	数値からストリングへの変換に使用する基数 (2 ～ 36) .
		 */
		private static function uint2str( value:uint, digits:int=0, radix:int=10 ):String
		{
			var s:String = value.toString(radix);
			if ( digits > 0 )
			{
				var len:int = s.length;
				if ( digits < len )
					return s.substr( len - digits, digits );
				else if ( digits > len )
					return __zero( digits-len ) + s;
				else
					return s;
			}
			else
			{
				return s;
			}
		}
		
		private static function __zero( n:int ):String
		{
			return Math.pow( 2, n ).toString(2).substring(1);
		}
		
		public static function insert( str:String , i:int , a:String ):String
		{
			return str.substring(0,i) + a + str.substring(i);
		}
		
	}
	
}