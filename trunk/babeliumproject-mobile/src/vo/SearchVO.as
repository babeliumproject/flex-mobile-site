package vo
{

	[RemoteClass(alias="SearchVO")]
	[Bindable]
	public class SearchVO
	{
		public var id:int; //Only used on data retrieving
		public var name:String; //Place here the filename or the Youtube videoID
		public var title:String;
		public var description:String;
		public var tags:String;
		public var language:String;
		public var source:String; //Youtube or Red5

		public var userName:String;

		public var thumbnailUri:String;
		public var addingDate:String;
		public var duration:int;
		public var transcriptionId:int;
		
		public var avgRating:Number;
		public var avgDifficulty:Number;

	}
}