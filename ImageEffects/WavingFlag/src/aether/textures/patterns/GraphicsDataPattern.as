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
package aether.textures.patterns {
	
	import aether.textures.ITexture;
	
	import flash.display.BitmapData;
	import flash.display.IGraphicsData;
	import flash.display.Shape;

	/**
	 * The GraphicsDataPattern provides a means to define a texure using <code>IGraphicsData</code> instances. This allows
	 * for the creation of complex vectors with solid, gradient, shader or bitmap fills that can then be used within larger
	 * composite textures and effects.
	 * 
	 * <pre>
	 * // the following creates a pattern of a vertical linear gradient from black to white
	 * // that is tiled over 50 vertical pixels
	 * 
	 * // define the drawing commands
	 * var pathCommands:Vector.&lt;int&gt; = new Vector.&lt;int&gt;();
	 * pathCommands.push(GraphicsPathCommand.LINE_TO);
	 * pathCommands.push(GraphicsPathCommand.LINE_TO);
	 * pathCommands.push(GraphicsPathCommand.LINE_TO);
	 * pathCommands.push(GraphicsPathCommand.LINE_TO);
	 * 
	 * // specify the data used with the commands
	 * var path:Vector.&lt;Number&gt; = new Vector.&lt;Number&gt;();
	 * path.push(50, 0);
	 * path.push(50, 50);
	 * path.push(0, 50);
	 * path.push(0, 0);
	 * 
	 * // matrix transformation for the gradient
	 * var matrix:Matrix = new Matrix();
	 * matrix.createGradientBox(50, 50, Math.PI/2);
	 * 	
	 * // define the drawing of the gradient fill with the drawing of the rectangle
	 * var data:Vector.&lt;IGraphicsData&gt; = new Vector.&lt;IGraphicsData&gt;();
	 * data.push(new GraphicsGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [1, 1], [0, 255], matrix));
	 * data.push(new GraphicsPath(pathCommands, path));
	 * data.push(new GraphicsEndFill());
	 * 	
	 * // draw with the defined pattern
	 * var pattern:BitmapData = new GraphicsDataPattern(data).draw();
	 * var shape:Shape = new Shape();
	 * shape.graphics.beginBitmapFill(pattern);
	 * shape.graphics.drawRect(0, 0, 550, 400);
	 * shape.graphics.endFill();
	 * addChild(shape);
	 * </pre>
	 */
	public class GraphicsDataPattern implements ITexture {
		
		private var _data:Vector.<IGraphicsData>;
	
		/**
		 * Constructor.
		 * 
		 * @param data A vector of <code>IGraphicsData</code> instances defining the pattern to draw.
		 */
		public function GraphicsDataPattern(data:Vector.<IGraphicsData>) {
			_data = data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw():BitmapData {
			var shape:Shape = new Shape();
			shape.graphics.drawGraphicsData(_data);
			var bitmap:BitmapData = new BitmapData(shape.width, shape.height, true, 0x00000000);
			bitmap.draw(shape);
			return bitmap;
		}
	
	}
	
}