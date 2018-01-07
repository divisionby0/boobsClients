package
{
	import dev.div0.Settings;
	import dev.div0.media.PublisherMedia;
	import dev.div0.net.P2PSubscribeStream;
	import dev.div0.net.PublisherStream;
	import dev.div0.net.StreamEvent;
	import dev.div0.net.SubscriberP2PStream;
	import dev.div0.net.SubscriberStream;
	import dev.div0.service.JSService;
	import dev.div0.service.JSServiceEvent;
	import dev.div0.ui.controls.ControlsEvent;
	import dev.div0.ui.controls.DebugControlsView;
	import dev.div0.ui.controls.playerControls.SubscriberPlayerControlsView;
	import dev.div0.ui.log.LogView;
	import dev.div0.ui.video.PublisherVideoView;
	import dev.div0.ui.video.SubscriberVideoView;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Camera;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	
	public class SubscriberP2P extends Sprite
	{
		private var service:JSService;
		private var logView:LogView;
		private var controlsView:DebugControlsView;
		private var videoView:Sprite;
		private var stream:P2PSubscribeStream;
		private var publisherImage:Bitmap;
		private var publisherImageUrl:String = "images/1.jpeg";
		
		private var _id:String;
		
		private var ver:String = "0.3.4";
		
		private var _publisherId:String;
		private var debug:Boolean = true;
		private var publisherImageContainer:Sprite = new Sprite();
		
		private var playerControls:SubscriberPlayerControlsView;
		private var screenState:String;
		
		public function SubscriberP2P()
		{
			screenState = SubscriberPlayerControlsView.NORMAL;
			
			_id = "user_"+generateRandomString(32);
			var debugFlashVar:int = 1;
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			if(this.loaderInfo.parameters["debug"])
			{
				debugFlashVar = this.loaderInfo.parameters["debug"];
			}
			
			if(this.loaderInfo.parameters["publisherImage"]){
				publisherImageUrl = this.loaderInfo.parameters["publisherImage"];
			}
			
			if(debugFlashVar != 1){
				debug = false;
			}
			
			addChild(publisherImageContainer);
			createPublisherImage();
			createVideo();
			logView = new LogView();
			addChild(logView);
			
			logView.visible = debug;
			
			log(ver);
			log("_id="+_id);
			
			service = new JSService();
			service.addEventListener(JSServiceEvent.DATA, jsDataHandler);
			service.init();
			
			createDebugControls();
			
			createPlayerControls();
			
			updateStage();
			
			_publisherId = 'user_dZyHcoFBAcSqWoHiYMt36IT7x5wWyCoP';
			start();
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
		
		private function createPlayerControls():void
		{
			playerControls = new SubscriberPlayerControlsView();
			addChild(playerControls);
			playerControls.addEventListener(ControlsEvent.FULLSCREEN_CLICKED, fullscreenClickedHandler);
		}
		
		private function fullscreenClickedHandler(event:Event):void
		{
			switch(screenState){
				case SubscriberPlayerControlsView.NORMAL:
					stage.displayState = StageDisplayState.FULL_SCREEN; 
					screenState = SubscriberPlayerControlsView.FULLSCREEN;
					break;
				case SubscriberPlayerControlsView.FULLSCREEN:
					stage.displayState = StageDisplayState.NORMAL; 
					screenState = SubscriberPlayerControlsView.NORMAL;
					break;
			}
		}
		
		private function updateStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			resizeImage();
			placeImage();
		}
		
		private function createPublisherImage():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, publisherImageLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, publisherImageIOErrorHandler);
			log("loading image "+publisherImageUrl);
			
			loader.load(new URLRequest(publisherImageUrl));
		}
		
		private function publisherImageIOErrorHandler(event:IOErrorEvent):void
		{
			log("Image IOError "+event.text);
		}
		
		private function publisherImageLoadComplete(event:Event):void
		{
			publisherImage = Bitmap(LoaderInfo(event.target).content);
			publisherImageContainer.addChild(publisherImage);
			resizeImage();
			placeImage();
		}
		
		private function placeImage():void
		{
			publisherImageContainer.x = (stage.stageWidth - publisherImageContainer.width)/2;
			publisherImageContainer.y = (stage.stageHeight - publisherImageContainer.height)/2;
		}
		
		private function resizeImage():void
		{
			if(publisherImageContainer && publisherImage){
				var scaleWidth:Number = publisherImage.width / publisherImageContainer.width;
				var scaleHeight:Number = stage.stageHeight / publisherImageContainer.height;
				
				if (scaleWidth < scaleHeight)
					publisherImageContainer.scaleX = publisherImageContainer.scaleY = scaleWidth;
				else
					publisherImageContainer.scaleX = publisherImageContainer.scaleY = scaleHeight;
			}
		}
		private function start():void{
			createStream();
			stream.start();
		}
		private function stop():void{
			if(stream){
				stream.stop();
			}
			(videoView as SubscriberVideoView).clear();
		}
		
		private function jsDataHandler(event:JSServiceEvent):void
		{
			var jsData:Object = JSON.parse(event.data.toString());
			var comand:String = jsData.comand;
			var comandData:Object = jsData.comandData;
			if(comand){
				switch(comand){
					case Settings.SET_DATA_COMAND:
						_id = comandData.id;
						break;
					case Settings.START:
						_publisherId = comandData.publisherStream;
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
			controlsView = new DebugControlsView(debug, "SUBSCRIBER");
			addChild(controlsView);
			controlsView.visible = debug;
			controlsView.addEventListener(ControlsEvent.START_CLICKED, startClickHandler);
			controlsView.addEventListener(ControlsEvent.STOP_CLICKED, stopClickHandler);
		}
		
		private function stopClickHandler(event:Event):void
		{
			stop();
		}
		
		private function startClickHandler(event:Event):void
		{
			start();
		}
		
		private function createStream():void{
			if(!stream){
				stream = new P2PSubscribeStream(_publisherId);
				Dispatcher.getInstance().addEventListener(StreamEvent.STREAM_STARTED, streamStartedHandler);
			}
		}
		
		private function streamStartedHandler(event:StreamEvent):void
		{
			(videoView as SubscriberVideoView).setStream(stream.getStream());
			// send data to js with userId
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
		
		private function createVideo():void{
			videoView = new SubscriberVideoView();
			addChild(videoView);
		}
		
		private function log(param0:String):void
		{
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}