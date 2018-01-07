package dev.div0.net
{
	import flash.events.Event;
	
	public class StreamEvent extends Event
	{
		public static const STREAM_STARTED:String = "streamStarted";
		public static const STREAM_READY:String = "streamReady";
		
		public var data:Object;
		
		public function StreamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}