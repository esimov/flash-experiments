﻿//
// Voxel head
// by Mr.doob and Román Cortés
//
// http://www.romancortes.com/
// http://mrdoob.com/
//


package
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	[SWF(width="512",height="512",frameRate="1000",backgroundColor="#FFFFFF")]
	public class voxel extends Sprite
	{
		private var outputBitmapData : BitmapData;
		private var outputBitmap : Bitmap;
		private	var urlStream : URLStream = new URLStream();
		private var fileData : ByteArray = new ByteArray();
		private var psin : Array = [];
		private var pcos : Array = [];	
		private var x10 : Array = [];
		private var y10 : Array = [];
		private var z10 : Array = [];
		private var kz : Array = [];
		private var ad : Array = [];
		private var color : Array = [];
		private var tp : Array = [];
		
		private var x101 : Array = [];
		private var y101 : Array = [];
		private var color1 : Array = [];
		private var x102 : Array = [];
		private var y102 : Array = [];
		private var color2 : Array = [];
		private var x103 : Array = [];
		private var y103 : Array = [];
		private var color3 : Array = [];
		private var x104 : Array = [];
		private var y104 : Array = [];
		private var color4 : Array = [];
		
		private var voxels : int = 321059;
		private var ang : int = 0;
		private var ang2 : int = 0;
		
		private var textfield : TextField;
		
		public function voxel()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			urlStream.addEventListener(Event.COMPLETE, loaded);
			urlStream.load(new URLRequest("data.v"));
			
			outputBitmapData = new BitmapData(512, 492, false);			
			outputBitmap = new Bitmap(outputBitmapData);
			addChild(outputBitmap);
			
			textfield = new TextField();
			textfield.defaultTextFormat = new TextFormat("_sans");
			textfield.text = "loading: heavy damaged head (500kb)";
			textfield.autoSize = "left";
			textfield.x = (stage.stageWidth >> 1) - (textfield.width >> 1);
			addChild(textfield);
			
			onStageResize(null);
		}
		
		public function loaded(event:Event):void
		{
			var n:int, n2:int, x:int, x2:int, y:int, z:int;
			var num:Array = [];
			var i:int = 0;
			var nx:int, ny:int;	
			var cont1:int=0, cont2:int=0, cont3:int=0, cont4:int=0, s:int=0;
			
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			fileData.uncompress();
			
			fileData.endian = "littleEndian";
			
			for (n = 0; n < 512; n++) kz[n] = 0;
			for (n=0; n<voxels; n++)
			{
				fileData.position = i;
				x10[n] = fileData.readInt();
				i +=4;
			}
			for (n=0; n<voxels; n++)
			{
				fileData.position = i;
				y10[n] = fileData.readInt();
				i += 4;
			}
			for (n=0; n<voxels; n++)
			{
				fileData.position = i;
				z10[n] = fileData.readInt();
				i += 4;
			}
			for (n=0; n<voxels; n++)
			{
				fileData.position = i;
				color[n]=(fileData.readInt()+1)*0x010101;
				i += 4;
			}
			for (n=0; n<512; n++)
			{
				fileData.position = i;
				ad[n] = fileData.readInt();
				i += 4;
			}
			for (n=0; n<voxels; n++)
			{
				n2 = z10[n];
				kz[n2]=n;			
			}
			
			
			for (i=100; i<512; i++)
			{	
				if (kz[i])
				{
					var tmp:int;
					
					for (n = 0; n < 512; n++) num[n]=0;				
					for (n=s; n<=kz[i]; n++)
					{
						y = y10[n];					
						tp[(y<<9)+num[y]] = n;
						num[y]++;					
					}				
					for (n=0; n<512; n++)
					{					
						for (x = 0; x < num[n]; x++)
						{
							for (x2 = x + 1; x2 < num[n]; x2++)
							{
								if ((x10[tp[(n << 9) + x]]) > (x10[tp[(n << 9) + x2]]))
								{
									tmp = tp[(n << 9) + x];
									tp[(n << 9) + x] = tp[(n << 9) + x2];
									tp[(n << 9) + x2] = tmp;
								}
							}
						}
						for (x = 0; x < num[n]; x++)
						{
							n2 = tp[(n<<9)+x];
							x101[cont1]=x10[n2]-256;
							y101[cont1]=y10[n2]-256;
							color1[cont1]=color[n2];						
							cont1++;
						}
					}
					for (n = 0; n < 512; n++) num[n]=0;				
					for (n=s; n<=kz[i]; n++)
					{
						x = x10[n];					
						tp[(x<<9)+num[x]] = n;
						num[x]++;					
					}				
					for (n=511; n>=0; n--)
					{					
						for (x = 0; x < num[n]; x++)
						{
							for (x2 = x + 1; x2 < num[n]; x2++)
							{
								if ((y10[tp[(n << 9) + x]]) > (y10[tp[(n << 9) + x2]]))
								{								
									tmp = tp[(n << 9) + x];
									tp[(n << 9) + x] = tp[(n << 9) + x2];
									tp[(n << 9) + x2] = tmp;
								}
							}
						}
						for (x = 0; x < num[n]; x++)
						{
							n2 = tp[(n<<9)+x];
							x102[cont2]=x10[n2]-256;
							y102[cont2]=y10[n2]-256;
							color2[cont2]=color[n2];						
							cont2++;
						}
					}
					for (n=s; n<=kz[i]; n++)
					{
						x103[n]=x101[s+kz[i]-n];
						y103[n]=y101[s+kz[i]-n];
						color3[n]=color1[s+kz[i]-n];
						x104[n]=x102[s+kz[i]-n];
						y104[n]=y102[s+kz[i]-n];
						color4[n]=color2[s+kz[i]-n];
					}
					s=kz[i]+1;	
				}
			}
			for (n=0; n<=16383; n++)
			{			
				psin[n]=Math.sin((n)*((3.141592)/(4096)))*65536;
				pcos[n]=Math.cos((n)*((3.141592)/(4096)))*65536;
			}
			
			addEventListener(Event.ENTER_FRAME, animIn);
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			outputBitmap.y = stage.stageHeight;
		}
		
		public function update(e:Event):void
		{
			var x:int;
			var y:int;
			var i:int;
			var n:int;
			var s:int;
			var xr:int;
			var a:int, b:int, n2:int;
			var t:int;		
			var k:int;
			
			ang2 += (mouseX - (stage.stageWidth >> 1)) >> 1;
			ang = (ang2 + 81920000) % 8192;
			a = psin[ang];
			b = pcos[ang];
			
			outputBitmapData.lock();
			outputBitmapData.fillRect( outputBitmapData.rect, 0xffffff );
			s = ad[100];		
			
			if ((ang>=1024+2048+4096)||(ang<1024))
			{
				for (i=100; i<512; i++)
				{
					t = kz[i];				
					for (n=s; n<=t; n++)
					{
						xr = 256 + ((x101[n] * b + y101[n] * a) >> 16);					
						n2 = color1[n];
						outputBitmapData.setPixel(xr++, i, n2);
						outputBitmapData.setPixel(xr, i, n2);					
					}
					s = t + ad[i];
				}
			}
			else if ((ang >= 1024) && (ang < 1024 + 2048))
			{
				for (i=100; i<512; i++)
				{
					t = kz[i];
					for (n=s; n<=t; n++)
					{							
						xr = 256 + ((x102[n] * b + y102[n] * a) >> 16);					
						n2 = color2[n];
						outputBitmapData.setPixel(xr++, i, n2);					
						outputBitmapData.setPixel(xr, i, n2);					
					}
					s = t + ad[i];
				}
			}
			else if ((ang>=1024+2048)&&(ang<1024+4096))
			{
				for (i=100; i<512; i++)
				{
					t = kz[i];
					for (n=s; n<=t; n++)
					{							
						xr = 256 + ((x103[n] * b + y103[n] * a) >> 16);					
						n2 = color3[n];
						outputBitmapData.setPixel(xr++, i, n2);					
						outputBitmapData.setPixel(xr, i, n2);					
					}
					s=t + ad[i];
				}
			}
			else 
			{
				for (i=100; i<512; i++)
				{
					t = kz[i];
					for (n=s; n<=t; n++)
					{							
						xr = 256 + ((x104[n] * b + y104[n] * a) >> 16);					
						n2 = color4[n];
						outputBitmapData.setPixel(xr++, i, n2);					
						outputBitmapData.setPixel(xr, i, n2);					
					}
					s=t + ad[i];
				}
			}
			outputBitmapData.unlock();
		}
		
		private function animIn(e:Event):void
		{
			if (outputBitmap.y == (stage.stageHeight - outputBitmap.height))
			{
				textfield.visible = false;
				removeEventListener(Event.ENTER_FRAME, animIn);
			}
				
			textfield.y += (-20 -textfield.y) * .1;
			outputBitmap.y += ((stage.stageHeight - outputBitmap.height) - outputBitmap.y) * .05;
			
		}
		
		private function onStageResize(e:Event):void
		{
			outputBitmap.x = (stage.stageWidth >> 1) - (outputBitmap.width >> 1); 	
			outputBitmap.y = stage.stageHeight - outputBitmap.height;
		}
	}
}