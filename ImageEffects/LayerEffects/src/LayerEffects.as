package {
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.filters.ConvolutionFilter;
	import flash.filters.ColorMatrixFilter;
	
	public class LayerEffects extends ImageLoader {
		public function LayerEffects():void {
			super ("assets/footprints.jpg");
		}
		
		override protected function afterImageLoad():void {
			var width:Number = stage.stageWidth/2;
			var height:Number = stage.stageHeight;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height);
			var shape:Shape = new Shape();
			var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [0, 1, 1, 0];
			var ratios:Array = [80, 150, 200, 235];
			shape.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			shape.graphics.drawCircle(width/2, height/2, 100);
			shape.graphics.endFill();
								
			addChild(_bitmap);
			_bitmap.x = 0;
			//addChild(shape);
			
			var mask:BitmapData = new BitmapData(width, height, true);
			var bmp:Bitmap = new Bitmap(mask);
			mask.draw(_bitmap);
			
			bmp.x = _bitmap.x;
			bmp.blendMode = BlendMode.ALPHA;
			stage.addChildAt(bmp, numChildren -1 );
			convolusionMatrix();
		}
		
		private function convolusionMatrix():void {
			var convFilter:ConvolutionFilter = new ConvolutionFilter();
			var colMatrix:Array = [1, 0, 0, 0, 0,
								0, 1, 0, 0, 0,
								1, 0, 0.23, 0, 0,
								0, 1, 1, 0, 0];
			var colFilter:ColorMatrixFilter = new ColorMatrixFilter(colMatrix);
			
			var randomX:Number = Math.random() * 3 - 1;
			var randomY:Number = Math.random() * 3 - 1;
			var matrix:Array = new Array();
			
			for (var i:uint = 0; i< 10; i++) {
				matrix.push(randomX);
				for (var j:uint = 0; j< 10; j++) {
					matrix.push(randomY);
				}
			}
			
			var divider:Number = 0;
			for each (var index:Number in matrix) {
				divider += index;
			}
			convFilter.matrixX = matrix.length;
			convFilter.matrixY = matrix.length;
			convFilter.matrix = matrix;
			convFilter.divisor = divider;
			convFilter.bias = 15;
			_bitmap.filters = [convFilter, colFilter];
			
			var filters:Array = _bitmap.filters;
			for each (var filter:ConvolutionFilter in filters) {
				filter = new ConvolutionFilter();
				filter.matrixX = matrix.length;
				filter.matrixY = matrix.length;
				filter.matrix = matrix;
				filter.divisor = divider;
				filter.bias = 15;
				_bitmap.filters = [filter, colFilter];
			}
		}
	}
}