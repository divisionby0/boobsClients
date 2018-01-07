package dev.div0.media
{
	import avmplus.getQualifiedClassName;
	
	import dev.div0.media.cameras.UserCameras;
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;

	public class PublisherMedia
	{
		private var userCameras:UserCameras;
		//private var camerasCollection:Array;
		private var camera:Camera;
		private var mic:Microphone;
		
		private var cameraWidth:int = 0;
		private var cameraHeight:int = 0;
		private var fps:int = 15;
		
		private var microphoneStatus:String = MediaState.MICROPHONE_MUTED;
		
		//private var savedCameraIndex:int = 1;
		
		private var mediaSelectionView:MediaSelectionView;
		
		public function PublisherMedia(cameraWidth:int = 0, cameraHeight:int = 0, fps:int = 0)
		{
			if(cameraWidth!=0){
				this.cameraWidth = cameraWidth;
			}
			if(cameraHeight!=0){
				this.cameraHeight = cameraHeight;
			}
			if(fps!=0){
				this.fps = fps;
			}
			getMedia();
		}
		public function init():void{
			getMedia();
		}
		
		public function showMediaSelectionView(parentView:Sprite):void{
			if(!mediaSelectionView){
				mediaSelectionView = new MediaSelectionView();
				parentView.addChild(mediaSelectionView);
			}
			
			mediaSelectionView.setCameras(userCameras.getCameras());
			mediaSelectionView.setCameraSelection(userCameras.getSavedCameraIndex());
			
			mediaSelectionView.setCameraSelectedFrameSize(userCameras.getSavedCameraFrameSize());
			
			Dispatcher.getInstance().addEventListener(MediaEvent.CAMERA_SELECTED, onCameraSelected);
			Dispatcher.getInstance().addEventListener(MediaEvent.CAMERA_FRAME_SIZE_CHANGED, onCameraFrameSizeChanged);
		}
		
		public function hideMediaSelectionView(parentView:Sprite):void{
			parentView.removeChild(mediaSelectionView);
			mediaSelectionView.destroy();
			mediaSelectionView = null;
		}
		
		private function onCameraFrameSizeChanged(event:MediaEvent):void
		{
			if(camera){
				cameraWidth = event.selectedFrameSize.width;
				cameraHeight = event.selectedFrameSize.height;
				updateCameraSettings();
				userCameras.setCameraFrameSize(event.selectedFrameSize);
			}
		}
		
		private function onCameraSelected(event:MediaEvent):void
		{
			userCameras.setCameraSelection(event.selectedCameraIndex);
			camera = userCameras.getSavedCamera();
			updateCameraSettings();
			Dispatcher.getInstance().dispatchEvent(new MediaEvent(MediaEvent.USER_CAMERA_CHANGED));
		}
		
		private function getMedia():void{
			getUserCamera();
			getUserMicrophone();
		}
		
		private function getUserMicrophone():void{
			//trace("getUserMicrophone");
			mic = Microphone.getEnhancedMicrophone();
			updateMicSettings();
			onMicrophoneStatusChanged();
		}
		
		private function getUserCamera():void{
			log("getUserCamera()");
			userCameras = new UserCameras();
			camera = userCameras.getSavedCamera();
			
			log("saved camera = "+camera);
			
			var cameraFrameSize:Object = userCameras.getSavedCameraFrameSize();
			cameraWidth = cameraFrameSize.width;
			cameraHeight = cameraFrameSize.height;
			
			if(camera.muted){
				camera.addEventListener(StatusEvent.STATUS, cameraStatusHandler);
				Dispatcher.getInstance().dispatchEvent(new MediaEvent(MediaEvent.CAMERA_MUTED));
				return;
			}
			else{
				camera.removeEventListener(StatusEvent.STATUS, cameraStatusHandler);
				Dispatcher.getInstance().dispatchEvent(new MediaEvent(MediaEvent.CAMERA_UNMUTED));
			}
			updateCameraSettings();
		}
		
		private function updateMicSettings():void
		{
			//log("updateMicSettings mic = "+mic);
			if(mic){
				try{
					//mic.setSilenceLevel(0);
					mic.codec = SoundCodec.NELLYMOSER;
					mic.encodeQuality = 10;
					//mic.rate = 44;
					
					var micOptions : MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
					micOptions.echoPath = 128;
					micOptions.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
					micOptions.nonLinearProcessing = true;
					mic.setSilenceLevel(0);
					mic.rate = 44;
					mic.enhancedOptions = micOptions;
					microphoneStatus = MediaState.MICROPHONE_UNMUTED;
				}
				catch(error:Error){
					log("set mic properties error: "+error.message);
					microphoneStatus = MediaState.MICROPHONE_MUTED;
				}
			}
		}
		
		private function onMicrophoneStatusChanged():void{
			//log("onMicrophoneStatusChanged microphoneStatus = "+microphoneStatus);
			if(microphoneStatus == MediaState.MICROPHONE_UNMUTED){
				onMicrophoneUnmute();
			}
			else{
				onMicrophoneMute();
			}
		}
		
		private function updateCameraSettings():void
		{
			if(camera){
				try{
					log("camera setMode("+cameraWidth+","+cameraHeight+","+fps+")");
					camera.setMode(cameraWidth, cameraHeight, fps, true);
					camera.setQuality(0, 85);
					//camera.setKeyFrameInterval(15);
				}
				catch(error:Error){
					log("set camera properties error: "+error.message);
				}
			}
		}
		
		private function cameraStatusHandler(event:StatusEvent):void
		{
			log("Camera status : "+event.code);
			if(event.code == "Camera.Unmuted"){
				updateCameraSettings();
				updateMicSettings();
				Dispatcher.getInstance().dispatchEvent(new MediaEvent(MediaEvent.CAMERA_UNMUTED));
			}
		}
		public function getCamera():Camera{
			return camera;
		}
		public function getMicrophone():Microphone{
			return mic;
		}
		public function clear():void{
			camera = null;
			destroyUserMicrophone();
			onMicrophoneMute();
		}
		
		private function destroyUserMicrophone():void{
			/*
			mic = Microphone.getMicrophone(); // to fade webcam light
			mic = null;
			*/
		}
		
		public function getMicrophoneStatus():String{
			return microphoneStatus;
		}
		
		public function onMicrophoneMute():void{
			destroyUserMicrophone();
			microphoneStatus = MediaState.MICROPHONE_MUTED;
			
			var mediaEvent:MediaEvent = new MediaEvent(MediaEvent.MICROPHONE_STATE_CHANGED);
			mediaEvent.microphoneStatus = microphoneStatus;
			Dispatcher.getInstance().dispatchEvent(mediaEvent);
		}
		public function onMicrophoneUnmute():void{
			/*
			if(!mic){
				getUserMicrophone();
			}
			*/
			
			microphoneStatus = MediaState.MICROPHONE_UNMUTED;
			
			var mediaEvent:MediaEvent = new MediaEvent(MediaEvent.MICROPHONE_STATE_CHANGED);
			mediaEvent.microphoneStatus = microphoneStatus;
			
			Dispatcher.getInstance().dispatchEvent(mediaEvent);
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