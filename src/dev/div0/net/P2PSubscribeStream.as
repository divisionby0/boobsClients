package dev.div0.net
{
	import dev.div0.media.PublisherMedia;
	import dev.div0.ui.controls.ControlsEvent;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;

	public class P2PSubscribeStream
	{
		private var userId:String;
		protected static const SERVER:String="rtmfp://p2p.rtmfp.net/";
		protected static const DEV_KEY:String="efb549452e48f663eedd1a3a-c09a61816fac";
		protected var connectionString:String = SERVER+DEV_KEY;
		
		private var streamName:String;
		private var stream:NetStream;
		private var connection:NetConnection;
		private var group:NetGroup;
		private var groupSpec:GroupSpecifier;
		private var media:PublisherMedia;
		
		public function P2PSubscribeStream(userId:String)
		{
			this.userId = userId;
			this.media = media;
			streamName = userId;
			Dispatcher.getInstance().addEventListener(ControlsEvent.VOLUME_CHANGED, volumeChangedHandler);
		}
		
		private function volumeChangedHandler(event:ControlsEvent):void
		{
			if(stream){
				var streamSoundTransform:SoundTransform = new SoundTransform();
				streamSoundTransform.volume = Number(event.data);
				stream.soundTransform = streamSoundTransform;
			}
		}
		
		public function getStream():NetStream{
			return stream;
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
			log("P2PSubscriber:"+event.info.code);
			
			switch(event.info.code){
				case 'NetConnection.Connect.Success':
					createStream();
					break;
				case 'NetStream.Connect.Success':
					playStream();
					break;
			}
		}		
		
		private function playStream():void
		{
			log("start stream: "+streamName);
			stream.play(streamName);
			
			var streamEvent:StreamEvent = new StreamEvent(StreamEvent.STREAM_STARTED);
			Dispatcher.getInstance().dispatchEvent(streamEvent);
		}
		
		private function createStream():void
		{
			if(!groupSpec){
				groupSpec = new GroupSpecifier("multicastGroup_"+userId);
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
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}