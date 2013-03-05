package modules.videoPlayer.controls.babelia
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import modules.videoPlayer.controls.SkinableButton;
	import modules.videoPlayer.events.babelia.SubtitlingEvent;
	
	public class SubtitleStartEndButton extends SkinableButton
	{
		/**
		 * Constants
		 */
		public static const START_STATE:String = "start";
		public static const END_STATE:String = "end";
		
		/**
		 * Variables
		 * 
		 */
		private var _state:String = START_STATE;
		
		
		public function SubtitleStartEndButton()
		{
			super("SubtitleStartEndButton");
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
			
			if( _state == START_STATE )
			{
				CreateStartButton();
				btn.x = this.width/2 - btn.width/2;
				btn.y = this.height/2 - btn.height/2;
				this.toolTip = resourceManager.getString('myResources','SUBITLE_START_TIME_TOOLTIP');
			}
			else
			{
				CreateEndButton();
				btn.x = this.width/2 - btn.width/2;
				btn.y = this.height/2 - btn.height/2;
				this.toolTip = resourceManager.getString('myResources','SUBTITLE_STOP_TIME_TOOLTIP');
				
				addChild( btn );
			}
		}
		
		
		private function CreateStartButton():void
		{
			var g:Sprite = btn;
			g.graphics.clear();
			g.graphics.beginFill( getSkinColor(ICON_COLOR) );
			g.graphics.moveTo( 0, 5 );
			g.graphics.lineTo( 5, 0 );
			g.graphics.lineTo( 5, 3 );
			g.graphics.lineTo( 12, 3 );
			g.graphics.lineTo( 12, 5 );
			g.graphics.endFill();
		}
		
		
		private function CreateEndButton():void
		{
			var g:Sprite = btn;
			g.graphics.clear();
			g.graphics.beginFill( getSkinColor(ICON_COLOR) );
			g.graphics.moveTo( 0, 5 );
			g.graphics.lineTo( 12, 5 );
			g.graphics.lineTo( 7, 0 );
			g.graphics.lineTo( 7, 3 );
			g.graphics.lineTo( 0, 3 );
			g.graphics.endFill();
		}
		
		
		override protected function onClick( e:MouseEvent ) : void
		{
			trace( "Subtitle start/end button pressed." );
			if (_state == START_STATE){
				this.State = END_STATE;
				dispatchEvent( new SubtitlingEvent( SubtitlingEvent.START ) );
			} else {
				this.State = START_STATE;
				dispatchEvent( new SubtitlingEvent( SubtitlingEvent.END ) );
			}
		}
		
		
	}
}