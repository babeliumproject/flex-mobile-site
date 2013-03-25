package View.common
{
	import mx.formatters.Formatter;

	public class TimeFormatter extends Formatter
	{

		private var _milliseconds:Boolean = false;

		public function get outputMilliseconds():Boolean
		{
			return _milliseconds;
		}

		public function set outputMilliseconds(value:Boolean):void
		{
			_milliseconds=value;
		}

		override public function format(input:Object):String
		{

			var value:Number=input as Number;
			value=value * 1000;
			var result:String="";

			if (value < 3600000)
			{
				var minutes:int=value / 60000;
				var seconds:int=(value % 60000) / 1000;
				var milliseconds:int=(value % 60000) % 1000;

				if (minutes < 10)
					result="0" + minutes;
				else if (minutes >= 10 && minutes < 60)
					result=minutes.toString();

				if (seconds < 10)
					result=result + ":0" + seconds;
				else if (seconds >= 10 && minutes < 60)
					result=result + ":" + seconds;

				if (_milliseconds)
				{
					if (milliseconds < 10)
						result=result + ".00" + milliseconds;
					else if (milliseconds >= 10 && milliseconds < 100)
						result=result + ".0" + milliseconds;
					else if (milliseconds >= 100 < 1000)
						result=result + "." + milliseconds;
				}
			}
			else
			{
				result="limit_exceeded";
			}
			return result;

		}

	}
}