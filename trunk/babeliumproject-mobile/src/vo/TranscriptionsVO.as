package vo
{
	[RemoteClass(alias="TranscriptionsVO")]
	[Bindable]
	public class TranscriptionsVO
	{
		public var exerciseID:int;
		public var exerciseTranscriptionID:int;
		public var exerciseTranscriptionAddingDate:String;
		public var exerciseTranscriptionStatus:String;
		public var exerciseTranscription:String;
		public var exerciseTranscriptionDate:String;
		public var exerciseTranscriptionSystem:String;
		
		public var responseID:int;
		public var responseTranscriptionID:int;
		public var responseTranscriptionAddingDate:String;
		public var responseTranscriptionStatus:String;
		public var responseTranscription:String;
		public var responseTranscriptionDate:String;
		public var responseTranscriptionSystem:String;
	}
}