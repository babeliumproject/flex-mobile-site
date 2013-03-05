package modules.videoPlayer.events
{
	import flash.events.Event;

	public class PlayPauseEvent extends Event
	{
		public static const STATE_CHANGED:String = "StateChanged";
		
		public function PlayPauseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}