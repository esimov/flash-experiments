﻿package {	import flash.display.Sprite;	import flash.events.Event;	import flash.text.TextField;		public class FollowMouse extends Sprite {				private var arrow:Arrow;		private var force:Number = 0.5;		private var vx:Number = 0;		private var vy:Number = 0;		private var distance:Number = 0;		private var txt:TextField = new TextField();				public function FollowMouse ():void {			init();		}				private function init():void {			arrow = new Arrow();			addChild(arrow);			arrow.x = stage.stageWidth*0.5;			arrow.y = stage.stageHeight*0.5;			//txt.autoSize = TextFieldAutoSize.LEFT;			txt.border = true;			txt.width = 100;			txt.height = 20;			addChild(txt);			addEventListener(Event.ENTER_FRAME, onEnterFrame);		}				private function onEnterFrame(evt:Event):void {			var dx:Number = mouseX - arrow.x;			var dy:Number = mouseY - arrow.y;			var dist:Number = Math.atan2(dy,dx);			var angle:Number = dist * 180 /Math.PI;			arrow.rotation = angle;			var ax:Number = Math.cos(dist) * force;			var ay:Number = Math.sin(dist) * force;			vx +=ax;			vy +=ay;			arrow.x += vx;			arrow.y += vy;			distance = Math.sqrt(dx*dx + dy*dy);			txt.text = Math.round(distance).toString();		}			}	}