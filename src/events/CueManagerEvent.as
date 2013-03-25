package events
{
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.SubtitleLineVO;
	import vo.SubtitleAndSubtitleLinesVO;

	public class CueManagerEvent extends CairngormEvent
	{
		
		public static const SUBTITLES_RETRIEVED:String = "subtitlesRetrieved";
		
		public function CueManagerEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new CueManagerEvent(type);
		}
		
	}
}