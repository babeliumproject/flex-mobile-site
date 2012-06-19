package vo
{
	import com.adobe.cairngorm.commands.ICommand;
	
	[Bindable]
	public class CueObject
	{
		public var subtitleId:uint;
		public var startTime:Number;
		public var endTime:Number;
		public var roleId:int;
		public var role:String;
		public var text:String;
		public var textColor:uint;
		
		private var startCommand:ICommand;
		private var endCommand:ICommand;
		
		
		public function CueObject(subtitleId:uint, startTime:Number, endTime:Number=-1, text:String=null, roleId:int=0, role:String=null, startCommand:ICommand=null, endCommand:ICommand=null, textColor:uint=0xffffff)
		{
			this.subtitleId=subtitleId;
			this.startTime=startTime;
			this.endTime=endTime;
			this.text=text;
			this.roleId=roleId;
			this.role=role;
			this.startCommand=startCommand;
			this.endCommand=endCommand;
			this.textColor=textColor;
		}
		
		public function executeStartCommand():void
		{
			startCommand.execute(null);
		}
		
		public function executeEndCommand():void
		{
			endCommand.execute(null);
		}
		
		public function setStartCommand(command:ICommand):void
		{
			this.startCommand=command;
		}
		
		public function setEndCommand(command:ICommand):void
		{
			this.endCommand=command;
		}
		
	}
}
