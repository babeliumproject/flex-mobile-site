package modules.videoPlayer.events.babelia
{
	import flash.events.Event;

	public class RecordingEvent extends Event
	{
		
		public static const END:String = "EndRecord";
		public static const REPLAY_END:String = "EndReplay";
		public static const MIC_DENIED:String = "MicDenied";
		public static const CAM_DENIED:String = "CamDenied";
		public static const ABORTED:String = "RecordingAborted";
		public static const REC_CLICK:String = "recClick";
		public var fileName:String;
		
		public function RecordingEvent(type:String, fileName:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.fileName = fileName;
		}
		
	}
}