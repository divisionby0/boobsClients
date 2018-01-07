package dev.div0.error
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;

	public class GlobalErrorHandling
	{
		public function GlobalErrorHandling(loaderInfo:LoaderInfo)
		{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				// do something with the error
				log("uncaughtError error : "+error.message);
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				// do something with the error
				log("uncaughtError errorEvent : "+errorEvent.text);
			}
			else
			{
				// a non-Error, non-ErrorEvent type was thrown and uncaught
				log("uncaughtError : a non-Error, non-ErrorEvent type was thrown and uncaught");
			}
		}
		
		protected function log(param0:String):void
		{
			trace(param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}