package vo
{
   [RemoteClass(alias="EvaluationVO")]
   [Bindable]
   public class EvaluationVO
   {
	   public var id:int;
	   public var responseId:int; //The resource that has been assessed
	   public var overallScore:uint;
	   public var intonationScore:uint;
	   public var fluencyScore:uint;
	   public var rhythmScore:uint;
	   public var spontaneityScore:uint;
	   public var comment:String;
	   public var addingDate:String;
	   
	   //When the same responseId has more than one entry this returns the average scores
	   public var overallScoreAverage:Number;
	   public var intonationScoreAverage:Number;
	   public var fluencyScoreAverage:Number;
	   public var rhythmScoreAverage:Number;
	   public var spontaneityScoreAverage:Number; 
	   
	   //When the video has video comments this fields are filled up with that video's data
	   public var evaluationVideoId:int;
	   public var evaluationVideoFileIdentifier:String;
	   public var evaluationVideoThumbnailUri:String;	
	   
	   //When retrieving the responses that need to be assessed... we also need info about the
	   //exercise that was followed to record the response that lead to the need of an assessment. 
	   public var exerciseId:int;
	   public var exerciseName:String;
	   public var exerciseSource:String;
	   public var exerciseTitle:String;
	   public var exerciseLanguage:String;
	   public var exerciseDuration:int;
	   public var exerciseThumbnailUri:String;
	   public var exerciseAvgDifficulty:Number;
	   
	   
	   public var responseFileIdentifier:String;
	   public var responseSource:String;
	   public var responseThumbnailUri:String;
	   public var responseDuration:int;
	   public var responseCharacterName:String;
	   public var responseRatingAmount:int;
	   public var responseAddingDate:String;
	   public var responseUserName:String;
	   public var responseSubtitleId:int;
	   
	   public var userName:String;
	   
	   public var transcriptionSystem:String;

   }
}