package dev.div0.media
{
	import flash.events.Event;
	
	public class MediaEvent extends Event
	{
		public static const CAMERA_SELECTED:String = "CAMERA_SELECTED";
		public static const CAMERA_FRAME_SIZE_CHANGED:String = "CAMERA_FRAME_SIZE_CHANGED";
		public static const USER_CAMERA_CHANGED:String = "USER_CAMERA_CHANGED";
		public static const CAMERA_MUTED:String = "cameraMuted";
		public static const CAMERA_UNAVAILABLE:String = "cameraUnavailable";
		public static const CAMERA_UNMUTED:String = "cameraUnmuted";
		
		public static const MICROPHONE_STATE_CHANGED:String = "MICROPHONE_STATE_CHANGED";
		
		public var microphoneStatus:String;
		public var selectedCameraIndex:int;
		public var selectedFrameSize:Object;
		
		public function MediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}