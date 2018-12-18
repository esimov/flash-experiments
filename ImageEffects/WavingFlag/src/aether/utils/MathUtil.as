/**

Copyright (c) 2009 Todd M. Yard

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/
package aether.utils {

	/**
	* Class performs common Math utility functions.
	*/
	public class MathUtil {
	
		/**
		 * Converts a number from degrees to radians.
		 *
		 * @param num Number to convert.
		 *
		 * @return Original degrees value in radians.
		 */
		static public function degreesToRadians(num:Number):Number {
			return num*Math.PI/180;
		}
	
		/**
		 * Converts a number from radians to degrees.
		 *
		 * @param num Number to convert.
		 *
		 * @return Original radians value in degrees.
		 */
		static public function radiansToDegrees(num:Number):Number {
			return num*180/Math.PI;
		}

		/**
		 * Ensures specified number stays in range of <code>min</code> and <code>max</code> values.
		 * 
		 * @param num The number to clamp within a range.
		 * @param min The minimum number in the range.
		 * @param max The maximium number in the range.
		 * 
		 * @return The number clamped within the range.
		 */
		static public function clamp(num:Number, min:Number, max:Number):Number {
			return Math.max(min, Math.min(num, max));
		}

	}
	
}