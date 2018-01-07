package dev.div0.utils.log
{
	import flash.events.Event;
	
	public class LogEvent extends Event
	{
		public var data:Object;
		public static const LOG:String="log";
		public static const LOG_READY:String="logReady";
		
		public function LogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, true);
		}
	}
}