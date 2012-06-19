package commands.search{
	
	import business.SearchDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
//	import view.common.CustomAlert;
	
	import vo.ExerciseVO;
	
	public class LaunchSearchCommand implements IResponder, ICommand{
		
			
		public function execute(event:CairngormEvent):void{
			new SearchDelegate(this).launchSearch(DataModel.getInstance().searchField);
		}
		
		public function result(data:Object):void{
			var result:Object=data.result;
			var resultCollection:ArrayCollection;

			if (result is Array){
				resultCollection=new ArrayCollection(ArrayUtil.toArray(result));
				try{
					if (!(resultCollection[0] is ExerciseVO)){
						//CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_PERFORMING_SEARCH'));
					}else{
						//Matches found
						//Set the data to the application's model
						DataModel.getInstance().videoSearches=resultCollection;
						//Reflect the visual changes
						DataModel.getInstance().videoSearchesRetrieved =true;
					}
				}catch(e:Error){
						//No matches found
						//Set the data to the application's model
						DataModel.getInstance().videoSearches=resultCollection;
						//Reflect the visual changes
						DataModel.getInstance().videoSearchesRetrieved =true;
				}		
			}else{}
		}
		
		public function fault(info:Object):void{
			var faultEvent:FaultEvent = FaultEvent(info);
//			CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_PERFORMING_SEARCH'));
			trace(ObjectUtil.toString(info));
		}
		
	}
}