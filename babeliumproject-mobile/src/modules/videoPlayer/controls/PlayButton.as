package modules.videoPlayer.controls
{
	import modules.videoPlayer.events.PlayPauseEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class PlayButton extends SkinableButton
	{
		
		/**
		 * Constants
		 */
		public static const PLAY_STATE:String = "play";
		public static const PAUSE_STATE:String = "pause";
		
		/**
		 * Variables
		 * 
		 */
		private var _state:String = PLAY_STATE;
		
		
		public function PlayButton()
		{
			super("PlayButton"); // Required for setup skinable component
		}
		
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR,OVERBG_COLOR,ICON_COLOR]);
		}
		
		
		/**
		 * Setters and Getters
		 * 
		 */
		
		public function set State( state:String ):void
		{
			_state = state;
			
			invalidateDisplayList();
		}
		
		public function getState( ):String
		{
			return _state;
		}
		
		/**
		 * Methods
		 * 
		 */
		
		
		/** OVERRIDEN */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( _state == PLAY_STATE )
			{
				CreatePlayButton();
				btn.x = this.width/2 - btn.width/2;
				btn.y = 14;
			}
			else
			{
				CreatePauseButton();
				btn.x = this.width/2 - btn.width/2;
				btn.y = 14;
				
				addChild( btn );
			}
		}
		
		
		private function CreatePlayButton():void
		{
			var g:Sprite = btn;
			g.graphics.clear();
			g.graphics.beginFill( getSkinColor(ICON_COLOR) );
			g.graphics.lineTo( 10, 5 );
			g.graphics.lineTo( 0, 10 );
			g.graphics.lineTo( 0, 0 );
			g.graphics.endFill();
		}
		
		
		private function CreatePauseButton():void
		{
			var g:Sprite = btn;
			g.graphics.clear();
			g.graphics.beginFill( getSkinColor(ICON_COLOR) );
			g.graphics.drawRect( 0, 0, 3, 10 );
			g.graphics.drawRect( 6, 0, 3, 10 );
			g.graphics.endFill();
		}
		
		
		override protected function onClick( e:MouseEvent ) : void
		{
			trace( "play/pause btn pressed" );
			this.State = _state == PLAY_STATE ? PAUSE_STATE : PLAY_STATE;
			
			dispatchEvent( new PlayPauseEvent( PlayPauseEvent.STATE_CHANGED ) );
		}
		
	}
}