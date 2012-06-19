package vo
{
	[Bindable]
	public class RoleComboDataVO
	{
		
		public static const ACTION_INSERT:String = "insert";
		public static const ACTION_SELECT:String = "select";
		public static const ACTION_NO_ACTION:String = "nothing";
		public static const ACTION_DELETE:String = "delete";
		
		public static const FONT_NORMAL:String = "normal";
		public static const FONT_BOLD:String = "bold";
		
		public static const INDENT_NONE:int = 0;
		public static const INDENT_ROLE:int = 10;
		
		public var roleId:int;
		public var charName:String;
		public var action:String;
		public var fontWeight:String;
		public var indent:int;
		
		
		public function RoleComboDataVO(roleId:int=0, charName:String='', action:String='', fontWeight:String='',indent:int=0)
		{
			this.roleId = roleId;
			this.charName = charName;
			this.action = action;
			this.fontWeight = fontWeight;
			this.indent = indent;
		}
	}
}