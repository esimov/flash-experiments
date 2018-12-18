package esimov.sound
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class BeatPortPlayer {
		private var gid:int;
		
		public function next ():void {
			if (channel) {
				channel.stop ();
				playRandomSample (new Event ("whatever"))
			}
		}
		
		/**
		 * Plays random samples by genre non-stop.
		 * @see http://api.beatport.com/catalog/genres?format=xml&v=1.0
		 */
		public function play (genreId:int):void {
			// 1st we need to get total number of tracks
			var loader:URLLoader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			subscribeLoader (loader, getCount, onIOFailure1);
			loader.load (new URLRequest (makeUrl (gid = genreId, 1)));
		}
		
		private function makeUrl (genreId:int, page:int):String {
			return "http://api.beatport.com/catalog/tracks?genreId=" + genreId + "&perPage=1&page=" + page + "&format=xml&v=1.0";
		}
		
		private var count:int, sound:Sound, channel:SoundChannel;
		private var context:SoundLoaderContext = new SoundLoaderContext (10, true);
		
		private function getCount (e:Event):void {
			var loader:URLLoader = URLLoader (e.target);
			unsubscribeLoader (loader, getCount, onIOFailure1);
			
			var result:XML = XML (loader.data);
			count = parseInt (result.result.@count);
			
			playRandomSample ();
		}
		
		private function playRandomSample (e:Event = null):void {
			if (e != null) {
				unsubscribeSoundStuff (); channel = null;
			}
			
			var loader:URLLoader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			subscribeLoader (loader, getRandomSampleUrl, onIOFailure2);
			loader.load (new URLRequest (makeUrl (gid, 1 + (count - 1) * Math.random ())));
		}
		
		private function getRandomSampleUrl (e:Event):void {
			var loader:URLLoader = URLLoader (e.target);
			unsubscribeLoader (loader, getRandomSampleUrl, onIOFailure2);
			
			var result:XML = XML (loader.data);
			
			channel = Sound (sound = new Sound (
				new URLRequest (result.result.document.track.@url), context
			)).play ();
			
			subscribeSoundStuff ();
		}
		
		private function subscribeLoader (loader:URLLoader, onComplete:Function, onIOFailure:Function):void {
			loader.addEventListener (Event.COMPLETE, onComplete);
			loader.addEventListener (IOErrorEvent.IO_ERROR, onIOFailure);
		}
		
		private function unsubscribeLoader (loader:URLLoader, onComplete:Function, onIOFailure:Function):void {
			loader.removeEventListener (Event.COMPLETE, onComplete);
			loader.removeEventListener (IOErrorEvent.IO_ERROR, onIOFailure);
		}
		
		private function subscribeSoundStuff ():void {
			sound.addEventListener (IOErrorEvent.IO_ERROR, onIOFailure3);
			channel.addEventListener (Event.SOUND_COMPLETE, playRandomSample);
		}
		
		private function unsubscribeSoundStuff ():void {
			sound.removeEventListener (IOErrorEvent.IO_ERROR, onIOFailure3);
			channel.removeEventListener (Event.SOUND_COMPLETE, playRandomSample);
		}
		
		private function onIOFailure1 (e:IOErrorEvent):void {
			unsubscribeLoader (URLLoader (e.target), getCount, onIOFailure1);
			play (gid);
		}
		
		private function onIOFailure2 (e:IOErrorEvent):void {
			unsubscribeLoader (URLLoader (e.target), getRandomSampleUrl, onIOFailure2);
			playRandomSample ();
		}
		
		private function onIOFailure3 (e:IOErrorEvent):void {
			// assumes sound's ioError comes before channel's soundComplete
			unsubscribeSoundStuff ();
			playRandomSample ();
		}
	}
}