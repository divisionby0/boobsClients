package dev.div0.ui.log
{
	import com.bit101.components.TextArea;
	
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LogView extends Sprite
	{
		private var textArea:TextArea;
		
		public function LogView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 10);
		}
		
		private function addedToStageHandler(event:Event):void{
			trace("log added to stage");
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			listentToLogEvents();
			createTextArea();
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			Dispatcher.getInstance().dispatchEvent(new LogEvent(LogEvent.LOG_READY));
		}
		
		private function stageResizeHandler(event:Event):void
		{
			setPosition();
		}
		
		private function createTextArea():void{
			textArea = new TextArea(this);
			setPosition();
		}
		
		private function setPosition():void
		{
			textArea.y = stage.stageHeight - textArea.height;
			textArea.x = stage.stageWidth - textArea.width;
			draw();
		}
		
		private function draw():void{
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(textArea.x, textArea.y, textArea.width, textArea.height);
			graphics.endFill();
		}
		
		private function listentToLogEvents():void{
			Dispatcher.getInstance().addEventListener(LogEvent.LOG, logDataHandler);
		}
		
		private function logDataHandler(event:LogEvent):void{
			addLogText(event.data.toString());
			
		}
		private function addLogText(text:String):void{
			//trace(text);
			textArea.text+='\n'+text;
		}
	}
}