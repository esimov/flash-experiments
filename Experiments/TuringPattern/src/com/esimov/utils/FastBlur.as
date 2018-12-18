package  
com.esimov.utils{

	/**
	 * @author simoe
	 */
	public class FastBlur 
	{
		public function blur(source:Vector.<int>, dest:Vector.<int>, buffer:Vector.<int>, w:Number, h:Number, radius:Number):void
		{
			var y:int;
			var x:int;
			for (y = 0; y<h; y++)
			{
				for (x = 0; x<w; x++)
				{
					var i:int = y*w+x;
					if(y == 0 && x == 0)
					{
						buffer[i] = source[i];
					} else if (y == 0)
					{
						buffer[i] = buffer[i-1] + source[i];
					} else if (x == 0)
					{
						buffer[i] = buffer[i-w] + source[i];
					} else
					{
						buffer[i] = buffer[i-1] + buffer[i-w] - buffer[i-w - 1] + source[i];
					}
				}
			}
			
			for (y = 0; y < h; y++)
			{
				for (x = 0; x<w; x++)
				{
					var minx:int = Math.max(0, x - radius);
					var maxx:int = Math.min(x + radius, w - 1);
					var miny:int = Math.max(0, y - radius);
					var maxy:int = Math.min(y + radius, h - 1);
					var area: int = (maxx - minx) * (maxy - miny);
					
					var nw:int = miny * w + minx;
					var ne:int = miny * w + maxx;
					var sw:int = maxy * w + minx;
					var se:int = maxy * w + maxx;
					
					var n:int = y * w + x;
					dest[n] = (buffer[se] - buffer[sw] - buffer[ne] + buffer[nw]) / area; 
				}
			}
		}
	}
}
