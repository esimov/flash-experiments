package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.GradientType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import com.generate.Tree;
	
	[SWF (backgroundColor = 0x00, width='900', height='500', frameRate='60')]
	
	/**
	 * ...
	 * @author Simo Endre
	 */
	public class Main extends Sprite
	{
		private const STAGE_WIDTH:Number = stage.stageWidth;
		private const STAGE_HEIGHT:Number = stage.stageHeight;
		
		private var maxSnowTheta:Number = 1.2566370614359172;
		private var numTrees:Number = 4;
		private var branchWidth:Number = 10;
		private var totalBranchLength:Number = 10;
		private var nBranchDivisions:int = 30;
		private var percentBranchless:Number = .3;
		private var branchSizeFraction:Number = .5;
		private var dThetaGrowMax:Number = Math.PI/15;
		private var dThetaSplitMax:Number = Math.PI/6;
		private var oddsOfBranching:Number = .3;
		private var branches:Vector.<Tree> = new Vector.<Tree>(numTrees);
		
		public function Main():void 
		{
			if (stage) init();
			else {
				throw new Error("Stage not active");
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = "medium";
			stage.fullScreenSourceRect = new Rectangle(0, 0, 900, 500);
			
			createBackground();
			createTrees();
			drawTrees();
		}
		
		private function createBackground():void 
		{
			var background:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(STAGE_WIDTH, STAGE_HEIGHT);
			background.graphics.beginGradientFill(GradientType.RADIAL, [0xEFEFEF, 0xEFEFEF, 0xEAEAEA], [1, 1, 1], [0x00, 0x7F, 0xFF], matrix);
			background.graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			background.graphics.endFill();
			addChild(background);
		}
		
		private function createTrees():void
		{
			var i:int = 0;
			var color:uint = random(0, 30);
			
			for (i = 0; i < numTrees; i++) {
				branches.push(new Tree( -1, 3 * Math.PI / 2, totalBranchLength, 10));
			}
		}
		
		private function drawTrees():void
		{
			for (var i:int = 0; i < numTrees; i++)
			{
				branches[i].drawBranches(new <Number> [(1+i)*(STAGE_WIDTH/(1+numTrees)), STAGE_HEIGHT]);
			}
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