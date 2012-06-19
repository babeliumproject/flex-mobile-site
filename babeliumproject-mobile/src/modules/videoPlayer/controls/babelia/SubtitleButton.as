package modules.videoPlayer.controls.babelia
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import modules.videoPlayer.controls.SkinableComponent;
	import modules.videoPlayer.events.babelia.SubtitleButtonEvent;
	
	import mx.core.UIComponent;
	
	import spark.components.ToggleButton;
	
	public class SubtitleButton extends SkinableComponent
	{
		/**
		 * SKIN CONSTANTS
		 */
		public static const BG_COLOR:String = "bgColor";
		
		public static const BG_GRADIENT_ANGLE:String = "bgGradientAngle";
		public static const BG_GRADIENT_START_COLOR:String = "bgGradientStartColor";
		public static const BG_GRADIENT_END_COLOR:String = "bgGradientEndColor";
		public static const BG_GRADIENT_START_ALPHA:String = "bgGradientStartAlpha";
		public static const BG_GRADIENT_END_ALPHA:String = "bgGradientEndAlpha";
		public static const BG_GRADIENT_START_RATIO:String = "bgGradientStartRatio";
		public static const BG_GRADIENT_END_RATIO:String = "bgGradientEndRatio";
		public static const BORDER_COLOR:String = "borderColor";
		public static const BORDER_WEIGHT:String = "borderWeight";
		
		
		/**
		 * VARIABLES
		 */
		private var _bg:Sprite;
		private var _button:ToggleButton;
		private var _state:String;
		private var _boxWidth:Number = 40;
		private var _boxHeight:Number = 20;
		private var _boxColor:uint = 0xFFFFFF;
		private var _defaultHeight:Number = 20;
		
		public function SubtitleButton(state:Boolean = false)
		{
			super("SubtitleButton"); // Required to setup skinable component
			
			_bg = new Sprite();
			addChild(_bg);
			
			_button = new ToggleButton();
			_button.buttonMode = true;
			_button.label = "SUB";
			_button.setStyle("fontSize",8);
			_button.setStyle("fontWeight", "bold");
			_button.setStyle("cornerRadius", 4);
			addChild( _button );
			
			_button.selected = state ? true : false;
			_button.toolTip = _button.selected ? resourceManager.getString('myResources','HIDE_SUBTITLES') : resourceManager.getString('myResources','SHOW_SUBTITLES');

			_button.addEventListener(MouseEvent.CLICK, showHideSubtitles);

			resize(_boxWidth, _boxHeight);
		}
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR]);
		}
		
		public function resize(width:Number, height:Number) : void
		{
			this.width = width;
			this.height = height;
			
			CreateBG( width, height );
			
			_button.width = _boxWidth - 2;
			_button.height = _boxHeight - 2;
			
			_button.x = (width - _button.width) / 2;
			_button.y = 11;
		}
		
		public function setEnabled(flag:Boolean) : void
		{
			_button.selected = (!flag) ? false : true;
			_button.toolTip = _button.selected ? resourceManager.getString('myResources','HIDE_SUBTITLES') : resourceManager.getString('myResources','SHOW_SUBTITLES');
			_button.enabled = flag;
		}
		
		private function showHideSubtitles(e:MouseEvent) : void
		{
			_button.toolTip = _button.selected ? resourceManager.getString('myResources','HIDE_SUBTITLES') : resourceManager.getString('myResources','SHOW_SUBTITLES');
				
			this.dispatchEvent(new SubtitleButtonEvent(SubtitleButtonEvent.STATE_CHANGED, _button.selected));
		}
		
		private function CreateBG( bgWidth:Number, bgHeight:Number ):void
		{
			var matr:Matrix = new Matrix();
			matr.createGradientBox(bgHeight, bgHeight, getSkinColor(BG_GRADIENT_ANGLE)*Math.PI/180, 0, 0);
			
			var colors:Array = [getSkinColor(BG_GRADIENT_START_COLOR), getSkinColor(BG_GRADIENT_END_COLOR)];
			var alphas:Array = [getSkinColor(BG_GRADIENT_START_ALPHA), getSkinColor(BG_GRADIENT_END_ALPHA)];
			var ratios:Array = [getSkinColor(BG_GRADIENT_START_RATIO), getSkinColor(BG_GRADIENT_END_RATIO)];
			
			_bg.graphics.clear();
			_bg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr);
			if(getSkinColor(BORDER_WEIGHT) > 0)
				_bg.graphics.lineStyle(getSkinColor(BORDER_WEIGHT),getSkinColor(BORDER_COLOR));
			_bg.graphics.drawRect( 0, 0, bgWidth, 40 );
			_bg.graphics.endFill();
			
		}
	}
}