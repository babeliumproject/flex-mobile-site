package events
{	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.ExerciseRoleVO;

	public class ExerciseRoleEvent extends CairngormEvent
	{
		
		public static const GET_EXERCISE_ROLES:String = "getExerciseRoles";
		
		public var exerciseRoles:ExerciseRoleVO;

		
		public function ExerciseRoleEvent(type:String, exerciseRoles:ExerciseRoleVO = null)
		{
			super(type);
			this.exerciseRoles = exerciseRoles;
		}
		
		override public function clone():Event{
			return new ExerciseRoleEvent(type,exerciseRoles);
		}
		
	}
}