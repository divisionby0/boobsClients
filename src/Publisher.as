package
{
	import dev.div0.AppEvent;
	import dev.div0.Settings;
	import dev.div0.media.MediaEvent;
	import dev.div0.media.PublisherMedia;
	import dev.div0.net.PublisherStream;
	import dev.div0.net.RtmpConnection;
	import dev.div0.net.RtmpConnectionEvent;
	import dev.div0.net.StreamEvent;
	import dev.div0.service.JSServiceEvent;
	import dev.div0.ui.ErrorView;
	import dev.div0.ui.image.BackgroundImage;
	import dev.div0.ui.video.PublisherVideoView;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.StringUtil;
	
	import flash.events.Event;

	public class Publisher extends BaseApplication
	{
		private var media:PublisherMedia;
		private var stream:PublisherStream;
		
		private var backgroundImageUrl:String;
		private var connection:RtmpConnection;
		
		private static var IDLE:String = "IDLE";
		private static var CONNECTING:String = "CONNECTING";
		private static var CONNECTION_ERROR:String = "CONNECTION_ERROR";
		
		private var currentState:String;
		
		private var currentErrorText:String;
		
		public function Publisher()
		{
			ver = "0.5.1";
			
			addAppEventListener();
			createLog();
			
			createConnection();
			
			if(this.loaderInfo.parameters["backgroundImageUrl"]){
				backgroundImageUrl = this.loaderInfo.parameters["backgroundImageUrl"];
			}
			else{
				log("No background image info");
			}
			
			var backgroundImage:BackgroundImage = new BackgroundImage(backgroundImageUrl);
			addChildAt(backgroundImage, 0);
		}
		
		
		private function createConnection():void{
			currentState = CONNECTING;
			
			onStateChanged();
			
			Dispatcher.getInstance().addEventListener(RtmpConnectionEvent.CONNECT_ERROR, onConnectError);
			Dispatcher.getInstance().addEventListener(RtmpConnectionEvent.CONNECT_SUCCESS, onConnectSuccess);
			connection = new RtmpConnection();
			connection.connect(Settings.rtmp);
		}
		
		private function addAppEventListener():void
		{
			Dispatcher.getInstance().addEventListener(AppEvent.APPLICATION_READY, applicationReadyHandler);
		}
		
		private function applicationReadyHandler(event:Event):void
		{
			Dispatcher.getInstance().removeEventListener(AppEvent.APPLICATION_READY, applicationReadyHandler);
			trace("App ready");
			startApp();
		}
		
		private function startApp():void
		{
			trace("publisher added to stage");
			init();
			addMediaListeners();
			bringLogToFront();
		}
		
		private function addMediaListeners():void
		{
			Dispatcher.getInstance().addEventListener(MediaEvent.CAMERA_MUTED, cameraMutedHandler);
			Dispatcher.getInstance().addEventListener(MediaEvent.CAMERA_UNAVAILABLE, cameraUnavailableHandler);
			Dispatcher.getInstance().addEventListener(MediaEvent.CAMERA_UNMUTED, cameraUnmutedHandler);
		}
		
		private function cameraUnavailableHandler(event:MediaEvent):void
		{
			service.send(JSON.stringify({asEvent:"cameraUnavailable"}));
		}
		
		public function showPublisherScreen():void{
			(videoView as PublisherVideoView).visible = true;
		}
		public function hidePublisherScreen():void{
			(videoView as PublisherVideoView).visible = false;
		}
		
		override protected function start():void{
			createMedia();
			createStream();
			stream.start();
		}
		
		override protected function stop():void{
			if(stream){
				stream.stop();
			}
			(videoView as PublisherVideoView).removeCamera();
			
			if(media){
				media.clear();
			}
			stream = null;
		}
		
		override protected function muteMicrophone():void{
			stream.onMicrophoneMute();
			media.onMicrophoneMute();
		}
		override protected function unmuteMicrophone():void{
			media.onMicrophoneUnmute();
			stream.onMicrophoneUnmute();
		}
		
		override protected function jsDataHandler(event:JSServiceEvent):void
		{
			super.jsDataHandler(event);
			
			if(jsComand){
				switch(jsComand){
					case Settings.START:
						start();
						break;
					case Settings.STOP:
						createStreamName();
						stop();
						break;
					case Settings.PAUSE:
						stop();
						break;
					case Settings.MICROPHONE_MUTE:
						muteMicrophone();
						service.send(JSON.stringify({microphoneStatus:media.getMicrophoneStatus(), asEvent:"streamMicState"}));
						break;
					case Settings.MICROPHONE_UNMUTE:
						unmuteMicrophone();
						service.send(JSON.stringify({microphoneStatus:media.getMicrophoneStatus(), asEvent:"streamMicState"}));
						break;
					case Settings.GET_MICROPHONE_STATUS:
						service.send(JSON.stringify({microphoneStatus:media.getMicrophoneStatus(), asEvent:"streamMicState"}));
						break;
				}
			}
		}
		
		private function createMedia():void{
			if(!media){
				media = new PublisherMedia(defaultCameraWidth, defaultCameraHeight, defaultFPS);
			}
			else{
				media.init();
			}
			
			(videoView as PublisherVideoView).setCamera(media.getCamera());
		}
		
		protected function cameraUnmutedHandler(event:Event):void
		{
			Dispatcher.getInstance().removeEventListener(MediaEvent.CAMERA_UNMUTED, cameraUnmutedHandler);
		}
		
		protected function cameraMutedHandler(event:Event):void
		{
			
		}
		private function createStream():void
		{
			if(!stream){
				stream = new PublisherStream(_streamId, media, muteVolume);
				Dispatcher.getInstance().addEventListener(StreamEvent.STREAM_STARTED, streamStartedHandler);
			}
			else{
				
				trace("Stream exists !!!");
			}
		}
		
		protected function streamStartedHandler(event:StreamEvent):void
		{
			service.send(JSON.stringify({asEvent:'streamStarted', streamId:event.data}));
		}
		
		override protected function createVideo():void{
			videoView = new PublisherVideoView();
			addChildAt(videoView, 1);
		}
		
		private function onConnectError(event:RtmpConnectionEvent):void{
			currentState = CONNECTION_ERROR;
			currentErrorText = event.data;
			onStateChanged();
		}
		private function onConnectSuccess(event:RtmpConnectionEvent):void{
			currentState = IDLE;
			onStateChanged();
		}
		
		private function onStateChanged():void{
			switch(currentState){
				case CONNECTION_ERROR:
					onConnectionError();
					break;
				case IDLE:
					
					break;
			}
		}
		
		private function onConnectionError():void{
			var errorView:ErrorView = new ErrorView("RtmpConnect error. "+currentErrorText);
			addChild(errorView);
		}
	}
}