package dev.div0.ui.controls
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RecorderControls extends Sprite
	{
		private static const IDLE:String = "idle";
		private static const RECORDING:String = "recording";
		private static const PLAYING:String = "playing";
		
		private var startRecordButton:HideableButton;
		private var stopRecordButton:HideableButton;
		private var startPlayButton:HideableButton;
		private var stopPlayButton:HideableButton;
		private var recordAgainButton:HideableButton;
		private var recordCompleteButton:HideableButton;
		
		private var layout:HBox;
		
		private var currentState:String = IDLE;
		
		private var useStartPlayingControl:Boolean = false;
		
		public function RecorderControls()
		{
			super();
			createLayout();
			createButtons();
			createButtonListeners();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			updateState();
		}
		
		public function setUseStartPlayingControl(value:Boolean):void{
			useStartPlayingControl = value;
		}
		public function playbackComplete():void{
			currentState = IDLE;
			updateState();
		}
		public function recordComplete():void{
			currentState = IDLE;
			updateState();
		}
		
		private function updateState():void
		{
			switch(currentState){
				case IDLE:
					showStartRecordButton();
					hideStopPlaybackButton();
					hideStopRecordButton();
					
					if(useStartPlayingControl){
						showStartPlaybackButton();
						showRecordCompleteButton();
					}
					else{
						hideStartPlaybackButton();
						hideRecordCompleteButton();
					}
					break;
				case RECORDING:
					hideStartRecordButton();
					hideStopPlaybackButton();
					showStopRecordButton();
					hideStartPlaybackButton();
					showRecordCompleteButton();
					hideRecordCompleteButton();
					break;
				case PLAYING:
					showStartRecordButton();
					showStopPlaybackButton();
					hideStopRecordButton();
					showRecordCompleteButton();
					break;
			}
		}		
		
		private function showStartRecordButton():void
		{
			startRecordButton.show();
		}
		private function hideStartRecordButton():void
		{
			startRecordButton.hide();
		}
		private function showStopRecordButton():void
		{
			stopRecordButton.show();
		}
		private function hideStopRecordButton():void
		{
			stopRecordButton.hide();
		}
		
		private function showStartPlaybackButton():void
		{
			startPlayButton.show();
		}
		private function hideStartPlaybackButton():void
		{
			startPlayButton.hide();
		}
		
		private function showStopPlaybackButton():void
		{
			stopPlayButton.show();
		}
		private function hideStopPlaybackButton():void
		{
			stopPlayButton.hide();
		}
		
		private function showRecordCompleteButton():void
		{
			recordCompleteButton.show();
		}
		private function hideRecordCompleteButton():void
		{
			recordCompleteButton.hide();
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageResizeHandler(null);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			layout.y = stage.stageHeight - 22;
			layout.x = 2;
		}
		
		private function createButtons():void
		{
			startRecordButton = new HideableButton(layout,0,0,"Start record");
			stopRecordButton = new HideableButton(layout,0,0,"Stop record");
			startPlayButton = new HideableButton(layout,0,0,"Play");
			stopPlayButton = new HideableButton(layout,0,0,"Stop");
			
			recordCompleteButton = new HideableButton(layout,0,0, "Save my recording & add to auto tweet!", null, 230);
		}
		private function createButtonListeners():void
		{
			startRecordButton.addEventListener(MouseEvent.CLICK, startRecordButtonClickHandler);
			stopRecordButton.addEventListener(MouseEvent.CLICK, stopRecordButtonClickHandler);
			startPlayButton.addEventListener(MouseEvent.CLICK, startPlayingButtonClickHandler);
			stopPlayButton.addEventListener(MouseEvent.CLICK, stopPlayingButtonClickHandler);
			recordCompleteButton.addEventListener(MouseEvent.CLICK, recordCompleteButtonClickHandler);
		}
		
		private function recordCompleteButtonClickHandler(event:MouseEvent):void
		{
			var recorderControlsEvent:RecorderControlsEvent = new RecorderControlsEvent(RecorderControlsEvent.RECORD_COMPLETE);
			dispatchEvent(recorderControlsEvent);
			currentState = IDLE;
			updateState();
		}
		
		private function stopPlayingButtonClickHandler(event:MouseEvent):void
		{
			var recorderControlsEvent:RecorderControlsEvent = new RecorderControlsEvent(RecorderControlsEvent.STOP_PLAYING);
			dispatchEvent(recorderControlsEvent);
			currentState = IDLE;
			updateState();
		}
		
		private function startPlayingButtonClickHandler(event:MouseEvent):void
		{
			var recorderControlsEvent:RecorderControlsEvent = new RecorderControlsEvent(RecorderControlsEvent.START_PLAYING);
			dispatchEvent(recorderControlsEvent);
			currentState = PLAYING;
			updateState();
		}
		
		private function stopRecordButtonClickHandler(event:MouseEvent):void
		{
			var recorderControlsEvent:RecorderControlsEvent = new RecorderControlsEvent(RecorderControlsEvent.STOP_RECORD);
			dispatchEvent(recorderControlsEvent);
			
			currentState = IDLE;
			updateState();
		}
		
		private function startRecordButtonClickHandler(event:MouseEvent):void
		{
			currentState = RECORDING;
			updateState();
			var recorderControlsEvent:RecorderControlsEvent = new RecorderControlsEvent(RecorderControlsEvent.START_RECORD);
			dispatchEvent(recorderControlsEvent);
		}
		
		private function createLayout():void
		{
			layout = new HBox(this);
			layout.spacing = 2;
		}
	}
}