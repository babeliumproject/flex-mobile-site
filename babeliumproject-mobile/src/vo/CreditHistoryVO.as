package vo
{
	import com.adobe.cairngorm.vo.ValueObject;

	[RemoteClass(alias="CreditHistoryVO")]
	[Bindable]
	public class CreditHistoryVO
	{
		
		public var changeDate:String;
		public var changeType:String;
		public var changeAmount:int;
		public var userName:String;
		public var videoExerciseId:int;
		public var videoExerciseName:String;
		public var videoResponseId:int;
		public var videoResponseName:String;
		public var videoEvaluationId:int;
		public var videoEvaluationName:String;

	}
}