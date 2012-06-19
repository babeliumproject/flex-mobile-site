package skins
{
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.TitleWindow;
	
	[Style(name="backgroundImage", type="*")]
	
	public class CustomTitleWindow extends TitleWindow
	{
		
		// Define a static variable.
		private static var classConstructed:Boolean=classConstruct();
		
		public function CustomTitleWindow()
		{
			super();
		}
		
		// Define a static method.
		private static function classConstruct():Boolean
		{
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("skins.CustomTitleWindowSkin"))
			{
				// If there is no CSS definition for StyledRectangle, 
				// then create one and set the default value.
				var customTitleWindowStyles:CSSStyleDeclaration=new CSSStyleDeclaration();
				customTitleWindowStyles.defaultFactory=function():void
				{
					this.backgroundImage='';
				}
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("skins.CustomTitleWindowSkin", customTitleWindowStyles, true);
				
			}
			return true;
		}
		
		
		// Define the flag to indicate that a style property changed.
		private var bStypePropChanged:Boolean=true;
		
		// Define the variable to hold the current icon path.
		private var backgroundImagePath:String;
		
		
		
		override public function styleChanged(styleProp:String):void
		{
			
			super.styleChanged(styleProp);
			
			// Check to see if style changed. 
			if (styleProp == "backgroundImage")
			{
				bStypePropChanged=true;
				invalidateDisplayList();
				return;
			}
		}
		
	}
}