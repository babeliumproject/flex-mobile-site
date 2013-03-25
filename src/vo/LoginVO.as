package vo
{
	[RemoteClass(alias="LoginVO")]
	[Bindable]
	public class LoginVO
	{
		public var name:String;
		public var pass:String;
		
		public function LoginVO(name:String, pass:String)
		{
			this.name = name;
			this.pass = pass;
		}
	}
}