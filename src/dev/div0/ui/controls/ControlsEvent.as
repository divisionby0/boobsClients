package dev.div0.ui.controls
{
	import flash.events.Event;
	
	public class ControlsEvent extends Event
	{
		public static const START_CLICKED:String = "startClicked";
		public static const STOP_CLICKED:String = "stopClicked";
		public static const FULLSCREEN_CLICKED:String = "fullscreenClicked";
		public static const VOLUME_CHANGED:String = "volumeChanged";
		public static const MICROPHONE_STATE_CHANGE_REQUEST:String = "MICROPHONE_STATE_CHANGE_REQUEST";
		
		public var data:Object;
		
		public function ControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}