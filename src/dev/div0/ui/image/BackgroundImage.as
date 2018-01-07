package dev.div0.ui.image
{
	import dev.div0.utils.Dispatcher;
	import dev.div0.utils.log.LogEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class BackgroundImage extends Sprite
	{
		private var image:Bitmap;
		private var imageUrl:String;
		
		private var imageContainer:Sprite = new Sprite();
		
		private var url:String;
		
		public function BackgroundImage(url:String)
		{
			addChild(imageContainer);
			imageUrl = url;
			
			if(imageUrl){
				createImage();
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}
		
		private function addedToStageHandler(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			resizeImage();
			placeImage();
		}
		
		private function createImage():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, publisherImageLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, publisherImageIOErrorHandler);
			log("loading image "+imageUrl);
			
			loader.load(new URLRequest(imageUrl));
		}
		
		private function publisherImageIOErrorHandler(event:IOErrorEvent):void
		{
			log("Image IOError "+event.text);
		}
		
		private function publisherImageLoadComplete(event:Event):void
		{
			image = Bitmap(LoaderInfo(event.target).content);
			imageContainer.addChild(image);
			image.smoothing = true;
			resizeImage();
			placeImage();
		}
		
		private function log(param0:String):void
		{
			trace(param0);
			var logEvent:LogEvent = new LogEvent(LogEvent.LOG);
			logEvent.data = param0;
			Dispatcher.getInstance().dispatchEvent(logEvent);
		}
		
		private function placeImage():void
		{
			imageContainer.x = (stage.stageWidth - imageContainer.width)/2;
			imageContainer.y = (stage.stageHeight - imageContainer.height)/2;
		}
		
		private function resizeImage():void
		{
			if(imageContainer && image){
				//var scaleWidth:Number = image.width / imageContainer.width;
				var scaleWidth:Number = stage.stageWidth / imageContainer.width;
				var scaleHeight:Number = stage.stageHeight / imageContainer.height;
				
				if (scaleWidth < scaleHeight)
					imageContainer.scaleX = imageContainer.scaleY = scaleWidth;
				else
					imageContainer.scaleX = imageContainer.scaleY = scaleHeight;
			}
		}
	}
}