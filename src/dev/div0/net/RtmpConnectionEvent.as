package dev.div0.net
{
	import flash.events.Event;
	
	public class RtmpConnectionEvent extends Event
	{
		public static var CONNECT_SUCCESS:String = "CONNECT_SUCCESS";
		public static var CONNECT_ERROR:String = "CONNECT_ERROR";
		
		public var data:String;
		
		public function RtmpConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}