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
// SFMTRandom class is ported from part of SFMT below URL.
// http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index.html
// 
// Original SFMT is licensed as follows:
// 
// Copyright (c) 2006,2007 Mutsuo Saito, Makoto Matsumoto and Hiroshima
// University. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of the Hiroshima University nor the names of
//       its contributors may be used to endorse or promote products
//       derived from this software without specific prior written
//       permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


package frocessing.math 
{
	
	/**
	 * SIMD-oriented Fast Mersenne Twister (SFMT)
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	public class SFMTRandom 
	{
		private static const MEXP:uint    = 19937;
		private static const N:int        = int(MEXP / 128 + 1); //156
		private static const N32:int      = N * 4;
		private static const POS:int      = 122 * 4;
		private static const PARITY:Array = [0x00000001, 0x00000000, 0x00000000, 0xc98e126a];
		
		private var psfmt32:Array = []; //w128_t[N][4]   W128_T : {uint32_t u[4]}
		//private var psfmt32:Vector.<uint> = new Vector.<uint>(N32);
		
		private var idx:uint;
		
		/**
		 * 
		 * @param	seed
		 */
		public function SFMTRandom( seed:uint=0 ) 
		{
			//for (var i:int = 0; i < N32; i++) { psfmt32[i] = 0; }
			randomSeed(seed);
			gen_rand_all();
			idx = 0;
		}
		
		/**
		 * 
		 * @return [0,1)
		 */
		public function random():Number
		{
			if (idx >= N32) {
				gen_rand_all();
				idx = 0;
			}
			return uint(psfmt32[idx++])/4294967296.0;
		}
		
		/**
		 * 
		 * @param	seed
		 */
		public function randomSeed( seed:uint ):void
		{
			psfmt32[0] = seed;
			for (var i:int = 1; i < N32; i++) {
				psfmt32[i] = seed = 1812433253 * ( seed ^ (seed >>> 30)) + i;
			}
			idx = N32;
			period_certification();
		}
		
		/** @private */
		private function period_certification():void
		{
			var inner:Number = 0;
			var i:int, j:int, work:uint;
			
			for (i = 0; i < 4; i++)
				inner ^= uint(psfmt32[i]) & uint(PARITY[i]);
			
			for (i = 16; i > 0; i >>>= 1)
				inner ^= inner >>> i;
				
			inner &= 1;
			// check OK
			if (inner == 1) return;
			
			// check NG, and modification
			for (i = 0; i < 4; i++) {
				work = 1;
				for (j = 0; j < 32; j++) {
					if( (work & uint(PARITY[i])) != 0) {
						psfmt32[i] ^= work;
						return;
					}
					work = work << 1;
				}
			}
		}
		/** @private */
		private function gen_rand_all():void
		{
			var p:Array = psfmt32;
			//var p:Vector.<uint> = psfmt32;
			
			var i:int;
			var r1:int = N32 - 8;
			var r2:int = N32 - 4;
			var s:int = POS;
			var p0:uint, p1:uint, p2:uint, p3:uint;
			for (i = 0; i < N32; ) {
				p[i] = (p0 = p[i]) ^ (p0 << 8)	         ^ ((p[s++] >>> 11) & 0xdfffffef) ^ (p[r1++] >>> 8 | p[r1] << 24) ^ (p[r2++] << 18); i++;
				p[i] = (p1 = p[i]) ^ (p1 << 8 | p0>>>24) ^ ((p[s++] >>> 11) & 0xddfecb7f) ^ (p[r1++] >>> 8 | p[r1] << 24) ^ (p[r2++] << 18); i++;
				p[i] = (p2 = p[i]) ^ (p2 << 8 | p1>>>24) ^ ((p[s++] >>> 11) & 0xbffaffff) ^ (p[r1++] >>> 8 | p[r1] << 24) ^ (p[r2++] << 18); i++;
				p[i] = (p3 = p[i]) ^ (p3 << 8 | p2>>>24) ^ ((p[s++] >>> 11) & 0xbffffff6) ^ (p[r1] >>> 8) 			      ^ (p[r2] << 18);   i++;
				r1 = r2 - 3;
				r2 = i - 4;
				if ( s >= N32) { s = 0; }
			}
			/*
			var x0:uint, x1:uint, x2:uint, x3:uint, y0:uint, y1:uint, y2:uint, y3:uint;
			for (i = 0; i < N32; i += 4 ) {
				x0 = p[i] << 8;
				x1 = p[i+1] << 8 | p[i]>>>24;
				x2 = p[i+2] << 8 | p[i+1]>>>24;
				x3 = p[i+3] << 8 | p[i+2]>>>24;
				y0 = p[r1] >>> 8 | p[r1 + 1] << 24;
				y1 = p[r1+1] >>> 8 | p[r1 + 2] << 24;
				y2 = p[r1+2] >>> 8 | p[r1 + 3] << 24;
				y3 = p[r1+3] >>> 8;
				p[i+3] = p[i+3] ^ x3 ^ ((p[s+3] >>> 11) & 0xbffffff6) ^ y3 ^ (p[r2+3] << 18);
				p[i+2] = p[i+2] ^ x2 ^ ((p[s+2] >>> 11) & 0xbffaffff) ^ y2 ^ (p[r2+2] << 18);
				p[i+1] = p[i+1] ^ x1 ^ ((p[s+1] >>> 11) & 0xddfecb7f) ^ y1 ^ (p[r2+1] << 18);
				p[i]   = p[i]   ^ x0 ^ ((p[s]   >>> 11) & 0xdfffffef) ^ y0 ^ (p[r2]   << 18);
				r1 = r2;
				r2 = i;
				s += 4;
				if ( s >= N32) { s = 0; }
			}
			//*/
		}
	}
}