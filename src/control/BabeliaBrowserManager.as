package control
{
	import events.ViewChangeEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.events.BrowserChangeEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	
	
	/**
	 * Default URL Format: http://babelia/#/module/action/target
	 */
	public class BabeliaBrowserManager
	{
		/** Constants **/
		public static const DELIMITER:String="/";
		public static const TARGET_DELIMITER:String="&";
		
		/** Variables **/
		public static var instance:BabeliaBrowserManager = new BabeliaBrowserManager();
		private var _isParsing:Boolean;
		private var _browserManager:IBrowserManager;
		
		/**
		 * URL Related Constants
		 **/
		private var _modulesFragments:ArrayCollection;
		
		[Bindable] public var moduleIndex:int;
		[Bindable] public var actionFragment:String;
		[Bindable] public var targetFragment:String;
		
		/**
		 * ACTION CONSTANTS
		 **/
		public static const ACTIVATE:String="activate";
		public static const SUBTITLE:String="edit";
		public static const VIEW:String="view";
		public static const RECORD:String="rec";
		public static const REVISE:String="revise";
		public static const EVALUATE:String="evaluate";
		
		/**
		 * Constructor
		 **/
		public function BabeliaBrowserManager()
		{        
			if ( instance )
				throw new Error("BabeliaBrowserManager is already running");
			
			_browserManager = BrowserManager.getInstance();
			_browserManager.init();
			_browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, parseURL);
			
			_isParsing = false;
			
			// viewstack-> url href
			_modulesFragments = new ArrayCollection();
			
			// fill array
			for ( var i:int = 0; i < 20; i++ )
				_modulesFragments.addItem(null);
			
			_modulesFragments.setItemAt("about", ViewChangeEvent.VIEWSTACK_ABOUT_MODULE_INDEX);
			_modulesFragments.setItemAt("account", ViewChangeEvent.VIEWSTACK_ACCOUNT_MODULE_INDEX);
			_modulesFragments.setItemAt("config", ViewChangeEvent.VIEWSTACK_CONFIGURATION_MODULE_INDEX);
			_modulesFragments.setItemAt("evaluation", ViewChangeEvent.VIEWSTACK_EVALUATION_MODULE_INDEX);
			_modulesFragments.setItemAt("exercises", ViewChangeEvent.VIEWSTACK_EXERCISE_MODULE_INDEX);
			_modulesFragments.setItemAt("home", ViewChangeEvent.VIEWSTACK_HOME_MODULE_INDEX);
			_modulesFragments.setItemAt("register", ViewChangeEvent.VIEWSTACK_REGISTER_MODULE_INDEX);
			_modulesFragments.setItemAt("search", ViewChangeEvent.VIEWSTACK_SEARCH_MODULE_INDEX);
			_modulesFragments.setItemAt("upload", ViewChangeEvent.VIEWSTACK_UPLOAD_MODULE_INDEX);
			_modulesFragments.setItemAt("help", ViewChangeEvent.VIEWSTACK_HELP_MODULE_INDEX);
			_modulesFragments.setItemAt("activation", ViewChangeEvent.VIEWSTACK_ACTIVATION_MODULE_INDEX);
			_modulesFragments.setItemAt("subtitles", ViewChangeEvent.VIEWSTACK_SUBTITLE_MODULE_INDEX);
		}
		
		// Get instance
		public static function getInstance() : BabeliaBrowserManager
		{
			return instance;
		}
		
		public function addBrowserChangeListener(listenerFunction:Function):void{
			_browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, listenerFunction);
		}
		
		public function removeBrowseChangeListener(listenerFunction:Function):void{
			_browserManager.removeEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, listenerFunction);
		}
		
		/**
		 * Parse function
		 **/
		public function parseURL(e:BrowserChangeEvent = null) : void
		{
			_isParsing = true;
			
			clearFragments();
			
			//Fixes a bug caused by email clients that escape url sequences
			var uescparams:String = unescape(_browserManager.fragment);
			
			var params:Array = uescparams.split(DELIMITER);
			var length:Number = params.length;
			
			if ( length <= 1 )
				updateURL(index2fragment(ViewChangeEvent.VIEWSTACK_HOME_MODULE_INDEX));
			
			if ( length > 1 ) // module
				if ( !changeModule(params[1]) ) return;
			
			if ( length > 2 ) // action
				actionFragment = params[2];
			
			if ( length > 3 ) // target
				targetFragment = params[3];
			
			_isParsing = false;
		}
		
		
		/**
		 * Update URL function
		 **/
		public function updateURL(module:String, action:String = null, target:String = null) : void
		{
			// default url format: /module/action/target
			
			clearFragments();
			
			if ( action == null )
				_browserManager.setFragment(DELIMITER+module);
			else if ( target == null )
				_browserManager.setFragment(DELIMITER+module+DELIMITER+action);
			else
				_browserManager.setFragment(DELIMITER+module+DELIMITER+action+DELIMITER+target);
		}
		
		
		/**
		 * From index to fragment
		 **/
		public static function index2fragment(index:int) : String
		{
			return instance._modulesFragments.getItemAt(index) as String;
		}
		
		
		/**
		 * Change module
		 **/
		private function changeModule(module:String) : Boolean
		{
			moduleIndex = _modulesFragments.getItemIndex(module);
			
			if ( moduleIndex == ViewChangeEvent.VIEWSTACK_ACCOUNT_MODULE_INDEX
				&& !DataModel.getInstance().isLoggedIn )
			{
				DataModel.getInstance().currentContentViewStackIndex = 0;
				updateURL("home");
			}
			
			if ( moduleIndex >= 0 )
			{
				DataModel.getInstance().currentContentViewStackIndex = moduleIndex;
				return true;
			}
			
			return false;
		}
		
		
		/**
		 * Clear Fragments
		 **/
		private function clearFragments() : void
		{
			moduleIndex = -1;
			actionFragment = null;
			targetFragment = null;
		}
	}
}