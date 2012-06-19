package modules.videoPlayer.controls.babelia
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import modules.videoPlayer.controls.SkinableComponent;
	
	
	public class SubtitleTextBox extends SkinableComponent
	{
		/**
		 * SKIN CONSTANTS
		 */
		public static const TEXT_COLOR:String="textColor";
		public static const BOX_COLOR:String="boxColor";
		public static const BORDER_COLOR:String="borderColor";
		public static const BG_COLOR:String="bgColor";
		
		private var _textBox:TextField;
		private var _textFormat:TextFormat;
		private var _boxWidth:Number=100;
		private var _boxHeight:Number=40;
		private var _defaultWidth:Number = 100;
		private var _defaultHeight:Number=40;
		
		private var _dropShadowFilter:DropShadowFilter;
		
		public function SubtitleTextBox()
		{
			super("SubtitleTextBox"); // Required for setup skinable component
			
			height = _defaultHeight;
			width = _defaultWidth;
			
			_dropShadowFilter = new DropShadowFilter();
			_dropShadowFilter.alpha = 1;
			_dropShadowFilter.distance = 0;
			_dropShadowFilter.color = 0x000000;
			_dropShadowFilter.strength = 15;
			_dropShadowFilter.blurX = 6;
			_dropShadowFilter.blurY = 6;
			
			_textFormat = new TextFormat();
			_textFormat.align = "center";
			_textFormat.font = "Arial";
			_textFormat.bold = true;
			_textFormat.size = 14;
			
			_textBox=new TextField();
			_textBox.multiline = true;
			_textBox.wordWrap = true;
			_textBox.selectable = false;
			_textBox.filters = [_dropShadowFilter];
			_textBox.setTextFormat(_textFormat);
			
			
			addChild(_textBox);
		}
		
		override public function availableProperties(obj:Array=null):void
		{
			super.availableProperties([BG_COLOR, BORDER_COLOR, BOX_COLOR, TEXT_COLOR]);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( height == 0 ) 
				height = _defaultHeight;
			if( width == 0 ) 
				width = _defaultWidth;
			
			_textFormat.color = getSkinColor(TEXT_COLOR);
			_textBox.width = width*0.9;
			_textBox.x = this.width / 2 - _textBox.width/2;
			_textBox.y = this.height - (_textBox.textHeight) - 6;
			
			_textBox.setTextFormat(_textFormat);
			
			
		}
		
		public function resize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
		}
		
		public function setText(text:String,textColor:uint=0xffffff):void
		{
			_textFormat.color = textColor;
			_textBox.text=text;
			_textBox.setTextFormat(_textFormat);
			_textBox.y = this.height - (_textBox.textHeight) - 6;
		}
	}
}
