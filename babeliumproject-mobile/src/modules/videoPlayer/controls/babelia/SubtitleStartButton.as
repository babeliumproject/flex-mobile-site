package modules.videoPlayer.controls.babelia
{
	import modules.videoPlayer.events.babelia.SubtitlingEvent;
	import modules.videoPlayer.controls.SkinableButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SubtitleStartButton extends SkinableButton
	{		
		public function SubtitleStartButton()
		{
			super("SubtitleStartButton"); // Required for setup skinable component
		}
		
		/**
		 * Methods
		 * 
		 */
		
		
		/** OVERRIDEN */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			createBtn();
		}
		
		
		private function createBtn() : void
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
				
		
		override protected function onClick( e:MouseEvent ) : void
		{
			dispatchEvent( new SubtitlingEvent( SubtitlingEvent.START ) );
		}
		
	}
}