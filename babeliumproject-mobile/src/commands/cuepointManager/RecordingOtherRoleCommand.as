package commands.cuepointManager
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import modules.videoPlayer.VideoPlayerBabelia;
	
	import vo.CueObject;

	public class RecordingOtherRoleCommand implements ICommand
	{
		private var VP:VideoPlayerBabelia;
		private var cue:CueObject;
		
		public function RecordingOtherRoleCommand(cue:CueObject, VP:VideoPlayerBabelia)
		{
			this.VP = VP;
			this.cue = cue;
		}

		public function execute(event:CairngormEvent):void
		{
			VP.setSubtitle(cue.text, cue.textColor);
			var time:Number = cue.endTime - cue.startTime as Number;
			VP.startTalking(cue.role, time);
			VP.highlight = false;
		}	
	}
}