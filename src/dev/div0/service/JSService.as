package dev.div0.service
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	public class JSService extends EventDispatcher
	{
		public var inited:Boolean = false;
		
		public function init(ver:String):void
		{
			log("JSService.init()");
			if(ExternalInterface.available)
			{
				var jsServiceEvent:JSServiceEvent;
				
				try{
					ExternalInterface.addCallback("onDataExternal",onExternalData);
					inited = true;
					Dispatcher.getInstance().addEventListener(LogEvent.LOG, logDataHandler);
				}
				catch(error:SecurityError){
					log("!! JS init security error "+error.message);
				}
				
				if(inited){
					jsServiceEvent = new JSServiceEvent(JSServiceEvent.READY);
					dispatchEvent(jsServiceEvent);
					var dataObject:Object = new Object();
					dataObject.message = 'inited ver='+ver;
					
					//JSON.stringify(dataObject.message);
					//send('inited ver='+ver);
					
					send(JSON.stringify(dataObject.message));
				}
			}
			else
			{
				log("JSServiceEvent.INIT_ERROR");
				jsServiceEvent = new JSServiceEvent(JSServiceEvent.INIT_ERROR);
				dispatchEvent(jsServiceEvent);
			}
		}
		
		private function onTestCall():void{
			log("On test Call !!!");
		}
		
		private function onExternalData(value:Object):void
		{
			//send(ObjectUtil.toString(value));
			var jsServiceEvent:JSServiceEvent = new JSServiceEvent(JSServiceEvent.DATA);
			jsServiceEvent.data = value;
			dispatchEvent(jsServiceEvent);
		}
		
		public function send(data:String):void	
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("receiveDataFromAs",data);
			}
			else
			{
				log("Error sending data: external not available");
			}
		}
		
		private function logDataHandler(event:LogEvent):void{
			var dataObject:Object = new Object();
			dataObject.message = event.data.toString();
			send(JSON.stringify(dataObject));
		}
		
		private function log(param0:String):void
		{
			trace(param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}