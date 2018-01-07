package
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.CustomComboBox;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;

	public class MinimalComponents_listDemo extends Sprite
	{
		public function MinimalComponents_listDemo()
		{
			var label:Label = new Label(this,0,0,'my label');
			var dataArrtay:Array = new Array();
			dataArrtay.push('camera 1');
			dataArrtay.push('camera 2');
			dataArrtay.push('camera 3');
			dataArrtay.push('camera 4');
			
			var window:Window = new Window(this, 100, 100, 'Window');
			var dropDown:CustomComboBox = new CustomComboBox(window, 20, 100, 'select camera', dataArrtay);
			
			//var list:List = new List(this, 0, 100, dataArrtay);
			
		}
	}
}