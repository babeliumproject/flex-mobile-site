package commands.evaluation
{
	import business.EvaluationDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.CreditEvent;
	import events.EvaluationEvent;
	
	import model.DataModel;
	
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	import view.common.CustomAlert;
	
	import vo.UserVO;
	
	public class AddVideoAssessmentCommand implements ICommand, IResponder
	{
		private var dataModel:DataModel = DataModel.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			new EvaluationDelegate(this).addVideoAssessment((event as EvaluationEvent).evaluation);
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			if (!result is UserVO)
			{
				CustomAlert.error(ResourceManager.getInstance().getString('myResources','YOUR_ASSESSMENT_COULDNT_BE_SAVE'));
			}
			else
			{
				var userData:UserVO=result as UserVO;
				dataModel.loggedUser.creditCount=userData.creditCount;
				CustomAlert.info(ResourceManager.getInstance().getString('myResources','YOUR_ASSESSMENT_HAS_BEEN_SAVED'));
				dataModel.addAssessmentRetrieved=!dataModel.addAssessmentRetrieved;
				dataModel.creditUpdateRetrieved=true;
			}
		}
		
		public function fault(info:Object):void
		{
			trace(ObjectUtil.toString(info));
			CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_SAVING_YOUR_ASSESSMENT'));
		}
	}
}