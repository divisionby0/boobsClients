package dev.div0.ui.controls
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import dev.div0.Settings;
	import dev.div0.media.MediaEvent;
	import dev.div0.media.MediaState;
	import dev.div0.utils.Dispatcher;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DebugControlsView extends Sprite
	{
		private var startButton:PushButton;
		private var stopButton:PushButton;
		
		private var microphoneCheckBox:CheckBox;
		
		private var microphoneStatusLable:Label;
		
		private var buttonsVisible:Boolean = true;
		private var label:String = "label";
		
		public function DebugControlsView(buttonsVisible:Boolean = true, label:String = "label")
		{
			super();
			this.label = label;
			this.buttonsVisible = buttonsVisible;
			create();
			Dispatcher.getInstance().addEventListener(MediaEvent.MICROPHONE_STATE_CHANGED, microphoneStateChangedHandler);
		}
		
		private function create():void{
			var label:Label = new Label(this,200,0, label);
			
			var hBox:HBox = new HBox(this);
			startButton = new PushButton(hBox);
			stopButton = new PushButton(hBox);
			
			microphoneCheckBox = new CheckBox(hBox);
			microphoneCheckBox.label = "Mic";
			
			microphoneStatusLable = new Label(hBox);
			
			microphoneStatusLable.text = MediaState.MICROPHONE_MUTED;
			
			startButton.addEventListener(MouseEvent.CLICK, startButtonClickHandler);
			stopButton.addEventListener(MouseEvent.CLICK, stopButtonClickHandler);
			microphoneCheckBox.addEventListener(MouseEvent.CLICK, microphoneCheckBoxClickHandler);
			
			startButton.label = Settings.startPublishButtonLabel;
			stopButton.label = Settings.stopPublishButtonLabel;
			
			microphoneCheckBox.enabled = false;
		}
		
		private function microphoneCheckBoxClickHandler(event:MouseEvent):void
		{
			var controlsEvent:ControlsEvent = new ControlsEvent(ControlsEvent.MICROPHONE_STATE_CHANGE_REQUEST);
			controlsEvent.data = microphoneCheckBox.selected;
			dispatchEvent(controlsEvent);
		}
		
		private function microphoneStateChangedHandler(event:MediaEvent):void
		{
			microphoneStatusLable.text = event.microphoneStatus;
			
			switch(event.microphoneStatus){
				case MediaState.MICROPHONE_MUTED:
					microphoneCheckBox.selected = false;
					break;
				case MediaState.MICROPHONE_UNMUTED:
					microphoneCheckBox.selected = true;
					break;
			}
		}
		
		private function stopButtonClickHandler(event:MouseEvent):void
		{
			var controlsEvent:ControlsEvent = new ControlsEvent(ControlsEvent.STOP_CLICKED);
			dispatchEvent(controlsEvent);
			microphoneCheckBox.enabled = false;
		}
		
		private function startButtonClickHandler(event:MouseEvent):void
		{
			var controlsEvent:ControlsEvent = new ControlsEvent(ControlsEvent.START_CLICKED);
			dispatchEvent(controlsEvent);
			microphoneCheckBox.enabled = true;
		}
	}
}