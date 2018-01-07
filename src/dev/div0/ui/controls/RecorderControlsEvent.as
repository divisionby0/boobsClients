package dev.div0.ui.controls
{
	import flash.events.Event;
	
	public class RecorderControlsEvent extends Event
	{
		public static const START_RECORD:String = "startRecord";
		public static const STOP_RECORD:String = "stopRecord";
		
		public static const STOP_PLAYING:String = "stopPlaying";
		public static const START_PLAYING:String = "startPlaying";
		
		public static const RECORD_COMPLETE:String = "recordComplete";
		
		public function RecorderControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}