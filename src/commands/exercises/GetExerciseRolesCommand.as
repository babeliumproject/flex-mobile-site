package commands.exercises
{
	import business.ExerciseRoleDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import events.ExerciseRoleEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	//import view.common.CustomAlert;


	public class GetExerciseRolesCommand implements ICommand, IResponder
	{

		public function execute(event:CairngormEvent):void
		{
			new ExerciseRoleDelegate(this).getExerciseRoles((event as ExerciseRoleEvent).exerciseRoles);
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			
			if (result is Array && (result as Array).length > 0 )
			{
				var resAr:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result));
				//Set the data to the application's model
				
				DataModel.getInstance().availableExerciseRoles.setItemAt(resAr, DataModel.SUBTITLE_MODULE);
				DataModel.getInstance().availableExerciseRoles.setItemAt(resAr, DataModel.RECORDING_MODULE);
				//Reflect the visual changes
				DataModel.getInstance().availableExerciseRolesRetrieved = new ArrayCollection(new Array (true, true));
			} else {
				//Set the data to the application's model
				DataModel.getInstance().availableExerciseRoles.setItemAt(new ArrayCollection(), DataModel.SUBTITLE_MODULE);
				DataModel.getInstance().availableExerciseRoles.setItemAt(new ArrayCollection(), DataModel.RECORDING_MODULE);

				//Reflect the visual changes
				DataModel.getInstance().availableExerciseRolesRetrieved = new ArrayCollection(new Array (true, true));
			}
		}
		
		public function fault(info:Object):void
		{
			
			var faultEvent:FaultEvent = FaultEvent(info);
		//	CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_RETRIEVING_ROLES'));
			trace(ObjectUtil.toString(info));
		}
		
	}
}