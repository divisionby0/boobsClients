package dev.div0.ui.video.videoPlayer
{
	import flash.events.Event;
	
	public class VideoPlayerEvent extends Event
	{
		public static const RECORD_AGAIN:String = "recordAgain";
		public static const RECORD_COMPLETE:String = "recordComplete";
		public static const PLAY:String = "play";
		public static const PLAYBACK_COMPLETE:String = "playbackComplete";
		
		public function VideoPlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}