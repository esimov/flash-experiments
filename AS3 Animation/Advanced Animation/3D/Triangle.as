package {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Triangle extends Sprite {
		private var pointA:Point3D;
		private var pointB:Point3D;
		private var pointC:Point3D;
		private var color:uint;
		public var light:Light;
		
		public function Triangle (pointA:Point3D, pointB:Point3D, pointC:Point3D, color:uint):void {
			this.pointA = pointA;
			this.pointB = pointB;
			this.pointC = pointC;
			this.color = color;
		}
		
		public function drawPoint(g:Graphics):void{
			if (backFace()) {
				return;
			}
			g.lineStyle(2, 0xC91E19);
			g.beginFill(color);
			g.moveTo(pointA.screenX, pointA.screenY);
			g.lineTo(pointB.screenX, pointB.screenY);
			g.lineTo(pointC.screenX, pointC.screenY);
			g.lineTo(pointA.screenX, pointA.screenY);
			g.endFill();
		}
		
		private function backFace():Boolean {
			var cax:Number = pointC.screenX - pointA.screenX;
			var cay:Number = pointC.screenY - pointA.screenY;
			var bcx:Number = pointB.screenX - pointC.screenX;
			var bcy:Number = pointB.screenY - pointC.screenY;
			
			return cax * bcy > cay * bcx;
		}
		
		public function get depth():Number {
			var zPos:Number = Math.min(pointA.zpos, pointB.zpos);
			zPos = Math.min(zPos, pointC.zpos);
			return zPos;
		}
	}
}