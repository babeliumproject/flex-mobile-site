package View.common
{
	import vo.LicenseVO;

	public class LicenseResource
	{
		
		public static function getLicenseData(licenseCode:String):LicenseVO{
			var license:LicenseVO = new LicenseVO();
			license.imageResource = '';
			license.tooltip = 'Creative Commons Attribution';
			license.licenseUrl = 'http://creativecommons.org/licenses/';
			
			switch(licenseCode){
				case 'cc-by-nc-nd':
					license.imageResource = 'resources/images/licenses/cc-by-nc-nd.png';
					license.tooltip += ' Non-Commercial No Derivatives';
					license.licenseUrl= license.licenseUrl+'by-nc-nd/3.0/';
					break;
				case 'cc-by-nc-sa':
					license.imageResource = 'resources/images/licenses/cc-by-nc-sa.png';
					license.tooltip += ' Non-Commercial Share Alike';
					license.licenseUrl= license.licenseUrl+'by-nc-sa/3.0/';
					break;
				case 'cc-by-nc':
					license.imageResource = 'resources/images/licenses/cc-by-nc.png';
					license.tooltip += ' Non-Commercial';
					license.licenseUrl = license.licenseUrl+'by-nc/3.0/';
					break;
				case 'cc-by-nd':
					license.imageResource = 'resources/images/licenses/cc-by-nd.png';
					license.tooltip += ' No Derivatives';
					license.licenseUrl = license.licenseUrl+'by-nd/3.0/';
					break;
				case 'cc-by-sa':
					license.imageResource = 'resources/images/licenses/cc-by-sa.png';
					license.tooltip += ' Share Alike';
					license.licenseUrl= license.licenseUrl+'by-sa/3.0/';
					break;
				case 'cc-by':
					license.imageResource = 'resources/images/licenses/cc-by.png';
					license.licenseUrl = license.licenseUrl+'by/3.0/';
					break;
				case 'copyrighted':
					license.imageResource = 'resources/images/licenses/copyrighted.png';
					license.licenseUrl = '';
				default:
					break;
			}
			return license;
		}
	}
}