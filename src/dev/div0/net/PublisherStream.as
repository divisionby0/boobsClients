package dev.div0.net
{
	import dev.div0.Settings;
	import dev.div0.media.PublisherMedia;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class PublisherStream extends BaseStream
	{
		private var media:PublisherMedia;
		private var muteVolume:Number = 0.01;
		
		//private var streamMinBuffer:Number = 0.1;
		//private var streamMaxBuffer:Number = 0.8;
		
		public function PublisherStream(_id:String, media:PublisherMedia, muteVolume:Number)
		{
			super(_id);
			this.media = media;
			
			if(!isNaN(muteVolume)){
				this.muteVolume = muteVolume;
			}
		}
		
		override protected function createStream():void
		{
			if(!stream){
				stream = new NetStream(connection);
			}
			//stream.bufferTime = 0;
			//stream.bufferTimeMax = 0;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS,streamStatusHandler);
			
			var camera:Camera = media.getCamera();
			log("stream attaching camera: "+camera+"  name: "+camera.name);
			stream.attachCamera(camera);
			stream.attachAudio(media.getMicrophone());
			
			stream.soundTransform = new SoundTransform(1);
			
			var h264VieoCodec:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264VieoCodec.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_1);
			stream.videoStreamSettings = h264VieoCodec;
			
			stream.publish(Settings.streamID, 'live');
		}
		
		
		override protected function sendMetadata():void{
			var metaData:Object = new Object();
			metaData.cameraWidth = media.getCamera().width;
			metaData.cameraHeight = media.getCamera().height;
			//stream.send("@setDataFrame", "onMetaData", metaData); // FMS only
			stream.send("onMetaData", metaData);
		}
		
		override protected function onStreamBufferFull():void{
			/*
			log("onStreamBufferFull stream.bufferTime="+stream.bufferTime);
			if (stream.bufferTime != streamMinBuffer) 
			{
				log("setting stream buffer tome to min");
				stream.bufferTime = streamMinBuffer;
			}
			*/;
		}
		override protected function onStreamBufferEmpty():void{
			/*
			log("onStreamBufferEmpty stream.bufferTime="+stream.bufferTime);
			if (stream.bufferTime != streamMaxBuffer) 
			{
				log("setting stream buffer tome to max");
				stream.bufferTime = streamMaxBuffer;
			}
			*/
		}
		
		public function onMicrophoneMute():void{
			log("mute microphone muteVolume="+muteVolume);
			/*
			if(stream){
				stream.attachAudio(null);
			}
			*/
			if(stream){
				stream.soundTransform = new SoundTransform(0);
			}
		}
		
		public function onMicrophoneUnmute():void{
			log("unmute microphone");

			if(stream){
				stream.attachAudio(media.getMicrophone());
				stream.soundTransform = new SoundTransform(1);
			}
		}
		public function setCamera(camera:Camera):void{
			if(stream){
				stream.attachCamera(camera);
			}
		}
	}
}