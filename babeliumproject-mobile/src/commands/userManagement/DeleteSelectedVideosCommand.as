package commands.userManagement
{
	import business.UserDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.UserEvent;
	
	import model.DataModel;
	
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;
	
	public class DeleteSelectedVideosCommand implements ICommand, IResponder
	{
		
		public function execute(event:CairngormEvent):void
		{
			new UserDelegate(this).deleteSelectedVideos((event as UserEvent).dataList);
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			
			if (result == true){
				DataModel.getInstance().selectedVideosDeleted = true;
			} else {
				DataModel.getInstance().selectedVideosDeleted = false;
				//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_DELETING_VIDEOS'));
			}
		}
		
		public function fault(info:Object):void
		{
			var faultEvent:FaultEvent=FaultEvent(info);
			//CustomAlert.error(ResourceManager.getInstance().getString('myResources', 'ERROR_WHILE_DELETING_VIDEOS'));
			trace(ObjectUtil.toString(info));
		}
	}
}