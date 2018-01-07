package dev.div0.net
{
	import dev.div0.media.PublisherMedia;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	import flash.utils.setInterval;

	public class P2PPublishStream
	{
		private var userId:String = 'user_0';
		protected static const SERVER:String="rtmfp://p2p.rtmfp.net/";
		protected static const DEV_KEY:String="efb549452e48f663eedd1a3a-c09a61816fac";
		protected var connectionString:String = SERVER+DEV_KEY;
		
		private var streamName:String;
		private var stream:NetStream;
		private var connection:NetConnection;
		private var group:NetGroup;
		private var groupSpec:GroupSpecifier;
		private var media:PublisherMedia;
		private var testDataInterval:int;
		private var groupId:String;
		
		public function P2PPublishStream(userId:String, media:PublisherMedia)
		{
			if(userId){
				this.userId = userId;
			}
			
			this.media = media;
			streamName = userId;
			groupId = "multicastGroup_"+streamName;
		}
		
		public function start():void{
			createConnection();
		}
		public function stop():void{
			if(stream){
				stream.close();
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream = null;
			}
			if(group){
				group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			
			if(connection){
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
		}
		
		private function createConnection():void
		{
			if(!connection){
				connection = new NetConnection();
			}
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.connect(connectionString);
		}		
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			log("P2PPublisher:"+event.info.code);
			
			switch(event.info.code){
				case 'NetConnection.Connect.Success':
					createStream();
					break;
				case "NetStream.Connect.Success":
					startStream();
					publishStarted();
					break;
				case "NetStream.Publish.Start":
					attachMedia();
					break;
			}
		}		
		
		private function attachMedia():void
		{
			log("attaching media...");
			try{
				stream.attachAudio(media.getMicrophone());
			}
			catch(error:Error){
				log("error attching camera: "+error.message);
			}
			try{
				stream.attachCamera(media.getCamera());
			}
			catch(error:Error){
				log("error attching mic: "+error.message);
			}
			log("media attached");
		}
		
		private function publishStarted():void
		{
			var streamEvent:StreamEvent = new StreamEvent(StreamEvent.STREAM_STARTED);
			streamEvent.data = {streamId:streamName, groupId:groupId};
			Dispatcher.getInstance().dispatchEvent(streamEvent);
		}
		
		private function startStream():void
		{
			log("start stream: "+streamName);
			stream.publish(streamName);
		}
		
		private function createStream():void
		{
			if(!groupSpec){
				groupSpec = new GroupSpecifier(groupId);
				log("groupId="+groupId);
				groupSpec.multicastEnabled=true;
				groupSpec.serverChannelEnabled=true;
			}
			if(!stream){
				stream = new NetStream(connection, groupSpec.groupspecWithAuthorizations());
			}
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
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