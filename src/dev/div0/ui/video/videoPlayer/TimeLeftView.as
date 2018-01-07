package dev.div0.ui.video.videoPlayer
{

	import dev.div0.ui.components.StyleableLabel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TimeLeftView extends Sprite
	{
		private var label:StyleableLabel;
		private var labelStyle:Object = {color:0xff0000, size:18};
		
		public function TimeLeftView()
		{
			super();
			createLabel();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function createLabel():void
		{
			label = new StyleableLabel(this,0,0,"",labelStyle);
		}
		
		public function setValue(timeLeft:String):void{
			label.text = timeLeft;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageResizeHandler(null);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			
			label.x = stage.stageWidth - 60;
		}
	}
}