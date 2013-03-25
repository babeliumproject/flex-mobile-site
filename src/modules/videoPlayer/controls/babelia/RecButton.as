package modules.videoPlayer.controls.babelia
{
	import modules.videoPlayer.events.babelia.RecordingEvent;
	import modules.videoPlayer.controls.SkinableButton;

	public class RecButton extends SkinableButton
	{
		public function RecButton(name:String="SkinableButton")
		{
			super("RecButton");
		}
		
		/**
		 * Methods
		 * 
		 */
		
		
		/** OVERRIDEN */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			createRecBtn();
		}
		
		
		private function createRecBtn() : void
		{
			var g:Sprite = btn;
			g.graphics.clear();
			g.graphics.beginFill(0xFF0000);
			g.graphics.drawCircle(0, 0, 4);
			g.graphics.endFill();
		}
		
		
		override protected function onClick( e:MouseEvent ) : void
		{
			dispatchEvent( new RecordingEvent( RecordingEvent.REC_CLICK ) );
		}
		
		
	}
}