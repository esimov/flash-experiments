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
// Copyright (C) 2008-09  TAKANAWA Tomoaki (http://nutsu.com) and
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
	
	/**
	 * Date Utility.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class FDate 
	{
		private static function get now():Date {
			return new Date();
		}
		
		/**
		 * 年 (2000 などの 4 桁の数字) をローカル時間で返します.
		 * @see Date#getFullYear
		 */
		public static function year():Number {
			return now.getFullYear();
		}
		
		/**
		 * 月 (1 月は 1、2 月は 2 など) をローカル時間で返します.
		 * @see Date#getMonth
		 */
		public static function month():Number {
			return now.getMonth()+1;
		}
		
		/**
		 * 日付 (1 ～ 31) をローカル時間で返します.
		 * @see Date#getDate
		 */
		public static function day():Number	{
			return now.getDate();
		}
		
		/**
		 * 曜日 (日曜日は 0、月曜日は 1 など) をローカル時間で返します.
		 * @see Date#getDay
		 */
		public static function weekday():Number {
			return now.getDay();
		}
		
		/**
		 * 時 (0 ～ 23) をローカル時間で返します.
		 * @see Date#getHours
		 */
		public static function hour():Number {
			return now.getHours();
		}
		
		/**
		 * 分 (0 ～ 59) をローカル時間で返します.
		 * @see Date#getMinutes
		 */
		public static function minute():Number {
			return now.getMinutes();
		}
		
		/**
		 * 秒 (0 ～ 59) をローカル時間で返します.
		 * @see Date#getSeconds
		 */
		public static function second():Number {
			return now.getSeconds();
		}
		
		/**
		 * ミリ秒 (0 ～ 999) をローカル時間で返します.
		 * @see Date#getMilliseconds
		 */
		public static function millis():Number {
			return now.getMilliseconds();
		}
	}
}