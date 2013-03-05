package modules.videoPlayer.controls.babelia
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import modules.videoPlayer.controls.SkinableComponent;
	
	//import mx.controls.Alert;
	//import mx.controls.ProgressBar;
	import mx.controls.ProgressBarMode;
	//import mx.controls.Text;
	import mx.core.UIComponent;
	//import mx.skins.halo.ProgressBarSkin;
	//import mx.skins.spark.ProgressBarSkin;
	
	public class RoleTalkingPanel extends SkinableComponent
	{
		/**
		 * SKIN CONSTANTS
		 */
		public static const TEXT_COLOR:String = "textColor";
		public static const ROLE_COLOR:String = "roleColor";
		public static const BAR_COLOR:String = "barColor";
		public static const BORDER_COLOR:String = "borderColor";
		public static const BG_COLOR:String = "bgColor";
		public static const HL_COLOR:String="hlColor";
		public static const BORDER_WEIGHT:String="borderWeight";
		public static const CORNER_RADIUS:String="cornerRadius";
		public static const FONT_FAMILY:String="fontFamily";
		
		private var _bg:Sprite;
		private var _talking:Boolean = false;
		private var _boxWidth:Number = 200;
		private var _boxHeight:Number = 50;
		private var _defaultMargin:Number = 5;
		private var _timer:Timer;
		private var _duration:Number;
		private var _refreshTime:Number = 10;
		private var _startTime:Number;
		private var _pauseTime:Number;
		private var _highlight:Boolean = false;
		
		private var _textFormat:TextFormat;
		private var _textBox:TextField;
		private var _roleFormat:TextFormat;
		private var _roleBox:TextField;
		
		private var _pBarBg:Sprite;
		private var _pBarFill:Sprite;
		private var _pBarMin:uint;
		private var _pBarMax:uint;
		
		public function RoleTalkingPanel()
		{
			super("RoleTalkingPanel"); // Required for setup skinable component
			
			_bg = new Sprite();
			addChildAt(_bg, 0);
			
			
			
			
			_textFormat = new TextFormat();
			_textFormat.font = getSkinProperty(FONT_FAMILY);
			_textFormat.bold = true;
			
			_textBox=new TextField();
			_textBox.selectable = false;
			_textBox.text = "Talking :";
			_textBox.setTextFormat(_textFormat);
			
			addChild(_textBox);
			
			_roleFormat = new TextFormat();
			_roleFormat.font = getSkinProperty(FONT_FAMILY);
			_roleFormat.bold = true;
			
			_roleBox = new TextField();
			_roleBox.selectable = false;
			_roleBox.setTextFormat(_roleFormat);
			
			addChild(_roleBox);
			
			_pBarBg = new Sprite();
			_pBarFill = new Sprite();
			
			addChild(_pBarBg);
			addChild(_pBarFill);
			
			var colors:Array = [0xd8d8d8, 0x8F8F8F];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];            
			
			_pBarBg.graphics.clear();
			_pBarBg.graphics.lineStyle(1,0x757575,1);
			_pBarBg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, verticalGradientMatrix(0,0,6,6));
			_pBarBg.graphics.drawRect(0,0,20,6);
			_pBarBg.graphics.endFill();
			
			resize(_boxWidth, _boxHeight);
		}
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR,BORDER_COLOR,BAR_COLOR,TEXT_COLOR,ROLE_COLOR,FONT_FAMILY]);
		}
		
		public function resize(width:Number, height:Number) : void
		{                       
			this.width = width;
			this.height = height;
			
			refresh();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			if ( w != 0 ) width = w;
			if ( h != 0 ) height = h;
			
			CreateBG( width, height );
			
			_textFormat.color=getSkinColor(TEXT_COLOR);
			_textFormat.font=getSkinProperty(FONT_FAMILY);
			
			_textBox.x = _defaultMargin*3;
			_textBox.y = _defaultMargin;
			_textBox.width = 60;
			_textBox.height = 20;
			_textBox.setTextFormat(_textFormat);
			
			_roleFormat.color = getSkinColor(ROLE_COLOR);
			_roleFormat.font = getSkinProperty(FONT_FAMILY);
			
			_roleBox.x = _textBox.x + _textBox.width;
			_roleBox.y = _textBox.y;
			_roleBox.width = width - _textBox.width - 2*_defaultMargin;
			_roleBox.height = 20;
			_roleBox.setTextFormat(_roleFormat);
			
			_pBarBg.x = _defaultMargin*2;
			_pBarFill.x = _defaultMargin*2;
			_pBarBg.y = _textBox.y + _textBox.height;
			_pBarFill.y = _textBox.y + _textBox.height;
			
			
			var colors:Array = [0xd8d8d8, 0x8F8F8F];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			
			
			_pBarBg.graphics.clear();
			_pBarBg.graphics.lineStyle(1,0x757575,alpha);
			_pBarBg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, verticalGradientMatrix(0,0,6,6));
			_pBarBg.graphics.drawRect(0,0,width - 4*_defaultMargin,6);
			_pBarBg.graphics.endFill();
			
		}
		
		public function get talking() : Boolean
		{
			return _talking;
		}
		
		public function setTalking(role:String, duration:Number) : void
		{
			_talking = true;
			_duration = duration;
			_roleBox.text = role;
			_pBarMin = 0;
			_pBarMax = duration;
			_startTime = flash.utils.getTimer();
			
			_timer = new Timer(_refreshTime);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
		}
		
		public function pauseTalk() : void
		{
			_timer.stop();
			_pauseTime = flash.utils.getTimer();
		}
		
		public function resumeTalk() : void
		{
			var timeRunning:Number = _pauseTime - _startTime;
			_startTime = flash.utils.getTimer() - timeRunning;
			_timer.start();
		}
		
		public function stopTalk() : void
		{
			_timer.stop();
			_timer.reset();
			_talking = false;
			setProgress(0,_pBarMax);
			_roleBox.text = "";
		}
		
		private function onTick(event:TimerEvent) : void
		{
			var currentTime:Number = (flash.utils.getTimer() - _startTime) / 1000;
			
			if ( currentTime >= _duration )
			{
				setProgress(0, _duration);
				_talking = false;
				_roleBox.text = "";
				_timer.stop();
				_timer.reset();
			}
			else
				setProgress(currentTime, _duration);    
		}
		
		private function setProgress(actual:Number, max:Number) : void
		{
			var w:Number = (width - 4*_defaultMargin) * actual / max;
			
			_pBarFill.graphics.clear();
			_pBarFill.graphics.lineStyle(1,0x757575,1);
			_pBarFill.graphics.beginFill( 0xffffff );
			_pBarFill.graphics.drawRect( 0, 0, w, 6 );
			_pBarFill.graphics.endFill();
		}
		
		private function set label(text:String) : void
		{
			
			_textFormat.color = getSkinColor(TEXT_COLOR);
			_textBox.text = text;
			_textBox.setTextFormat(_textFormat);
		}
		
		private function CreateBG( bgWidth:Number, bgHeight:Number ):void
		{
			_bg.graphics.clear();
			
			_bg.graphics.beginFill(getSkinColor(BORDER_COLOR));
			_bg.graphics.drawRoundRect(0, 0, width, height, getSkinColor(CORNER_RADIUS), getSkinColor(CORNER_RADIUS));
			_bg.graphics.endFill();
			if ( !_highlight )
				_bg.graphics.beginFill(getSkinColor(BG_COLOR));
			else
				_bg.graphics.beginFill(getSkinColor(HL_COLOR));
			_bg.graphics.drawRoundRect(getSkinColor(BORDER_WEIGHT), getSkinColor(BORDER_WEIGHT), width - (2*getSkinColor(BORDER_WEIGHT)), height - (2*getSkinColor(BORDER_WEIGHT)), getSkinColor(CORNER_RADIUS), getSkinColor(CORNER_RADIUS));
			_bg.graphics.endFill();
		}
		
		public function set highlight(flag:Boolean) : void
		{
			_highlight = flag;
			refresh();
		}
	}
}
