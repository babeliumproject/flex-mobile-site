package modules.videoPlayer.events.babelia
{
	import flash.events.Event;

	public class SubtitleButtonEvent extends Event
	{
		public static const STATE_CHANGED:String = "SubtitleStateChanged";
		public var state:Boolean;
		
		public function SubtitleButtonEvent(type:String, state:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.state = state;
		}
		
	}
}