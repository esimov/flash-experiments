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

package frocessing.core.graphics 
{
	/**
	 * 線のスタイルを定義します.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class FStroke
	{
		/**
		 * 線の太さを示します.有効な値は 0～255 です.
		 */
		public var thickness:Number; //NaN
		
		/**
		 * 線の色を示します.
		 */
		public var color:uint; //0
		
		/**
		 * 線の透明度を示します.有効な値は 0～1 です.
		 */
		public var alpha:Number; //1
		
		/**
		 * 線をヒンティングするかどうかを示します.
		 */
		public var pixelHinting:Boolean; //false
		
		/**
		 * 使用する拡大 / 縮小モードを指定する LineScaleMode クラスの値を示します.
		 * @see flash.display.LineScaleMode
		 */
		public var scaleMode:String; //"normal"
		
		/**
		 * 線の終端のキャップの種類を指定する CapsStyle クラスの値を示します.
		 * @see flash.display.CapsStyle
		 */
		public var caps:String; //null
		
		/**
		 * 角で使用する接合点の外観の種類を指定する JointStyle クラスの値を示します.
		 * @see flash.display.JointStyle
		 */
		public var joints:String; //null
		
		/**
		 * マイターが切り取られる限度を示す数値を示します.
		 */
		public var miterLimit:Number; //3
		
		public function FStroke( thickness:Number=0, color:uint=0, alpha:Number=1, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null, miterLimit:Number=3 ) {
			this.thickness		= thickness;
			this.color			= color;
			this.alpha    		= alpha;
			this.pixelHinting	= pixelHinting;
			this.scaleMode		= scaleMode;
			this.caps			= caps;
			this.joints			= joints;
			this.miterLimit		= miterLimit;
		}
	}
}