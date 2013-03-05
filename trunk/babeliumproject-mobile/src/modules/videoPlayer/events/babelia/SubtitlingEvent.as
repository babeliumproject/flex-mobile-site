package modules.videoPlayer.events.babelia
{
	import flash.events.Event;

	public class SubtitlingEvent extends Event
	{
		public static const START:String = "StartClicked";
		public static const END:String = "EndClicked";
		public var time:Number;
		
		public function SubtitlingEvent(type:String, time:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.time = time;
		}
		
	}
}