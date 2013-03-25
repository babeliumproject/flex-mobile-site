package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.EvaluationVO;

	public class EvaluationDelegate
	{
		
		public var responder:IResponder;
		
		public function EvaluationDelegate(responder:IResponder)
		{
			this.responder = responder;
		}
		
		public function getResponsesWaitingAssessment():void
		{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.getResponsesWaitingAssessment();
			pendingCall.addResponder(responder);
		}
		
		public function getResponsesAssessedToCurrentUser(sortField:String,pageNumber:uint):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.getResponsesAssessedToCurrentUser(sortField,pageNumber);
			pendingCall.addResponder(responder);
		}
		
		public function getResponsesAssessedByCurrentUser():void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.getResponsesAssessedByCurrentUser();
			pendingCall.addResponder(responder);
		}
		
		public function addAssessment(assessment:EvaluationVO):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.addAssessment(assessment);
			pendingCall.addResponder(responder);
		}
		
		public function addVideoAssessment(assessment:EvaluationVO):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.addVideoAssessment(assessment);
			pendingCall.addResponder(responder);
		}
		
		public function detailsOfAssessedResponse(responseId:int):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.detailsOfAssessedResponse(responseId);
			pendingCall.addResponder(responder);
		}
		
		public function updateResponseRatingAmount(responseId:int):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.updateResponseRatingAmount(responseId);
			pendingCall.addResponder(responder);
		}
		
		public function getEvaluationChartData(responseId:int):void{
			var service:RemoteObject=ServiceLocator.getInstance().getRemoteObject("evaluationRO");
			var pendingCall:AsyncToken=service.getEvaluationChartData(responseId);
			pendingCall.addResponder(responder);
		}
	}
}