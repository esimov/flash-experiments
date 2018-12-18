package {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Triangle3D extends Sprite {
		private var pointA:Point3D;
		private var pointB:Point3D;
		private var pointC:Point3D;
		private var color:uint;
		
		public function Triangle3D(pointA:Point3D, pointB:Point3D, pointC:Point3D, color:uint):void {
			this.pointA = pointA;
			this.pointB = pointB;
			this.pointC = pointC;
			this.color = color;
		}
		
		public function drawPoint(g:Graphics):void{
			g.beginFill(color, .5);
			g.lineStyle(1,0x6633cc,0.7);
			g.moveTo(pointA.screenX, pointA.screenY);
			g.lineTo(pointB.screenX, pointB.screenY);
			g.lineTo(pointC.screenX, pointC.screenY);
			g.lineTo(pointA.screenX, pointA.screenY);
			g.endFill();
		}
	}
}