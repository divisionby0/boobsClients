package dev.div0.net
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.sensors.Accelerometer;

	public class RtmpConnection
	{
		private var connection:NetConnection;
		//private var streamer:String = "rtmp://localhost:1935/live/";
		private var streamer:String = "";
		
		public function RtmpConnection()
		{
			
		}
		
		public function connect(streamer:String):void{
			if(streamer){
				this.streamer = streamer;
			}
			
			connectToStreamer();
		}
		
		public function disconnect():void{
			if(connection){
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHander);
				connection = null;
			}
		}
		
		private function connectToStreamer():void
		{
			if(!connection){
				connection = new NetConnection();
			}
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHander);
			log("connecting to "+streamer);
			connection.connect(streamer);
		}
		
		private function netStatusHander(event:NetStatusEvent):void
		{
			log("RtmpConnection netStatus:"+event.info.code);
			switch(event.info.code) 
			{
				case 'NetConnection.Connect.Success':
					onConnectSuccess();
					break;
				case 'NetConnection.Connect.Failed':
					onConnectError(event.info.code);
					break;
				case 'NetConnection.Connect.InvalidApp':
					onConnectError(event.info.code);
					break;
			}
		}
		
		private function onConnectSuccess():void{
			Dispatcher.getInstance().dispatchEvent(new RtmpConnectionEvent(RtmpConnectionEvent.CONNECT_SUCCESS));
		}
		private function onConnectError(errorText:String):void{
			var event:RtmpConnectionEvent = new RtmpConnectionEvent(RtmpConnectionEvent.CONNECT_ERROR);
			event.data = errorText;
			Dispatcher.getInstance().dispatchEvent(event);
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