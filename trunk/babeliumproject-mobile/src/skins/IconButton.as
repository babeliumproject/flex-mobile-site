package skins
{

	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.Button;
	import spark.components.TextInput;

	[Style(name="icon", type="*")]
	
	[Style(name="gradientColors", type="Array", arrayType="uint", format="Color", inherit="yes" )]
	
	[Style(name="gradientColorsOver", type="Array", arrayType="uint", format="Color", inherit="yes" )]
	
	[Style(name="gradientColorsDown", type="Array", arrayType="uint", format="Color", inherit="yes" )]
	
	[Style(name="borderColors", type="Array", arrayType="uint", format="Color", inherit="yes" )]
	
	[Style(name="borderSize", type="uint", format="Length", inherit="yes" )]
	
	[Style(name="colorOver", type="uint", format="Color", inherit="yes" )]
	
	[Style(name="colorDown", type="uint", format="Color", inherit="yes" )]
	
	[Style(name="underlineOver", type="Boolean", inherit="yes" )]
	
	[Style(name="underlineDown", type="Boolean", inherit="yes" )]
	
	[Style(name="padding", type="uint", format="Length", inherit="yes" )]

	public class IconButton extends Button
	{

		// Define a static variable.
		private static var classConstructed:Boolean=classConstruct();

		public function IconButton()
		{
			super();
			this.buttonMode=true;
		}



		// Define a static method.
		private static function classConstruct():Boolean
		{
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("skins.IconButton"))
			{
				// If there is no CSS definition for StyledRectangle, 
				// then create one and set the default value.
				var iconButtonStyles:CSSStyleDeclaration=new CSSStyleDeclaration();
				iconButtonStyles.defaultFactory=function():void
				{
					this.icon='';
				}
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("skins.IconButton", iconButtonStyles, true);

			}
			return true;
		}


		// Define the flag to indicate that a style property changed.
		private var bStypePropChanged:Boolean=true;

		// Define the variable to hold the current icon path.
		private var iconPath:String;



		override public function styleChanged(styleProp:String):void
		{

			super.styleChanged(styleProp);

			// Check to see if style changed. 
			if (styleProp == "icon")
			{
				bStypePropChanged=true;
				invalidateDisplayList();
				return;
			}
		}
	}
}