package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF (width = 800, height = 600)]
	
	public class Cilinder3D extends Sprite {
		private var points:Array;
		private var triangles:Array;
		private var numFaces:Number = 30;
		private var vpX:Number = stage.stageWidth/2;
		private var vpY:Number = stage.stageHeight/2;
		
		public function Cilinder3D():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init();
		}
		
		private function init():void {
			points = new Array();
			triangles = new Array();
			var index:uint = 0;
			for (var i:uint = 0; i<numFaces; i++) {
				var angle:Number = Math.PI * 2 / numFaces * i;
				var xpos:Number = Math.cos(angle) * 200;
				var ypos:Number = Math.sin(angle) * 200;
				points[index] = new Point3D(xpos, ypos, -100);
				points[index+1] = new Point3D(xpos, ypos, 100);
				index += 2;
			}
			
			for (i = 0; i< points.length; i++) {
				points[i].setVanishingPoint(vpX, vpY);
				points[i].setCenter(0, 0, 200);
			}
			
			index = 0;
			for (i = 0; i< numFaces-1; i++) {
				triangles[index] = new Triangle3D(points[index], points[index + 3], points[index + 1], 0x6666cc);
				triangles[index + 1] = new Triangle3D(points[index], points[index + 2], points[index + 3], 0x6666cc);
				index += 2;
			}
			
			triangles[index] = new Triangle3D(points[index], points[1], points[index+1],0x6666cc);
			triangles[index+1] = new Triangle3D(points[index], points[0], points[1],0x6666cc);
			
			stage.addEventListener(Event.ENTER_FRAME, onStartFrame);
		}
		
		private function onStartFrame(evt:Event):void {
			var angleY:Number = (mouseX - vpX) * 0.0003;
			var angleX:Number = (mouseY - vpY) * 0.0003;
			for (var i:uint = 0; i< points.length; i++) {
				var point:Point3D = points[i] as Point3D;
				point.rotateX(angleX);
				point.rotateY(angleY);
			}
			
			graphics.clear();
			for (i = 0; i<triangles.length; i++) {
				triangles[i].drawPoint(graphics);
			}
		}
	}
}