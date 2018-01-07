// знаю что даже намека нет на инкапсуляцию и ООП. Но нет времени
package dev.div0.ui.video.videoPlayer
{
	
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	
	import dev.div0.RecorderSettings;
	import dev.div0.Settings;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayerView extends Sprite
	{
		private static const PLAYING:String = "playing";
		private static const STOPED:String = "stoped";
		
		private var hLayout:HBox;
		private var video:Video;
		
		/*
		private var playButton:PushButton;
		private var stopButton:PushButton;
		private var completeButton:PushButton;
		private var recordAgainButton:PushButton;
		*/
		
		private var videoSource:String;
		private var stream:NetStream;
		private var streamClient:Object;
		private var connection:NetConnection;
		
		private var streamName:String;
		
		private var currentState:String = STOPED;
		
		private var tempLabel:Label;
		
		public function VideoPlayerView()
		{
			super();
			createVideo();
			createLayout();
			createConnection();
			createStream();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			tempLabel = new Label(this, 200,0, "Video player");
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageResizeHandler(null);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			video.width = stage.stageWidth;
			video.height = stage.stageHeight;
			hLayout.y = stage.stageHeight - 40;
		}
		
		public function onPlayStatus(data:Object):void{
			if(data.code == "NetStream.Play.Complete"){
				log("FINISHED");
				currentState = STOPED;
				var videoPlayerEvent:VideoPlayerEvent = new VideoPlayerEvent(VideoPlayerEvent.PLAYBACK_COMPLETE);
				dispatchEvent(videoPlayerEvent);
			}
		}
		
		private function createStream():void
		{
			stream = new NetStream(connection);
			video.attachNetStream(stream);
			stream.client = this;
			stream.addEventListener(NetStatusEvent.NET_STATUS,streamStatusHandler);
		}
		
		private function streamStatusHandler(event:NetStatusEvent):void
		{
			switch(event.info.code){
				case "NetStream.Play.StreamNotFound":
					log("STREAM_NOT_FOUND_ERROR. Stream name = "+streamName);
					break;
			}
		}
		
		private function createConnection():void
		{
			connection = new NetConnection();
			connection.connect(null);
		}
		
		public function setVideoSource(url:String):void{
			videoSource = url;
		}
		
		public function start():void{
			if(videoSource && videoSource!=""){
				stop();
				streamName = RecorderSettings.recordsBasePath+videoSource+"?"+Math.random();
				stream.play(streamName);
				currentState = PLAYING;
			}
		}
		
		private function createVideo():void
		{
			video = new Video();
			addChild(video);
		}
		
		private function createLayout():void
		{
			hLayout = new HBox(this);
		}
		
		private function createControls():void
		{
			/*
			playButton = new PushButton(hLayout,0,0, "Play");
			stopButton = new PushButton(hLayout,0,0, "Stop");
			recordAgainButton = new PushButton(hLayout,0,0, "Record again");
			completeButton = new PushButton(hLayout,0,0, "That's my favorite !");
			addButtonListeners();
			*/
		}
		
		private function addButtonListeners():void
		{
			/*
			playButton.addEventListener(MouseEvent.CLICK, playButtonClickHandler);
			completeButton.addEventListener(MouseEvent.CLICK, completeButtonClickHandler);
			stopButton.addEventListener(MouseEvent.CLICK, stopButtonClickHandler);
			recordAgainButton.addEventListener(MouseEvent.CLICK, recordAgainButtonClickHandler);
			*/
		}
		
		private function recordAgainButtonClickHandler(event:MouseEvent):void
		{
			stop();
			var videoPlayerEvent:VideoPlayerEvent = new VideoPlayerEvent(VideoPlayerEvent.RECORD_AGAIN);
			dispatchEvent(videoPlayerEvent);
		}
		
		private function stopButtonClickHandler(event:MouseEvent):void
		{
			stop();
		}
		
		public function stop():void{
			currentState = STOPED;
			stream.close();
			video.clear();
		}
		
		private function completeButtonClickHandler(event:MouseEvent):void
		{
			stop();
			var videoPlayerEvent:VideoPlayerEvent = new VideoPlayerEvent(VideoPlayerEvent.RECORD_COMPLETE);
			dispatchEvent(videoPlayerEvent);
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