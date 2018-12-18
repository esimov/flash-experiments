﻿package {	import flash.events.MouseEvent;	import flash.events.Event;	import flash.display.Sprite;	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	public class ShipSimulator extends Sprite {		private var ship:Ship;		private var turn:Number=0;		private var speed:Number=0;		private var vx:Number=0;		private var vy:Number=0;		public function ShipSimulator():void {			init();		}		private function init():void {			ship=new Ship;			addChild(ship);			ship.x=stage.stageWidth/2;			ship.y=stage.stageHeight/2;			ship.rotation = -45;						addEventListener(Event.ENTER_FRAME,onEnterFrame);			stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeyDown);			stage.addEventListener(KeyboardEvent.KEY_UP,onkeyUp);		}		private function onkeyUp(evt:KeyboardEvent):void {			switch (evt.keyCode) {				case Keyboard.LEFT :					turn-=3;					break;				case Keyboard.RIGHT :					turn+=3;					break;				case Keyboard.UP :					speed+=0.3;					ship.draw(true);					break;				case Keyboard.DOWN :					speed-=0.05;					break;				default :					break;			}		}		private function onkeyDown(evt:KeyboardEvent):void {			turn=0;			speed=0;			ship.draw(false);		}		private function onEnterFrame(evt:Event):void {			ship.rotation+=turn;			var angle:Number=ship.rotation*Math.PI/180;			var ax:Number=Math.cos(angle)*speed/2;			var ay:Number=Math.sin(angle)*speed/2;			vx+=ax;			vy+=ay;			ship.x+=vx;			ship.y+=vy;		}	}}