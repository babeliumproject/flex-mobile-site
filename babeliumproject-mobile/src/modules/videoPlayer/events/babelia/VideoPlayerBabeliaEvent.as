package modules.videoPlayer.events.babelia
{
	import flash.events.Event;

	public class VideoPlayerBabeliaEvent extends Event
	{
		
		public static const SECONDSTREAM_FINISHED_PLAYING:String = "SecondStreamFinishedPlaying";
		
		
		public function VideoPlayerBabeliaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}