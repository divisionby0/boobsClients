package dev.div0.ui.controls.playerControls
{
	import dev.div0.ui.controls.ControlsEvent;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;

	public class SubscriberPlayerControls extends Sprite
	{
		private var playerControls:SubscriberPlayerControlsView;
		private var state:String;
		
		public function SubscriberPlayerControls()
		{
			state = SubscriberPlayerControlsView.NORMAL;
			createPlayerControls();
		}
		
		private function createPlayerControls():void
		{
			playerControls = new SubscriberPlayerControlsView();
			addChild(playerControls);
			playerControls.addEventListener(ControlsEvent.FULLSCREEN_CLICKED, fullscreenClickedHandler);
		}
		
		private function fullscreenClickedHandler(event:Event):void
		{
			switch(state){
				case SubscriberPlayerControlsView.NORMAL:
					stage.displayState = StageDisplayState.FULL_SCREEN; 
					state = SubscriberPlayerControlsView.FULLSCREEN; // нарушение инкапсуляции ???
					break;
				case SubscriberPlayerControlsView.FULLSCREEN:
					stage.displayState = StageDisplayState.NORMAL; 
					state = SubscriberPlayerControlsView.NORMAL; // нарушение инкапсуляции ???
					break;
			}
		}
	}
}