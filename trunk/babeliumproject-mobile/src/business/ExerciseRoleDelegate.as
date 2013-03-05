
package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.ExerciseRoleVO;
	
	public class ExerciseRoleDelegate
	{
		public var responder:IResponder;
		
		
		public function ExerciseRoleDelegate(responder:IResponder)
		{
			this.responder = responder;
		}
		
		
		public function getExerciseRoles(rol:ExerciseRoleVO):void
		{
			var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("subtitleRO");
			var pendingCall:AsyncToken = service.getExerciseRoles(rol.exerciseId);
			pendingCall.addResponder(responder);                    
		}
		
		/*
		public function deleteSingleExerciseRol(rol:ExerciseRoleVO):void
		{
		var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("rolRO");                       
		var pendingCall:AsyncToken = service.deleteSingleExerciseRol(rol.id);
		pendingCall.addResponder(responder);
		}
		
		public function deleteAllExerciseRoles(rol:ExerciseRoleVO):void
		{
		var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("rolRO");                       
		var pendingCall:AsyncToken = service.deleteAllExerciseRoles(rol.exerciseId);
		pendingCall.addResponder(responder);
		}
		
		public function saveExerciseRoles(roles:Array):void
		{
		var service:RemoteObject = ServiceLocator.getInstance().getRemoteObject("rolRO");                       
		var pendingCall:AsyncToken = service.saveExerciseRoles(roles);
		pendingCall.addResponder(responder);
		}
		*/
		
	}
}
