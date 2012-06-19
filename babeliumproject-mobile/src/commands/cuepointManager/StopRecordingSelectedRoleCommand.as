package commands.cuepointManager
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	import modules.videoPlayer.VideoPlayerBabelia;

	public class StopRecordingSelectedRoleCommand implements ICommand
	{
		private var VP:VideoPlayerBabelia;

//		private var executed:Boolean=false;

		public function StopRecordingSelectedRoleCommand(VP:VideoPlayerBabelia)
		{
			this.VP=VP;
		}

		public function execute(event:CairngormEvent):void
		{
//			if (!executed)
//			{
//				executed=true;
				VP.setSubtitle("");
				VP.muteVideo(false);
				VP.muteRecording(true);
				VP.highlight = false;
//			}
		/*
		   if(!DataModel.getInstance().soundDetected &&
		   DataModel.getInstance().gapsWithNoSound > DataModel.GAPS_TO_ABORT_RECORDING){
		   DataModel.getInstance().gapsWithNoSound = 0;
		   VP.dispatchEvent(new RecordingEvent(RecordingEvent.ABORTED));
		 }*/
		}
	}
}