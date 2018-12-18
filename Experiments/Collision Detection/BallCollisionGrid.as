package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.getTimer;
	
	[SWF (backgroundColor = 0xffffff, width = 1090, height = 800)]
	
	public class BallCollisionGrid extends Sprite {
		private var _grids:Array;
		private var _balls:Array;
		private var numBalls:Number = 200;
		private static const RADIUS:Number = 20;
		private static const GRID_SIZE:Number = 40;
	
		public function BallCollisionGrid():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			createBalls();
			drawGrids();
			
			//Grid Check Collision
			var startTime:int = getTimer();
			var elapsedTime:int;
			
			for (var i:int = 0; i< 10; i++) {
				createGrids();
				assignBallsToGrid();
				checkBallsCollision();
			}
			
			elapsedTime = getTimer() - startTime;
			trace ("Time elapsed:" + elapsedTime);
			
			// Basic Check Collision
			startTime = getTimer();
			for (var j:int = 0; j< 10; j++) {
				basicCheck();
			}
			
			elapsedTime = getTimer() - startTime;
			trace ("Time elapsed:" + elapsedTime);
		}
		
		private function createBalls():void {
			_balls = new Array();
			for (var i:int = 0; i < numBalls; i++) {
				var ball:Ball = new Ball(RADIUS);
				ball.x = Math.random() * stage.stageWidth;
				ball.y = Math.random() * stage.stageHeight;
				ball.vx = Math.random() * 4 - 2;
				ball.vy = Math.random() * 4 - 2;
				addChild(ball);
				_balls.push(ball);
			}
		}
		
		private function createGrids():void {
			_grids = new Array();
			for (var i:int = 0; i< stage.stageWidth / GRID_SIZE; i++) {
				_grids[i] = new Array();
				for (var j:int = 0; j< stage.stageHeight / GRID_SIZE; j++) {
					_grids[i][j] = new Array();
				}
			}
		}
					
		private function drawGrids():void {
			//graphics.clear();
			graphics.lineStyle(0, 0.5);
			for (var i:int = 0; i<= stage.stageWidth; i+=GRID_SIZE) {
				graphics.moveTo(i, 0);
				graphics.lineTo(i, stage.stageHeight);
			}
			
			for (i = 0; i<= stage.stageHeight; i+= GRID_SIZE) {
				graphics.moveTo(0, i);
				graphics.lineTo(stage.stageWidth, i);
			}
		}
				
		private function assignBallsToGrid():void {
			for (var i:int = 0; i< numBalls; i++) {
				var ball:Ball = Ball(_balls[i]);
				var xpos:int = Math.floor(ball.x / GRID_SIZE);
				var ypos:int = Math.floor(ball.y / GRID_SIZE);
				_grids[xpos][ypos].push(ball);
			}
		}
		
		private function checkBallsCollision():void {
			for (var i:int = 0; i< _grids.length; i++) {
				for (var j:int = 0; j< _grids[i].length; j++) {
					checkOneCell(i, j);
					
					checkTwoCell(i, j, i+1, j);
					checkTwoCell(i, j, i, j+1);
					checkTwoCell(i, j, i-1, j);
					checkTwoCell(i, j, i+1, j+1);
				}
			}
		}
		
		private function checkOneCell(x1:Number, y1:Number):void {
			var _cell:Array = _grids[x1][y1] as Array;
			for (var i:int = 0; i< _cell.length-1; i++) {
				var ballA:Ball = _cell[i] as Ball;
				for (var j:int = i+1; j< _cell.length; j++) {
					var ballB:Ball = _cell[j] as Ball;
					checkCollision(ballA, ballB);
				}
			}
		}
		
		private function checkTwoCell(x1:Number, y1:Number, x2:Number, y2:Number):void {
			if (x2 < 0) { return } 
			if (x2 >= _grids.length) { return }
			if (y2 >= _grids[x2].length) { return }
			
			var _cell0:Array = _grids[x1][y1] as Array;
			var _cell1:Array = _grids[x2][y2] as Array;
			
			for (var i:int = 0; i< _cell0.length; i++) {
				var ballA:Ball = _cell0[i] as Ball;
				for (var j:int = 0; j< _cell1.length; j++) {
					var ballB:Ball = _cell1[j] as Ball;
					checkCollision(ballA, ballB);
				}
			}
		}
		
		private function checkCollision(ballA:Ball, ballB:Ball):void {
			var dx:Number = ballB.x - ballA.x;
			var dy:Number = ballB.y - ballA.y;
			var dist:Number = Math.sqrt(dx*dx + dy*dy);
			if (dist < ballB.radius + ballA.radius) {
				ballA.color = 0xff0000;
				ballB.color = 0xff0000;
			}
		}
		
		private function basicCheck():void {
			for (var i:int = 0; i< numBalls-1; i++) {
				var ballA:Ball = _balls[i] as Ball;
				for (var j:int = i+1; j< numBalls; j++) {
					var ballB:Ball = _balls[j] as Ball;
					checkCollision(ballA, ballB);
				}
			}
		}
	}
}