package modules.videoPlayer.events.babelia
{
	import flash.events.Event;

	public class SubtitleComboEvent extends Event
	{
		public static const SELECTED_CHANGED:String = "SubtitleSelectedChanged";
		public var selectedIndex:int;
		
		public function SubtitleComboEvent(type:String, selected:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedIndex = selected;
		}
		
	}
}