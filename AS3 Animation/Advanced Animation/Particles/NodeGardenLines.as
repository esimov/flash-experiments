﻿package {	import flash.display.Sprite;	import flash.events.Event;	import flash.display.StageScaleMode;	import flash.display.StageAlign;	import flash.filters.BlurFilter;		[SWF (backgroundColor = 0x000000)]		public class NodeGardenLines extends Sprite {		private var numParticles:Number = 70;		private var minDist:Number = 80;		private var spring:Number = 0.002;		private var part:Ball;		private var particles:Array;		private var blur:BlurFilter = new BlurFilter();				public function NodeGardenLines():void {			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			init();		}				private function init():void {						blur.blurX = blur.blurY = 5;			blur.quality = 1;			var size:Number = Math.random() * 3 + 2;			particles = new Array();			for (var i:uint = 0; i<numParticles; i++) {				part = new Ball(Math.random() * 4 + 2, 0xffffff);				part.x = Math.random() * stage.stageWidth;				part.y = Math.random() * stage.stageHeight;				part.vx = Math.random() * 5 - 2;				part.vy = Math.random() * 5 - 2;				part.mass = size;				addChild(part);				particles.push(part);				part.filters = [blur];				part.cacheAsBitmap = true;			}						stage.addEventListener(Event.ENTER_FRAME, onStart);		}				private function onStart(evt:Event):void {						graphics.clear();			for (var i:uint = 0; i< numParticles; i++) {				var part:Ball = Ball(particles[i]);				part.x += part.vx;				part.y += part.vy;								if (part.x < 0) {					part.x = stage.stageWidth - part.radius;				}								if (part.x > stage.stageWidth) {					part.x = part.radius;				}								if (part.y < 0) {					part.y = stage.stageHeight - part.radius;				}								if (part.y > stage.stageHeight) {					part.y = part.radius;				}			}						for (i = 0; i< numParticles - 1; i++) {				var partA:Ball = Ball(particles[i]);								for (var j:Number = i+1; j< numParticles; j++) {					var partB:Ball = Ball(particles[j]);										checkParticleDistance(partA, partB);				}			}		}				private function checkParticleDistance(partA:Ball, partB:Ball):void {			var dx:Number = partB.x - partA.x;			var dy:Number = partB.y - partA.y;			var dist:Number = Math.sqrt(dx*dx + dy*dy);			if (dist < minDist) {								graphics.lineStyle(1, 0xffffff, 1 - dist/minDist);				graphics.moveTo(partA.x, partA.y);				graphics.lineTo(partB.x, partB.y);								var ax:Number = dx * spring;				var ay:Number = dy * spring;				partA.vx += ax / partA.mass;				partA.vy += ay / partA.mass;				partB.vx -= ax / partB.mass;				partA.vy -= ax / partB.mass;			}		}	}}