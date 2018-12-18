﻿package {	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import fl.motion.easing.Back;	import flash.geom.ColorTransform;	import flash.geom.Transform;		[SWF (backgroundColor = 0xffffff, width = 800, height = 600)]		public class Extruded3D extends Sprite	{		private var points:Array;		private var Triangle3Ds:Array;		private var fl:Number = 250;		private var vpX:Number = stage.stageWidth / 2;		private var vpY:Number = stage.stageHeight / 2;				public function Extruded3D()		{			init();		}				private function init():void		{			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						points = new Array();			points[0] =  new Point3D( -50, -250, 100);			points[1] =  new Point3D(  50, -250, 100);			points[2] =  new Point3D( 250,  250, 100);			points[3] =  new Point3D( 100,  250, 100);			points[4] =  new Point3D(  50,  100, 100);			points[5] =  new Point3D( -50,  100, 100);			points[6] =  new Point3D(-100,  250, 100);			points[7] =  new Point3D(-200,  250, 100);			points[8] =  new Point3D(   0, -150, 100);			points[9] =  new Point3D(  50,    0, 100);			points[10] = new Point3D( -50,    0, 100);						points[11] = new Point3D( -50, -250, -100);			points[12] = new Point3D(  50, -250, -100);			points[13] = new Point3D( 250,  250, -100);			points[14] = new Point3D( 100,  250, -100);			points[15] = new Point3D(  50,  100, -100);			points[16] = new Point3D( -50,  100, -100);			points[17] = new Point3D(-100,  250, -100);			points[18] = new Point3D(-200,  250, -100);			points[19] = new Point3D(   0, -150, -100);			points[20] = new Point3D(  50,    0, -100);			points[21] = new Point3D( -50,    0, -100);						for(var i:uint = 0; i < points.length; i++)			{				points[i].setVanishingPoint(vpX, vpY);				points[i].setCenter(0, 0, 100);			}						Triangle3Ds = new Array();			Triangle3Ds[0] =new Triangle3D(points[0],   points[1],  points[8],  0x6666cc);			Triangle3Ds[1] =new Triangle3D(points[1],   points[9],  points[8],  0x6666cc);			Triangle3Ds[2] =new Triangle3D(points[1],   points[2],  points[9],  0x6666cc);			Triangle3Ds[3] =new Triangle3D(points[2],   points[4],  points[9],  0x6666cc);			Triangle3Ds[4] =new Triangle3D(points[2],   points[3],  points[4],  0x6666cc);			Triangle3Ds[5] =new Triangle3D(points[4],   points[5],  points[9],  0x6666cc);			Triangle3Ds[6] =new Triangle3D(points[9],   points[5],  points[10], 0x6666cc);			Triangle3Ds[7] =new Triangle3D(points[5],   points[6],  points[7],  0x6666cc);			Triangle3Ds[8] =new Triangle3D(points[5],   points[7],  points[10], 0x6666cc);			Triangle3Ds[9] =new Triangle3D(points[0],   points[10], points[7],  0x6666cc);			Triangle3Ds[10] = new Triangle3D(points[0], points[8],  points[10], 0x6666cc);						Triangle3Ds[11] = new Triangle3D(points[11], points[19], points[12], 0xcc6666);			Triangle3Ds[12] = new Triangle3D(points[12], points[19], points[20], 0xcc6666);			Triangle3Ds[13] = new Triangle3D(points[12], points[20], points[13], 0xcc6666);			Triangle3Ds[14] = new Triangle3D(points[13], points[20], points[15], 0xcc6666);			Triangle3Ds[15] = new Triangle3D(points[13], points[15], points[14], 0xcc6666);			Triangle3Ds[16] = new Triangle3D(points[15], points[20], points[16], 0xcc6666);			Triangle3Ds[17] = new Triangle3D(points[20], points[21], points[16], 0xcc6666);			Triangle3Ds[18] = new Triangle3D(points[16], points[18], points[17], 0xcc6666);			Triangle3Ds[19] = new Triangle3D(points[16], points[21], points[18], 0xcc6666);			Triangle3Ds[20] = new Triangle3D(points[11], points[18], points[21], 0xcc6666);			Triangle3Ds[21] = new Triangle3D(points[11], points[21], points[19], 0xcc6666);						Triangle3Ds[22] = new Triangle3D(points[0],  points[11], points[1],  0xcccc66);			Triangle3Ds[23] = new Triangle3D(points[11], points[12], points[1],  0xcccc66);			Triangle3Ds[24] = new Triangle3D(points[1],  points[12], points[2],  0xcccc66);			Triangle3Ds[25] = new Triangle3D(points[12], points[13], points[2],  0xcccc66);			Triangle3Ds[26] = new Triangle3D(points[3],  points[2],  points[14], 0xcccc66);			Triangle3Ds[27] = new Triangle3D(points[2],  points[13], points[14], 0xcccc66);			Triangle3Ds[28] = new Triangle3D(points[4],  points[3],  points[15], 0xcccc66);			Triangle3Ds[29] = new Triangle3D(points[3],  points[14], points[15], 0xcccc66);			Triangle3Ds[30] = new Triangle3D(points[5],  points[4],  points[16], 0xcccc66);			Triangle3Ds[31] = new Triangle3D(points[4],  points[15], points[16], 0xcccc66);			Triangle3Ds[32] = new Triangle3D(points[6],  points[5],  points[17], 0xcccc66);			Triangle3Ds[33] = new Triangle3D(points[5],  points[16], points[17], 0xcccc66);			Triangle3Ds[34] = new Triangle3D(points[7],  points[6],  points[18], 0xcccc66);			Triangle3Ds[35] = new Triangle3D(points[6],  points[17], points[18], 0xcccc66);			Triangle3Ds[36] = new Triangle3D(points[0],  points[7],  points[11], 0xcccc66);			Triangle3Ds[37] = new Triangle3D(points[7],  points[18], points[11], 0xcccc66);						Triangle3Ds[38] = new Triangle3D(points[8],  points[9],  points[19], 0xcccc66);			Triangle3Ds[39] = new Triangle3D(points[9],  points[20], points[19], 0xcccc66);			Triangle3Ds[40] = new Triangle3D(points[9],  points[10], points[20], 0xcccc66);			Triangle3Ds[41] = new Triangle3D(points[10], points[21], points[20], 0xcccc66);			Triangle3Ds[42] = new Triangle3D(points[10], points[8],  points[21], 0xcccc66);			Triangle3Ds[43] = new Triangle3D(points[8],  points[19], points[21], 0xcccc66);						addEventListener(Event.ENTER_FRAME, onEnterFrame);		}				private function onEnterFrame(event:Event):void		{			var angleX:Number = (mouseY - vpY) * .001;			var angleY:Number = (mouseX - vpX) * .001;			for(var i:uint = 0; i < points.length; i++)			{				var point:Point3D = points[i];				point.rotateX(angleX);				point.rotateY(angleY);			}						graphics.clear();			for (i = 0; i< Triangle3Ds.length; i++) {				Triangle3Ds[i].drawPoint(graphics);			}		}	}}