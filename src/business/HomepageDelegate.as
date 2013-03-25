package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;

	public class HomepageDelegate
	{

		public var responder:IResponder;

		public function HomepageDelegate(responder:IResponder)
		{
			this.responder=responder;
		}

		public function unsignedMessagesOfTheDay(messageLocale:String):void
		{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.unsignedMessagesOfTheDay(messageLocale);
			pendingCall.addResponder(responder);
		}

		public function signedMessagesOfTheDay(messageLocale:String):void
		{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.signedMessagesOfTheDay(messageLocale);
			pendingCall.addResponder(responder);
		}
		
		public function usersLatestReceivedAssessments():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.usersLatestReceivedAssessments();
			pendingCall.addResponder(responder);
		}
		
		public function usersLatestGivenAssessments():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.usersLatestGivenAssessments();
			pendingCall.addResponder(responder);
		}
		
		public function usersLatestUploadedVideos():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.usersLatestUploadedVideos();
			pendingCall.addResponder(responder);
		}
		
		public function topScoreMostViewedVideos():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.topScoreMostViewedVideos();
			pendingCall.addResponder(responder);
		}
		
		public function latestAvailableVideos():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("homepageRO");
			var pendingCall:AsyncToken=service.latestAvailableVideos();
			pendingCall.addResponder(responder);
		}

	}
}