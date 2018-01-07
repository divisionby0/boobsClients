package dev.div0.ui
{
	import com.bit101.components.Label;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ErrorView extends Sprite
	{
		private var errorText:String;
		private var label:Label;
		private var background:Sprite;
		
		public function ErrorView(errorText:String)
		{
			super();
			this.errorText = errorText;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			createBackground();
			createLabel();
			stage.addEventListener(Event.RESIZE, onStageResized);
			onResize();
		}
		
		private function onStageResized(event:Event):void
		{
			onResize();
		}
		
		private function createLabel():void{
			label = new Label(this, 0,0, errorText);
			label.autoSize = true;
		}
		
		private function createBackground():void{
			background = new Sprite();
			addChild(background);
			drawBackground();
		}
		
		private function drawBackground():void{
			background.graphics.clear();
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			background.graphics.endFill();
		}
		
		private function positionChildren():void{
			label.x = (stage.stageWidth - label.width)/2;
			label.y = (stage.stageHeight - label.height)/2;
		}
		
		private function onResize():void{
			drawBackground();
			positionChildren();
		}
	}
}