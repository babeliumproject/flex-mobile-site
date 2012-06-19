package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.ResponseVO;
	
	public class ResponseDelegate
	{
		
		private var responder:IResponder;
		
		public function ResponseDelegate(responder:IResponder)
		{
			this.responder = responder;
		}
		
		public function saveResponse(response:ResponseVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject( "responseRO" );
			var pendingCall:AsyncToken = service.saveResponse(response);
			pendingCall.addResponder(responder);
		}
		
		public function makePublic(response:ResponseVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject( "responseRO" );
			var pendingCall:AsyncToken = service.makePublic(response);
			pendingCall.addResponder(responder);
		}

	}
}