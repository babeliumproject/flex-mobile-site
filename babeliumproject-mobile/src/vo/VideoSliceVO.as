package vo
{
	[RemoteClass(alias="VideoSliceVO")]
	[Bindable]
	public class VideoSliceVO
	{
		public var id:int; //Only used on data retrieving
		public var name:String; //Place here the Youtube videoID
		public var watchUrl:String;
		public var start_time:int; // Video slice start time frame
		public var duration:int; //Video slice duration 
		
			
		

	}
}