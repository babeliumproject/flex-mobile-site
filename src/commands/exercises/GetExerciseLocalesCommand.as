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
	
	
	
	public class GetExerciseLocalesCommand implements ICommand, IResponder
	{
		
		public function execute(event:CairngormEvent):void
		{
			new ExerciseDelegate(this).getExerciseLocales((event as ExerciseEvent).exercise);
			
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			if (result is Array && (result as Array).length > 0 )
			{
				var resultList:Array = result as Array;
				var localeList:Array = new Array();
				for each (var item:Object in resultList){
					localeList.push(item.locale);
				}
			
				DataModel.getInstance().availableExerciseLocales = localeList;
				DataModel.getInstance().availableExerciseLocalesRetrieved = true;
			} else {
				//Set the data to the application's model
				DataModel.getInstance().availableExerciseLocales = null;
				//Reflect the visual changes
				DataModel.getInstance().availableExerciseLocalesRetrieved = true;
			}
		}
		
		public function fault(info:Object):void
		{
			var faultEvent:FaultEvent = FaultEvent(info);
			trace(ObjectUtil.toString(info));
		}
		
	}
}