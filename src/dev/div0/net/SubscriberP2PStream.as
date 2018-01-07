package dev.div0.net
{
	import dev.div0.media.PublisherMedia;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class SubscriberP2PStream extends BaseStream
	{
		public function SubscriberP2PStream(_id:String)
		{
			super(_id);
			streamer = connectionString;
			streamId = _id;
		}
		
		public function onMetaData(data:Object):void
		{
			trace("on Meta data ");
		}
		
		override protected function netGroupConnected():void{
			log("netGroupConnected stream="+stream);
			if(!stream){
				stream = new NetStream(connection, groupSpecifier.groupspecWithAuthorizations());
			}
			stream.addEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler);
			

			stream.play(streamId);
		}
		
		override protected function createStream():void
		{
			createGroup();
			/*
			if(!stream){
				stream = new NetStream(connection);
				stream.client = this;
				
				var streamEvent:StreamEvent = new StreamEvent(StreamEvent.STREAM_READY);
				Dispatcher.getInstance().dispatchEvent(streamEvent);
			}
			
			stream.addEventListener(NetStatusEvent.NET_STATUS,streamStatusHandler);
			log("Start subscribing stream "+streamId);
			stream.play(streamId);
			*/
		}
	}
}