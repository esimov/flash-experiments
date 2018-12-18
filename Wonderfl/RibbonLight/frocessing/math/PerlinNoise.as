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

package frocessing.math {
	
	/**
	* Perlin Noise を生成するメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.6
	*/
	public class PerlinNoise 
	{
		private static const PERLIN_YWRAPB :int = 4;
		private static const PERLIN_YWRAP  :int = 1<<PERLIN_YWRAPB;
		private static const PERLIN_ZWRAPB :int = 8;
		private static const PERLIN_ZWRAP  :int = 1<<PERLIN_ZWRAPB;
		private static const PERLIN_SIZE   :int = 4095;
		
		private var perlin_octaves :int = 4; // default to medium smooth
		private var perlin_amp_falloff:Number = 0.5; // 50% reduction/octave
		
		private var __perlin:Array;	//Number[]
		private var __random:SFMTRandom;
		
		//private static var __cosTabel:Array;
		//private static var __perlin_TWOPI:int = 360 * 2;
		//private static var __perlin_PI:int = 360;
		
		/**
		 * 
		 */
		public function PerlinNoise() 
		{
			;
		}
		
		/**
		 * Computes the Perlin noise function
		 */
		public function noise( x:Number, y:Number=0.0, z:Number=0.0 ):Number
		{
			if ( __perlin == null ){
				if ( __random == null )
					__random = new SFMTRandom();
				
				__perlin = new Array(PERLIN_SIZE + 1);
				for ( var p:int = 0; p < PERLIN_SIZE + 1; p++){
					__perlin[p] = __random.random();
				}
				/*
				if ( __cosTabel == null )
				{
					__cosTabel = [];
					var d2r:Number = 0.5 * Math.PI / 180;
					for ( var j:int = 0; j < __perlin_TWOPI; j++ )
						__cosTabel[j] = Math.cos( j * d2r );
				}
				*/
			}
			
			if (x < 0) x = -x;
			if (y < 0) y = -y;
			if (z < 0) z = -z;
			
			var xi:int = int(x);
			var yi:int = int(y);
			var zi:int = int(z);
			var xf:Number = x-xi;
			var yf:Number = y-yi;
			var zf:Number = z-zi;
			var rxf:Number;
			var ryf:Number;
			
			var r:Number = 0.0;
			var ampl:Number = 0.5;
			
			var n1:Number;
			var n2:Number;
			var n3:Number;
			
			for ( var i:int=0; i < perlin_octaves; i++ ) 
			{
				var of:int = xi + (yi << PERLIN_YWRAPB) + (zi << PERLIN_ZWRAPB);
				
				rxf = 0.5 * (1.0 - Math.cos( xf * Math.PI ));
				ryf = 0.5 * (1.0 - Math.cos( yf * Math.PI ));
				
				//*
				n1  = (1 - ryf) *( (1 - rxf) * __perlin[int(of & PERLIN_SIZE)] + rxf * __perlin[int((of + 1) & PERLIN_SIZE)] )+ 
					   ryf *( (1 - rxf) * __perlin[int((of + PERLIN_YWRAP) & PERLIN_SIZE)] + rxf * __perlin[int((of + PERLIN_YWRAP + 1) & PERLIN_SIZE)]);
				of += PERLIN_ZWRAP;
				n2  = (1 - ryf) * ((1 - rxf) * __perlin[int(of & PERLIN_SIZE)] + rxf * __perlin[int((of + 1) & PERLIN_SIZE)] ) + 
					  ryf * ((1 - rxf) * __perlin[int((of + PERLIN_YWRAP) & PERLIN_SIZE)] + rxf*__perlin[int((of + PERLIN_YWRAP + 1) & PERLIN_SIZE)]);
				n1 += 0.5 * (1.0 - Math.cos( zf * Math.PI )) * (n2 - n1);
				
				//*/
				/*
				n1  = __perlin[int(of & PERLIN_SIZE)];
				n1 += rxf * ( __perlin[int((of + 1) & PERLIN_SIZE)] - n1 );
				n2  = __perlin[int((of + PERLIN_YWRAP) & PERLIN_SIZE)];
				n2 += rxf * ( __perlin[int((of + PERLIN_YWRAP + 1) & PERLIN_SIZE)] - n2);
				n1 += ryf * ( n2 - n1 );
				of += PERLIN_ZWRAP;
				n2  = __perlin[int(of & PERLIN_SIZE)];
				n2 += rxf * (__perlin[int((of + 1) & PERLIN_SIZE)] - n2);
				n3  = __perlin[int((of + PERLIN_YWRAP) & PERLIN_SIZE)];
				n3 += rxf * (__perlin[int((of + PERLIN_YWRAP + 1) & PERLIN_SIZE)] - n3);
				n2 += ryf * (n3 - n2);
				n1 += 0.5 * (1.0 - Math.cos( zf * Math.PI ))*(n2-n1);
				//*/
				
				
				r += n1*ampl;
				ampl *= perlin_amp_falloff;
				xi<<=1; xf*=2;
				yi<<=1; yf*=2;
				zi<<=1; zf*=2;
				
				if (xf>=1.0 ) { xi++; xf--; }
				if (yf>=1.0 ) { yi++; yf--; }
				if (zf>=1.0 ) { zi++; zf--; }
			}
			return r;
			//return ( r < 1 ) ? r : 1;
		}
		
		/**
		 * set random seed.
		 * @param	seed
		 */
		public function noiseSeed( seed:uint ):void
		{
			if (__random == null)
				__random = new SFMTRandom( seed );
			else
				__random.randomSeed( seed );
			__perlin = null;
		}
  
		/**
		 * note that fallout value greater than 0.5 might result in greater than 1.0 values returned by noise().
		 * @param	lod
		 * @param	falloff
		 */
		public function noiseDetail( lod:uint, falloff:Number=0):void
		{
			if (lod > 0) 
				perlin_octaves = lod;
				
			if (falloff > 0 )
				perlin_amp_falloff = ( falloff > 1 ) ? 1 : falloff;
		}
	}
	
}