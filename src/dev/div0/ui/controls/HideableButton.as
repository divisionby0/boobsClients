package dev.div0.ui.controls
{
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	
	public class HideableButton extends PushButton
	{
		private var naturalWidth:int = 110;
		
		public function HideableButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null, _naturalWidth:int = 110)
		{
			this.naturalWidth = _naturalWidth;
			super(parent, xpos, ypos, label, defaultHandler);
			setSize(naturalWidth, 20);
		}
		
		public function show():void{
			//width = naturalWidth;
			setSize(naturalWidth, 20);
			visible = true;
		}
		public function hide():void{
			//naturalWidth = width;
			//width = 0;
			setSize(0, 20);
			visible = false;
		}
	}
}