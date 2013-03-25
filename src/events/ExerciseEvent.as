package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.ExerciseReportVO;
	import vo.ExerciseScoreVO;
	import vo.ExerciseVO;

	public class ExerciseEvent extends CairngormEvent
	{

		public static const ADD_UNPROCESSED_EXERCISE:String="addUnprocessedExercise";
		public static const ADD_WEBCAM_EXERCISE:String="addWebcamExercise";
		public static const GET_EXERCISES:String="getExercises";
		public static const GET_RECORDABLE_EXERCISES:String="getRecordableExercises";
		public static const WATCH_EXERCISE:String="watchExercise";
		public static const EXERCISE_SELECTED:String="exerciseSelected";
		public static const GET_EXERCISE_LOCALES:String="exerciseLocales";
		public static const RATE_EXERCISE:String="rateExercise";
		public static const REPORT_EXERCISE:String="reportExercise";
		public static const USER_RATED_EXERCISE:String="userRatedExercise";
		public static const USER_REPORTED_EXERCISE:String="userReportedExercise";

		public var exercise:ExerciseVO;
		public var report:ExerciseReportVO;
		public var score:ExerciseScoreVO;

		public function ExerciseEvent(type:String, exercise:ExerciseVO = null, report:ExerciseReportVO = null, score:ExerciseScoreVO = null)
		{
			super(type);
			this.exercise=exercise;
			this.report=report;
			this.score=score;
		}
		
		override public function clone():Event{
			return new ExerciseEvent(type,exercise,report,score);
		}

	}
}