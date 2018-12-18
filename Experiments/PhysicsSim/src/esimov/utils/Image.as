package esimov.utils
{
	import com.bit101.components.NumericStepper;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.geom.Matrix;
	import flash.events.Event;
	import mx.utils.Base64Decoder;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	public class Image extends Sprite
	{
		private var bmd:BitmapData;
		private var bmp:Bitmap;
		private var matrix:Matrix;
		private var scaleFactor:Number;
		private var radius:Number;
		
		public function Image(radius:Number = 0, scaleFactor:Number = 0):void
		{
			this.radius = radius;
			this.scaleFactor = scaleFactor;
			var decoder:Base64Decoder = new Base64Decoder;
			decoder.decode("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");
			
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBMDComplete);
			loader.loadBytes(decoder.toByteArray());
		}
		
		private function loadBMDComplete(event:Event):void
		{
			if (bmd != null)
			{
				bmd.dispose();
				bmd = null;
			}
			
			bmd = event.target.content.bitmapData.clone();
			radius = .7 * Math.sqrt(Math.pow(bmd.width, 2) + Math.pow(bmd.height, 2));
			
			matrix = new Matrix();
			var randomNum:Number = random(10, 30);
			var bmpData:BitmapData = new BitmapData(randomNum + radius, randomNum + radius, true, 0x00);
			
			if (radius > bmpData.width)
			{
				matrix.scale(bmpData.width / radius, bmpData.height / radius);
				scaleFactor = bmpData.width / radius;
			}
			else
			{
				matrix.scale(radius / bmpData.width, radius / bmpData.height);
				scaleFactor = radius / bmpData.width;
			}
			
			bmpData.draw(bmd, matrix, null, null, null, true);
			bmp = new Bitmap(bmpData);
			addChild(bmp);
		}
		
		public function get circleRadius():Number
		{
			return radius;
		}
		
		public function get factor():Number
		{
			return scaleFactor;
		}
		
		private function random(min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			
			return Math.random() * (max - min) + min;
		}
	}
}