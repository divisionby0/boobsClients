package dev.div0.ui.components
{
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StyleableLabel extends Label
	{
		
		private var style:Object;
		public function StyleableLabel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", style:Object = null)
		{
			this.style = style; 
			super(parent, xpos, ypos, text);
		}
		
		
		override protected function addChildren():void
		{
			_height = 18;
			_tf = new TextField();
			_tf.height = _height;
			_tf.embedFonts = Style.embedFonts;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			
			var fontColor:uint;
			var fontSize:int;
			
			if(style){
				if(style.color){
					fontColor = style.color;
				}
				else{
					fontColor = Style.LABEL_TEXT;
				}
				if(style.size){
					fontSize = style.size;
				}
				else{
					fontSize = Style.fontSize;
				}
			}
			
			_tf.defaultTextFormat = new TextFormat(Style.fontName, fontSize, fontColor);
			_tf.text = _text;			
			addChild(_tf);
			draw();
		}
	}
}