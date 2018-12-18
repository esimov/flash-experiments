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

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The ScreenCapture class provides a simple means to transform display objects or regions of display objects
	 * into bitmap data.
	 */
	public class ScreenCapture {
	
		/**
		 * Captures the specified display object as bitmap data. If the <code>area</code> is not specified, the whole
		 * object is capture.
		 * 
		 * @param displayObject The display object to capture as bitmap data.
		 * @param transparent Whether the bitmap data returned should contain transparency if present in the original object.
		 *                    If this is false, the transparent pixels in the original object will be rendered as white.
		 * @param area The rectangular area of the display object to capture. If this is null, the whole object will be captured.
		 * 
		 * @return The bitmap data containing the specified region of the display object.
		 * 
		 * @example
		 * <pre>
		 * // the following captures the top left corner of the stage
		 * 
		 * var region:Rectangle = new Rectangle(0, 0, 100, 100);
		 * var capture:BitmapData = ScreenCapture.capture(stage, false, region);
		 * </pre>
		 */
		static public function capture(
			displayObject:DisplayObject,
			transparent:Boolean=true,
			area:Rectangle=null
		):BitmapData {
			if (area == null) {
				area = new Rectangle(0, 0, displayObject.width, displayObject.height);
			}
			var color:uint = transparent ? 0x00FFFFFF : 0xFFFFFFFF;
			var image:BitmapData = new BitmapData(area.width, area.height, true, color);
			var matrix:Matrix = new Matrix();
			matrix.translate(-area.x, -area.y);
			image.draw(displayObject, matrix);
			return image;
		}
	
		/**
		 * Performs a <code>BitmapData.draw()</code> command, drawing the specified display object into new bitmap data.
		 * This simply handles the creation of the bitmap data and the call to <code>draw()</code>.
		 * 
		 * @param displayObject The display object to capture as bitmap data.
		 * 
		 * @return The bitmap data containing the pixel data of the display object.
		 * 
		 * @example
		 * <pre>
		 * // the following draws a sprite into new bitmap data
		 * 
		 * var capture:BitmapData = ScreenCapture.drawFromObject(sprite);
		 * </pre>
		 */
		static public function drawFromObject(displayObject:DisplayObject):BitmapData {
			var bitmapData:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000);
			bitmapData.draw(displayObject);
			return bitmapData;
		}
	
	}
	
}