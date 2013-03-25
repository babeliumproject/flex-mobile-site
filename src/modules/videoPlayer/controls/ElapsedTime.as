package modules.videoPlayer.controls
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	//import mx.controls.Alert;
	import mx.core.UIComponent;

	public class ElapsedTime extends SkinableComponent
	{
		/**
		 * Skin constants
		 */
		public static const BG_COLOR:String = "bgColor";
		public static const TEXT_COLOR:String = "textColor";
		
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
		 * Variables
		 * 
		 */
		private var _bg:Sprite;
		private var _timeBox:TextField;
		private var tf:TextFormat = new TextFormat();
		private var _defaultWidth:Number = 75;
		private var _defaultHeight:Number = 40;
		
		
		public function ElapsedTime()
		{
			super("ElapsedTime"); // Required for setup skinable component
			
			_bg = new Sprite();
			addChild(_bg);
			
			width = _defaultWidth;
			height = _defaultHeight;
			
			_timeBox = new TextField();
			_timeBox.text = "0:00/0:00";
			_timeBox.selectable = false;
			_timeBox.y = 11;
			
			
			tf.bold = true;
			tf.align = "center";
			tf.font = "Arial";
			
			_timeBox.setTextFormat( tf );
			
			addChild( _timeBox );
		}
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR,TEXT_COLOR]);
		}
		
		/**
		 * Methods
		 * 
		 */
		
		
		/** Overriden */
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( height == 0 ) height = _defaultHeight;
			if( width == 0 ) width = _defaultWidth;
			
			CreateBG( width, height );
			
			_timeBox.width = width;
			tf.color = getSkinColor(TEXT_COLOR);
			
		}
		
		
		private function CreateBG( bgWidth:Number, bgHeight:Number ):void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill( getSkinColor(BG_COLOR) );
			_bg.graphics.drawRect( 0, 0, bgWidth, bgHeight );
			_bg.graphics.endFill();
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(bgHeight, bgHeight, getSkinColor(BG_GRADIENT_ANGLE)*Math.PI/180, 0, 0);
			
			var colors:Array = [getSkinColor(BG_GRADIENT_START_COLOR), getSkinColor(BG_GRADIENT_END_COLOR)];
			var alphas:Array = [getSkinColor(BG_GRADIENT_START_ALPHA), getSkinColor(BG_GRADIENT_END_ALPHA)];
			var ratios:Array = [getSkinColor(BG_GRADIENT_START_RATIO), getSkinColor(BG_GRADIENT_END_RATIO)];
			
			_bg.graphics.clear();
			_bg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr);
			if(getSkinColor(BORDER_WEIGHT) > 0)
				_bg.graphics.lineStyle(getSkinColor(BORDER_WEIGHT),getSkinColor(BORDER_COLOR));
			_bg.graphics.drawRect( 0, 0, bgWidth, bgHeight );
			_bg.graphics.endFill();
			
		}
		
		
		public function updateElapsedTime( curTime:Number, duration:Number ):void
		{
			var cMin:Object = Math.floor( curTime/60 );
			var cSec:Object = Math.floor( curTime - ( Number( cMin )*60 ) );
			
			var dMin:Object = Math.floor( duration/60 );
			var dSec:Object = Math.floor( duration - ( Number( dMin )*60 ) );
			
			if( Number( cSec ) > Number( dSec ) && Number( cMin ) == Number( dMin ) ) cSec = dSec;
			
			if( cSec.toString().length == 1 ) cSec = "0" + cSec;
			
			if( dSec.toString().length == 1 ) dSec = "0" + dSec;
			
			_timeBox.text = cMin + ":" + cSec + " / " + dMin + ":" + dSec;
			
			_timeBox.setTextFormat( tf );
		}
	}
}