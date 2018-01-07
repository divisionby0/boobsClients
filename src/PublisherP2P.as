package
{
	import dev.div0.Settings;
	import dev.div0.media.PublisherMedia;
	import dev.div0.net.P2PPublishStream;
	import dev.div0.net.PublisherP2PStream;
	import dev.div0.net.PublisherStream;
	import dev.div0.net.StreamEvent;
	import dev.div0.service.JSService;
	import dev.div0.service.JSServiceEvent;
	import dev.div0.ui.controls.ControlsEvent;
	import dev.div0.ui.controls.DebugControlsView;
	import dev.div0.ui.log.LogView;
	import dev.div0.ui.video.PublisherVideoView;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Camera;
	import flash.utils.setInterval;
	
	public class PublisherP2P extends Sprite
	{
		private var service:JSService;
		private var logView:LogView;
		private var debugControlsView:DebugControlsView;
		private var videoView:Sprite;
		private var media:PublisherMedia;
		private var stream:P2PPublishStream;
		
		private var _id:String;

		private var ver:String = "0.4.7";
		private var debug:Boolean = true;
		
		public function PublisherP2P()
		{
			updateStage();
			var debugFlashVar:int =1;
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			if(this.loaderInfo.parameters["debug"]){
				debugFlashVar = this.loaderInfo.parameters["debug"];
			}
			
			if(debugFlashVar != 1){
				debug = false;
			}
			
			_id = "user_"+generateRandomString(32);
			
			createVideo();
			logView = new LogView();
			addChild(logView);
			log("_id="+_id);
			
			logView.visible = debug;
			
			log(ver);
			service = new JSService();
			service.addEventListener(JSServiceEvent.DATA, jsDataHandler);
			service.init();
			
			createDebugControls();
			log("debugFlashVar="+debugFlashVar);
		}
		
		private function updateStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
		}
		
		private function start():void{
			createMedia();
			createStream();
			stream.start();
		}
		
		private function stop():void{
			if(stream){
				stream.stop();
			}
			
			try{
				(videoView as PublisherVideoView).removeCamera();
			}
			catch(error:Error){
				log("error removing camera after stop "+error.message);
			}
			if(media)
			{
				media.clear();
			}
		}
		
		
		private function jsDataHandler(event:JSServiceEvent):void
		{
			var jsData:Object = JSON.parse(event.data.toString());
			var comand:String = jsData.comand;
			var comandData:Object = jsData.comandData;
			if(comand){
				switch(comand){
					case Settings.SET_DATA_COMAND:
						//_id = comandData.id;
						break;
					case Settings.START:
						start();
						break;
					case Settings.STOP:
						stop();
						break;
				}
			}
		}
		
		private function createDebugControls():void
		{
			debugControlsView = new DebugControlsView(debug, "PUBLISHER");
			addChild(debugControlsView);
			
			debugControlsView.visible = debug;
			debugControlsView.addEventListener(ControlsEvent.START_CLICKED, startClickHandler);
			debugControlsView.addEventListener(ControlsEvent.STOP_CLICKED, stopClickHandler);
		}
		
		private function stopClickHandler(event:Event):void
		{
			stop();
		}
		
		private function startClickHandler(event:Event):void
		{
			start();
		}
		
		private function createMedia():void
		{
			if(!media)
			{
				media = new PublisherMedia();
			}
			else
			{
				media.init();
			}
			
			try{
				(videoView as PublisherVideoView).setCamera(media.getCamera());
			}
			catch(error:Error){
				log("Error set camera to videoView. "+error.message);
			}
		}
		
		private function createStream():void{
			if(!stream){
				stream = new P2PPublishStream(_id, media);
				Dispatcher.getInstance().addEventListener(StreamEvent.STREAM_STARTED, streamStartedHandler);
			}
		}
		
		private function streamStartedHandler(event:StreamEvent):void
		{
			try{
				service.send(JSON.stringify({asEvent:'streamStarted', data:event.data}));
			}
			catch(error:Error){
				log("Error sending data to outside "+error.message);
			}
		}
		
		private function createVideo():void{
			videoView = new PublisherVideoView();
			addChild(videoView);
		}
		
		private function generateRandomString(strlen:Number):String{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var num_chars:Number = chars.length - 1;
			var randomChar:String = "";
			
			for (var i:Number = 0; i < strlen; i++){
				randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
			}
			return randomChar;
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				// do something with the error
				log("uncaughtError error : "+error.message);
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				// do something with the error
				log("uncaughtError errorEvent : "+errorEvent.text);
			}
			else
			{
				// a non-Error, non-ErrorEvent type was thrown and uncaught
				log("uncaughtError : a non-Error, non-ErrorEvent type was thrown and uncaught");
			}
		}
		
		private function log(param0:String):void
		{
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
			
			if(service && service.inited){
				service.send(JSON.stringify({asEvent:'log', data:param0}));
			}
		}
	}
}