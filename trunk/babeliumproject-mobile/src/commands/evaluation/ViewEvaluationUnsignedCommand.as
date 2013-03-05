package commands.evaluation
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.DataModel;
	
	public class ViewEvaluationUnsignedCommand implements ICommand
	{
		
		public function execute(event:CairngormEvent):void
		{
			DataModel.getInstance().currentEvaluationViewStackIndex = 0;
		}
	}
}