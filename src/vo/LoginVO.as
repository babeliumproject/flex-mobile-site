package vo
{
	[RemoteClass(alias="LoginVO")]
	[Bindable]
	public class LoginVO
	{
		public var username:String;
		public var password:String;
		
		public function LoginVO(name:String, pass:String)
		{
			this.username = name;
			this.password = pass;
		}
	}
}