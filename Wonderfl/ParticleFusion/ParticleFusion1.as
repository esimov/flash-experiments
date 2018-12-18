package
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display.StageQuality;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Shape;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.IOErrorEvent;
    import flash.display.LoaderInfo;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    
    import com.bit101.components.RotarySelector;
    import com.bit101.components.Style;
    import com.bit101.components.Panel;
    import net.hires.debug.Stats;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.system.LoaderContext;
    
    [SWF (backgroundColor = 0x00, width = '465', height = '465')]

    public class ParticleFusion1 extends Sprite
    {
        // CONSTANTS
        private static const SPRING:Number = 0.01;
        private static const BOUNCE:Number = 0.998;
        private static const REPEL:Number = -0.38;
        private static const DAMP:Number = 0.97;
        private static const K:Number = 18;
        
        private const OFFSET_X:Number = 50;
        private const OFFSET_Y:Number = 45;
        private const WIDTH:Number = stage.stageWidth;
        private const HEIGHT:Number = stage.stageHeight;
        
        // Particle attributes
        private var _maxDistSQ:Number = Math.pow(1000 / Math.sqrt(2), 2);
        private var _minDistForce:Number = 2000;
        private var _lastMouseX:Number;
        private var _lastMouseY:Number;
        private var _dx:Number;
        private var _dy:Number;
        private var _vdx:Number;
        private var _vdy:Number;
        private var _firstParticle:Particle;
        
        // Stage and Bitmap variables
        private var _stat:Stats;
        private var _stage:Sprite = new Sprite();
        private var _bmpData:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0x00000000);
        private var _bmp:Bitmap = new Bitmap(_bmpData);
        private var _blur:BlurFilter = new BlurFilter(3,3);
        private var _circle:Circle;
        private var _redCircles:Object = new Object();
        private var _greenCircles:Object = new Object();
        private var _blueCircles:Object = new Object();
        private var _numCircles:Number = 10;
        private var _count:Number = 0; // count the spawn circles
        private var _particles:TextField;
        
        // Control variables
        private var _panel:Panel;
        private var _springs:RotarySelector;
        private var _sinks:RotarySelector;
        private var _manual:RotarySelector;
        
        //Boolean variables
        private var _springsOn:Boolean = false;
        private var _sinksOn:Boolean = false;
        private var _manualOn:Boolean = false;
        private var _mouseDown:Boolean = false;
        
        public function ParticleFusion1():void
        {
            if (stage) { initStage(null) }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initStage);
                throw new Error("Stage not active");    
            }
        }
        
        private function initStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initStage);
            
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.quality = StageQuality.MEDIUM;
            stage.frameRate = 30;
            
            _blur.quality = BitmapFilterQuality.LOW;
            addChild(_stage);
            addChild(_stat = new Stats());
            var tf:TextFormat = new TextFormat("Verdana", 10);
            _particles = new TextField();
            _particles.defaultTextFormat = tf;
            _particles.background = true;
            _particles.backgroundColor = 0x333333;
            _particles.autoSize = "right";
            _particles.textColor = 0xffffff;
            _particles.x = WIDTH - _particles.textWidth - 5;
            _particles.text = "";
            addChild(_particles);
            _stage.addChild(_bmp);
            
            //Style.setStyle(Style.DARK);
            _panel = new Panel(_stage, 0, HEIGHT - OFFSET_Y);
            _panel.width = WIDTH;
            
            var offset_x:Number = OFFSET_X / 2 ;
            _springs = new RotarySelector(_panel, offset_x, 5, "Springs", changeSpringSelection);
            _springs.height = 20;
            _springs.numChoices = 2;
            _springs.labelMode = RotarySelector.NUMERIC;
            offset_x = _springs.x + _springs.width + OFFSET_X;
            
            _sinks = new RotarySelector(_panel, offset_x, 5, "Sinks Auto", changeSinkSelection);
            _sinks.height = 20;
            _sinks.numChoices = 2;
            _sinks.labelMode = RotarySelector.NUMERIC;
            offset_x = _sinks.x + _sinks.width + OFFSET_X;
            
            _manual = new RotarySelector(_panel, offset_x, 5, "Sinks Manual", changeManualSelection);
            _manual.height = 20;
            _manual.numChoices = 2;
            _manual.labelMode = RotarySelector.NUMERIC;
            
            _springs.enabled = false;
            _sinks.enabled = false;
            _manual.enabled = false;
            
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorListener);
            loader.load(new URLRequest("http://www.uploadimage.co.uk/images/16762908908743739406.jpg"), new LoaderContext(true));
            
            addEventListener(Event.ENTER_FRAME, startEvent);
        }
        
        private function changeManualSelection (e:Event):void
        {
            _manualOn = !_manualOn;
        }
		
		private function changeSinkSelection (e:Event):void
        {
            _sinksOn = !_sinksOn;
        }

		private function changeSpringSelection (e:Event):void
        {
            _springsOn = !_springsOn;
        }
        
        private function onMouseDown (event:MouseEvent):void
        {
            if (!_manualOn)
            {
                var rect:Rectangle = _panel.getBounds(this);
                if (mouseY < rect.top)
                {
                    if (_count <= _numCircles)
                    {
                        var randomColor:Number = Math.abs(Math.round(Math.random() * 10 - 2) + Math.round(Math.random() * 10 - 4));
                        var dir_x:Number = Math.random() * 8.5 - 2.5;
                        var dir_y:Number = Math.random() * 8.5 - 2.5;
                        
                        if (randomColor >= 0 && randomColor <= 4)
                        {
                            var red:Circle = new Circle(6, 3, 0xff1111);
                            red.x = mouseX;
                            red.y = mouseY;
                            
                            _redCircles["red"+ _count++] = {x:mouseX, y:mouseY, ref:red, radius:red.radius, lastX: Number, lastY:Number,
                                                            vel_x:Math.cos(dir_x) * 8.5, vel_y:Math.sin(dir_y) * 8.5}
                            red.mouseEnabled = false;
                            _stage.addChild(red);
                        }
                        
                        else if (randomColor > 4 && randomColor <= 7)
                        {
                            //_count = 0;
                            var green:Circle = new Circle(6, 3, 0x009933);
                            green.x = mouseX;
                            green.y = mouseY;
                            
                            _greenCircles["green"+ _count++] = {x:mouseX, y:mouseY, ref:green, radius:green.radius, lastX: Number, lastY:Number,
                                                                vel_x:Math.cos(dir_x) * 8.5, vel_y:Math.sin(dir_y) * 8.5 }
                            green.mouseEnabled = false;
                            _stage.addChild(green);
                        }
                        
                        else if (randomColor > 7)
                        {
                            //_count = 0;
                            var blue:Circle = new Circle(6, 3, 0xff);
                            blue.x = mouseX;
                            blue.y = mouseY;
                            
                            _greenCircles["blue"+ _count++] = {x:mouseX, y:mouseY, ref:blue, radius:blue.radius,lastX: Number, lastY:Number,
                                                                vel_x:Math.cos(dir_x) * 8.5, vel_y:Math.sin(dir_y) * 8.5 }
                            blue.mouseEnabled = false;
                            _stage.addChild(blue);
                        }
                        _count++;
                    }
                }
            }

            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function startEvent(event:Event):void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            moveCircles(_redCircles);
            moveCircles(_greenCircles);
            moveCircles(_blueCircles);
            
            if (!_springsOn) {
                computeParticleMovement(_redCircles);
                computeParticleMovement(_greenCircles);
                computeParticleMovement(_blueCircles);
            }
        }
        
        private function onDown(event:MouseEvent):void
        {
            if (_manualOn)
            {
                var c:Circle = (event.currentTarget) as Circle;
                var rect:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT-OFFSET_Y - c.radius);
                _lastMouseX = c.x;
                _lastMouseY = c.y;
                
                c.addEventListener(MouseEvent.MOUSE_UP, onUp);
                c.startDrag(false, rect);
                event.stopPropagation();                
            }
        }
        
        private function onUp(event:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            Circle(event.currentTarget).stopDrag();
            Circle(event.currentTarget).x = mouseX;
            Circle(event.currentTarget).y = mouseY; 
            Circle(event.currentTarget).removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        }
        
        private function computeParticleMovement(obj:Object):void
        {
            var p:Particle = _firstParticle;
            var color:uint;
            
            if (obj != null)
            {
                for each (var circle:Object in obj)
                {
                    while (p) 
                    {
                        p.vel.x = DAMP * p.vel.x;
                        p.vel.y = DAMP * p.vel.y;
                        p.acc.x = 0;
                        p.acc.y = 0;
                        
                        if (obj == _redCircles)
                        color = (p.red - REPEL*(p.green + p.blue))
                        else if (obj == _greenCircles)
                        color = (p.green - REPEL*(p.red + p.blue))
                        else if (obj == _blueCircles)
                        color = (p.blue - REPEL*(p.red + p.green));
                        _dx = circle.ref.x - p.x;
                        _dy = circle.ref.y - p.y;
                        var dist:Number = _dx * _dx + _dy * _dy;
                        if (dist < _maxDistSQ)
                        {
                            var d:Number = Math.pow(dist, 1.6);
                            if (d < _minDistForce)
                            d = _minDistForce;
                            var factor:Number = -color * K*(1/d);
                            p.acc.x += _dx * factor;
                            p.acc.y += _dy * factor;
                        }
                        
                        if (_sinksOn){
                            p.acc.x += 0.01*(p.initX - p.x);
                            p.acc.y += 0.01*(p.initY - p.y);
                        }
                
                        p.vel = p.vel.add(p.acc);
                        p.x += p.vel.x;
                        p.y += p.vel.y;
                        if (p.x < 0) {
                            p.x = 0;
                            p.vel.x = -p.vel.x * BOUNCE;
                        }
                        if (p.y < 0) {
                            p.y = 0;
                            p.vel.y = -p.vel.y * BOUNCE;
                        }
                        if (p.x > WIDTH) {
                            p.x = WIDTH;
                            p.vel.x = -p.vel.x * BOUNCE;
                        }
                        if (p.x > HEIGHT) {
                            p.x = HEIGHT;
                            p.vel.y = -p.vel.y * BOUNCE;
                        }
                        p = p.next;
                    }
                }
            }
            
            _bmpData.lock();
            _bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(), _blur);
            _bmpData.colorTransform(_bmpData.rect, new ColorTransform(0.98,0.98,0.98, 0.98));
            
            p = _firstParticle;
            while (p)
            {
                _bmpData.setPixel32(p.x, p.y, p.color);
                p = p.next;
            }
            
            _bmpData.unlock();
        }
        
        private function moveCircles(obj:Object):void
        {
            if (!_manualOn)
            {
                var friction:Number = 0.99;
                for each(var circle:Object in obj)
                {
                    //circle.vel_x *= friction;
                    //circle.vel_y *= friction;
                    circle.x += circle.vel_x;
                    circle.y += circle.vel_y;
                    
                    if (circle.x +  circle.radius > WIDTH)
                    {
                        circle.vel_x *= -1;
                        circle.x -= 1;
                    } else if (circle.x - circle.radius < 0)
                    {
                        circle.vel_x *= -1;
                        circle.x += 1;
                    } else if (circle.y + circle.radius > HEIGHT - OFFSET_Y) 
                    {
                        circle.vel_y *= -1;
                        circle.y -= 1;
                    } else if (circle.y - circle.radius < 0)
                    {
                        circle.vel_y *= -1;
                        circle.y += 1;
                    }
                    circle.ref.x = circle.x;
                    circle.ref.y = circle.y;
                }
            } else if ((_redCircles != null || _greenCircles != null || _blueCircles != null) && _manualOn)
            {
                for each (circle in obj)
                {
                    Sprite(circle.ref).buttonMode = true;
                    Sprite(circle.ref).mouseEnabled = true;
                    Sprite(circle.ref).addEventListener(MouseEvent.MOUSE_DOWN, onDown);
                }
            }
        }
        
        
        private function onMouseUp(event:MouseEvent):void
        {
            _mouseDown = !_mouseDown;
        }
        
        
        private function onLoadImage(event:Event):void
        {
            //event.target.loader.removeEventListener(Event.COMPLETE, onLoadImage);
            var pic:Bitmap;
            var info:LoaderInfo = event.target as LoaderInfo;
			trace(info.childAllowsParent);
            var display:DisplayObject = info.content as DisplayObject;
            pic = info.content as Bitmap;
            createParticles(pic);
            drawFirstFrame();
            clearLoader(event.target as LoaderInfo);
            
            _springs.enabled = true;
            _sinks.enabled = true;
            _manual.enabled = true;
        }
        
        private function clearLoader(event:LoaderInfo):void
        {
            event.removeEventListener(Event.COMPLETE, onLoadImage);
            event.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorListener);
        }
        
        private function IOErrorListener(event:IOErrorEvent):void
        {
            try {
                throw new Error("Loading failed")
            } catch (e:Error)
            {
                trace(e.toString());
            }
            clearLoader(event.target as LoaderInfo);
        }
                
        
        private function createParticles(image:Bitmap):void
        {
            var color:uint;
            var numParticles:Number = 0;
            var prevParticle:Particle;
            var count:Number = 0;
            
            for (var i:int = 0; i <= image.width - 1; i = i+3) //sampling every third pixel on x axis
            {
                for (var j:int = 0; j <= image.height - 1; j = j+3) // //sampling every third pixel on y axis
                {
                    color = image.bitmapData.getPixel32(i, j);
                    var pixel:Particle = new Particle(color);
                    pixel.x = (WIDTH - image.width)/2 + i;
                    pixel.y = (HEIGHT - image.height - OFFSET_Y)/2 + j;
                    
                    pixel.initX = pixel.x;
                    pixel.initY = pixel.y;
                    pixel.vel.x = 0;
                    pixel.vel.y = 0;
                    
                    numParticles++;
                    
                    if (numParticles == 1)
                    {
                        _firstParticle = pixel;
                    } 
                    else {
                        pixel.next = _firstParticle;
                        _firstParticle = pixel;
                    }
                    count++;
                }
            }
            _particles.text = count + "  particles";
        }
        
        private function drawFirstFrame():void
        {
            var p:Particle = _firstParticle;
            do
            {
                _bmpData.setPixel32(p.x, p.y, p.color);
                p = p.next;
            } while (p != null)
        }
    }
}


import flash.geom.Point;

internal class Particle extends Point
{
    // Velocity and acceleration values of particles
    public var vel:Point = new Point();
    public var acc:Point = new Point();
    
    // Initial particle positions
    public var initX:Number;
    public var initY:Number;
    
    // Color attributes
    public var red:uint;
    public var green:uint;
    public var blue:uint;
    public var color:uint;
    public var alpha:uint;
    public var next:Particle;
    
    public final function Particle(color:uint = 0xffffffff):void
    {
        this.color = color;
        alpha    = (color >> 32) & 0xff;
        red      = (color >> 16) & 0xff;
        green    = (color >> 08) & 0xff;
        blue     = (color >> 00) & 0xff;
    }
}



import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Shape;
import flash.geom.Point;
import flash.filters.BlurFilter;
import flash.geom.Matrix;

internal class Circle extends Sprite
{
    private var _radius:Number;
    private var _color:uint;
    private var _thickness:Number;
    private var _matrix:Matrix;
    
    public var vx:Number;
    public var vy:Number;
    
    public final function Circle(radius:Number = 10, thickness:Number = 4, color:uint = 0x00)
    {
        this._color = color;
        this._radius = radius;
        this._thickness = thickness;
        
        _matrix = new Matrix();
        _matrix.createGradientBox(2*_radius, 2*_radius, 0);
        var circle:Sprite = new Sprite();
        circle.cacheAsBitmap = true;
        var g:Graphics = circle.graphics;
        g.beginGradientFill("radial", [0xCB0000, 0xE28A09], [1, 1], [120, 129], _matrix, "reflect", "rgb", -0.9);
        g.lineStyle(_thickness, _color, .8, true, "none");
        g.drawCircle(0, 0, _radius);
        g.endFill();
        circle.filters = [new BlurFilter(4, 4)];
        addChild(circle);
    }
    
    public function get color():uint
    {
        return this._color;
    }
    
    public function get radius():Number
    {
        return _radius;
    }
}
