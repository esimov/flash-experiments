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

package frocessing.core.utils 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.geom.ColorTransform;
	/**
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class TintImageCache 
	{
		private var d:Dictionary;
		private var ct:ColorTransform;
		
		/**
		 * 
		 */
		public function TintImageCache()
		{
			d  = new Dictionary(false);
			ct = new ColorTransform();
		}
		
		/**
		 * カラー調整した BitmapData を取得.
		 * 指定の TintColor に対応した BitmapData が存在しない場合、カラー調整したデータを生成.
		 */
		public function getTintImage( src:BitmapData, color32:uint ):BitmapData
		{
			if ( color32 != 0xffffffff )
			{
				var tint_img:BitmapData;
				if ( d[src] == null )
				{
					d[src] = [];
					d[src][color32] = tint_img = tint( src, color32 );
				}
				else
				{
					tint_img = d[src][color32];
					if ( tint_img == null )
						d[src][color32] = tint_img = tint( src, color32 );
				}
				return tint_img;
			}
			else
			{
				return src;
			}
		}
		
		private function tint( src:BitmapData, color32:uint ):BitmapData
		{
			var img:BitmapData = src.clone();
			ct.alphaMultiplier = ( color32>>>24 ) / 0xff;
			ct.redMultiplier   = ( color32>>16 & 0xff ) / 0xff;
			ct.greenMultiplier = ( color32>>8 & 0xff ) / 0xff;
			ct.blueMultiplier  = ( color32 & 0xff ) / 0xff;
			img.colorTransform( img.rect, ct );
			return img;
		}
		
		/**
		 * 保持しているカラー調整済み BitmapData を dispose.
		 * nullを指定した場合、全てのデータを dispose
		 */
		public function dispose( targetSrc:BitmapData=null ):void
		{
			var d2:Array;
			var tintImg:BitmapData;
			if ( targetSrc == null ){
				for ( var img:* in d ){
					d2 = d[img];
					for each ( tintImg in d2 ){
						tintImg.dispose();
						tintImg = null;
					}
					delete d[img];
				}
			}else{
				d2 = d[targetSrc];
				if ( d2 != null ){
					for each ( tintImg in d2 ){
						tintImg.dispose();
						tintImg = null;
					}
					delete d[targetSrc];
				}
			}
		}
	}
}