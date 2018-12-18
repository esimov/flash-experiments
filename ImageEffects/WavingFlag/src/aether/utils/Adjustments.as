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
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * A utilities class to handle image adjustment operations like those found in Photoshop's Image > Adjustments menu through static methods.
	 */
	public class Adjustments {
		
		/**
		 * Adjust the brightness levels of the pixels in an image based on a remapping of the original brightness values
		 * per channel to new levels as specified in the arguments. All pixels with brightness level less than or equals to 
		 * the specified <code>blackPoint</code> will be remapped to have a brightness level in each channel of 0.
		 * All pixels with a brightness level above the <code>whitePoint</code> will have a brightness level set to 255 in each channel.
		 * The pixels inbetween the <code>blackPoint</code> and <code>whitePoint</code> will be redistributed across the
		 * 255 values per channel with the <code>midPoint</code> determining how the values are distributed across that range.
		 * 
		 * @param bitmapData The image on which to alter the levels.
		 * @param blackPoint The value between 0 and 255 below which all pixels will be set to black.
		 * @param midPoint The point in the range between the <code>blackPoint</code> and the <code>whitePoint</code>
		 *                 that determines how the pixels of this intermediate brightness are distributed across the 
		 *                 remaining range.
		 * @param whitePoint The value between 0 and 255 above which all pixels will be set to white.
		 * 
		 * @see #setChannelLevels()
		 * @see #threshold()
		 * 
		 * @example
		 * <pre>
		 * // the following would increase the contrast of the image
		 * 
		 * Adjustments.setLevels(image, 50, 127, 205);
		 * </pre>
		 */
		static public function setLevels(
			bitmapData:BitmapData,
			blackPoint:uint,
			midPoint:uint,
			whitePoint:uint
		):void {
			var levels:Object={};
			levels.r=[];
			levels.g=[];
			levels.b=[];
			// set all pixels below blackPoint to 0
			for (var i:uint=0;i<=blackPoint;i++){
				levels.r.push(0);
				levels.g.push(0);
				levels.b.push(0);
			}
			var n:uint=0;
			var d:uint=midPoint-blackPoint;
			// set all pixels between blackPoint and midPoint to be between 0 and 127
			for (i=blackPoint+1;i<=midPoint;i++){
				n=(((i-blackPoint)/d)*127)|0;
				levels.r.push(n<<16);
				levels.g.push(n<<8);
				levels.b.push(n);
			}
			d=whitePoint-midPoint;
			// set all pixels between midPoint and whitePoint to be between and 128 and 255
			for (i=midPoint+1;i<=whitePoint;i++){
				n=((((i-midPoint)/d)*128)|0)+127;
				levels.r.push(n<<16);
				levels.g.push(n<<8);
				levels.b.push(n);
			}
			// set all pixels above whitePoint to be 255
			for (i=whitePoint+1;i<256;i++){
				levels.r.push(0xFF<<16);
				levels.g.push(0xFF<<8);
				levels.b.push(0xFF);
			}
			bitmapData.paletteMap(bitmapData, bitmapData.rect, new Point(), levels.r, levels.g, levels.b);
		}
	
		/**
		 * Adjust the brightness levels of the pixels in an image based on a remapping of the original brightness values
		 * per channel to new levels as specified in the arguments. All pixels with brightness level less than or equals to 
		 * the specified <code>blackPoint</code> will be remapped to have a brightness level of 0. All pixels with a brightness
		 * level above the <code>whitePoint</code> will have a brightness level set to 255. The pixels inbetween the
		 * <code>blackPoint</code> and <code>whitePoint</code> will be redistributed across the 255 values per channel with the
		 * <code>midPoint</code> determining how the values are distributed across that range.
		 * 
		 * The difference between this method and <code>setLevels()</code> is that this method allows you to set the levels
		 * separately for each individual channel. Each of the <code>red</code>, <code>green</code> and <code>blue</code>
		 * arguments should hold a vector of three integer values, specifiying the black, middle gray and white point for each channel.
		 * If you only wish to set the levels for one channel, the other two channels' vectors should contain values of 0, 127, 255.
		 * 
		 * @param bitmapData The image on which to alter the levels.
		 * @param red A vector of three integer values specifying the white, middle gray and black points, respectively, of the red channel.
		 * @param green A vector of three integer values specifying the white, middle gray and black points, respectively, of the green channel.
		 * @param blue A vector of three integer values specifying the white, middle gray and black points, respectively, of the blue channel.
		 * 
		 * @see #setChannelLevels()
		 * @see #adjustContrast()
		 * @see #adjustBrightness()
		 * 
		 * @example
		 * <pre>
		 * // the following would increase the contrast of just the green channel in the image
		 * 
		 * var red:Vector.&lt;int&gt;;
		 * red.push(0, 127, 255);
		 * 
		 * var green:Vector.&lt;int&gt;;
		 * green.push(50, 127, 205);
		 * 
		 * var blue:Vector.&lt;int&gt;;
		 * blue.push(0, 127, 255);
		 * 
		 * Adjustments.setChannelLevels(image, red, green, blue);
		 * </pre>
		 */
		static public function setChannelLevels(
			bitmapData:BitmapData,
			red:Vector.<int>,
			green:Vector.<int>,
			blue:Vector.<int>
		):void {
			var ls:Array=[];
			var cs:Array=[red,green,blue];
			var b:Number;
			var m:Number;
			var w:Number;
			var i:uint;
			var n:Number;
			var d:Number;
			var c:Array;
			var l:Array;
			var sh:Number;
			// run through all three channels;
			// basically, these loops are the same as in setLevels()
			for (var j:uint=0;j<3;j++){
				l=ls[j]=[];
				c=cs[j];
				sh=8*(2-j);
				b=c[0];
				for (i=0;i<=b;i++){
					ls[j].push(0);
				}
				n=0;
				m=c[1];
				d=m-b;
				for (i=b+1;i<=m;i++){
					n=(((i-b)/d)*127)|0;
					l.push(n<<(sh));
				}
				w=c[2];
				d=w-m;
				for (i=m;i<=w;i++){
					n=((((i-m)/d)*128)|0)+127;
					l.push(n<<(sh));
				}
				for (i=w+1;i<256;i++){
					l.push(0xFF<<(sh));
				}
			}
			bitmapData.paletteMap(bitmapData,bitmapData.rect, new Point(), ls[0], ls[1], ls[2]);
		}
	
		/**
		 * Inverts the brightness levels in an image using a <code>ColorTransform</code>.
		 * 
		 * @param bitmapData The image to invert.
		 * 
		 * @see #setLevels()
		 * 
		 * @example
		 * <pre>
		 * // the following inverts the brightness levels of the image
		 * 
		 * Adjustments.invert(image);
		 * </pre>
		 */
		static public function invert(bitmapData:BitmapData):void {
			bitmapData.colorTransform(bitmapData.rect, new ColorTransform(-1, -1, -1, 1, 255, 255, 255, 0));
		}
	
		/**
		 * Adjusts the brightness levels in an image using a call to the <code>setLevels()</code> method.
		 * Any amount less than 0 will result in a darkening of the image. Any amount greater than 0 will
		 * brighten an image. The amount should be in the range between -255 and 255.
		 * 
		 * @param bitmapData The image in which to adjust brightness.
		 * @param amount The amount to darken or lighten an image. Values less than 0 will darken an image
		 *               while values greater than 0 will brighten the image. Values should range from -255 to 255.
		 * 
		 * @see #setLevels()
		 * @see #adjustContrast()
		 * 
		 * @example
		 * <pre>
		 * // the following darkens an image by 100;
		 * // the result is the same as calling setLevels(100, 177, 255)
		 * 
		 * Adjustments.adjustBrightness(image, -100);
		 * </pre>
		 */
		static public function adjustBrightness(bitmapData:BitmapData, amount:Number):void {
			if (amount < 0) {
				var bottom:uint = -amount;
				setLevels(bitmapData, bottom, bottom + (255-bottom)/2, 255);
			} else {
				var top:uint = 255-amount;
				setLevels(bitmapData, 0, top/2, top);
			}
		}
		
		/**
		 * Adjusts the contrast of an image using a <code>ColorMatrixFilter</code>. The amount should fall between
		 * a range of -1 and 1 (though greater values could be used to blow out an image to white).
		 * A value above 0 will increase the image's contrast, while a value below 0 will reduce the contrast.
		 * 
		 * @param bitmapData The image in which to adjust contrast.
		 * @param amount The amount by which to adjust the contrast. Values below 0 towards -1 will reduce contrast
		 *               (a value of -1 will produce a solid medium gray image). Values above 0 will increase contrast.
		 * 
		 * @see #adjustBrightness()
		 * 
		 * @example
		 * <pre>
		 * // the following increases the contrast of brightness values in the image
		 * 
		 * Adjustments.adjustContrast(image, 0.3);
		 * </pre>
		 */
		static public function adjustContrast(bitmapData:BitmapData, amount:Number):void {
			amount += 1;
			var filter:ColorMatrixFilter = new ColorMatrixFilter([
				amount,      0,      0, 0, (128 * (1 - amount)), 
				     0, amount,      0, 0, (128 * (1 - amount)), 
				     0,      0, amount, 0, (128 * (1 - amount)), 
				     0,      0,      0, 1,                  1
			]);
			ImageUtil.applyFilter(bitmapData, filter);
		}
	
		/**
		 * Reduces an image to two colors, black and white, with the <code>level</code> argument determining the brightness
		 * level of a pixel in the original image below which a pixel will be recolored as black and above which a pixel
		 * will be colored as white.
		 * 
		 * To achieve this, this method first reduces the image to grayscale using the <code>desaturate()</code> method, then
		 * uses a call to <code>setLevels()</code> passing in the <code>level</code> value for the <code>blackPoint</code>,
		 * <code>midPoint</code> and <code>whitePoint</code>.
		 * 
		 * @param bitmapData The image to which to apply a threshold.
		 * @param level The brightness threshold value below which a pixel will be colored black and above which a pixel
		 *              will be colored white. This should be a value between 0 and 255.
		 * 
		 * @see #desaturate()
		 * @see #setLevels()
		 * 
		 * @example
		 * <pre>
		 * // the following reduces the image to black and white with the threshold level
		 * // set to be a 100 brightness level.
		 * 
		 * Adjustments.threshold(image, 100);
		 * </pre>
		 */
		static public function threshold(bitmapData:BitmapData, level:uint=128):void {
			desaturate(bitmapData);
			setLevels(bitmapData, level, level, level);
		}

		/**
		 * Reduces the number of colors in an image through quantization. The <code>levels</code> parameter
		 * determines how many colors in each channel will be allowed. The default value of 2 will reduce each color
		 * channel to black and white, resulting in an image with 8 possible colors (2x2x2, or 2 to the 3rd power).
		 * More levels results in more colors.
		 * 
		 * @param bitmapData The image to posterize by reducing colors.
		 * @param levels The number of colors to reduce each channel to.
		 * 
		 * @see #threshold()
		 * @see #setLevels()
		 * 
		 * @example
		 * <pre>
		 * // the following reduces an image to 27 colors (3x3x3)
		 * 
		 * Adjustments.posterize(image, 3);
		 * </pre>
		 */
		static public function posterize(bitmapData:BitmapData, levels:uint=2):void {
			// less than 2 would mean a pure black image
			levels = Math.max(2, levels);

			// draw each channel as a grayscale bitmap
			var red:BitmapData = ImageUtil.getChannelData(bitmapData, BitmapDataChannel.RED);
			var green:BitmapData = ImageUtil.getChannelData(bitmapData, BitmapDataChannel.GREEN);
			var blue:BitmapData = ImageUtil.getChannelData(bitmapData, BitmapDataChannel.BLUE);
			var sourceChannels:Vector.<BitmapData> = new Vector.<BitmapData>();
			sourceChannels.push(red, green, blue);

			// create bitmaps in which the reduced channels will be drawn			
			var redFiltered:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			var greenFiltered:BitmapData = redFiltered.clone();
			var blueFiltered:BitmapData = redFiltered.clone();
			var filteredChannels:Vector.<BitmapData> = new Vector.<BitmapData>();
			filteredChannels.push(redFiltered, greenFiltered, blueFiltered);

			var channelData:BitmapData;
			var threshold:uint;
			var colorTransform:ColorTransform;
			var brightnessAdjust:uint;
			var j:uint;
			// always run through one less than total levels since 1 iteration
			// produces 2 colors (levels) already
			levels--;
			for (var i:uint = 0; i < levels; i++) {
				// threshold will be higher on lower iterations of the loop, resulting in images with more black
				// for the lower iterations and images with more white for the higher iterations
				threshold = 255*((levels-i)/(levels+1));
				brightnessAdjust = 255*((levels-i-1)/levels);
				colorTransform = new ColorTransform(1, 1, 1, 1, brightnessAdjust, brightnessAdjust, brightnessAdjust);
				for (j = 0; j < 3; j++) {
					channelData = sourceChannels[j].clone();
					// set the levels on the data to reduce the colors to 2
					setLevels(channelData, threshold, threshold, threshold);
					// draw the thresholded image into the adjusted channel after brightening it,
					// using MULTIPLY to overlay the grays
					filteredChannels[j].draw(channelData, null, colorTransform, BlendMode.MULTIPLY);
				}
			}
			
			// copy reduced channels back in to original image
			ImageUtil.copyChannel(redFiltered, bitmapData, BitmapDataChannel.RED);
			ImageUtil.copyChannel(greenFiltered, bitmapData, BitmapDataChannel.GREEN);
			ImageUtil.copyChannel(blueFiltered, bitmapData, BitmapDataChannel.BLUE);
		}

		/**
		 * Decreases the color saturation in an image using a <code>ColorMatrixFilter</code>. The amount should be
		 * between 0 and 1, with 0 resulting in no desaturation and 1 resulting in full desaturation. This method
		 * merely invokes the <code>saturate()</code> method, passing a value of <code>1-percent</code> to <code>saturate()</code>.
		 * 
		 * @param bitmapData The image to desaturate.
		 * @param amount The amount by which to desaturate the image. A value of 1 will fully desaturate the image.
		 *               A value of 0 will not affect the color saturation. Values between 0 and 1 will desaturate
		 *               the image at varying degrees.
		 * 
		 * @see #saturate()
		 * 
		 * @example
		 * <pre>
		 * // the following completely desaturates the colors of an image
		 * 
		 * Adjustments.desaturate(image, 1);
		 * </pre>
		 */
		static public function desaturate(bitmapData:BitmapData, percent:Number=1):void {
			saturate(bitmapData, 1-percent);
		}
	
		/**
		 * Increases or decreases the color saturation in an image using a <code>ColorMatrixFilter</code>. The amount should be
		 * between -1 and a positive number. A value of -1 will completely desaturate the image while a value of 1
		 * will not affect the image at all. Values between -1 and 1 will result in varying levels of desaturation.
		 * A value above 1 will result is saturation of the image's colors. The higher the number, the more
		 * saturation that will be applied.
		 * 
		 * @param bitmapData The image in which to adjust color saturation.
		 * @param amount The amount by which to adjust the saturation. A value of -1 will fully desaturate the image.
		 *               A value of 1 will not affect the color saturation. Values between -1 and 1 will desaturate
		 *               the image at varying degrees. A value above 1 will saturate the image colors.
		 * 
		 * @see #desaturate()
		 * 
		 * @example
		 * <pre>
		 * // the following saturates the colors of an image
		 * 
		 * Adjustments.saturate(image, 3);
		 * </pre>
		 */
		static public function saturate(bitmapData:BitmapData, amount:Number):void {
			var r:Number = 0.3;
			var g:Number = 0.59;
			var b:Number = 0.11;
			var p:Number = 1-amount;
			var matrix:Array=[
				p*r+amount, p*g,        p*b,        0, 0,
				p*r,        p*g+amount, p*b,        0, 0,
				p*r,        p*g,        p*b+amount, 0, 0,
				0,          0,          0,          1, 0
			];
			ImageUtil.applyFilter(bitmapData, new ColorMatrixFilter(matrix));
		}

	}
	
}