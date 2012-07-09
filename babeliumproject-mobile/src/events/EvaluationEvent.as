package events {
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import vo.EvaluationVO;

	public class EvaluationEvent extends CairngormEvent {
		
		public static const GET_RESPONSES_WAITING_ASSESSMENT:String = "getResponsesWaitingAssessment";
		public static const GET_RESPONSES_ASSESSED_TO_CURRENT_USER:String="getResponsesAssessedToCurrentUser";
		public static const GET_RESPONSES_ASSESSED_BY_CURRENT_USER:String="getResponsesAssessedByCurrentUser";
		
		public static const ADD_ASSESSMENT:String="addAssessment";
		public static const ADD_VIDEO_ASSESSMENT:String="addVideoAssessment";
		
		public static const DETAILS_OF_ASSESSED_RESPONSE:String="detailsOfAssessedResponse";
		public static const UPDATE_RESPONSE_RATING_AMOUNT:String="updateResponseRatingAmount";
		
		public static const GET_EVALUATION_CHART_DATA:String = "getEvaluationChartData";
		

		public static const AUTOMATIC_EVAL_RESULTS:String = "automaticEvalResults";

		public static const ENABLE_TRANSCRIPTION_TO_EXERCISE:String = "enableTranscriptionToExercise";
		public static const ENABLE_TRANSCRIPTION_TO_RESPONSE:String = "enableTranscriptionToResponse";
		
		public static const CHECK_AUTOEVALUATION_SUPPORT_EXERCISE:String = "checkAutoevaluationSupportExercise";
		public static const CHECK_AUTOEVALUATION_SUPPORT_RESPONSE:String = "checkAutoevaluationSupportResponse";
		
		public var evaluation:EvaluationVO;
		public var responseId:uint;
		public var sortField:String;
		public var pageNumber:uint;

		public function EvaluationEvent(type:String, evaluation:EvaluationVO = null, responseId:uint = 0, sortField:String = '', pageNumber:uint = 0) {
			super(type);
			this.evaluation = evaluation;
			this.responseId = responseId;
			this.sortField=sortField;
			this.pageNumber=pageNumber;
		}

		override public function clone():Event {
			return new EvaluationEvent(type, evaluation, responseId);
		}
	}
}