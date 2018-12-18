package
{
	import esimov.utils.Image;
	import esimov.physics.Attraction;
	import esimov.physics.Particle;
	import esimov.physics.ParticleSystem;
	import esimov.utils.CollisionDetector;
	
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import net.hires.debug.Stats;
	
	[SWF(width=1080,height=720,backgroundColor=0xeaeaea,frameRate=60)]
	
	public class FreeFloatingTest extends Sprite
	{
		public const SWF_WIDTH:uint = stage.stageWidth;
		public const SWF_HEIGHT:uint = stage.stageHeight;
		
		private var s:ParticleSystem;
		private var prev_x:Number;
		private var prev_y:Number;
		private var circleRadius:Number;
		private static var friction:Number = 0.98;
		
		private var particles:Vector.<Particle>;
		private var p_gfx:Vector.<Sprite>;
		private var attractions:Vector.<Attraction>;
		
		private var attractor:Particle;
		private var canvas:Sprite;
		private var image:Image;
		
		public function FreeFloatingTest()
		{
			var numP:Number = 300;
			var randx:Number, randy:Number = 0;
			particles = new Vector.<Particle>;
			p_gfx = new Vector.<Sprite>;
			attractions = new Vector.<Attraction>;
			
			s = new ParticleSystem(new Vector3D(0, 1.8, 0), 0.08);
			attractor = s.makeParticle(.8, new Vector3D(0, 0, 0));
			
			s.setIntegrator(ParticleSystem.RK);
			
			createBackground();
			canvas = new Sprite();
			addChild(canvas);						
			
			for (var i:int = 0; i < numP; i++)
			{
				randx = Math.random() * SWF_WIDTH;
				randy = Math.random() * SWF_HEIGHT;
				var p:Particle = s.makeParticle(.9, new Vector3D(randx, randy, 0));
				image =new Image(Math.random() * 10 - 5)as Image;
				particles.push(p);
				canvas.addChild(image);
				
				attractions.push(s.makeAttractors(p, attractor, 100, 80));
				p_gfx.push(image);
				
			}
			
			addChild(new Stats());
			addEventListener(Event.ENTER_FRAME, render);
		
		}
		
		private function render(evt:Event):void
		{
			var i:int=0;
			if (s.getIntegrator() == ParticleSystem.VERLET)
			{
				s.applyIntegrator(getTimeElapsed());
			}
			else
				s.applyIntegrator(1);
			
			attractor.position.x = mouseX;
			attractor.position.y = mouseY;
			
			for (i=0; i<particles.length; i++)
			{
				particles[i].boundCheck(Particle.BOUNCE, 0, stage.stageWidth - Image(p_gfx[i]).circleRadius * Image(p_gfx[i]).factor, 
														 0, stage.stageHeight - Image(p_gfx[i]).circleRadius * Image(p_gfx[i]).factor);
				particles[i].setMass(Math.random() * 0.5 + 0.2);
				particles[i].position.x = (SWF_WIDTH + particles[i].position.x) % SWF_WIDTH;
				particles[i].position.y = (SWF_HEIGHT + particles[i].position.y) % SWF_HEIGHT;
				particles[i].maxVelocity = 2;
				
				p_gfx[i].x = particles[i].position.x;
				p_gfx[i].y = particles[i].position.y;
				
				if (prev_x)
				{
					var mouse_d:Number = Point.distance(new Point(mouseX, mouseY), new Point(prev_x, prev_y));
					attractions[i].setDistance(mouse_d * 0.5);
					attractions[i].setStrength(-(10 + (120 * (mouse_d * mouse_d))));
				}
			}
			
			prev_x = mouseX;
			prev_y = mouseY;
		
		}
		
		private function getTimeElapsed():Number
		{
			var currentTime:Number;
			var previousTime:Number;
			var elapsedTime:Number;
			var leftOverTime:Number = 0;
			
			currentTime = getTimer();
			previousTime = getTimer();
			elapsedTime = currentTime - previousTime;
			previousTime = currentTime;
			
			var timeStep:Number = elapsedTime + leftOverTime;
			leftOverTime = elapsedTime - (timeStep * 15);
			
			return leftOverTime;
		}
		
		private function createBackground():void
		{
			var background:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(SWF_WIDTH, SWF_HEIGHT);
			background.graphics.beginGradientFill(GradientType.RADIAL, [0xEFEFEF, 0xEFEFEF, 0xEAEAEA], [1, 1, 1], [0x00, 0x7F, 0xFF], matrix);
			background.graphics.drawRect(0, 0, SWF_WIDTH, SWF_HEIGHT);
			background.graphics.endFill();
			addChild(background);
		}
	}
}