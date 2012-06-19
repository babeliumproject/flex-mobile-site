package commands.exercises
{
	import business.ExerciseDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.ExerciseEvent;
	
	import model.DataModel;
	
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	import view.common.CustomAlert;

	public class UserReportedExerciseCommand implements ICommand, IResponder
	{

		public function execute(event:CairngormEvent):void
		{
			new ExerciseDelegate(this).userReportedExercise((event as ExerciseEvent).report);
		}

		public function result(data:Object):void
		{
			var reported:Boolean=data.result as Boolean;
			
			DataModel.getInstance().userReportedExercise = reported;
			DataModel.getInstance().userReportedExerciseFlag = !DataModel.getInstance().userReportedExerciseFlag;
		}

		public function fault(info:Object):void
		{
			var fault:FaultEvent=FaultEvent(info);
			CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_CHECKING_ALREADY_REPORTED'));
			trace(ObjectUtil.toString(fault));
		}
	}
}