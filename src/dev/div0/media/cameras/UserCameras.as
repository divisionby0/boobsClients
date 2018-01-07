package dev.div0.media.cameras
{
	import avmplus.getQualifiedClassName;
	
	import dev.div0.media.MediaEvent;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.events.Event;
	import flash.media.Camera;
	import flash.net.SharedObject;

	public class UserCameras
	{
		private var camerasCollection:Array;
		private var camera:Camera;
		private var savedCameraIndex:int = -1;
		private var savedCameraFrameSize:Object = {width:640, height:480};
		
		private var localId:String = "boobsApplication";
		private var sharedObject:SharedObject;
		
		public function UserCameras()
		{
			initSharedObject();
			camerasCollection = Camera.names;
			
			log("cameras: "+camerasCollection);
			if(camerasCollection.length == 0){
				log("Camera unavaliable");
				Dispatcher.getInstance().dispatchEvent(new MediaEvent(MediaEvent.CAMERA_UNAVAILABLE));
				return;	
			}
		}
		
		public function getSavedCamera():Camera{
			if(savedCameraIndex==-1){
				return Camera.getCamera();
			}
			else{
				return Camera.getCamera(String(savedCameraIndex));
			}
		}
		
		public function getSavedCameraIndex():int{
			return savedCameraIndex;
		}
		public function getSavedCameraFrameSize():Object{
			return savedCameraFrameSize;
		}
		
		public function getCameraByIndex(cameraIndex:int):Camera{
			if(cameraIndex==-1){
				return Camera.getCamera();
			}
			else{
				return Camera.getCamera(String(cameraIndex));
			}
		}
		
		public function getCameras():Array{
			return camerasCollection;
		}
		
		public function setCameraSelection(cameraIndex:int):void{
			sharedObject.data.selectedCamera = cameraIndex;
			sharedObject.flush();
			savedCameraIndex = cameraIndex;
		}
		
		public function setCameraFrameSize(frameSize:Object):void{
			sharedObject.data.selectedCameraFrameSize = frameSize;
			sharedObject.flush();
			savedCameraFrameSize = frameSize;
		}
		
		private function initSharedObject():void{
			sharedObject = SharedObject.getLocal(localId);	
			
			var mediaEvent:MediaEvent;
			
			if(sharedObject.data.selectedCamera!=null){
				savedCameraIndex = sharedObject.data.selectedCamera;
				log("savedCameraIndex = "+savedCameraIndex);
				
				mediaEvent = new MediaEvent(MediaEvent.USER_CAMERA_CHANGED);
				mediaEvent.selectedCameraIndex = savedCameraIndex;
				Dispatcher.getInstance().dispatchEvent(mediaEvent);
			}
			else{
				log("No saved camera available");
			}
			
			if(sharedObject.data.selectedCameraFrameSize!=null){
				savedCameraFrameSize = sharedObject.data.selectedCameraFrameSize; 
				log("savedCameraFrameSize = "+savedCameraFrameSize);
				
				mediaEvent = new MediaEvent(MediaEvent.CAMERA_FRAME_SIZE_CHANGED);
				mediaEvent.selectedFrameSize = savedCameraFrameSize;
				Dispatcher.getInstance().dispatchEvent(mediaEvent);
			}
			else{
				log("no saved camera frame size available");
			}
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