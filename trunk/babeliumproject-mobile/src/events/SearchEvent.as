package events{
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SearchEvent extends CairngormEvent{
		
		public static const LAUNCH_SEARCH:String="launchSearch";


		public function SearchEvent(type:String){
			super(type)
		}

	}
}