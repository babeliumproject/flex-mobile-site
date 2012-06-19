package vo
{
	[RemoteClass(alias="UserVO")]
   	[Bindable]
	public class UserVO
	{
		public var id:int;
		public var name:String;
		public var email:String;
		public var creditCount:int;
		public var realName:String;
		public var realSurname:String;
		public var active:Boolean;
		public var joiningDate:String;
		public var isAdmin:Boolean;
		
		public var userLanguages:Array; //An array of UserLanguageVO objects
	}
}