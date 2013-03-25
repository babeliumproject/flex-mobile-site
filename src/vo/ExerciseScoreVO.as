package vo
{

	[RemoteClass(alias="ExerciseScoreVO")]
	[Bindable]
	public class ExerciseScoreVO
	{
		public var id:int;
		public var exerciseId:int;
		public var suggestedScore:int;
		public var suggestionDate:int;

	}
}