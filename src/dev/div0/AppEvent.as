package dev.div0
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		public static const APPLICATION_READY:String="applicationReady";
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, true);
		}
	}
}