package dev.div0.ui.controls.playerControls
{
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	
	import dev.div0.utils.Dispatcher;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import dev.div0.ui.controls.ControlsEvent;
	
	public class SubscriberPlayerControlsView extends Sprite
	{
		public static const NORMAL:String = "normal";
		public static const FULLSCREEN:String = "fullscreen";
		
		private var volumeSlider:HSlider;
		private var fullscreenButton:PushButton;
		private var currentState:String = NORMAL;
		
		private var hLayout:HBox;
		
		public function SubscriberPlayerControlsView()
		{
			super();
			createControls();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function createControls():void
		{
			hLayout = new HBox(this);
			
			volumeSlider = new HSlider(hLayout);
			volumeSlider.maximum = 0;
			volumeSlider.maximum = 100;
			volumeSlider.value = 100;
			
			fullscreenButton = new PushButton(hLayout,0,0,"To fullscreen");
			addChild(fullscreenButton);
			
			fullscreenButton.addEventListener(MouseEvent.CLICK, fullscreenButtonClickHandler);
			volumeSlider.addEventListener(Event.CHANGE, volumeSliderChangeHandler);
		}
		
		private function volumeSliderChangeHandler(event:Event):void
		{
			var controlsEvent:ControlsEvent = new ControlsEvent(ControlsEvent.VOLUME_CHANGED);
			controlsEvent.data = volumeSlider.value/100;
			Dispatcher.getInstance().dispatchEvent(controlsEvent);
		}
		
		private function fullscreenButtonClickHandler(event:MouseEvent):void
		{
			var controlsEvent:ControlsEvent = new ControlsEvent(ControlsEvent.FULLSCREEN_CLICKED);
			dispatchEvent(controlsEvent);
			
			switch(currentState){
				case NORMAL:
					fullscreenButton.label = "To normal screen";
					currentState = FULLSCREEN;
					break;
				case FULLSCREEN:
					fullscreenButton.label = "To fullscreen";
					currentState = NORMAL;
					break;
			}
			setPosition();
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			setPosition();
		}
		
		private function stageResizeHandler(event:Event):void
		{
			setPosition();
		}
		
		private function setPosition():void
		{
			x = stage.stageWidth - (fullscreenButton.width + volumeSlider.width)- 10;
			y = stage.stageHeight - fullscreenButton.height - 10;
			volumeSlider.y = (fullscreenButton.height - volumeSlider.height)/2;
		}
	}
}