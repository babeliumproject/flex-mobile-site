package business{
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;    
	
	public class SearchDelegate{
		
		public var responder:IResponder;
		
		public function SearchDelegate(responder:IResponder){
			
			this.responder=responder;
			
		}
		public function launchSearch(search:String):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("searchRO");
			var pendingCall:AsyncToken=service.launchSearch(search);
			pendingCall.addResponder(responder);
			//service.setTagToDB(search);
		}
	}
}