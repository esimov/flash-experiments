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
package aether.textures.synthetic {
	
	import aether.textures.ITexture;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	
	/**
	 * The TileTexture creates a grid of tiles of a specified color. The width, height and gutter between tiles is all configurable,
	 * as is the color of the gutter (or grout) between tiles. In addition, a bevel is applied to the tiles to offer a slight 3D
	 * look.
	 * 
	 * <pre>
	 * // the following creates an offwhite tile with a 2 pixel white grout
	 * 
	 * var tiles:TileTexture = new TileTexture(
	 *   0xEEDDCC,
	 *   0xFFFFFF,
	 *   30,
	 *   2
	 * );
	 * 
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(tiles.draw());
	 * shape.graphics.drawRect(0, 0, 100, 100);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class TileTexture implements ITexture {
		
		private var _tileColor:uint;
		private var _groutColor:uint;
		private var _tileSize:Number;
		private var _gutter:Number;
		private var _tileCornerRadius:Number;
		private var _depth:Number;
		private var _knockout:Boolean;
		private var _bevelStrength:Number;

		/**
		 * Constructor.
		 * 
		 * @param tileSize The pixel width and height of a single tile.
		 * @param tileColor The color to use for each tile.
		 * @param gutter The pixel space between each tile.
		 * @param groutColor The color to use within the space between each tile.
		 * @param depth The 3D depth of a tile, used with the <code>BevelFilter</code>. 
		 * @param tileCornerRadius The radius of a tile corner, creating rounded corners.
		 * @param bevelStrength The strength of the <code>BevelFilter</code> applied.
		 * @param knockout True to knockout the colors of the texture and only use the bevel.
		 */
		public function TileTexture(
			tileSize:Number,
			tileColor:uint,
			gutter:Number,
			groutColor:uint,
			depth:Number=2,
			tileCornerRadius:Number=0,
			bevelStrength:Number=1,
			knockout:Boolean=false
		) {
			_tileColor = tileColor;
			_groutColor = groutColor;
			_tileSize = tileSize;
			_gutter = gutter;
			_tileCornerRadius = tileCornerRadius;
			_depth = depth;
			_knockout = knockout;
			_bevelStrength = bevelStrength;
		}
	
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var size:Number = _tileSize + _gutter;
			var bitmap:BitmapData = new BitmapData(size, size, true, 0x000000);
			var container:Sprite = new Sprite();
			container.graphics.beginFill(_groutColor, 1);
			container.graphics.drawRect(0, 0, size, size);
			container.graphics.drawRoundRect(_gutter, _gutter, _tileSize, _tileSize, _tileCornerRadius, _tileCornerRadius);
			container.graphics.endFill();
			var tile:Shape = new Shape();
			tile.graphics.beginFill(_tileColor, 1);
			tile.graphics.drawRoundRect(0, 0, _tileSize, _tileSize, _tileCornerRadius, _tileCornerRadius);
			tile.graphics.endFill();
			tile.filters = [new BevelFilter(_depth, 45, 0xFFFFFF, _bevelStrength, 0, _bevelStrength, 2, 2, 1, 1, BitmapFilterType.INNER, _knockout)];
			tile.x = _gutter;
			tile.y = _gutter;
			container.addChild(tile);
			bitmap.draw(container);
			return bitmap;
		}
	
	}
	
}