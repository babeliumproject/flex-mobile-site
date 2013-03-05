package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import vo.ExerciseVO;
	import vo.UserVO;

	public class UserEvent extends CairngormEvent
	{
		public static const GET_TOP_TEN_CREDITED:String = "getTopTenCredited";
		public static const KEEP_SESSION_ALIVE:String = "keepSessionAlive";
		public static const MODIFY_PREFERRED_LANGUAGES:String = "modifyPreferredLanguages";
		public static const MODIFY_PERSONAL_DATA:String = "modifyPersonalData";
		public static const RETRIEVE_USER_VIDEOS:String = "retrieveUserVideos";
		public static const DELETE_SELECTED_VIDEOS:String = "deleteSelectedVideos";
		public static const MODIFY_VIDEO_DATA:String = "modifyVideoData";
		
		public var dataList:Array;
		public var personalData:UserVO;
		public var videoData:ExerciseVO;
		
		public function UserEvent(type:String, dataList:Array = null, personalData:UserVO = null, videoData:ExerciseVO = null)
		{
			super(type);
			this.dataList = dataList;
			this.personalData = personalData;
			this.videoData = videoData;
		}
		
	}
}