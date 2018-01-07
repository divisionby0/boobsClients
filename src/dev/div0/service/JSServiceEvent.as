package dev.div0.service
{
	import flash.events.Event;
	
	public class JSServiceEvent extends Event
	{
		public var data:Object;
		public static const READY:String="ready";
		public static const INIT_ERROR:String="initError";
		public static const PROGRESS:String="progress";
		public static const COMPLETE:String="complete";
		public static const DATA:String="data";
		
		public function JSServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, true);
		}
	}
}