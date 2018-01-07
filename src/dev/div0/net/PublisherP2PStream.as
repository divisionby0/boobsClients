package dev.div0.net
{
	import dev.div0.media.PublisherMedia;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;

	public class PublisherP2PStream extends BaseStream
	{
		private var media:PublisherMedia;
		
		public function PublisherP2PStream(_id:String, media:PublisherMedia)
		{
			super(_id);
			this.media = media;
			streamer = connectionString;
			streamId = 'stream_'+_id;
			log("streamId="+streamId);
		}
		
		override protected function createStream():void
		{
			createGroup();
		}
		
		override protected function onStreamConnected():void
		{
			log("Stream connected");
			stream.attachCamera(media.getCamera());
			stream.attachAudio(media.getMicrophone());
			
			var h264VieoCodec:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264VieoCodec.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_1);
			stream.videoStreamSettings = h264VieoCodec;
			
			stream.publish(streamId);
		}
		
		
		override protected function netGroupConnected():void{
			log("netGroupConnected stream="+stream);
			if(!stream){
				stream = new NetStream(connection, groupSpecifier.groupspecWithAuthorizations());
			}
			stream.addEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler);
		}
		
		override protected function streamStatusHandler(event:NetStatusEvent):void
		{
			log("PStream:"+event.info.code);
			switch(event.info.code){
				case "NetStream.Publish.Start":
					var streamEvent:StreamEvent = new StreamEvent(StreamEvent.STREAM_STARTED);
					streamEvent.data = streamId;
					Dispatcher.getInstance().dispatchEvent(streamEvent);
					break;
			}
		}
	}
}