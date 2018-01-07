package
{
	import com.bit101.components.Style;
	
	import dev.div0.RecorderSettings;
	import dev.div0.Settings;
	import dev.div0.net.StreamEvent;
	import dev.div0.ui.controls.RecorderControls;
	import dev.div0.ui.controls.RecorderControlsEvent;
	import dev.div0.ui.video.videoPlayer.TimeLeftView;
	import dev.div0.ui.video.videoPlayer.VideoPlayerEvent;
	import dev.div0.ui.video.videoPlayer.VideoPlayerView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Recorder extends Publisher
	{
		private static const RECORDING:String = "recording";
		private static const PLAYING:String = "playing";
		private static const IDLE:String = "idle";
		private static const WAITING_USER_MEDIA:String = "waitingUserMedia";
		
		private var recordTimer:Timer = new Timer(1000);
		
		private var recordedSeconds:int = 0;
		private var maxRecordedSeconds:int = 30;
		
		private var videoPlayerView:VideoPlayerView;
		private var timeLeftView:TimeLeftView;
		private var currentState:String = IDLE;
		
		private var controls:RecorderControls = new RecorderControls();
		
		private var streamRecorded:Boolean = false;
		
		public function Recorder(){
			Settings.startPublishButtonLabel = RecorderSettings.startRecordButtonLabel;
			Settings.stopPublishButtonLabel = RecorderSettings.stopRecordButtonLabel;
			
			Settings.rtmp = "rtmp://red5.divisionby0.ru:1935/liveRecorder/";
			
			Settings.debugHeaderLabel = RecorderSettings.debugRecorderLabel;
			
			if(this.loaderInfo.parameters["recordsBasePath"]){
				RecorderSettings.recordsBasePath = this.loaderInfo.parameters["recordsBasePath"];
			}
			
			createVideoPlayer();
			super();
			ver = "0.0.6";
			log(ver);
			createRecorderControls();
			createTimeLeftView();
			hidePlayer();
		}
		
		private function createRecorderControls():void
		{
			controls = new RecorderControls();
			addChild(controls);
			controls.addEventListener(RecorderControlsEvent.START_RECORD, startRecordHandler);
			controls.addEventListener(RecorderControlsEvent.STOP_RECORD, stopRecordHandler);
			
			controls.addEventListener(RecorderControlsEvent.START_PLAYING, startPlayingHandler);
			controls.addEventListener(RecorderControlsEvent.STOP_PLAYING, stopPlayingHandler);
			controls.addEventListener(RecorderControlsEvent.RECORD_COMPLETE, recordCompleteHandler);
		}
		
		private function startPlayingHandler(event:Event):void
		{
			startPlaying();
		}
		private function stopPlayingHandler(event:Event):void
		{
			stopPlaying();
		}
		
		private function stopRecordHandler(event:Event):void
		{
			stop();
		}
		
		private function startRecordHandler(event:Event):void
		{
			start();
		}
		
		private function createTimeLeftView():void
		{
			timeLeftView = new TimeLeftView();
			addChild(timeLeftView);
			timeLeftView.setValue(maxRecordedSeconds+" sec");
		}
		
		private function createVideoPlayer():void
		{
			videoPlayerView = new VideoPlayerView();
			addChild(videoPlayerView);
			videoPlayerView.addEventListener(VideoPlayerEvent.PLAYBACK_COMPLETE, playbackCompleteHandler);
		}
		
		private function playbackCompleteHandler(event:Event):void
		{
			currentState = IDLE;
			controls.playbackComplete();
		}
		
		private function stopPlayingRecordedRequestHandler(event:Event):void
		{
			stopPlaying();
		}
		
		private function playRecordedRequestHandler(event:Event):void
		{
			startPlaying();
		}
		
		private function recordCompleteHandler(event:Event):void
		{
			videoPlayerView.stop();
			stop();
			hidePlayer();
			showRecorder();
			sendVideoUrl();
			currentState = IDLE;
		}
		
		private function sendVideoUrl():void
		{
			var userVideoURL:String = RecorderSettings.recordsBasePath+Settings.streamID+RecorderSettings.recordContainerType;
			service.send(JSON.stringify({asEvent:'recordedStream', streamUrl:userVideoURL}));
			log(JSON.stringify({asEvent:'recordedStream', streamUrl:userVideoURL}));
		}
		
		override protected function cameraMutedHandler(event:Event):void
		{
			super.stop();
			currentState = WAITING_USER_MEDIA;
			stopTimer();
		}
		override protected function cameraUnmutedHandler(event:Event):void
		{
			super.cameraUnmutedHandler(null);
			start();
			startTimer();
		}
		
		override protected function start():void{
			if(currentState == IDLE || currentState == PLAYING){
				stopTimer();
				super.start();
				startRecord();
				currentState = RECORDING;
				streamRecorded = true;
			}
		}
		
		override protected function stop():void{
			if(currentState == RECORDING){
				controls.setUseStartPlayingControl(true);
				super.stop();
				
				videoPlayerView.stop();
				stopRecord();
				currentState = IDLE;
			}
		}
		
		private function startPlaying():void{
			if(currentState == RECORDING || (currentState == IDLE && streamRecorded)){
				stop();
				currentState = PLAYING;
				//sendVideoUrl();
				showPlayer();
				hideRecorder();
				videoPlayerView.start();
			}
			else if(currentState == PLAYING){
				videoPlayerView.start();
			}
		}
		
		private function stopPlaying():void
		{
			if(currentState == PLAYING){
				currentState = IDLE;
				videoPlayerView.stop();
			}
		}
		
		private function startRecord():void
		{
			trace("start record currentState="+currentState);
			if(currentState!=WAITING_USER_MEDIA){
				currentState = RECORDING;
				videoPlayerView.stop();
				showRecorder();
				startTimer();
			}
		}
		private function stopRecord():void
		{
			stopTimer();
			super.stop();
			
			hideRecorder();
			showPlayer();
			setVideoSource();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			recordedSeconds++;
			timeLeftView.setValue((maxRecordedSeconds-recordedSeconds)+" sec");
			if(recordedSeconds > maxRecordedSeconds){
				stopRecord();
				showPlayer();
				hideRecorder();
				controls.setUseStartPlayingControl(true);
				controls.recordComplete();
			}
		}
		
		private function startTimer():void{
			trace("start timer");
			recordTimer.reset();
			recordTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			recordTimer.start();
		}
		private function stopTimer():void{
			trace("stop timer");
			recordTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			//recordTimer.reset();
			recordTimer.stop();
			recordedSeconds = 0;
			timeLeftView.setValue((maxRecordedSeconds-recordedSeconds)+" sec");
		}
		
		private function showPlayer():void{
			videoPlayerView.visible = true;
		}
		private function hidePlayer():void{
			videoPlayerView.visible = false;
		}
		
		private function showRecorder():void{
			timeLeftView.visible = true;
			videoView.visible = true;
			showPublisherScreen();
		}
		private function hideRecorder():void{
			timeLeftView.visible = false;
			videoView.visible = false;
			hidePublisherScreen();
		}
		
		private function setVideoSource():void
		{
			videoPlayerView.setVideoSource(Settings.streamID+RecorderSettings.recordContainerType);
		}
	}
}