package vo
{
	[RemoteClass(alias="NewUserVO")]
   	[Bindable]
	public class NewUserVO
	{
		public var name:String;
		public var pass:String;
     	public var realName:String;
     	public var realSurname:String;
		public var email:String;
		public var activationHash:String;
		
		//Stores the languages the user knows or is interested in
		public var languages:Array;
		
		public function NewUserVO(name:String, pass:String, realName:String, realSurname:String, email:String, activationHash:String, languages:Array){
			
			this.name = name;
			this.pass = pass;
			this.realName = realName;
			this.realSurname = realSurname;
			this.email =  email;
			this.activationHash = activationHash;
			this.languages = languages;

		}
		
		
	}
}