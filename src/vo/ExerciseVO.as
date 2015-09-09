package vo
{

	[RemoteClass(alias="ExerciseVO")]
	[Bindable]
	public class ExerciseVO
	{
		public var id:int; //Only used on data retrieving
		public var name:String; //Place here the filename or the Youtube videoID
		public var title:String;
		public var description:String;
		public var tags:String;
		public var language:String;
		public var source:String; //Youtube or Red5

		public var userName:String;
		public var userId:uint;

		public var thumbnailUri:String;
		public var addingDate:String;
		public var duration:int;
		public var transcriptionId:int;
		public var status:String;
		public var license:String;
		public var reference:String;
		
		public var ismodel:uint;
		public var model_id: int;
		
		public var type: int;
		public var situation: int;
		public var competence: int;
		public var lingaspect: int;
		
		public var avgRating:Number;
		public var ratingCount:int; //used for bayesian average rating calculation
		
		public var avgDifficulty:Number;
		
		public var isSubtitled:uint;
		
		public var descriptors:*;
		
		public var score:Number; //is used to sort the searches
		public var idIndex:int; //is used to delete exercises
		public var itemSelected:Boolean; //Determines whether this object is selected in a customRenderer list-based control

	}
}