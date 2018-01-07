package
{
	import avmplus.getQualifiedClassName;
	
	import com.bit101.components.Text;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class RtmpStreamTester extends Sprite
	{
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		//private var connectionUrl:String = "rtmp://red6.divisionby0.ru:1935/live/";
		private var connectionUrl:String = "rtmp://185.93.0.132:1935/live/";
		private var streamName:String = "testingStream_68161";
		
		private var video:Video = new Video(320, 240);
		private var label:Text;
		
		private var streamMinBuffer:Number = 0;
		private var streamMaxBuffer:Number = 0.8;
		
		public function RtmpStreamTester()
		{
			addChild(video);
			
			label = new Text(this,0,0);
			
			createConnection();
			
		}
		
		private function createConnection():void
		{
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netConnection.connect(connectionUrl);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			log("StreamTester: "+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					createStream();
					break;
				case "NetStream.Play.PublishNotify":
					restart();
					break;
				// adaptive
				case "NetStream.Buffer.Full":
					onStreamBufferFull();
					break;
				case "NetStream.Buffer.Empty":
					onStreamBufferEmpty();
					break;
				case "NetStream.SeekStart.Notify":
					onStreamBufferFull();
					break;
			}
		}
		
		private function onStreamBufferFull():void{
			netStream.bufferTime = streamMinBuffer;
			label.text = netStream.bufferLength.toString();
		}
		
		private function onStreamBufferEmpty():void{
			netStream.bufferTime = streamMaxBuffer;
			label.text = netStream.bufferLength.toString();
		}
		
		public function onPlayStatus(data:Object):void{
			log("onPlayStatus "+data);
		}
		
		public function setDataFrame(data:Object):void{
			log("Subscriber. setDataFrame "+data);
		}
		public function onMetaData(data:Object):void{
			log("Subscriber. onMetaData "+data);
		}
		
		private function createStream():void
		{
			if(!netStream){
				netStream = new NetStream(netConnection);
				netStream.client = this;
				netStream.bufferTime = streamMaxBuffer;
				netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			
			netStream.play(streamName);
			video.attachNetStream(netStream);
			label.text = netStream.bufferLength.toString();
		}
		
		private function restart():void{
			if(netStream){
				netStream.play(streamName);
				video.attachNetStream(netStream);
			}
			else{
				createStream();
			}
		}
		
		private function log(param0:String):void
		{
			trace("["+getQualifiedClassName(this)+"] "+param0);
		}
	}
}