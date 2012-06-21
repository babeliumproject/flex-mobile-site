package commands.exercises
{
	import business.ResponseDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.CreditEvent;
	import events.ResponseEvent;
	
	import model.DataModel;
	
	//import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;
	
	import vo.UserVO;

	public class MakeResponsePublicCommand implements ICommand, IResponder
	{

		public function execute(event:CairngormEvent):void
		{
			new ResponseDelegate(this).makePublic((event as ResponseEvent).response);
		}
		
		public function result(data:Object):void {
			
			var result:Object=data.result;
			if (!result is UserVO)
			{
				//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_UPDATING_RESPONSE'));
			}
			else
			{
				var userData:UserVO=result as UserVO;
				trace(userData.name);
				DataModel.getInstance().loggedUser.creditCount=userData.creditCount;
				DataModel.getInstance().creditUpdateRetrieved=true;
			}
		}

		public function fault(info:Object):void {
			var faultEvent:FaultEvent = FaultEvent(info);
		//	CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_MAKING_RESPONSE_PUBLIC'));
			trace(ObjectUtil.toString(info));
		}
		
	}
}