package dev.div0.ui.video
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class SubscriberVideoView extends Sprite
	{
		private var stream:NetStream;
		private var video:Video;
		
		private var videoWidth:int = 480;
		private var videoHeight:int = 289;
		
		public function SubscriberVideoView()	
		{
			create();
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function clear():void{
			if(video){
				video.attachNetStream(null);
				video.clear();
				//video.visible = false;
			}
		}
		public function setStream(stream:NetStream):void
		{
			this.stream = stream;
			attachStream();
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
		}
		
		private function create():void{
			video = new Video(videoWidth, videoHeight);
			addChild(video);
			attachStream();
		}
		
		private function attachStream():void{
			if(video && stream){
				//video.visible = true;
				
				video.attachNetStream(stream);
			}
		}
		
		private function log(param0:String):void
		{
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}