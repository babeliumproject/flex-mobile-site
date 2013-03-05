package events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class RecordingEndOptionEvent extends CairngormEvent
	{
		public static const VIEW_BOTH:String = "viewBoth";
		public static const VIEW_RESPONSE:String = "viewResponse";
		public static const RECORD_AGAIN:String = "recordAgain";
		public static const DISCARD_RESPONSE:String = "discardResponse";
		public static const SAVE_RESPONSE:String = "saveResponse";
		public static const CLOSE_REQUEST:String = "closeRequest";
		
		public function RecordingEndOptionEvent(type:String)
		{
			super(type);
		}
		
	}
}