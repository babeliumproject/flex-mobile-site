package commands.cuepointManager
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import control.CuePointManager;
	
	import modules.videoPlayer.VideoPlayerBabelia;
	

	
	import spark.components.DataGrid;
	
	import vo.CueObject;

	public class ShowHideSubtitleCommand implements ICommand
	{
		private var VP:VideoPlayerBabelia;
		private var dg:spark.components.DataGrid;
		public var cue:CueObject;

		public function ShowHideSubtitleCommand(cue:CueObject, subHolder:VideoPlayerBabelia, dg:DataGrid=null)
		{
			this.VP=subHolder;
			this.dg=dg;
			this.cue=cue;
		}

		public function execute(event:CairngormEvent):void
		{
			if (cue)
			{
				VP.setSubtitle(cue.text,cue.textColor);
				var index:int = CuePointManager.getInstance().getCueIndex(cue);
				if(dg != null && dg.rowHeight > index)
					dg.selectedIndex = index;
			}
			else
			{
				VP.setSubtitle('');
			}
		}
	}
}