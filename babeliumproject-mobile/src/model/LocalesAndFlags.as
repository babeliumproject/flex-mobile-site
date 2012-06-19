package model
{
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	import mx.resources.ResourceManager;

	public class LocalesAndFlags
	{

		[Bindable]
		[Embed("../resources/images/flags/flag_united_states.png")]
		private var FlagUnitedStates:Class;
		
		[Bindable]
		[Embed("../resources/images/flags/flag_new_zealand.png")]
		private var FlagNewZealand:Class;

		[Bindable]
		[Embed("../resources/images/flags/flag_spain.png")]
		public var FlagSpain:Class;

		[Bindable]
		[Embed("../resources/images/flags/flag_basque_country.png")]
		public var FlagBasqueCountry:Class;

		[Bindable]
		[Embed("../resources/images/flags/flag_france.png")]
		public var FlagFrance:Class;
		
		[Bindable]
		[Embed("../resources/images/flags/flag_morocco.png")]
		public var FlagMorocco:Class;
		
		[Bindable]
		[Embed("../resources/images/flags/flag_germany.png")]
		public var FlagGermany:Class;
		
		[Bindable]
		[Embed("../resources/images/flags/flag_italy.png")]
		public var FlagItaly:Class;
		
//		private var af_ZA:Object={code: 'af_ZA', icon: };
//		private var sq_AL:Object={code: 'sq_AL', icon: };
//		private var ar_DZ:Object={code: 'ar_DZ', icon: };
//		private var ar_BH:Object={code: 'ar_BH', icon: };
//		private var ar_EG:Object={code: 'ar_EG', icon: };
//		private var ar_IQ:Object={code: 'ar_IQ', icon: };
//		private var ar_JO:Object={code: 'ar_JO', icon: };
//		private var ar_KW:Object={code: 'ar_KW', icon: };
//		private var ar_LB:Object={code: 'ar_LB', icon: };
//		private var ar_LY:Object={code: 'ar_LY', icon: };
		private var ar_MA:Object={code: 'ar_MA', icon: FlagMorocco};
//		private var ar_OM:Object={code: 'ar_OM', icon: };
//		private var ar_QA:Object={code: 'ar_QA', icon: };
//		private var ar_SA:Object={code: 'ar_SA', icon: };
//		private var ar_SY:Object={code: 'ar_SY', icon: };
//		private var ar_TN:Object={code: 'ar_TN', icon: };
//		private var ar_AE:Object={code: 'ar_AE', icon: };
//		private var ar_YE:Object={code: 'ar_YE', icon: };
//		private var hy_AM:Object={code: 'hy_AM', icon: };
//		private var az_AZ:Object={code: 'az_AZ' icon: };
		private var eu_ES:Object={code: 'eu_ES', icon: FlagBasqueCountry};
//		private var be_BY:Object={code: 'be_BY' icon: };
//		private var bg_BG:Object={code: 'bg_BG' icon: };
//		private var ca_ES:Object={code: 'ca_ES' icon: };
//		private var zh_HK:Object={code: 'zh_HK' icon: };
//		private var zh_MO:Object={code: 'zh_MO' icon: };
//		private var zh_CN:Object={code: 'zh_CN' icon: };
//		private var zh_SG:Object={code: 'zh_SG' icon: };
//		private var zh_TW:Object={code: 'zh_TW' icon: };
//		private var hr_HR:Object={code: 'hr_HR' icon: };
//		private var cs_CZ:Object={code: 'cs_CZ' icon: };
//		private var da_DK:Object={code: 'da_DK' icon: };
//		private var nl_BE:Object={code: 'nl_BE' icon: };
//		private var nl_NL:Object={code: 'nl_NL' icon: };
//		private var en_AU:Object={code: 'en_AU' icon: };
//		private var en_BZ:Object={code: 'en_BZ' icon: };
//		private var en_CA:Object={code: 'en_CA' icon: };
//		private var en_CB:Object={code: 'en_CB' icon: };
//		private var en_IE:Object={code: 'en_IE' icon: };
//		private var en_JM:Object={code: 'en_JM' icon: };
		private var en_NZ:Object={code: 'en_NZ', icon: FlagNewZealand};
//		private var en_PH:Object={code: 'en_PH' icon: };
//		private var en_ZA:Object={code: 'en_ZA' icon: };
//		private var en_TT:Object={code: 'en_TT' icon: };
//		private var en_GB:Object={code: 'en_GB' icon: };
		private var en_US:Object={code: 'en_US', icon: FlagUnitedStates};
//		private var en_ZW:Object={code: 'en_ZW' icon: };
//		private var et_EE:Object={code: 'et_EE' icon: };
//		private var fo_FO:Object={code: 'fo_FO' icon: };
//		private var fa_IR:Object={code: 'fa_IR' icon: };
//		private var fi_FI:Object={code: 'fi_FI' icon: };
//		private var fr_BE:Object={code: 'fr_BE' icon: };
//		private var fr_CA:Object={code: 'fr_CA' icon: };
		private var fr_FR:Object={code: 'fr_FR', icon: FlagFrance};
//		private var fr_LU:Object={code: 'fr_LU' icon: };
//		private var fr_MC:Object={code: 'fr_MC' icon: };
//		private var fr_CH:Object={code: 'fr_CH' icon: };
//		private var gl_ES:Object={code: 'gl_ES' icon: };
//		private var ka_GE:Object={code: 'ka_GE' icon: };
//		private var de_AT:Object={code: 'de_AT' icon: };
		private var de_DE:Object={code: 'de_DE', icon: FlagGermany};
//		private var de_LI:Object={code: 'de_LI' icon: };
//		private var de_LU:Object={code: 'de_LU' icon: };
//		private var de_CH:Object={code: 'de_CH' icon: };
//		private var el_GR:Object={code: 'el_GR' icon: };
//		private var gu_IN:Object={code: 'gu_IN' icon: };
//		private var he_IL:Object={code: 'he_IL' icon: };
//		private var hi_IN:Object={code: 'hi_IN' icon: };
//		private var hu_HU:Object={code: 'hu_HU' icon: };
//		private var is_IS:Object={code: 'is_IS' icon: };
//		private var id_ID:Object={code: 'id_ID' icon: };
		private var it_IT:Object={code: 'it_IT', icon: FlagItaly};
//		private var it_CH:Object={code: 'it_CH' icon: };
//		private var ja_JP:Object={code: 'ja_JP' icon: };
//		private var kn_IN:Object={code: 'kn_IN' icon: };
//		private var kk_KZ:Object={code: 'kk_KZ' icon: };	
//		private var ko_KR:Object={code: 'ko_KR' icon: };	
//		private var ky_KG:Object={code: 'ky_KG' icon: };	
//		private var lv_LV:Object={code: 'lv_LV' icon: };	
//		private var lt_LT:Object={code: 'lt_LT' icon: };
//		private var mk_MK:Object={code: 'mk_MK' icon: };
//		private var ms_BN:Object={code: 'ms_BN' icon: };
//		private var ms_MY:Object={code: 'ms_MY' icon: };
//		private var mr_IN:Object={code: 'mr_IN' icon: };
//		private var mn_MN:Object={code: 'mn_MN' icon: };
//		private var nb_NO:Object={code: 'nb_NO' icon: };
//		private var nn_NO:Object={code: 'nn_NO' icon: };
//		private var pl_PL:Object={code: 'pl_PL' icon: };
//		private var pt_BR:Object={code: 'pt_BR' icon: };
//		private var pt_PT:Object={code: 'pt_PT' icon: };
//		private var pa_IN:Object={code: 'pa_IN' icon: };
//		private var ro_RO:Object={code: 'ro_RO' icon: };
//		private var ru_RU:Object={code: 'ru_RU' icon: };
//		private var sa_IN:Object={code: 'sa_IN' icon: };
//		private var sr_SP:Object={code: 'sr_SP' icon: };
//		private var sk_SK:Object={code: 'sk_SK' icon: };
//		private var sl_SI:Object={code: 'sl_SI' icon: };
//		private var es_AR:Object={code: 'es_AR' icon: };
//		private var es_BO:Object={code: 'es_BO' icon: };
//		private var es_CL:Object={code: 'es_CL' icon: };
//		private var es_CO:Object={code: 'es_CO' icon: };
//		private var es_CR:Object={code: 'es_CR' icon: };
//		private var es_DO:Object={code: 'es_DO' icon: };
//		private var es_EC:Object={code: 'es_EC' icon: };
//		private var es_SV:Object={code: 'es_SV' icon: };
//		private var es_GT:Object={code: 'es_GT' icon: };
//		private var es_HN:Object={code: 'es_HN' icon: };
//		private var es_MX:Object={code: 'es_MX' icon: };
//		private var es_NI:Object={code: 'es_NI' icon: };
//		private var es_PA:Object={code: 'es_PA' icon: };
//		private var es_PY:Object={code: 'es_PY' icon: };
//		private var es_PE:Object={code: 'es_PE' icon: };
//		private var es_PR:Object={code: 'es_PR' icon: };
		private var es_ES:Object={code: 'es_ES', icon: FlagSpain};
//		private var es_UY:Object={code: 'es_UY' icon: };
//		private var es_VE:Object={code: 'es_VE' icon: };
//		private var sw_KE:Object={code: 'sw_KE' icon: };
//		private var sv_FI:Object={code: 'sv_FI' icon: };
//		private var sv_SE:Object={code: 'sv_SE' icon: };
//		private var ta_IN:Object={code: 'ta_IN' icon: };
//		private var tt_RU:Object={code: 'tt_RU' icon: };
//		private var te_IN:Object={code: 'te_IN' icon: };
//		private var th_TH:Object={code: 'th_TH' icon: };
//		private var tr_TR:Object={code: 'tr_TR' icon: };
//		private var uk_UA:Object={code: 'uk_UA' icon: };
//		private var ur_PK:Object={code: 'ur_PK' icon: };
//		private var uz_UZ:Object={code: 'uz_UZ' icon: };
//		private var vi_VN:Object={code: 'vi_VN' icon: };
		
		
		//This array contains the selectable languages for the exercises
		[Bindable] public var availableLanguages:Array = new Array();
		

		//The selectable GUI languages
		[Bindable] public var guiLanguages:Array = new Array;

		public function LocalesAndFlags()
		{
			availableLanguages.push(en_US);
			availableLanguages.push(en_NZ);
			availableLanguages.push(es_ES);
			availableLanguages.push(eu_ES);
			availableLanguages.push(fr_FR);
			availableLanguages.push(de_DE);
			availableLanguages.push(ar_MA);
			availableLanguages.push(it_IT);
			
			for each(var code:String in ResourceManager.getInstance().getLocales()){
				guiLanguages.push(getLocaleAndFlagGivenLocaleCode(code));
			}
		}

		public function getLocaleAndFlagGivenLocaleCode(code:String):Object
		{
			var localeAndFlag:Object = null;
			for each(var language:Object in availableLanguages){
				if(language.code == code){
					localeAndFlag = language;
					break;
				}
			}
			return localeAndFlag;
		}
		
		public function getLevelCorrespondence(avgDifficulty:Number):String
		{
			var numFormat:NumberFormatter=new NumberFormatter();
			numFormat.precision=0;
			numFormat.rounding=NumberBaseRoundType.NEAREST;
			var roundedAvgDifficulty:int=int(numFormat.format(avgDifficulty));
			switch (roundedAvgDifficulty)
			{
				case 1:
					return 'A1';
					break;
				case 2:
					return 'A2';
					break;
				case 3:
					return 'B1';
					break;
				case 4:
					return 'B2';
					break;
				case 5:
					return 'C1';
					break;
				default:
					return '';
					break;
			}
		}

	}
}
