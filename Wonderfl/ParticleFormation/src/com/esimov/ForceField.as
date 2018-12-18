package com.esimov
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	public class ForceField extends BitmapData
	{
		private static const WIND:Number = 0.9;
		private static const GRAVITY:Number = 0.3;
		private static const NUM_PART:Number = 4000;
		
		private var _field:BitmapData;
		private var _dimm:ColorMatrixFilter;
		private var _firstParticle:Particle;
		
		public function ForceField(field:BitmapData):void
		{
			super(field.width, field.height, true, 0x00);
			
			this._field = field;
			var prevParticle:Particle;
			for (var i:int = 0; i < NUM_PART; i++)
			{
				var p:Particle = new Particle(Math.random() * 600, Math.random() * 600);
				var a:Number = Math.random() * Math.PI ;
				p.vx = Math.cos(a) * 0.5;
				p.vy = Math.sin(a) * 0.5;
				p.next = prevParticle;
				prevParticle = p;
			}
			_firstParticle = p;
			
			_dimm = new ColorMatrixFilter([1, 0, 0, 0, -8,
										  0, 1, 0, 0, -4,
										  0, 0, 1, 0, 0,
										  0, 0, 0, 0.98, 0]);
		}
		
		public function update()
		{
			var n:Number = 3;
			lock();
			while (--n)
			{
				applyFilter(this, rect, new Point(), _dimm);
				var p:Particle = _firstParticle;
				while (p)
				{
					var ch_1:Number = _field.getPixel(p.x, p.y) & 0xff;
					var ch_2:Number = _field.getPixel(p.x + 1, p.y) & 0xff;
					var ch_3:Number = _field.getPixel(p.x, p.y + 1) & 0xff;
					p.vx += (ch_2 - ch_1) / 0x80 * GRAVITY;
					if ((p.vx > 0 ? p.vx : - p.vx) > 0.5)
					p.vx *= WIND;
					p.x += p.vx;
					
					if (p.x >= 600)
					{
						p.x = 600 - (p.x - 600);
						p.vx *= -1;
					} else if (p.x <= 0)
					{
						p.x = -p.x;
						p.vx *= -1;
					}
					
					p.vy += (ch_3 - ch_1) / 0x80 * GRAVITY;
					if ((p.vy > 0 ? p.vy : - p.vy) > 0.5)
					p.vy *= WIND;
					p.y += p.vy;
					
					if (p.y >= 600)
					{
						p.y = 600 - (p.y - 600);
						p.vy *= -1;
					} else if (p.y <= 0)
					{
						p.y = -p.y;
						p.vy *= -1;
					}
					
					setPixel32(p.x, p.y, 0xffffffff);
					p = p.next;
				}
			}
			unlock();
		}
	}
}