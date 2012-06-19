package vo
{

	[RemoteClass(alias="UserVideoHistoryVO")]
	[Bindable]
	public class UserVideoHistoryVO
	{
		public var id:int;
		public var userSessionId:int;
		public var exerciseId:int;
		public var responseAttempt:Boolean;
		public var responseId:int;
		public var incidenceDate:String;
		public var subtitlesAreUsed:Boolean;
		public var subtitleId:int;
		public var exerciseRoleId:int;

		public function UserVideoHistoryVO(id:int=0, userSessionId:int=0, exerciseId:int=0, responseAttempt:Boolean=false, responseId:int=0, incidenceDate:String='', subtitlesAreUsed:Boolean=false, subtitleId:int=0, exerciseRoleId:int=0)
		{
			this.id=id;
			this.userSessionId=userSessionId;
			this.exerciseId=exerciseId;
			this.responseAttempt=responseAttempt;
			this.responseId=responseId;
			this.incidenceDate=incidenceDate;
			this.subtitlesAreUsed=subtitlesAreUsed;
			this.subtitleId=subtitleId;
			this.exerciseRoleId=exerciseRoleId;
		}
	}
}