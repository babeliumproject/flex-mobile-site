package vo
{
	[RemoteClass(alias="ResponseVO")]
	[Bindable]
	public class ResponseVO
	{
		public var id:int;
		public var exerciseId:int;
		public var fileIdentifier:String;
		public var isPrivate:Boolean;
		public var thumbnailUri:String;
		public var source:String;
		public var duration:int;
		public var addingDate:String;
		public var ratingAmount:int;
		public var characterName:String;
		public var transcriptionId:int;
		public var subtitleId:int;
		
		
		public function ResponseVO(id:int, exerciseId:int, fileIdentifier:String, isPrivate:Boolean, thumbnailUri:String, source:String, duration:int, addingDate:String, ratingAmount:int, characterName:String, transcriptionId:int, subtitleId:int){
			this.id = id;
			this.exerciseId = exerciseId;
			this.fileIdentifier = fileIdentifier;
			this.isPrivate = isPrivate;
			this.thumbnailUri = thumbnailUri;
			this.source = source;
			this.duration = duration;
			this.addingDate = addingDate;
			this.ratingAmount = ratingAmount;
			this.characterName = characterName;
			this.transcriptionId = transcriptionId;
			this.subtitleId = subtitleId;
		}
		

	}
}