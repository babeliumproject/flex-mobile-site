package modules.videoPlayer.controls
{
	import flash.utils.Dictionary;
	
	//import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	
	public class SkinableComponent extends UIComponent
	{
		private var skinColors:Dictionary;
		public var COMPONENT_NAME:String;
		
		public function SkinableComponent(name:String = "SkinableComponent" )
		{
			super();
			COMPONENT_NAME = name;
			skinColors = new Dictionary();
		}
		
		/**
		 * Shows available propertys
		 */
		public function availableProperties(obj:Array = null) : void
		{
			//Alert.show(ObjectUtil.toString(obj));
		}
		
		/**
		 * Sets color for a skinProperty
		 */
		public function setSkinProperty(propertyName:String, propertyValue:String) : void
		{
			skinColors[propertyName] = propertyValue;
		}
		
		/**
		 * Gets color from a skinProperty
		 */
		public function getSkinColor(propertyName:String) : uint
		{
			return new uint(skinColors[propertyName]);
		}
		
		/** 
		 * Returns the value of a property of this skin
		 */
		public function getSkinProperty(propertyName:String) : String
		{
			return skinColors[propertyName];
		}
		
		public function refresh() : void
		{
			updateDisplayList(0,0);
		}
		
	}
}

