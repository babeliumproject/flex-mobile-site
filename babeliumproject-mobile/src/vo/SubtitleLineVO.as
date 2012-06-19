// ActionScript file
package vo
{
	
	[RemoteClass(alias="SubtitleLineVO")]
	[Bindable]
	public class SubtitleLineVO
	{
		public var id:int;
		public var subtitleId:int;
		public var showTime:Number;
		public var hideTime:Number;
		public var text:String;
		public var exerciseRoleId:int;
		public var exerciseRoleName:String;
		
		public function SubtitleLineVO(id:int = 0, subtitleId:int = 0, showTime:Number = 0, hideTime:Number = 0, text:String='', exerciseRoleId:int=0, exerciseRoleName:String=''){
			this.id = id;
			this.subtitleId = subtitleId;
			this.showTime = showTime;
			this.hideTime = hideTime;
			this.text = text;
			this.exerciseRoleId = exerciseRoleId;
			this.exerciseRoleName = exerciseRoleName;
		}
	}
}