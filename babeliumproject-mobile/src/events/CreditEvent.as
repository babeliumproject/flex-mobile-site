package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class CreditEvent extends CairngormEvent
	{		
		public static const GET_CURRENT_DAY_CREDIT_HISTORY:String = "getCurrentDayCreditHistory"; 
		public static const GET_LAST_WEEK_CREDIT_HISTORY:String = "getLastWeekCreditHistory";
		public static const GET_LAST_MONTH_CREDIT_HISTORY:String = "getLastMonthCreditHistory";
		public static const GET_ALL_TIME_CREDIT_HISTORY:String = "getAllTimeCreditHistory";
		
		public function CreditEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new CreditEvent(type);
		}

	}
}