package dev.div0.net
{
	import dev.div0.Settings;
	import dev.div0.media.PublisherMedia;
	import dev.div0.ui.controls.ControlsEvent;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.H264VideoStreamSettings;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class SubscriberStream extends BaseStream
	{
		public function SubscriberStream(_id:String)
		{
			super(_id);
			Dispatcher.getInstance().addEventListener(ControlsEvent.VOLUME_CHANGED, volumeChangedHandler);
		}
		
		public function onMetaData(data:Object):void
		{
			trace("on Meta data ");
		}
		
		private function volumeChangedHandler(event:ControlsEvent):void
		{
			if(stream){
				var streamSoundTransform:SoundTransform = new SoundTransform();
				streamSoundTransform.volume = Number(event.data);
				stream.soundTransform = streamSoundTransform;
			}
		}
		
		override protected function createStream():void
		{
			if(!stream){
				stream = new NetStream(connection);
				stream.client = this;
				
				var streamEvent:StreamEvent = new StreamEvent(StreamEvent.STREAM_READY);
				Dispatcher.getInstance().dispatchEvent(streamEvent);
			}
			
			stream.addEventListener(NetStatusEvent.NET_STATUS,streamStatusHandler);
			stream.play(Settings.streamID);
		}
	}
}