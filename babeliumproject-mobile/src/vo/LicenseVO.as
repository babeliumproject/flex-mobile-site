package vo
{
	[RemoteClass(alias="LicenseVO")]
	[Bindable]
	public class LicenseVO
	{
		
		public var imageResource:String;
		public var tooltip:String;
		public var licenseUrl:String;
		
		public function LicenseVO(imageResource:String = null, tooltip:String = null, licenseUrl:String = null)
		{
			this.imageResource = imageResource;
			this.tooltip = tooltip;
			this.licenseUrl = licenseUrl;
		}
	}
}