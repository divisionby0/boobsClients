package com.bit101.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CustomComboBox extends ComboBox
	{
		public function CustomComboBox(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultLabel:String="", items:Array=null)
		{
			super(parent, xpos, ypos, defaultLabel, items);
		}
		
		
		
		override protected function addChildren():void{
			//super.addChildren();
			_list = new List(null, 0, 0, _items);
			_list.autoHideScrollBar = true;
			_list.addEventListener(Event.SELECT, onSelect);
			
			_labelButton = new CustomPushButton(this, 0, 0, "", onDropDown);
			_dropDownButton = new CustomPushButton(this, 0, 0, "+", onDropDown);
			
			
			this.addEventListener(MouseEvent.ROLL_OVER, componentRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, componentRollOutHandler);
		}
		
		private function componentRollOutHandler(event:MouseEvent):void
		{
			onStageClick(event);
		}
		
		private function componentRollOverHandler(event:MouseEvent):void
		{
			onDropDown(event);
		}
	}
}