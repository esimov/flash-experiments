package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.filters.DisplacementMapFilter;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	[SWF (backgroundColor = 0x202020, width = 800, height = 600, frameRate = 60)]
	
	public class FisheyeLens extends AbstractImageLoader {
		private static const LENS_DIAMETER:Number = 250;
		private var _friction:Number = 0.2;
		private var _bitmapData:BitmapData;
		private var _lens:BitmapData;
		private var _lensBitmap:Bitmap;
		
		public function FisheyeLens():void {
			// call the Abstract image loader class by it's super CLASS
			super("assets/image.jpg");
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageAdded(evt:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		* Override the postImage() protected function in the Abstract Image loader class
		*/
		
		override protected function postImage():void {
			_bitmapData = _loadedBitmap.bitmapData.clone();
			_lens = createLens(LENS_DIAMETER);
			// bitmap used to visualize the lens distorsion, but not necessary for the effect
			_lensBitmap = new Bitmap(_lens);
			_lensBitmap.x = stage.stageWidth/2;
			_lensBitmap.y = stage.stageHeight/2;
			addChild(_loadedBitmap);
			addChild(_lensBitmap);
			
			// made invisible initially but can be made visible by mouse Click
			_lensBitmap.visible = false;
			
			// mouse click hendlers for different actions
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		* @param diameter Diameter of lens
		* @param amount The amount of distorsion applied on lens
		*/
		
		private function createLens(diameter:Number, amount:Number = .9):BitmapData {
			// lens BitmapData filled with medium grey
			var lens:BitmapData = new BitmapData(diameter, diameter, false, 0xFF808080);
			// get the center of the lens
			var center:Number = diameter /2;
			for (var i:uint = 0; i< diameter; i++) {
				// get the coordinate on x axis on relation to the center of the lens
				var xc:Number = i - center;
				for (var j:uint = 0; j< diameter; j++) {
					// get the coordinate on y axis on relation to the center of the lens
					var yc:Number = j - center;
					// calculate the distance on the x and y axis in relation to the center of the lens
					var dist:Number = Math.sqrt(xc*xc + yc*yc);
					if (dist < center) {
						var pow:Number = Math.pow(Math.sin(Math.PI/2 * dist/center), amount);
						var dx:Number = xc *(pow - 1) / diameter;
						var dy:Number = yc *(pow - 1) / diameter;
						var green:uint = 0x80 + dx * 0xff;
						var blue:uint = 0x80 + dy * 0xff;
						lens.setPixel(i, j, green << 8 | blue);
					}
				}
			}
			return lens;
		}
			
		private function onMouseMove(evt:MouseEvent):void {
			Mouse.hide();
			var vx:Number = ((stage.mouseX - LENS_DIAMETER/2) - _lensBitmap.x) * _friction;
			var vy:Number = ((stage.mouseY - LENS_DIAMETER/2) - _lensBitmap.y) * _friction;
			_lensBitmap.x += vx ;
			_lensBitmap.y += vy ;
			var displacement:DisplacementMapFilter = new DisplacementMapFilter(_lens, 
																			   new Point(_lensBitmap.x, _lensBitmap.y),
																			   BitmapDataChannel.GREEN,
																			   BitmapDataChannel.BLUE,
																			   LENS_DIAMETER, LENS_DIAMETER,
																			   DisplacementMapFilterMode.CLAMP);
			
			// apply the displacement map filter to the destination bitmap data
			_loadedBitmap.bitmapData.applyFilter(_bitmapData, _bitmapData.rect, new Point(), displacement);
			evt.updateAfterEvent();
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			_lensBitmap.visible = true;
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			_lensBitmap.visible = false;
		}
	}
}