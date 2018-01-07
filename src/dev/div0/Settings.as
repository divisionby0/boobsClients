package dev.div0
{
	public class Settings
	{
		public static const SET_DATA_COMAND:String = "setData";
		public static const START:String = "start";
		public static const STOP:String = "stop";
		public static const PAUSE:String = "pause";
		public static const MICROPHONE_MUTE:String = "MUTE_MICROPHONE";
		public static const MICROPHONE_UNMUTE:String = "UNMUTE_MICROPHONE";
		public static const GET_MICROPHONE_STATUS:String = "GET_MICROPHONE_STATUS";
		public static var startPublishButtonLabel:String = "Start";
		public static var stopPublishButtonLabel:String = "Stop";
		public static var debugPublisherLabel:String = "PUBLISHER";
		public static var debugSubscriberLabel:String = "SUBSCRIBER";
		public static var debugHeaderLabel:String = "";
		
		
		public static var streamID:String = "";
		//public static var rtmp:String = "rtmp://185.93.0.132:1935/live/";
		//public static var rtmp:String = "rtmp://red5.divisionby0.ru:1935/live/";
		//public static var rtmp:String = "rtmp://localhost:1935/live/";
		public static var rtmp:String = "rtmp://185.93.0.132:1935/live/";
	}
}