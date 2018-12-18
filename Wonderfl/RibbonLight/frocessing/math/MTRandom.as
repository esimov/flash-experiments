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
// --------------------------------------------------------------------------
// MTRandom class is ported from part of Mersenne Twister below URL.
// http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
// 
// Original Mersenne Twister is licensed as follows:
//
//Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
//All rights reserved.                          
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions
//are met:
//
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//  3. The names of its contributors may not be used to endorse or promote 
//     products derived from this software without specific prior written 
//     permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
//CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package frocessing.math 
{
	
	/**
	* Mersenne Twister
	* 
	* @author nutsu
	* @version 0.6
	*/	
	public class MTRandom
	{
		private static const N:int = 624;
		private static const M:int = 397;
		private static const MATRIX_A:uint   = 0x9908b0df;
		private static const UPPER_MASK:uint = 0x80000000;
		private static const LOWER_MASK:uint = 0x7fffffff;
		
		private var mt:Array = new Array(N);
		private var mti:int = N+1;
		
		public function MTRandom()
		{
			;
		}
		
		//---------------------------------------------------------------------------------------------------INIT
		
		/**
		 * 
		 */
		public function randomSeed( seed:uint ):void
		{
			mti = 0;
			mt[0]= seed & 0xffffffff;
			for( mti=1; mti<N; mti++ ){
				mt[mti] = $multi(1812433253 , (mt[uint(mti-1)]^(mt[uint(mti-1)] >>> 30))) + mti;
				mt[mti] &= 0xffffffff;
			}
		}
		
		/**
		 * 
		 */
		public function randomSeedArray( init_key:Array ):void
		{
			var key_length:uint = init_key.length;
			var i:int;
			var j:int;
			var k:int;
			
			randomSeed(19650218);
			i=1; j=0;
			k = (N>key_length ? N : key_length);
			for (; k; k--)
			{
				mt[i] = (mt[i]^$multi((mt[i-1]^(mt[i-1] >>> 30)) , 1664525)) + init_key[j] + j;
				mt[i] &= 0xffffffff;
				i++; j++;
				if (i>=N) { mt[0] = mt[N-1]; i=1; }
				if (j>=key_length) j=0;
			}
			for (k = N - 1; k; k--)
			{
				mt[i] = (mt[i]^$multi((mt[i-1]^(mt[i-1] >>> 30)) , 1566083941 )) - i;
				mt[i] &= 0xffffffff;
				i++;
				if (i>=N) { mt[0] = mt[N-1]; i=1; }
			}
			mt[0] = 0x80000000;
		}
		
		
		//---------------------------------------------------------------------------------------------------GENERATE
		
		/**
		 * 
		 * @return [0,1)
		 */
		public function random():Number
		{
			var y:uint;
			if ( mti >= N )
			{
				var kk:int;
				if( mti==N+1 )
					randomSeed(5489);
				
				for (kk = 0; kk < N - M; kk++)
				{
					y = (mt[kk]&UPPER_MASK)|(mt[uint(kk+1)]&LOWER_MASK);
					mt[kk] = mt[uint(kk+M)] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				}
				for (; kk < N - 1; kk++)
				{
					y = (mt[kk]&UPPER_MASK)|(mt[uint(kk+1)]&LOWER_MASK);
					mt[kk] = mt[uint(kk+(M-N))] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				}
				y = (mt[uint(N-1)]&UPPER_MASK)|(mt[0]&LOWER_MASK);
				mt[uint(N-1)] = mt[uint(M-1)] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				mti = 0;
			}
			y = mt[mti];
			y ^= (y >>> 11);
			y ^= (y << 7) & 0x9d2c5680;
			y ^= (y << 15) & 0xefc60000;
			y ^= (y >>> 18);
			mti++;
			return y/4294967296.0;
		}
		
		
		/**
		 * generates a random number on [0,0xffffffff]-interval
		 */
		/*
		public function randomInt32():uint
		{
			var y:uint;
			if ( mti >= N )
			{
				var kk:int;
				if( mti==N+1 )
					randomSeed(5489);
				
				for (kk = 0; kk < N - M; kk++)
				{
					y = (mt[kk]&UPPER_MASK)|(mt[uint(kk+1)]&LOWER_MASK);
					mt[kk] = mt[uint(kk+M)] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				}
				for (; kk < N - 1; kk++)
				{
					y = (mt[kk]&UPPER_MASK)|(mt[uint(kk+1)]&LOWER_MASK);
					mt[kk] = mt[uint(kk+(M-N))] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				}
				y = (mt[uint(N-1)]&UPPER_MASK)|(mt[0]&LOWER_MASK);
				mt[uint(N-1)] = mt[uint(M-1)] ^ (y >>> 1) ^ (y & 0x1)*MATRIX_A;
				mti = 0;
			}
			y = mt[uint(mti++)];
			y ^= (y >>> 11);
			y ^= (y << 7) & 0x9d2c5680;
			y ^= (y << 15) & 0xefc60000;
			y ^= (y >>> 18);
			return y;
		}
		*/
		/**
		 * generates a random number on [0,0x7fffffff]-interval
		 */
		/*
		private function genrand_int31():uint
		{
			return randomInt32() >> 1;
		}
		*/
		/**
		 * generates a random number on [0,1]-real-interval
		 */
		/*
		public function genrand_real1():Number
		{
			return randomInt32()*1.0/4294967295.0;
		}
		*/
		/**
		 * generates a random number on [0,1)-real-interval
		 */
		/*
		public function genrand_real2():Number
		{
			return randomInt32()*1.0/4294967296.0;
		}
		*/
		/**
		 * generates a random number on (0,1)-real-interval
		 */
		/*
		public function genrand_real3():Number
		{
			return (randomInt32()+0.5)*1.0/4294967296.0;
		}
		*/
		
		/** @private */
		private function $multi(a:uint, b:uint):uint
		{
            var a_low:uint  = a & 0xffff;
            var a_high:uint = a >>> 16;
            var b_low:uint  = b & 0xffff;
            var b_high:uint = b >>> 16;
            return (((((a_low * b_low >>> 16) + a_low * b_high) & 0xffff) + a_high * b_low ) & 0xffff) << 16 | a_low * b_low & 0xffff;
        }
	}
	
}