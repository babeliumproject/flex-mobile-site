package vo
{


	[RemoteClass(alias="SubtitleAndSubtitleLinesVO")];
	[Bindable]
	public class SubtitleAndSubtitleLinesVO
	{
		public var id:int;
		public var exerciseId:int;
		public var userName:String;
		public var language:String;
		public var translation:Boolean;
		public var addingDate:String;

		public var subtitleLines:Array;

		public function SubtitleAndSubtitleLinesVO(id:int=0, exerciseId:int=0, userName:String=null, language:String=null, translation:Boolean=false, addingDate:String=null, subtitleLines:Array=null)
		{
			this.id=id;
			this.exerciseId=exerciseId;
			this.userName=userName;
			this.language=language;
			this.translation=translation;
			this.addingDate=addingDate;
			this.subtitleLines=subtitleLines;
		}

	}
}