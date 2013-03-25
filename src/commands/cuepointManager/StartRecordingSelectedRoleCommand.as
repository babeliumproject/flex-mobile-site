package commands.cuepointManager
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import modules.videoPlayer.VideoPlayerBabelia;
	
	import vo.CueObject;

	public class StartRecordingSelectedRoleCommand implements ICommand
	{
		private var VP:VideoPlayerBabelia;
		private var cue:CueObject;
		
//		private var executed:Boolean = false;

		public function StartRecordingSelectedRoleCommand(cue:CueObject, VP:VideoPlayerBabelia)
		{
			this.VP=VP;
			this.cue = cue;
		}

		public function execute(event:CairngormEvent):void
		{
//			if(!executed){
//				executed = true;
				VP.setSubtitle(cue.text, cue.textColor);
				//VP.playSpeakNotice();
				VP.muteVideo(true);
				VP.muteRecording(false);
				var time:Number = cue.endTime - cue.startTime as Number;
				VP.startTalking(cue.role, time);
				VP.highlight = true;
					//if(!DataModel.getInstance().soundDetected)
					//	DataModel.getInstance().gapsWithNoSound++;
//			}
		}
	}
}