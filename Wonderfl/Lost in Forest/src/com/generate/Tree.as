package com.generate
{
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.IGraphicsFill;
	import flash.display.IGraphicsStroke;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	
	public class Tree extends Sprite
	{
		public const PHI:Number = Math.PI;
		public const HALF_PHI:Number = Math.PI / 2;
		private var x1:Number;
		private var y1:Number;
		private var theta:Number;
		private var theta0:Number;
		private var startingThickness:Number;
		private var segmentLength:Number;
		private var totalSegments:Number = 15;
		public var index:int = -1;
		private var maxSnowTheta:Number = 1.2566370614359172;
		
		private var drawing:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
		private var stroke:GraphicsStroke = new GraphicsStroke();
		private var treePath:GraphicsPath = new GraphicsPath();
		private var trees:Vector.<Tree>;
		private var coords:Vector.<Number>;
		private var thetas:Vector.<Number>;
		
		private var color:uint;
		private var canvas:Sprite;
		public var addSnow:Boolean = true;
		
		public var totalBranchLength:Number = 400;
		public var maxBranchThickness:Number = 10;
		public var minBranchThickness:Number = 4; 
		public var minSpawnDistance:Number = .3; //this controls how far the branch will grow before splitting
		public var branchSpawnOdds:Number = .8;   //the odds of a branch growing there
		public var branchSpawnOddsOfSecond:Number = 0; //odds of a second branch growing from the same node
		public var mindThetaSplit:Number = HALF_PHI;
		public var maxdThetaSplit:Number = HALF_PHI;
		public var maxdThetaWander:Number = 0;
		public var dBranchSize:Number = 0; //the new branch may change by 1.0+/- this amount

		public function Tree(index:int, theta:Number, totalLength:Number, startingThickness:Number):void
		{	
			this.index = index;
			this.startingThickness = startingThickness;
			this.theta = theta;
			this.color = color;
			this.coords = new Vector.<Number>(Infinity);
			thetas = new Vector.<Number>(totalSegments);
			thetas[0] = this.theta;
			trees = new Vector.<Tree>();
			segmentLength = totalLength / totalSegments;
			addChild(canvas = new Sprite());
			
			for (var i:int = 1; i < totalSegments; i++)
			{
				thetas[i] = thetas[i - 1] + random( -maxdThetaWander, maxdThetaWander);
			}
			
			for (i = 1; i < totalSegments; i++)
			{
				if (startingThickness * (1 - i / totalSegments) > minBranchThickness && 
					i / totalSegments > minSpawnDistance && random(0, 1) <= branchSpawnOdds)
				{
					var dThetaSign:Number = randomSign();
					trees.push(new Tree(i, thetas[i] + dThetaSign * random(mindThetaSplit, maxdThetaSplit), 
								totalLength * (1 - i / totalSegments) * random(1 - dBranchSize, 1 + dBranchSize), 
								startingThickness * (1 - i / totalSegments)));
					if (random(0, 1) <= branchSpawnOddsOfSecond)
						trees.push(new Tree(i, thetas[i] - dThetaSign * random(mindThetaSplit, maxdThetaSplit), 
											totalLength * (1 - i / totalSegments) * random(1 - dBranchSize, 1 + dBranchSize), 
											startingThickness * (1 - i / totalSegments)));
				}
			}	
		}
		
		private function getCoords(n:int):Vector.<Number>
		{
			var x2:Number;
			var y2:Number;
			
			x2 = x1;
			y2 = y1;
			for (var i:int = 0; i < n; i++)
			{
				x2 += segmentLength * Math.cos(thetas[i]);
				y2 += segmentLength * Math.sin(thetas[i]);
			}
			return new <Number>[x2, y2];
		}
		
		public function drawBranches(coords:Vector.<Number>):void
		{
			this.coords = coords;
			x1 = coords[0];
			y1 = coords[1];
			var start_x:Number = x1;
			var start_y:Number = y1;
			var end_x:Number; var end_y:Number;
			for (var i:int = 0; i < totalSegments; i++)
			{
				end_x = start_x + segmentLength * Math.cos(thetas[i]);
				end_y = start_y + segmentLength * Math.sin(thetas[i]);
				stroke.thickness = startingThickness * (1 - i / totalSegments);
				stroke.fill = new GraphicsSolidFill(0x663399);
				treePath.moveTo(start_x, start_y);
				treePath.lineTo(end_x, end_y);
				
				drawing.push(treePath, stroke, 0x000000);
				canvas.graphics.drawGraphicsData(drawing);
				
				if (addSnow)
				{
					stroke.fill = new GraphicsSolidFill(0xffffff);
					var dx:Number = 0;
					var dy:Number = 0;
					var overlapScaling:Number = 1.2;
					if (thetas[i] < -Math.PI / 2)
					{
						if (Math.abs(Math.PI + thetas[i]) < maxSnowTheta)
						{
							var minThickness:Number = Math.max(0, Math.abs(maxBranchThickness) / 2 * (1 - Math.abs(theta + PHI) / HALF_PHI));
							var maxThickness:Number = Math.min(minThickness, Math.abs(maxBranchThickness) / 2);
							var snowThickness:Number = random(minThickness, maxThickness);
							if (snowThickness > 0)
							{
								stroke.thickness = snowThickness;
								dx = Math.abs(maxBranchThickness) - snowThickness / 2 * Math.cos(theta + HALF_PHI) * overlapScaling;
								dy = Math.abs(maxBranchThickness) - snowThickness / 2 * Math.sin(theta + HALF_PHI) * overlapScaling;
								treePath.moveTo(start_x + dx - Math.abs(maxBranchThickness) * Math.cos(thetas[i]) / 4, 
												start_y + dy - Math.abs(maxBranchThickness) * Math.sin(thetas[i]) / 4);
								treePath.lineTo(end_x + dx, end_y + dy);
								drawing.push(treePath, stroke, null);
								canvas.graphics.drawGraphicsData(drawing);
							}
						}
					}
					
					if (thetas[i] > -Math.PI / 2)
					{
						if (Math.abs(thetas[i]) < maxSnowTheta)
						{
							minThickness = Math.max(0, Math.abs(maxBranchThickness) / 2 * (1 - Math.abs(theta + PHI) / HALF_PHI));
							maxThickness = Math.min(minThickness, Math.abs(maxBranchThickness) / 2);
							snowThickness = random(minThickness, maxThickness);
							if (snowThickness > 0)
							{
								stroke.thickness = snowThickness;
								dx = Math.abs(maxBranchThickness) - snowThickness / 2 * Math.cos(theta + HALF_PHI) * overlapScaling;
								dy = Math.abs(maxBranchThickness) - snowThickness / 2 * Math.sin(theta + HALF_PHI) * overlapScaling;
								treePath.moveTo(start_x + dx - Math.abs(maxBranchThickness) * Math.cos(thetas[i]) / 4, 
												start_y + dy - Math.abs(maxBranchThickness) * Math.sin(thetas[i]) / 4);
								treePath.lineTo(end_x + dx, end_y + dy);
								drawing.push(treePath, stroke, null);
								canvas.graphics.drawGraphicsData(drawing);
							}
						}
					}
				}
				
			}
			
			for (i = 0; i < trees.length-1; i++)
			{
				Tree(trees[i]).drawBranches(getCoords(Tree(trees[i]).index));
			}
		}
				
		public function random(min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			return Math.random() * (max - min) + min;
		}
		
		public function randomSign():Number
		{
			var num:Number = random( -1, 1);
			return num = (num == 0) ? -1 : int(num / Math.abs(num));
		}
	}
}