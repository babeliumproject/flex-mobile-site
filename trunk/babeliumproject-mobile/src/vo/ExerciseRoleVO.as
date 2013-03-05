package vo
{

	[RemoteClass(alias="ExerciseRoleVO")]
	[Bindable]
	public class ExerciseRoleVO
	{
		public var id:int;
		public var exerciseId:int;

		public var characterName:String;
		
		public function ExerciseRoleVO(id:int=0,exerciseId:int=0,characterName:String=''){
			this.id = id;
			this.exerciseId = exerciseId;
			this.characterName = characterName;
		}
	}
}