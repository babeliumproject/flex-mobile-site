package commands.home
{
	import business.HomepageDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;
	
	public class LatestUploadedVideosCommand implements ICommand, IResponder
	{
		private var dataModel:DataModel = DataModel.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			new HomepageDelegate(this).latestAvailableVideos();
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			var resultCollection:ArrayCollection;
			
			if (result is Array && (result as Array).length > 0 )
			{
				resultCollection=new ArrayCollection(ArrayUtil.toArray(result));
				//Set the data in the application's model
				dataModel.signedInLatestUploadedVideos = resultCollection;
			} else {
				dataModel.signedInLatestUploadedVideos = new ArrayCollection();
			}
			dataModel.signedInLatestUploadedVideosRetrieved = !dataModel.signedInLatestUploadedVideosRetrieved;
		}
		
		public function fault(info:Object):void
		{
			trace(ObjectUtil.toString(info));
			//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_RETRIEVING_LATEST_ACTIVITY'));
		}
	}
}