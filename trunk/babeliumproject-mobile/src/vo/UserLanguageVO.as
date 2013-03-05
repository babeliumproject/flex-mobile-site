package vo
{
	
	[RemoteClass(alias="UserLanguageVO")]
	[Bindable]
	public class UserLanguageVO
	{
		//public static const PURPOSE_EVALUATE:String = 'evaluate';
		//public static const PURPOSE_PRACTICE:String = 'practice';
		
		public var id:int;
		public var language:String; //Use the language's two digit code: ES, EU, FR, EN...
		public var level:int; //Level goes from 1 to 6. 7 used for mother tongue
		public var purpose:String;
		public var positivesToNextLevel:int; //An indicator of how many assessments or steps are needed to advance to the next level
		
		public function UserLanguageVO(id:int=0, language:String='', level:int=0, purpose:String='practice', positivesToNextLevel:int=0)
		{
			this.id=id;
			this.language=language;
			this.level=level;
			this.purpose=purpose;
			this.positivesToNextLevel=positivesToNextLevel;
		}
		
	}
}