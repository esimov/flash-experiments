package {
	import flash.display.*
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	
	[SWF(backgroundColor = 0x00, width = 800, height = 600)]
	
	public class RibbonLight extends Sprite
	{
		
		private const WIDTH:Number = stage.stageWidth;
		private const HEIGHT:Number = stage.stageHeight;
		
		private var _sketch:CurveSketch;
		private var _bmp:Bitmap;
		private var _bmd:BitmapData;
		private var _stage:Sprite;
	
		public function RibbonLight():void
		{
			if (stage) addEventListener(Event.ADDED_TO_STAGE, init);
			else removeEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			_stage = new Sprite();
			_sketch = new CurveSketch();
			addChild(_stage);
			_stage.addChild(_sketch);
			_bmd = new BitmapData(WIDTH, HEIGHT, true, 0x00);
			_stage.addChild(_bmp = new Bitmap(_bmd));
			_bmp.blendMode = "add";
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void
		{
			_bmd.draw(_sketch, null, null);
			_bmd.applyFilter(_bmd, _bmd.rect, new Point(), new BlurFilter(8, 8, BitmapFilterQuality.LOW));
		}
	}
}


//package {
    import frocessing.display.F5MovieClip2D;
    import frocessing.geom.FGradientMatrix;
    import frocessing.color.ColorHSV
    
    class CurveSketch extends F5MovieClip2D
    {
        
        private var xx:Number;
        private var yy:Number;
        
        private var vx:Number;
        private var vy:Number;
        
        private var ac:Number;
        
        private var de:Number;
        
        
        private var px0:Array;
        private var py0:Array;
        private var px1:Array;
        private var py1:Array;
        
        private var t:Number = 0
        
        
        private var shapes:Array;
        
        public function CurveSketch() 
        {
            
            vx = vy = 0.0;
            xx = mouseX;
            yy = mouseY;
            ac = 0.06;
            de = 0.9;
            px0 = [xx, xx, xx, xx];
            py0 = [yy, yy, yy, yy];
            px1 = [xx, xx, xx, xx];
            py1 = [yy, yy, yy, yy];
                        
            shapes = [];
            
            noStroke();            
        }
        
        public function draw():void
        {
            xx += vx += ( mouseX - xx ) * ac;
            yy += vy += ( mouseY - yy ) * ac;
            
            var len:Number = mag( vx, vy );
            
            var x0:Number = xx + 1 + len * 0.1;
            var y0:Number = yy - 1 - len * 0.1;
            var x1:Number = xx - 1 - len * 0.1;
            var y1:Number = yy + 1 + len * 0.1;
            
            px0.shift(); px0.push( x0 );
            py0.shift(); py0.push( y0 );
            px1.shift(); px1.push( x1 );
            py1.shift(); py1.push( y1 );
            
            var _px0:Array = [px0[0], px0[1], px0[2], px0[3]];
            var _py0:Array = [py0[0], py0[1], py0[2], py0[3]];
            var _px1:Array = [px1[0], px1[1], px1[2], px1[3]];
            var _py1:Array = [py1[0], py1[1], py1[2], py1[3]];
            
            shapes.push( { px0:_px0, py0:_py0, px1:_px1, py1:_py1, mtx:null} );
            if (shapes.length >= 50) shapes.shift();
            
            var shapesLength:int = shapes.length;
            for (var i:int = shapesLength-1; i >= 0; i--) 
            {
                var sh:Object = shapes[i];
                
                var color:ColorHSV = new ColorHSV(t, 0.8, 1, 0.1)
                t += 0.05;
                
                beginFill(int(color), 0.2)
                beginShape();
                curveVertex( sh.px0[0], sh.py0[0] );
                curveVertex( sh.px0[1], sh.py0[1] );
                curveVertex( sh.px0[2], sh.py0[2] );
                curveVertex( sh.px0[3], sh.py0[3] );
                vertex( sh.px1[2], sh.py1[2] );
                curveVertex( sh.px1[3], sh.py1[3] );
                curveVertex( sh.px1[2], sh.py1[2] );
                curveVertex( sh.px1[1], sh.py1[1] );
                curveVertex( sh.px1[0], sh.py1[0] );
                endShape();
            }
            
            vx *= de;
            vy *= de;
        }

    }
//}