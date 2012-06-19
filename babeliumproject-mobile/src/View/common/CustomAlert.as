package view.common
{
	import flash.display.Sprite;

	import mx.controls.Alert;
	import mx.resources.ResourceManager;


	public class CustomAlert extends Alert
	{

		[Embed('/resources/images/alertError.png')]
		private static var errorIcon:Class;

		[Embed('/resources/images/alertInfo.png')]
		private static var infoIcon:Class;

		[Embed('/resources/images/alertConfirmation.png')]
		private static var confirmationIcon:Class;

		public function CustomAlert()
		{
			super();
		}

		public static function info(text:String="", parent:Sprite=null, closehandler:Function=null):void
		{
			var localizedTitle:String=ResourceManager.getInstance().getString('myResources', 'TITLE_INFORMATION');
			var alert:Alert=show(text, localizedTitle, 0x4, parent, closehandler, infoIcon, 0x4);
			setStyles(alert);
		}

		public static function error(text:String="", parent:Sprite=null, closehandler:Function=null):void
		{
			var localizedTitle:String=ResourceManager.getInstance().getString('myResources', 'TITLE_ERROR');
			var alert:Alert=show(text, localizedTitle, 0x4, parent, closehandler, errorIcon, 0x4);
			setStyles(alert);
		}

		public static function confirm(text:String="", flags:uint=0x3, parent:Sprite=null, closehandler:Function=null, defaultButtonFlag:uint=0x2):void
		{
			var localizedTitle:String=ResourceManager.getInstance().getString('myResources', 'TITLE_CONFIRMATION');
			var alert:Alert=show(text, localizedTitle, flags, parent, closehandler, confirmationIcon, defaultButtonFlag);
			setStyles(alert);

		}

		private static function setStyles(alert:Alert):void
		{
//			alert.setStyle('fontSize', 11);
//			alert.setStyle('backgroundColor', 0xffffff);
//			alert.setStyle('borderColor', 0xE5E8EA);
//			alert.setStyle('borderWeight', 1);
//			alert.setStyle('borderStyle', "solid");
//			alert.setStyle('dropShadowEnabled', true);
//			alert.setStyle('dropShadowColor', 0x000000);
//			alert.setStyle('cornerRadius', 6);
//			alert.setStyle('color', 0x2B333C);
//			alert.setStyle('paddingBottom', 2);
//			alert.setStyle('paddingLeft', 2);
//			alert.setStyle('paddingRight', 2);
//			alert.setStyle('headerHeight', 19);
//			alert.setStyle('headerColors', [0x919191, 0xFFFFFF]);
//			alert.setStyle('footerColors', [0x9db6d9, 0xffffff]);
//			alert.setStyle('borderColor', 0xaaaaaa);
//
//			alert.autoLayout=true;
		}


	}
}