package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.ResponseVO;

	public class ResponseEvent extends CairngormEvent
	{
		
		//Used when saving the final response of some user to some exercise
		public static const SAVE_RESPONSE:String = "saveResponse";
		
		//Used when the user wants his/her response evaluated
		public static const MAKE_RESPONSE_PUBLIC:String="makeResponsePublic";
		
		public var response:ResponseVO;
		
		public function ResponseEvent(type:String, response:ResponseVO)
		{
			super(type);
			this.response = response;
		}
		
		override public function clone():Event{
			return new ResponseEvent(type, response);
		}
		
	}
}