package modules.videoPlayer.events
{
	import flash.events.Event;

	public class StopEvent extends Event
	{
		public static const STOP_CLICK:String = "StopClicked";
		
		public function StopEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}