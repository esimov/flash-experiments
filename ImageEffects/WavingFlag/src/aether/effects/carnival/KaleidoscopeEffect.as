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
package aether.effects.carnival {
	
	import aether.effects.ImageEffect;
	import aether.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.Shape;
	
	/**
	 * The KaleidoscopeEffect class creates a visual using a slice of the original image mirrored and rotated about
	 * a central point. The effect can be configured to have a different number of segments and to display a different
	 * slice of the image.
	 * 
	 * <pre>
	 * // the following creates a kaleidoscope visual with the image
	 * // and draws it into a round shape
	 * 
	 * new KaleidoscopeEffect(10).apply(image);
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(image);
	 * shape.graphics.drawCircle(image.width/2, image.height/2, Math.min(image.height/2, image.width/2));
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class KaleidoscopeEffect extends ImageEffect {
	
		private var _startAngle:Number;
		private var _segments:uint;

		/**
		 * Constructor.
		 * 
		 * @param segments The total number of segments in the kaleidoscope.
		 * @param startAngle The starting angle from the center of the image from which the kaleidoscope segments will
		 *                   be drawn.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function KaleidoscopeEffect(
			segments:uint=8,
			startAngle:Number=0,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_segments = segments;
			if (_segments % 2 > 0) _segments++;
			_startAngle = MathUtil.degreesToRadians(startAngle);
		}
		
		/**
		 * Draws a single segment in the kaleidoscope, returning it in a rotated Bitmap instance.
		 * 
		 * @param index The index of the segment within the full kaleidoscope.
		 * @param segment The bitmap data to draw in the segment.
		 * @param center The center position of the kaleidoscope.
		 * @param angle The angle at which the segment should be rotated.
		 */
		private function drawSegment(index:uint, segment:BitmapData, center:Point, angle:Number):Bitmap {
			var bitmap:Bitmap = new Bitmap(segment);
			if (index % 2 > 0) {
				bitmap.scaleY = -1;
				bitmap.rotation = (index+1)*angle;
			} else {
				bitmap.rotation = index*angle;
			}
			bitmap.x = center.x;
			bitmap.y = center.y;
			return bitmap;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			var w:Number = bitmapData.width;
			var h:Number = bitmapData.height;
			var r:Number = Math.min(w,h)/2;
			var segmentAngle:Number = 360/_segments;
			var theta:Number = MathUtil.degreesToRadians(segmentAngle);
			var angle:Number = Math.PI-theta;
			var x:Number = Math.cos(theta)*r;
			var y:Number = Math.sin(theta)*r;
			var matrix:Matrix = new Matrix();
			matrix.translate(-w/2, -h/2);
			matrix.rotate(-_startAngle);
			var image:BitmapData = new BitmapData(w, h, true, 0x00000000);
			image.draw(bitmapData, matrix);
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(image, null, false);
			shape.graphics.lineTo(r, 0);
			shape.graphics.lineTo(x, y);
			shape.graphics.lineTo(0, 0);
			shape.graphics.endFill();
			var segment:BitmapData = new BitmapData(shape.width, shape.height, true, 0x00000000);
			segment.draw(shape);
			var sprite:Sprite = new Sprite();
			var center:Point = new Point(w/2, h/2);
			for (var i:uint; i < _segments; i++) {
				sprite.addChild(drawSegment(i, segment, center, segmentAngle));
			}
			bitmapData.fillRect(bitmapData.rect, 0x00000000);
			bitmapData.draw(sprite);
		}
	
	}
	
}