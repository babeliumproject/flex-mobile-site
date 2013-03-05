package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.LoginVO;
	import vo.UserVO;
	
	public class LoginDelegate
	{
		private var responder:IResponder;
		private var data:Object;
		public function LoginDelegate(responder:IResponder)
		{
			this.responder = responder;
		}
		
		public function processLogin(user:LoginVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("loginRO");
			var pendingCall:AsyncToken = service.processLogin(user);
			pendingCall.addResponder(responder);
			
		
		}
		
		public function doLogout():void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("loginRO");
			var pendingCall:AsyncToken = service.doLogout();
			pendingCall.addResponder(responder);
		}
		
		public function resendActivationEmail(data:UserVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("loginRO");
			var pendingCall:AsyncToken = service.resendActivationEmail(data);
			pendingCall.addResponder(responder);
		}

	}
}