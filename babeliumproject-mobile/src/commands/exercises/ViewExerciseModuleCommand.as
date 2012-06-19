package commands.exercises
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import control.BabeliaBrowserManager;
	
	import events.CloseConnectionEvent;
	import events.ViewChangeEvent;
	
	import model.DataModel;
	
	import modules.exercises.Exercises;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;

	public class ViewExerciseModuleCommand implements ICommand
	{

		public function execute(event:CairngormEvent):void
		{
			var index:uint = ViewChangeEvent.VIEWSTACK_EXERCISE_MODULE_INDEX;
			DataModel.getInstance().currentContentViewStackIndex = index;
			
			
			BabeliaBrowserManager.getInstance().updateURL(
				BabeliaBrowserManager.index2fragment(index));
		}
		
	}
}