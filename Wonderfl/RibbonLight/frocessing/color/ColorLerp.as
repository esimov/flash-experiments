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

package frocessing.color {
	
	import frocessing.math.FMath;
	
	/**
	* 2つの色の 中間色 を取得するメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.5
	*/
	public class ColorLerp
	{
		private static var _rgb_mode:Boolean = true;
		
		/**
		 * "rgb", "hsv"
		 */
		public static function get mode():String { return (_rgb_mode) ? "rgb" : "hsv"; }
		public static function set mode( value:String ):void
		{
			_rgb_mode = (value == "rgb");
		}
		
		
		/**
		 * uint color を Lerp します．
		 * 
		 * @param	c1	from color
		 * @param	c2	to color
		 * @param	amt	[0.0,1.0]
		 */
		public static function lerp( c1:uint, c2:uint, amt:Number ):uint
		{
			var a1:uint = c1 >>> 24;
			var a2:uint = c2 >>> 24;
			
			if ( _rgb_mode )
			{
				if ( a1 > 0 || a2 > 0 )
					return uint(FMath.lerp( a1, a2, amt )) << 24 | lerpRGB( c1 >> 16 & 0xff, c1 >> 8 & 0xff, c1 & 0xff, c2 >> 16 & 0xff, c2 >> 8 & 0xff, c2 & 0xff, amt ); 
				else
					return lerpRGB( c1 >> 16 & 0xff, c1 >> 8 & 0xff, c1 & 0xff, c2 >> 16 & 0xff, c2 >> 8 & 0xff, c2 & 0xff, amt ); 
			}
			else
			{
				var e1:Object = FColor.RGBtoHSV( c1 >> 16 & 0xff, c1 >> 8 & 0xff, c1 & 0xff );
				var e2:Object = FColor.RGBtoHSV( c2 >> 16 & 0xff, c2 >> 8 & 0xff, c2 & 0xff );
				if ( a1 > 0 || a2 > 0 )
					return uint(FMath.lerp( a1, a2, amt )) << 24 | lerpHSV( e1.h, e1.s, e1.v, e2.h, e2.s, e2.v, amt );
				else
					return lerpHSV( e1.h, e1.s, e1.v, e2.h, e2.s, e2.v, amt );	
			}
		}
		
		/**
		 * 2つの色のグラデーションの値を Array で取得します. 
		 * 
		 * @example 次のコードは、<code>0xCC6600</code> から <code>0xCC6600</code> の10段階のグラデーション値を取得し描画します.
		 * <listing>
		 * var g:Array = ColorLerp.gradient( 0xCC6600, 0x006699, 10 );
		 * for( var i:int=0; i&lt;g.length; i++ ){
		 * 	graphics.beginFill( g[i] );
		 * 	graphics.drawRect( i~~20, 0, 20, 20 );
		 * 	graphics.endFill();
		 * }</listing>
		 * 
		 * @param	c1	from color
		 * @param	c2	to color
		 * @param	step	グラデーションのステップ数
		 */
		public static function gradient( c1:uint, c2:uint, step:uint ):Array
		{
			var a1:uint = c1 >>> 24;
			var a2:uint = c2 >>> 24;
			
			var grad:Array = [];
			var amt:Number = 1.0 / step;
			grad[0] = c1;
			
			var i:int;
			if ( _rgb_mode )
			{
				var r1:uint = c1 >> 16 & 0xff;
				var g1:uint = c1 >> 8 & 0xff;
				var b1:uint = c1 & 0xff;
				var r2:uint = c2 >> 16 & 0xff;
				var g2:uint = c2 >> 8 & 0xff;
				var b2:uint = c2 & 0xff;
				if ( a1 > 0 || a2 > 0 )
				{
					for ( i = 1; i <= step; i++ )
						grad[i] = uint(FMath.lerp( a1, a2, i * amt )) << 24 | lerpRGB( r1, g1, b1, r2, g2, b2, i * amt );
				}
				else
				{
					for ( i = 1; i <= step; i++ )
						grad[i] = lerpRGB( r1, g1, b1, r2, g2, b2, i * amt );
				}
			}
			else
			{
				var e1:Object = FColor.RGBtoHSV( c1 >> 16 & 0xff, c1 >> 8 & 0xff, c1 & 0xff );
				var e2:Object = FColor.RGBtoHSV( c2 >> 16 & 0xff, c2 >> 8 & 0xff, c2 & 0xff );
				var h1:uint = e1.h;
				var s1:uint = e1.s;
				var v1:uint = e1.v;
				var h2:uint = e2.h;
				var s2:uint = e2.s;
				var v2:uint = e2.v;
				if ( a1 > 0 || a2 > 0 )
				{
					for ( i = 1; i <= step; i++ )
						grad[i] = uint(FMath.lerp( a1, a2, i * amt )) << 24 | lerpHSV( h1, s1, v1, h2, s2, v2, i * amt );
				}
				else
				{
					for ( i = 1; i <= step; i++ )
						grad[i] = lerpHSV( h1, s1, v1, h2, s2, v2, i * amt );
				}
			}
			grad[step] = c2;
			
			return grad;
		}
		
		/**
		 * 
		 */
		public static function lerpRGB( r1:uint, g1:uint, b1:uint, r2:uint, g2:uint, b2:uint, amt:Number ):uint
		{
			return uint(FMath.lerp( r1, r2, amt )) << 16 | uint(FMath.lerp( g1, g2, amt )) << 8 | uint(FMath.lerp( b1, b2, amt ));
		}
		
		/**
		 * 
		 */
		public static function lerpHSV( h1:Number, s1:Number, v1:Number, h2:Number, s2:Number, v2:Number, amt:Number ):uint
		{
			return FColor.HSVtoValue( FMath.lerp( h1, h2, amt ), FMath.lerp( s1, s2, amt ), FMath.lerp( v1, v2, amt ) );
		}
	}
	
}