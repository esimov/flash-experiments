package  
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import esimov.utils.PreLoader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import esimov.physics.Spring;
	import esimov.physics.Particle;
	import esimov.physics.ParticleSystem;
	import flash.display.Sprite;

	import net.hires.debug.Stats;

	[ SWF (width=800, height=600, backgroundColor=0xeaeaea, frameRate=60) ]

	/**
	 * @author simoe
	 */
	public class ClothSim extends Sprite
	{	
		private var ps:ParticleSystem;
		private var particles:Vector.<Vector.<Particle>>;
		private var springs:Vector.<Spring>;
		private var dragPoint:Particle;
		private var mouseDown:Boolean = false;
		
		private var numRows:Number = 28;
		private var numCols:Number = 26;
		private var offset:Number = 16;
		
		private var handle1:PreLoader;
		private var handle2:PreLoader;
		private var canvas:Sprite;
		private var stats:Stats;
		
		private const STAGE_WIDTH:Number = stage.stageWidth;
		private const STAGE_HEIGHT:Number = stage.stageHeight;
		
		public function ClothSim():void
		{
			var i:int, j:int;
			var clothWidth:Number = (numRows - 1) * offset;
			var clothHeight:Number = (numCols - 1) * offset;
			var posX:Number = (STAGE_WIDTH - clothWidth) / 2;
			var posY:Number = (STAGE_HEIGHT - clothHeight) / 2;
			
			stats = new Stats();
			particles = new Vector.<Vector.<Particle>>();
			springs = new Vector.<Spring>();
			ps = new ParticleSystem(new Vector3D(0,0.08,0),0.01);
			
			ps.setIntegrator(ParticleSystem.RK);
			
			
			//switch colums and rows if rows>cols
			if (numRows > numCols)
			{
				var temp:Number = numRows;
				numRows = numCols;
				numCols = temp;
			}
			
			//create a two dimensional vector array
			for (i = 0;i < numRows;i++)
			{
				var vector_rows:Vector.<Particle> = new Vector.<Particle>();
				for (j = 0;j < numCols;j++)
				{	
					vector_rows.push(ps.makeParticle(0.9, new Vector3D(posX+j*offset,posY+i*offset,0)));
				}
				
				particles.push(vector_rows);
			}
			
			//create Spring attractors between particles horozontally
			for (i = 0;i < numRows;i++)
			{
				for (j = 0;j < numCols - 1;j++)
				{
					ps.makeSpring(particles[i][j], particles[i][j+1], 0.9, 0.2, offset>>1);
				}
			}
			
			//create Spring attractors between particles vertically
			for (i = 0;i < numRows - 1;i++)
			{
				for (j = 0;j < numCols;j++)
				{
					ps.makeSpring(particles[i][j], particles[i+1][j], 0.9, 0.2, offset>>1);
				}
			}
			
			createBackground();
			canvas = new Sprite();
			addChild(canvas);
			
			handle1 = new PreLoader();
			handle1.load("../_assets/pin_handle.png");
			canvas.addChild(handle1);
			
			handle2 = new PreLoader();
			handle2.load("../_assets/pin_handle.png");
			canvas.addChild(handle2);
			canvas.addChildAt(stats, numChildren-1);
			
			handle1.buttonMode = true;
			handle2.buttonMode = true;
			
			handle1.x = particles[0][0].position.x - 35;
			handle1.y = particles[0][0].position.y - 25;
			handle2.x = particles[0][numRows-1].position.x - 30;
			handle2.y = particles[0][numCols-1].position.y - 25;
			particles[0][0].makeFix();
			particles[0][numCols - 1].makeFix();
			
			handle1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			handle2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onClothPress);
			stage.addEventListener(MouseEvent.MOUSE_UP, onClothRelease);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			
			addEventListener(Event.ENTER_FRAME, renderCloth);
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

		
		private function onMouseDownHandler(event : MouseEvent) : void 
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
				event.stopImmediatePropagation();
				event.currentTarget.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseDownHandler);
				break;
				
				case MouseEvent.MOUSE_UP:
				event.stopImmediatePropagation();
				handle1.stopDrag();
				handle2.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseDownHandler);
				break;
			}
		}
		
		private function keyDownListener(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				stats.visible = !stats.visible;
			}
		}
		
		private function onClothPress(event:MouseEvent):void
		{
			mouseDown = true;
			dragPoint = searchDraggingPoint();
			dragPoint.isDragging = true;
		}
		
		private function onClothRelease(event:MouseEvent):void
		{
			mouseDown = false;
			dragPoint.isDragging = false;
			dragPoint = undefined;
		}

		
		private function searchDraggingPoint():Particle
		{
			var target:Particle;
			var lastMinimumDist:Number = Infinity;
			
			for (var i:int = 0; i<numRows; i++)
			{
				for (var j:int = 0; j<numCols; j++)
				{		
					var particle:Particle = particles[i][j];
					var mousePos:Vector3D = new Vector3D(mouseX, mouseY, 0);
					var dist:Number = particle.position.subtract(mousePos).lengthSquared;
					
					if (dist < lastMinimumDist)
					{
						lastMinimumDist = dist;
						target = particle; 
					}
				}
			}
			return target;
		}

		private function renderCloth(event : Event) : void 
		{
			particles[0][0].position.x = handle1.x + 35;
			particles[0][0].position.y = handle1.y + 25;
			
			particles[0][numCols - 1].position.x = handle2.x + 30;
			particles[0][numCols - 1].position.y = handle2.y + 25;
			
			if(mouseDown)
			{
				dragPoint.position.x = mouseX;
				dragPoint.position.y = mouseY;
				dragPoint.velocity.scaleBy(dragPoint.mass);
			}
			
			ps.applyIntegrator(1);
			ps.clearForces();
			
			canvas.graphics.clear();
			canvas.graphics.lineStyle(1, 0x555555);
			
			for (var i:int = 0; i<numRows; i++)
			{
				for (var j:int = 0; j<numCols-1; j++)
				{		
					canvas.graphics.moveTo(particles[i][j].position.x, particles[i][j].position.y);
					canvas.graphics.lineTo(particles[i][j+1].position.x, particles[i][j+1].position.y);
				}
			}
			
			for (i = 0; i<numRows-1; i++)
			{
				for (j = 0; j<numCols; j++)
				{		
					canvas.graphics.moveTo(particles[i][j].position.x, particles[i][j].position.y);
					canvas.graphics.lineTo(particles[i+1][j].position.x, particles[i+1][j].position.y);
				}
			}
		}
	
	}
}
