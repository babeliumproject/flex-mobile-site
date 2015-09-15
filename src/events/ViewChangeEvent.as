package events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import modules.configuration.ConfigurationContainer;
	import modules.configuration.ConfigurationMain;
	import modules.evaluation.EvaluationContainer;
	import modules.exercises.Exercises;
	import modules.home.HomeMain;
	import modules.main.About;
	import modules.main.HelpFAQMain;
	import modules.search.Search;
	import modules.subtitles.SubtitleMain;
	import modules.userManagement.AccountActivation;
	import modules.userManagement.AccountMain;
	import modules.userManagement.SignUpForm;
	import modules.videoUpload.UploadContainer;
	
	
	public class ViewChangeEvent extends CairngormEvent
	{
		//This views belong to the application's content ViewStack
		public static const VIEW_EVALUATION_MODULE:String="viewEvaluationModule";
		public static const VIEW_EXERCISE_MODULE:String="viewExerciseModule";
		public static const VIEW_HOME_MODULE:String="viewHomeModule";
		public static const VIEW_UPLOAD_MODULE:String="viewUploadModule";
		public static const VIEW_SUBTITLE_MODULE:String="viewSubtitleModule";
		public static const VIEW_CONFIGURATION_MODULE:String="viewConfigurationModule";
		public static const VIEW_RANKING_MODULE:String="viewRankingModule";
		public static const VIEW_ABOUT_MODULE:String="viewAboutModule";
		public static const VIEW_SEARCH_MODULE:String="viewSearchModule";
		public static const VIEW_HELP_MODULE:String="viewHelpModule";
		
		//User related views
		public static const VIEW_REGISTER_MODULE:String="viewRegisterModule";
		public static const VIEW_ACCOUNT_MODULE:String="viewAccountModule";
		public static const VIEW_ACTIVATION_MODULE:String="viewActivationModule";
		
		//Home related views
		public static const VIEW_HOME_UNSIGNED:String="viewHomeUnsigned";
		public static const VIEW_HOME_SIGNED_IN:String="viewHomeSignedIn";
		
		//Upload related views
		public static const VIEW_UPLOAD_UNSIGNED:String="viewUploadUnsigned";
		public static const VIEW_UPLOAD_SIGNED_IN:String="viewUploadSignedIn";
		
		//Configuration related views
		public static const VIEW_CONFIG_UNSIGNED:String="viewConfigUnsigned";
		public static const VIEW_CONFIG_SIGNED:String="viewConfigSigned";
		
		//Evaluation related views
		public static const VIEW_EVALUATION_UNSIGNED:String="viewEvaluationUnsigned";
		public static const VIEW_EVALUATION_SIGNED_IN:String="viewEvaluationSignedIn";
		
		//Subtitle related views
		public static const VIEW_SUBTITLES_UNSIGNED:String="viewSubtitlesUnsigned";
		public static const VIEW_SUBTITLES_SIGNED_IN:String="viewSubtitlesSignedIn";
		public static const VIEW_SUBTITLE_EDITOR:String="viewSubtitleEditor";
		
		//User account related views
		public static const VIEW_ACCOUNT_UNSIGNED:String="viewAccountUnsigned";
		public static const VIEW_ACCOUNT_SIGNED:String="viewAccountSigned";
		
		
		//Indexes of application's content ViewStack
		public static const VIEWSTACK_HOME_MODULE_INDEX:uint = 0;
		public static const VIEWSTACK_EXERCISE_MODULE_INDEX:uint = 1;
		public static const VIEWSTACK_EVALUATION_MODULE_INDEX:uint = 2;
		public static const VIEWSTACK_REGISTER_MODULE_INDEX:uint = 3;
		public static const VIEWSTACK_ACCOUNT_MODULE_INDEX:uint = 4;
		public static const VIEWSTACK_UPLOAD_MODULE_INDEX:uint = 5;
		public static const VIEWSTACK_SUBTITLE_MODULE_INDEX:uint = 6;
		public static const VIEWSTACK_CONFIGURATION_MODULE_INDEX:uint = 7;
		public static const VIEWSTACK_ABOUT_MODULE_INDEX:uint = 8;
		public static const VIEWSTACK_SEARCH_MODULE_INDEX:uint = 9;
		public static const VIEWSTACK_HELP_MODULE_INDEX:uint = 10;
		public static const VIEWSTACK_ACTIVATION_MODULE_INDEX:uint = 11;
		
		public function ViewChangeEvent(type:String)
		{
			super(type);
		}
		
	}
}