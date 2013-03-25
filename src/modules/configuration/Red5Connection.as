package modules.configuration
{
	import flash.net.NetConnection;
	
	public class Red5Connection
	{
		import model.DataModel;
		
		private  var nc:NetConnection;
		
		public function Red5Connection(app:String){
			nc = new NetConnection();
			nc.connect("rtmp://" + DataModel.getInstance().server + ":" + DataModel.getInstance().red5Port + "/" + app);
		}
		
		public function getNetConnection():NetConnection{
			return nc;
		}

	}
}