package com.bit101.components
{
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	
	import org.osmf.layout.ScaleMode;
	
	public class CustomPushButton extends PushButton
	{
		private var cornerRadius:int = 5;
		
		public function CustomPushButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			/*
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			
			_back.graphics.lineStyle(1, 0xff0000,1, true, ScaleMode.ZOOM, CapsStyle.ROUND);
			_back.graphics.drawRoundRect(0, 0, _width, _height, cornerRadius, cornerRadius);
			_back.graphics.endFill();
			*/
			drawFace();
			
			
			_label.text = _labelText;
			_label.autoSize = true;
			_label.draw();
			if(_label.width > _width - 4)
			{
				_label.autoSize = false;
				_label.width = _width - 4;
			}
			else
			{
				_label.autoSize = true;
			}
			_label.draw();
			_label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);
		}
		
		/**
		 * Draws the face of the button, color based on state.
		 */
		override protected function drawFace():void
		{
			_face.graphics.clear();
			if(_down)
			{
				_face.graphics.beginFill(Style.BUTTON_DOWN);
			}
			else
			{
				_face.graphics.beginFill(Style.BUTTON_FACE);
			}
			_face.graphics.lineStyle(1, 0xff0000,1, true, ScaleMode.ZOOM,CapsStyle.ROUND);
			_face.graphics.drawRoundRect(0, 0, _width - 2, _height - 2, cornerRadius, cornerRadius);
			_face.graphics.endFill();
		}
	}
}