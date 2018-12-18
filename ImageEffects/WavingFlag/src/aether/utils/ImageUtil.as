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
	import flash.display.BitmapDataChannel;
	import flash.filters.BitmapFilter;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * The ImageUtil class provides static utility methods for iamge manipulation. The class also provides shortcuts
	 * to commonly used <code>BitmapData</code> methods that often require known parameters.
	 */
	public class ImageUtil {

		/**
		 * Returns a pixel capture of the display object. This calls the <code>ScreenCapture.drawFromObject</code> method.
		 * 
		 * @param displayObject The object from qhich to capture the pixel data.
		 * 
		 * @return Bitmap data into which the display object is drawn.
		 * 
		 * @see ScreenCapture#drawFromObject()
		 * 
		 * @example
		 * <pre>
		 * // the following captures the pixel data of the sprite
		 * 
		 * var capture:BitmapData = ImageUtil.getBitmapData(sprite);
		 * </pre>
		 */
		static public function getBitmapData(displayObject:DisplayObject):BitmapData {
			return ScreenCapture.drawFromObject(displayObject);
		}

		/**
		 * Returns new bitmap data with all three channels containing the same pixel values based on a single
		 * channel from the data passed to the method. This allows you to easily see a grayscale representation
		 * of a single channel within a new bitmap, and also allow you to use methods that work on all three color
		 * channels to effectively only be applied to a single channel.
		 * 
		 * @param bitmapData The original image from which to capture a single channel's data.
		 * @param channel The channel to draw into all the color channels of new bitmap data. This should be
		 *                a constant of <code>BitmapDataChannel</code>.
		 * 
		 * @return The new bitmap data with all three color channels drawn from a single channel in the original image.
		 * 
		 * @example
		 * <pre>
		 * // the following copies the red channel from the original image into new bitmap data
		 * // which will display the red channel data as a grayscale image
		 * 
		 * var redData:BitmapData = getChannelData(image, BitmapDataChannel.RED);
		 * </pre>
		 */
		static public function getChannelData(bitmapData:BitmapData, channel:uint):BitmapData {
			var clone:BitmapData = new BitmapData(bitmapData.width, bitmapData.height);
			clone.copyChannel(bitmapData, bitmapData.rect, new Point(), channel, BitmapDataChannel.RED);
			clone.copyChannel(bitmapData, bitmapData.rect, new Point(), channel, BitmapDataChannel.GREEN);
			clone.copyChannel(bitmapData, bitmapData.rect, new Point(), channel, BitmapDataChannel.BLUE);
			return clone;
		}
		
		/**
		 * Copies a channel from a source image into a destination image. This simplifies the call to
		 * <code>BitmapData.copyChannel()</code> by assuming that the whole of the image rectangle is copied,
		 * it is to be copied to the same position in the destination image and that the channel being copied
		 * is to be copied into the same color channel in the destination.
		 * 
		 * @param source The source of the channel to be copied.
		 * @param destination The destination image for the copied channel.
		 * @param channel The channel to be copied. This should be a constant of <code>BitmapDataChannel</code>.
		 * 
		 * @example
		 * <pre>
		 * // the following copies the alpha channel from image0 to image1
		 * 
		 * ImageUtil.copyChannel(image0, image1, BitmapDataChannel.ALPHA);
		 * </pre>
		 */
		static public function copyChannel(source:BitmapData, destination:BitmapData, channel:uint):void {
			destination.copyChannel(source, source.rect, new Point(), channel, channel);
		}

		/**
		 * Copies the pixels from a source image into a destination image. This simplifies the call to
		 * <code>BitmapData.copyPixels()</code> by assuming that the whole of the image rectangle is copied and
		 * the it is to be copied to the same position in the destination image.
		 * 
		 * @param source The source image to be copied.
		 * @param destination The destination image for the copied data.
		 * 
		 * @example
		 * <pre>
		 * // the following copies all pixels from image0 to image1
		 * 
		 * ImageUtil.copyPixels(image0, image1);
		 * </pre>
		 */
		static public function copyPixels(source:BitmapData, destination:BitmapData):void {
			destination.copyPixels(source, source.rect, new Point());
		}

		/**
		 * Applies a bitmap filter to the data. This simplifies the call to <code>BitmapData.applyFilter()</code>
		 * by assuming that the whole of the image rectangle is to be filtered.
		 * 
		 * @param bitmapData The data to which to apply the filter.
		 * @param filter The bitmap filter to apply to the image.
		 * 
		 * @example
		 * <pre>
		 * // the following applies a blur filter to an image
		 * 
		 * ImageUtil.applyFilter(bitmapData, new BlurFilter());
		 * </pre>
		 */
		static public function applyFilter(bitmapData:BitmapData, filter:BitmapFilter):void {
			bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), filter);
		}

	}

}