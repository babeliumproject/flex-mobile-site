package vo
{
	import mx.collections.ArrayCollection;
	
	public class CueObjectCache
	{
		private var cachedTime:int;
		private var cuelist:ArrayCollection;
		
		public function CueObjectCache(cachedTime:int, cuelist:ArrayCollection)
		{
			this.cachedTime = cachedTime;
			this.cuelist = cuelist;	
		}
		
		public function getCachedTime() : int
		{
			return cachedTime;
		}
		
		public function getCueList() : ArrayCollection
		{
			return cuelist;
		}
		
		public function setCachedTime(time:int) : void
		{
			this.cachedTime = time;
		}
		
		public function setCueList(cuelist:ArrayCollection) : void
		{
			this.cuelist = cuelist;
		}

	}
}