package
{
	import avmplus.getQualifiedClassName;
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.PushButton;
	
	import dev.div0.Settings;
	import dev.div0.media.MediaEvent;
	import dev.div0.media.PublisherMedia;
	import dev.div0.net.PublisherStream;
	import dev.div0.net.StreamEvent;
	import dev.div0.ui.video.PublisherVideoView;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.ButtonAsset;

	public class GetMediaTest extends BaseApplication
	{
		private var publisherMedia:PublisherMedia;
		
		private var mediaSettingsView:Sprite;
		private var controlsView:Sprite;
		private var startPublisheButton:ButtonAsset
		
		private var showMediaSelectionViewControl:CheckBox;
		
		private var selfVideoView:PublisherVideoView;
		private var stream:PublisherStream;
		
		public function GetMediaTest()
		{
			ver = "0.0.1";
			
			_streamId = "testingStream_"+Math.round(Math.random()*100000);
			Settings.streamID = _streamId;
			
			createLog();
			log(ver);
			createJsService();
			createVideo();
			
			mediaSettingsView = new Sprite();
			addChild(mediaSettingsView);
			
			publisherMedia = new PublisherMedia();
			publisherMedia.showMediaSelectionView(mediaSettingsView);
			
			attachCamera();
			Dispatcher.getInstance().addEventListener(MediaEvent.USER_CAMERA_CHANGED, onUserCameraChanged);
			
			createControls();
			moveLogViewUp();
		}
		
		private function createControls():void
		{
			controlsView = new Sprite();
			addChild(controlsView);
			
			showMediaSelectionViewControl = new CheckBox(controlsView, 230, 10, "mediaSelectionView", onShowMediaSelectionViewControlChanged);
			showMediaSelectionViewControl.selected = true;
			
			var publishButton:PushButton = new PushButton(controlsView, 330,0, "publish", onPublishButtonClicked);
		}
		
		private function onPublishButtonClicked(event:Event):void{
			log("on publish clicked");
			createStream();
			stream.start();
		}
		
		private function createStream():void
		{
			if(!stream){
				stream = new PublisherStream(_streamId, publisherMedia, muteVolume);
				Dispatcher.getInstance().addEventListener(StreamEvent.STREAM_STARTED, streamStartedHandler);
			}
			else{
				log("Stream exists !!!");
			}
		}
		
		protected function streamStartedHandler(event:StreamEvent):void
		{
			log("streamStartedHandler  id="+event.data);
			service.send(JSON.stringify({asEvent:'streamStarted', streamId:event.data}));
		}
		
		
		private function onShowMediaSelectionViewControlChanged(event:Event):void{			
			if(showMediaSelectionViewControl.selected){
				publisherMedia.showMediaSelectionView(mediaSettingsView);
			}
			else{
				publisherMedia.hideMediaSelectionView(mediaSettingsView);
			}
		}
		
		private function attachCamera():void
		{
			selfVideoView.setCamera(publisherMedia.getCamera());
			if(stream){
				stream.setCamera(publisherMedia.getCamera());
			}
		}
		
		private function onUserCameraChanged(event:Event):void
		{
			attachCamera();
		}
		
		override protected function createVideo():void{
			var videoViewContainer:Sprite = new Sprite();
			addChild(videoViewContainer);
			
			selfVideoView = new PublisherVideoView();
			videoViewContainer.addChild(selfVideoView);
		}
		
		override protected function log(param0:String):void
		{
			trace("["+getQualifiedClassName(this)+"] "+param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}