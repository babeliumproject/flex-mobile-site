package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.SubtitleAndSubtitleLinesVO;
	
	public class SubtitleDelegate
	{
		public var responder:IResponder;
		
		
		public function SubtitleDelegate(responder:IResponder)
		{
			this.responder = responder;
		}
		
		public function saveSubtitles(subtitles:SubtitleAndSubtitleLinesVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("subtitleRO");
			var pendingCall:AsyncToken = service.saveSubtitles(subtitles);
			pendingCall.addResponder(responder);
		}
		
		public function getSubtitleLines(subtitle:SubtitleAndSubtitleLinesVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("subtitleRO");
			var pendingCall:AsyncToken = service.getSubtitleLines(subtitle);
			pendingCall.addResponder(responder);	
		}
		
		public function getSubtitleLinesUsingId(subtitleId:int):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("subtitleRO");
			var pendingCall:AsyncToken = service.getSubtitleLinesUsingId(subtitleId);
			pendingCall.addResponder(responder);
		}
		
		public function getExerciseSubtitles(subtitle:SubtitleAndSubtitleLinesVO):void{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("subtitleRO");
			var pendingCall:AsyncToken = service.getExerciseSubtitles(subtitle.exerciseId);
			pendingCall.addResponder(responder);
		}
		

	}
}