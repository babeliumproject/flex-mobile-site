package vo
{
	[RemoteClass(alias="ChangePassVO")]
	[Bindable]
	public class ChangePassVO
	{
		public var oldpass:String;
		public var newpass:String;
		
		public function ChangePassVO(oldpass:String, newpass:String)
		{
			this.oldpass = oldpass;
			this.newpass = newpass;
		}
	}
}