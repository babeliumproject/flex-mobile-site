package commands.exercises
{
	import business.ResponseDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.ResponseEvent;
//	import events.ViewChangeEvent;
	
	import model.DataModel;
	
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;
	
	import vo.ResponseVO;

	public class SaveResponseCommand implements ICommand, IResponder
	{

		public function execute(event:CairngormEvent):void
		{
			new ResponseDelegate(this).saveResponse((event as ResponseEvent).response);
		}
		
		public function result(data:Object):void
		{
			//Should be the id of the added response
			if (!data.result is int){
				
				//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_SAVING_RESPONSE'));
			} else {
				
				var responseId:int = data.result.toString();
				//The response has been successfully saved, so we must store it's id in the model
				DataModel.getInstance().savedResponseId = responseId;
				DataModel.getInstance().savedResponseRetrieved = !DataModel.getInstance().savedResponseRetrieved;
				
				var response:ResponseVO=new ResponseVO(responseId, 0, "", false, "", "", 0, "", 0, "", 0, 0);
				new ResponseEvent(ResponseEvent.MAKE_RESPONSE_PUBLIC, response).dispatch();
			}
			
		}
		
		public function fault(info:Object):void
		{
			var faultEvent : FaultEvent = FaultEvent(info);
			//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_SAVING_RESPONSE'));
			trace(ObjectUtil.toString(info));
		}
		
	}
}