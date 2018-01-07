package dev.div0.net
{
	import avmplus.getQualifiedClassName;
	
	import dev.div0.Settings;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;

	public class BaseStream
	{
		protected static const SERVER:String="rtmfp://p2p.rtmfp.net/";
		protected static const DEV_KEY:String="efb549452e48f663eedd1a3a-c09a61816fac";
		protected var connectionString:String = SERVER+DEV_KEY;
		
		protected var _id:String  = "-1";
		//protected var streamer:String = "rtmp://78.108.82.195:1935/live/";
		//protected var streamer:String = "rtmp://red5.divisionby0.ru:1935/live/";
		protected var streamer:String = "rtmp://localhost:1935/live/";
		protected var stream:NetStream;
		protected var connection:NetConnection;
		
		protected var netGroup:NetGroup;
		protected var groupSpecifier:GroupSpecifier;
		private var streamEvent:StreamEvent;
		
		public function BaseStream(_id:String):void
		{
			if(_id){
				this._id = _id;
			}
			if(Settings.rtmp){
				streamer = Settings.rtmp;
			}
		}
		public function start():void{
			connect();
		}
		
		public function stop():void{
			if(connection){
				connection.close();
			}
			
			if(stream)
			{
				stream.close();
				stream.removeEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler);
			}
			connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHander);
			
			stream = null;
		}
		
		public function getStream():NetStream{
			return stream;
		}
		
		private function connect():void
		{
			if(!connection){
				connection = new NetConnection();
			}
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHander);
			log("connect to "+streamer);
			connection.connect(streamer);
		}
		
		protected function log(param0:String):void
		{
			trace("["+getQualifiedClassName(this)+"] "+param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
		
		protected function netStatusHander(event:NetStatusEvent):void
		{
			log("Base netStatus:"+event.info.code);
			switch(event.info.code) 
			{
				case 'NetConnection.Connect.Success':
					createStream();
					break;
				case "NetGroup.Connect.Success": // e.info.group
					netGroupConnected();
					break;
				case "NetStream.Connect.Success":
					onStreamConnected();
					break;
			}
		}
		
		protected function onStreamConnected():void
		{
			
		}
		
		protected function netGroupConnected():void
		{
			log('netGroupConnected');
		}
		
		protected function streamStatusHandler(event:NetStatusEvent):void
		{
			log("BaseStream streamStatus:"+event.info.code);
			switch(event.info.code){
				case "NetStream.Play.Start":
					streamEvent = new StreamEvent(StreamEvent.STREAM_STARTED);
					streamEvent.data = Settings.streamID;
					Dispatcher.getInstance().dispatchEvent(streamEvent);
					break;
				case "NetStream.Publish.Start":
					streamEvent = new StreamEvent(StreamEvent.STREAM_STARTED);
					streamEvent.data = Settings.streamID;
					Dispatcher.getInstance().dispatchEvent(streamEvent);
					sendMetadata();
					break;
				// adaptive
				case "NetStream.Buffer.Full":
					onStreamBufferFull();
					break;
				case "NetStream.Buffer.Empty":
					onStreamBufferEmpty();
					break;
				
			}
		}
		
		protected function onStreamBufferFull():void{
			
		}
		protected function onStreamBufferEmpty():void{
			
		}
		
		protected function sendMetadata():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function createStream():void
		{
			
		}
		private function createGroup():void
		{
			if(!netGroup){
				groupSpecifier = new GroupSpecifier("p2pGroup/" + Settings.streamID);
				groupSpecifier.postingEnabled = true;
				groupSpecifier.serverChannelEnabled = true;
				
				netGroup = new NetGroup(connection, groupSpecifier.groupspecWithAuthorizations());
				//log("groupSpec: "+"p2pGroup/" + Settings.streamID);
				netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatusHander);
			}
		}
	}
}