package dev.div0.ui.video
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class PublisherVideoView extends Sprite
	{
		private var camera:Camera;
		private var video:Video;
		
		private var videoWidth:int = 480;
		private var videoHeight:int = 289;
		
		public function PublisherVideoView(camera:Camera = null)
		{
			this.camera = camera;
			super();
			create();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageResizeHandler(null);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			try{
				video.width = stage.stageWidth;
				video.height = stage.stageHeight;
			}
			catch(error:Error){
				log("self video resize error "+error.message);
			}
		}
		
		public function setCamera(camera:Camera):void{
			this.camera = camera;
			if(video){
				video.visible = true;
			}
			attachStream();
		}
		public function removeCamera():void{
			if(video){
				video.attachCamera(null);
				video.clear();
				video.visible = false;
			}
		}
		private function create():void{
			video = new Video(videoWidth, videoHeight);
			addChild(video);
			attachStream();
		}
		
		private function attachStream():void{
			if(video && camera){
				video.attachCamera(camera);
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