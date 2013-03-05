//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Babelium Project open source collaborative second language oral practice - http://www.babeliumproject.com
//
//  Copyright (c) 2011 GHyM and by respective authors (see below).
//	
//	This file is part of Babelium Project.
//		
//	Babelium Project is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//	
//	Babelium Project is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package modules.main
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.Capabilities;
	
	import model.DataModel;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ResourceEvent;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;
	
	import view.common.IconComboBox;
	
	public class LocalizationComboBox extends IconComboBox
	{
		
		private var _availableLocales:Array=DataModel.getInstance().localesAndFlags.guiLanguages;
		
		public function LocalizationComboBox()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function onCreationComplete(event:FlexEvent):void{
			
			this.setStyle('fontWeight', 'normal');
			
			this.dataProvider=_availableLocales;
			
			this.labelFunction=localeComboBoxLabelFunction;
			this.addEventListener(ListEvent.CHANGE, localeComboBoxChangeHandler);
			updateLocaleComboBox();
		}
		
		/**
		 * Parses the language codes and returns a locally formatted label with the name of the language
		 * 
		 * @param item
		 * @return Language name
		 */		
		public function localeComboBoxLabelFunction(item:Object):String
		{
			var locale:String=String(item.code);
			var upperLocale:String=locale.toUpperCase();
			return resourceManager.getString('myResources', 'LOCALE_' + upperLocale);
		}
		
		public function localeComboBoxChangeHandler(event:Event):void
		{
			var newLocale:String=String(this.selectedItem.code);
			if (resourceManager.getLocales().indexOf(newLocale) != -1)
			{
				switchLocale();
			}
			else
			{
				var resourceModuleURL:String="Resources_" + newLocale + ".swf";
				var eventDispatcher:IEventDispatcher=resourceManager.loadResourceModule(resourceModuleURL);
				eventDispatcher.addEventListener(ResourceEvent.COMPLETE, resourceModuleCompleteHandler);
			}
		}
		
		private function resourceModuleCompleteHandler(event:ResourceEvent):void
		{
			switchLocale();
		}
		
		private function switchLocale():void
		{
			var newLocale:String=String(this.selectedItem.code);
			resourceManager.localeChain=[newLocale];
			updateLocaleComboBox();
			DataModel.getInstance().languageChanged=!DataModel.getInstance().languageChanged;
		}
		
		private function localeCompareFunction(item1:Object, item2:Object):int
		{
			var language1:String=localeComboBoxLabelFunction(item1);
			var language2:String=localeComboBoxLabelFunction(item2);
			if (language1 < language2)
				return -1;
			if (language1 > language2)
				return 1;
			return 0;
		}
		
		private function updateLocaleComboBox():void
		{
			// Repopulate the combobox with locales,
			// re-sorting by localized language name.
			_availableLocales.sort(localeCompareFunction);
			this.dataProvider=_availableLocales;
			updateSelected(resourceManager.localeChain[0]);
		}
		
		private function updateSelected(localeCode:String) : void
		{
			// Update selected index
			for ( var i:int; i < _availableLocales.length; i++)
			{
				if ( localeCode == _availableLocales[i].code )
				{
					this.selectedIndex = i;
					this.selectedItem = _availableLocales[i];
					break;
				}
			}
		}
		
		public function updateSelectedIndex(): void
		{
			var localeCode:String = resourceManager.localeChain[0];
			_availableLocales.sort(localeCompareFunction);
			updateSelected(localeCode);
		}
		
	}
}