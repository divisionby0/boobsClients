package
{
	import dev.div0.AppEvent;
	import dev.div0.Settings;
	import dev.div0.error.GlobalErrorHandling;
	import dev.div0.service.JSService;
	import dev.div0.service.JSServiceEvent;
	import dev.div0.ui.controls.ControlsEvent;
	import dev.div0.ui.controls.DebugControlsView;
	import dev.div0.ui.log.LogView;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.StringUtil;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;

    public class BaseApplication extends Sprite
	{
		protected var ver:String;
		protected var service:JSService;
		protected var _streamId:String;
		protected var debug:Boolean = true;
		protected var useLog:Boolean = true;
		protected var logView:LogView;
		protected var videoView:Sprite;
		protected var debugControlsView:DebugControlsView;
		protected var defaultCameraWidth:int = 0;
		protected var defaultCameraHeight:int = 0;
		protected var defaultFPS:int = 0;
		protected var muteVolume:Number = 0.01;
		
		protected var jsData:Object;
		protected var jsComand:String;
		protected var jsComandData:Object;
		
		protected function init():void{
			new GlobalErrorHandling(loaderInfo);
			
			createLog();
			log("init");
			log(ver);
			
			getFlashVars();
			createStreamName();
			
			createVideo();
			
			createJsService();
			createDebugControls();
			updateStage();
			updateLogVisibility();
		}
		
		private function updateLogVisibility():void
		{
			//useLog = false;
			if(logView){
				logView.visible = useLog;
			}
		}
		protected function moveLogViewUp():void{
			setChildIndex(logView, numChildren-1);
		}
		
		private function dispatchAppReadyEvent():void
		{
			Dispatcher.getInstance().dispatchEvent(new AppEvent(AppEvent.APPLICATION_READY));
		}
		
		private function getFlashVars():void
		{
			log("get flash vars...");
			log("Settings.rtmp = "+Settings.rtmp+"  flashvar rtmp="+this.loaderInfo.parameters["rtmp"]+" useLog="+this.loaderInfo.parameters["useLog"]+"  streamId="+this.loaderInfo.parameters["streamId"]+" camWidth:"+this.loaderInfo.parameters["cameraWidth"]+"  camHeight="+this.loaderInfo.parameters["cameraHeight"]+"  fps="+this.loaderInfo.parameters["fps"]+"  muteVolume="+this.loaderInfo.parameters["muteVolume"]);
			var debugFlashVar:int =1;
			var useLogFlashVar:int =1;
			
			if(this.loaderInfo.parameters["streamId"]){
				_streamId = this.loaderInfo.parameters["streamId"];
			}
			
			if(this.loaderInfo.parameters["debug"]){
				debugFlashVar = this.loaderInfo.parameters["debug"];
			}

			if(this.loaderInfo.parameters["muteVolume"]){
				muteVolume = this.loaderInfo.parameters["muteVolume"];
			}

			if(this.loaderInfo.parameters["rtmp"]){
				Settings.rtmp = this.loaderInfo.parameters["rtmp"];
			}
			
			if(this.loaderInfo.parameters["cameraWidth"]){
				defaultCameraWidth = this.loaderInfo.parameters["cameraWidth"];
			}
			if(this.loaderInfo.parameters["cameraHeight"]){
				defaultCameraHeight = this.loaderInfo.parameters["cameraHeight"];
			}
			if(this.loaderInfo.parameters["fps"]){
				defaultFPS = this.loaderInfo.parameters["fps"];
			}
			
			if(debugFlashVar != 1){
				debug = false;
			}
			if(useLogFlashVar != 1){
				useLog = false;
			}
		}
		
		protected function createJsService():void
		{
			log("BaseApp createJsService");
			service = new JSService();
			service.addEventListener(JSServiceEvent.DATA, jsDataHandler);
			service.init(ver);
		}
		
		private function createDebugControls():void
		{
			debugControlsView = new DebugControlsView(debug, Settings.debugHeaderLabel);
			
			debugControlsView.visible = debug;
			
			addChild(debugControlsView);
			debugControlsView.addEventListener(ControlsEvent.START_CLICKED, startClickHandler);
			debugControlsView.addEventListener(ControlsEvent.STOP_CLICKED, stopClickHandler);
			debugControlsView.addEventListener(ControlsEvent.MICROPHONE_STATE_CHANGE_REQUEST, microphoneStateChangeRequestHandler);
		}
		
		protected function microphoneStateChangeRequestHandler(event:ControlsEvent):void
		{
			if(event.data == true){
				unmuteMicrophone();
			}
			else{
				muteMicrophone();
			}
		}
		
		protected function createVideo():void{
			
		}
		
		
		protected function jsDataHandler(event:JSServiceEvent):void
		{
			jsData = JSON.parse(event.data.toString());
			jsComand = jsData.comand;
			jsComandData = jsData.comandData;
		}
		
		protected function createStreamName():void
		{
			if(!_streamId){
				log("stream name not set - generating");
				_streamId = "user_"+StringUtil.generateRandomString(32);
			}
			else{
				log("stream name set from outside to "+_streamId);
			}
			
			log("_streamId "+_streamId);
			
			//_id = 'publisherStream';
			Settings.streamID = _streamId;
		}
		
		private function stopClickHandler(event:Event):void
		{
			stop();
		}
		
		private function startClickHandler(event:Event):void
		{
			start();
		}
		
		protected function start():void{
			
		}
		protected function stop():void{
			
		}
		
		protected function muteMicrophone():void{
			
		}
		protected function unmuteMicrophone():void{
			
		}
		
		private function updateStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
		}
		
		protected function log(param0:String):void
		{
			trace(param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
		
		protected function createLog():void
		{
			Dispatcher.getInstance().addEventListener(LogEvent.LOG_READY, logReadyHandler);
			
			logView = new LogView();
			updateLogVisibility();
			addChildAt(logView, 0);
		}
		protected function bringLogToFront():void{
			setChildIndex(logView, numChildren - 1);
		}
		
		private function logReadyHandler(event:Event):void
		{
			Dispatcher.getInstance().removeEventListener(LogEvent.LOG_READY, logReadyHandler);
			dispatchAppReadyEvent();
		}
	}
}