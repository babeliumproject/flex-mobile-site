package commands.evaluation
{
	import business.EvaluationDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.EvaluationEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;
	
	public class GetResponsesWaitingAssessmentCommand implements ICommand, IResponder
	{
		private var dataModel:DataModel = DataModel.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			new EvaluationDelegate(this).getResponsesWaitingAssessment();
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			var resultCollection:ArrayCollection;
			
			if (result is Array && (result as Array).length > 0 )
			{
			
				resultCollection=new ArrayCollection(ArrayUtil.toArray(result));
				//Set the data in the application's model
				dataModel.waitingForAssessmentData = resultCollection;
			} else {
				dataModel.waitingForAssessmentData = new ArrayCollection();
				dataModel.responeListEmpty=true;
			}
			dataModel.waitingForAssessmentDataRetrieved = !dataModel.waitingForAssessmentDataRetrieved;
		}
		
		public function fault(info:Object):void
		{
			trace(ObjectUtil.toString(info));
			//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_RETRIEVING_RESPONSES_WAITING'));

		}
	}
}