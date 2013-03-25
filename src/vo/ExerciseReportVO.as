package vo
{
	[RemoteClass(alias="ExerciseReportVO")]
	[Bindable]
	public class ExerciseReportVO
	{
		public var id:int;
		public var exerciseId:int;
		public var reason:String;
		public var reportDate:String;
	}
}