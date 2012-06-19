package modules.videoPlayer.events.babelia
{
	import flash.events.TimerEvent;

	public class StreamEvent extends TimerEvent
	{
		
		public static const ENTER_FRAME:String = "FrameEntered";
		public var time:Number;
		
		public function StreamEvent(type:String, time:Number, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.time = time;
			//trace(this.time);
		}
		
	}
}