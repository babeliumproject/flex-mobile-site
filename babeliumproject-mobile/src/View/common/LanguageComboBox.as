package view.common
{

	import flash.events.Event;
	
	import model.DataModel;
	import model.LocalesAndFlags;
	
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.resources.ResourceManager;

	public class LanguageComboBox extends IconComboBox
	{

		private var _promptMessage:String=ResourceManager.getInstance().getString('myResources', 'PROMPT_SELECT_LANGUAGE');

		private var _displayPrompt:Boolean = true;
		
		private var _creationComplete:Boolean=false;

		private var _localesAndFlags:LocalesAndFlags=DataModel.getInstance().localesAndFlags;

		private var _useCustomDataProvider:Boolean=false;

		private var _currentDataProvider:Array = new Array();
		
		private var _prefixedValue:Object;

		public function LanguageComboBox()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		public function onCreationComplete(event:FlexEvent):void
		{

			_creationComplete=true;

			this.setStyle('fontWeight', 'normal');

			if (!_useCustomDataProvider)
				_currentDataProvider=_localesAndFlags.availableLanguages;
			this.dataProvider=_currentDataProvider;

			this.labelFunction=languageComboBoxLabelFunction;
			this.addEventListener(ListEvent.CHANGE, languageComboBoxChangeHandler);
			if(_displayPrompt)
				this.prompt=_promptMessage;
			updateLanguageComboBox();
		}

		public function set useCustomDataProvider(value:Boolean):void
		{
			_useCustomDataProvider=value;
		}
		
		public function set displayPrompt(value:Boolean):void{
			_displayPrompt = value;
		}

		public function set customDataProvider(languages:Array):void
		{
			var newData:Array=new Array();
			for (var i:int=0; i < languages.length; i++)
			{
				var localeAndFlag:Object=_localesAndFlags.getLocaleAndFlagGivenLocaleCode(languages[i]);
				if (localeAndFlag)
					newData.push(localeAndFlag);
			}
			_currentDataProvider=newData;
			if (_useCustomDataProvider && _creationComplete)
				this.dataProvider=null;
				this.dataProvider=_currentDataProvider;
		}

		// Localization combobox functions
		public function languageComboBoxLabelFunction(item:Object):String
		{
			var locale:String=String(item.code);
			var upperLocale:String=locale.toUpperCase();
			return resourceManager.getString('myResources', 'LOCALE_' + upperLocale);
		}

		public function languageComboBoxChangeHandler(event:Event):void
		{
			updateLanguageComboBox();
		}

		private function localeCompareFunction(item1:Object, item2:Object):int
		{
			var language1:String=languageComboBoxLabelFunction(item1);
			var language2:String=languageComboBoxLabelFunction(item2);
			if (language1 < language2)
				return -1;
			if (language1 > language2)
				return 1;
			return 0;
		}

		private function updateLanguageComboBox():void
		{
			if (_currentDataProvider.length > 0)
			{
				var oldSelectedItem:Object=this.selectedItem;
				// Repopulate the combobox with locales,
				// re-sorting by localized language name.
				_currentDataProvider.sort(localeCompareFunction);
				this.dataProvider=_currentDataProvider;
				this.selectedItem=oldSelectedItem;
			}
		}
		
		public function set prefixedValue(value:Object):void{
			_prefixedValue = value;
		}
		
		public function get prefixedValue():Object{
			return _prefixedValue;
		}

	}
}