package dev.div0.media
{
	import avmplus.getQualifiedClassName;
	
	import com.bit101.components.ComboBox;
	
	import dev.div0.media.cameras.UserCamera;
	import dev.div0.media.cameras.UserCameras;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class MediaSelectionView extends Sprite
	{
		private var camerasSelect:ComboBox;
		private var frameSizesSelect:ComboBox;
		
		private var cameraFrameSizes:Array = [
			"320x240", 
			"640x480", 
			"854x480",
			"800x600",
			"1024x768",
			"1280x720",
			"1400x1050",
			"1600x900",
			"1920x1080"];
		
		public function MediaSelectionView()
		{
			super();
			createChildren();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function destroy():void{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function createChildren():void
		{
			camerasSelect = new ComboBox(this);
			camerasSelect.addEventListener(Event.SELECT, onCameraSelectionChange);
			
			frameSizesSelect = new ComboBox(this,110);
			
			for(var i:int=0; i<cameraFrameSizes.length; i++){
				var size:String = cameraFrameSizes[i];
				frameSizesSelect.addItem(size);
			}
			frameSizesSelect.addEventListener(Event.SELECT, onCameraFrameSizeChanged);
		}
		
		private function onCameraFrameSizeChanged(event:Event):void
		{
			var sizeData:Array = frameSizesSelect.selectedItem.split("x");
			var cameraFrameWidth:int = parseInt(sizeData[0]);
			var cameraFrameHeight:int = parseInt(sizeData[1]);
			
			var cameraFrameSizeEvent:MediaEvent = new MediaEvent(MediaEvent.CAMERA_FRAME_SIZE_CHANGED);
			cameraFrameSizeEvent.selectedFrameSize = {width:cameraFrameWidth, height:cameraFrameHeight};
			
			Dispatcher.getInstance().dispatchEvent(cameraFrameSizeEvent);
		}
		
		private function onCameraSelectionChange(event:Event):void
		{
			var mediaEvent:MediaEvent = new MediaEvent(MediaEvent.CAMERA_SELECTED);
			mediaEvent.selectedCameraIndex = camerasSelect.selectedIndex;
			Dispatcher.getInstance().dispatchEvent(mediaEvent);
		}
		
		public function setCameras(cameras:Array):void{
			for(var i:int = 0; i<cameras.length; i++){
				var cameraName:String = cameras[i];
				var userCamera:UserCamera = new UserCamera(i, cameraName);
				camerasSelect.addItem({label:cameraName});
			}
		}
		
		public function setCameraSelection(index:int):void{
			if(index>-1){
				camerasSelect.selectedIndex = index;
			}
		}
		public function setCameraSelectedFrameSize(data:Object):void{
			log("setCameraSelectedFrameSize "+data);
			if(data && data.width && data.height){
				var selection:String = data.width+"x"+data.height;
				log("set selection");
				frameSizesSelect.selectedItem = selection;
			}
		}
		
		private function addedToStageHandler(event:Event):void
		{
			// resize listener
		}
		
		private function log(param0:String):void
		{
			trace("["+getQualifiedClassName(this)+"] "+param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
	}
}