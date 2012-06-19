package modules.videoPlayer.controls.babelia
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import model.DataModel;
	
	import modules.videoPlayer.controls.SkinableComponent;
	
	import mx.collections.ArrayCollection;
	//import mx.controls.Alert;
	import spark.components.Image;
	import mx.core.UIComponent;
	
	
	public class ArrowPanel extends SkinableComponent
	{
		/**
		 * Skin constants
		 */
		public static const BORDER_COLOR:String="borderColor";
		public static const BG_COLOR:String="bgColor";
		public static const HL_COLOR:String="hlColor";
		public static const BORDER_WEIGHT:String="borderWeight";
		public static const CORNER_RADIUS:String="cornerRadius";
		public static const BG_ALPHA:String="bgAlpha";
		
		private var _bg:Sprite;
		private var _arrows:ArrayCollection;
		private var _dataProvider:ArrayCollection;
		private var _boxWidth:Number=500;
		private var _boxHeight:Number=50;
		private var _highlight:Boolean=false;
		
		private var selectedRoleArrow:Bitmap;
		
		public function ArrowPanel(state:Boolean=false)
		{
			super("ArrowPanel"); // Required for setup skinable component
			
			_bg=new Sprite();
			addChild(_bg);
			
			_arrows=new ArrayCollection();
			
			resize(_boxWidth, _boxHeight);
		}
		
		override public function availableProperties(obj:Array=null):void
		{
			super.availableProperties([BG_COLOR, BORDER_COLOR]);
		}
		
		public function resize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
			
			refresh();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			if ( w != 0 ) width = w;
			if ( h != 0 ) height = h;
			
			CreateBG(width, height);
		}
		
		public function setArrows(data:ArrayCollection, duration:Number, role:String):void
		{
			_dataProvider=data;
			
			for each (var obj:Object in _dataProvider)
			doShowArrow(obj.startTime, duration, obj.role == role);
		}
		
		public function removeArrows():void
		{
			if (_arrows.length > 0)
			{
				while (_arrows.length > 0)
				{
					removeChildAt(1);
					_arrows.removeItemAt(0);
				}
				
				_dataProvider.removeAll();
			}
		}
		
		private function CreateBG(bgWidth:Number, bgHeight:Number):void
		{
			_bg.graphics.clear();
			
			if ( !_highlight )
				_bg.graphics.beginFill(getSkinColor(BG_COLOR), getSkinColor(BG_ALPHA)/100);
			else
				_bg.graphics.beginFill(getSkinColor(HL_COLOR), getSkinColor(BG_ALPHA)/100);
			_bg.graphics.lineStyle(getSkinColor(BORDER_WEIGHT), getSkinColor(BORDER_COLOR), 1);
			_bg.graphics.drawRoundRect(0, 0, width, height, getSkinColor(CORNER_RADIUS));
			_bg.graphics.endFill();
		}

		public function set highlight(flag:Boolean) : void
		{
			_highlight = flag;
			refresh();
		}
		
		private function drawArrowSprite():Sprite
		{
			var arrow2:Sprite = new Sprite();
			arrow2.graphics.clear();
			arrow2.graphics.beginFill(0xa12829);
			arrow2.graphics.moveTo(4,0);
			arrow2.graphics.lineTo(4,26);
			arrow2.graphics.lineTo(0,26);
			arrow2.graphics.lineTo(8,34);
			arrow2.graphics.lineTo(16,26);
			arrow2.graphics.lineTo(12,26);
			arrow2.graphics.lineTo(12,0);
			arrow2.graphics.lineTo(4,0);
			arrow2.graphics.endFill();
			return arrow2;
		}
		
		private function doShowArrow(time:Number, duration:Number, flag:Boolean):void
		{       
			if(flag)
				var arrow:Sprite = drawArrowSprite();
			else
				return;
			
			/*************************************
			 *    \/  (0)
			 *  _________________________________
			 * |__|______________________________|
			 * 0                               duration
			 * 
			 * arrow's width: 16px
			 * scrubber's width: 10px
			 * margins: ~5px (left) ~5px (right)
			 * ***********************************/
			var margin:int = 5;
			var scrubberW:int = 10;
			
			arrow.width = 16;
			arrow.height = 34;
			arrow.x = time * (width-scrubberW - margin*2) / duration + (margin + scrubberW - arrow.width/2); // -1 
			arrow.y = 4;
			
			_arrows.addItem(arrow);
			addChild(arrow);
		}
	}
}
