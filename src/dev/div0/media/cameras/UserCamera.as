package dev.div0.media.cameras
{
	public class UserCamera
	{
		private var index:int;
		private var name:String;
		public function UserCamera(index:int, name:String)
		{
			this.index = index;
			this.name = name;
		}

		public function getName():String
		{
			return name;
		}

		public function setName(value:String):void
		{
			name = value;
		}

		public function getIndex():int
		{
			return index;
		}

		public function setIndex(value:int):void
		{
			index = value;
		}
	}
}