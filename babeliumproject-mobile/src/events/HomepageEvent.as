package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class HomepageEvent extends CairngormEvent
	{
		
		public static const LATEST_RECEIVED_ASSESSMENTS:String = "latestReceivedAssessments";
		public static const LATEST_DONE_ASSESSMENTS:String = "latestDoneAssessments";
		public static const LATEST_USER_UPLOADED_VIDEOS:String = "latestUserUploadedVideos";
		public static const BEST_RATED_VIDEOS_SIGNED_IN:String = "bestRatedVideosSignedIn";
		public static const BEST_RATED_VIDEOS_UNSIGNED:String="bestRatedVideoUnsigned";
		public static const LATEST_UPLOADED_VIDEOS:String = "latestUploadedVideos";
		
		public function HomepageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}