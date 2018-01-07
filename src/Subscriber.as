package
{
	import dev.div0.Settings;
	import dev.div0.net.StreamEvent;
	import dev.div0.net.SubscriberStream;
	import dev.div0.service.JSServiceEvent;
	import dev.div0.ui.controls.playerControls.SubscriberPlayerControls;
	import dev.div0.ui.controls.playerControls.SubscriberPlayerControlsView;
	import dev.div0.ui.image.BackgroundImage;
	import dev.div0.ui.video.SubscriberVideoView;
	import dev.div0.utils.Dispatcher;

	public class Subscriber extends BaseApplication
	{
		private var stream:SubscriberStream;
		
		protected var _publisherStreamId:String = "testingStream_55737";
		private var screenState:String;
		
		private var publisherImageUrl:String = "images/1.jpeg";
		
		private var playerControls:SubscriberPlayerControls;
		private var publisherImage:BackgroundImage;
		
		public function Subscriber()
		{
			ver = "0.2.9";
			
			if(this.loaderInfo.parameters["publisherImage"]){
				publisherImageUrl = this.loaderInfo.parameters["publisherImage"];
			}
			
			publisherImage = new BackgroundImage(publisherImageUrl);
			addChild(publisherImage);
			
			init();
			playerControls = new SubscriberPlayerControls();
			addChild(playerControls);
		}
		
		override protected function start():void{
			createStream();
			stream.start();
		}
		override protected function stop():void{
			if(stream){
				stream.stop();
			}
			(videoView as SubscriberVideoView).clear();
		}
		
		override protected function jsDataHandler(event:JSServiceEvent):void
		{
			super.jsDataHandler(event);
			if(jsComand){
				switch(jsComand){
					case Settings.START:
						_publisherStreamId = jsComandData.publisherStream;
						log("Start() publStream = "+_publisherStreamId);
						Settings.streamID = _publisherStreamId;
						start();
						break;
					case Settings.STOP:
						stop();
						break;
				}
			}
		}
		
		private function createStream():void{
			if(!stream){
				trace("starting pulisher stream with id "+_publisherStreamId);
				stream = new SubscriberStream(_publisherStreamId);
				Dispatcher.getInstance().addEventListener(StreamEvent.STREAM_STARTED, streamStartedHandler);
			}
		}
		
		private function streamStartedHandler(event:StreamEvent):void
		{
			log("stream started");
			(videoView as SubscriberVideoView).setStream(stream.getStream());
			service.send(JSON.stringify({asEvent:'streamStarted'}));
		}
		
		override protected function createVideo():void{
			videoView = new SubscriberVideoView();
			addChild(videoView);
		}
	}
}