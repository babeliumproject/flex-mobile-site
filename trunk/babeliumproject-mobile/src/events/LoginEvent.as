package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.LoginVO;
	import vo.UserVO;

	public class LoginEvent extends CairngormEvent
	{
		
		public static const RESTORE_PASS:String = "restorePass";
		public static const PROCESS_LOGIN: String = "processLogin";
		public static const RESEND_ACTIVATION_EMAIL:String = "resendActivationEmail";
		public static const SIGN_OUT: String = "signOut";
		
		public var user:LoginVO;
		public var activation:UserVO;
		
		public function LoginEvent(type:String, user:LoginVO, activation:UserVO = null)
		{
			super(type);
			this.user = user;
			this.activation = activation;
			
		}
		
		override public function clone():Event{
			return new LoginEvent(type,user,activation);
		}
		
	}
}