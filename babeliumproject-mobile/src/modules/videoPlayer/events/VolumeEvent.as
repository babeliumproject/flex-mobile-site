package modules.videoPlayer.events
{
	import flash.events.Event;

	public class VolumeEvent extends Event
	{
		private var _volumeAmount:Object;
		
		public static const VOLUME_CHANGED:String = "VolumeChanged";
		
		public function VolumeEvent(type:String, value:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_volumeAmount = value;
		}
		
		
		public function get volumeAmount( ):Number
		{
			return _volumeAmount as Number;
		}
		
		
	}
}