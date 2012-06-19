package modules.videoPlayer.controls
{	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Graphic;

	public class SkinableButton extends SkinableComponent
	{
		/**
		 * Skin related constants
		 */
		public static const BG_COLOR:String = "bgColor";
		public static const OVERBG_COLOR:String = "overBgColor";
		public static const ICON_COLOR:String = "iconColor";
		
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
		private var bg:Sprite;
		private var bgOver:Sprite;
		private var bgClick:Sprite;
		protected var btn:Sprite;
		
		
		
		public function SkinableButton(name:String = "SkinableButton")
		{
			super(name); // Required for setup skinable component
			
			this.height = 20;
			this.width = 20;
			
			bgClick = new Sprite();
			bgOver = new Sprite();
			bg = new Sprite();
			btn = new Sprite();
			
			//addChild( bgClick );
			addChild( bgOver );
			addChild( bg );
			
			addChild( btn );
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			this.addEventListener( MouseEvent.ROLL_OVER, onMouseOver );
			this.addEventListener( MouseEvent.ROLL_OUT, onMouseOut );
			this.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR,OVERBG_COLOR,ICON_COLOR]);
		}
		
		/**
		 * Enable/disable stop button
		 **/
		override public function set enabled(flag:Boolean) : void
		{
			super.enabled = flag;
			
			this.buttonMode = flag;
			this.useHandCursor = flag;

			if ( flag )
			{
				this.addEventListener( MouseEvent.ROLL_OVER, onMouseOver );
				this.addEventListener( MouseEvent.ROLL_OUT, onMouseOut );
				this.addEventListener( MouseEvent.CLICK, onClick );
			}
			else
			{
				this.removeEventListener( MouseEvent.ROLL_OVER, onMouseOver );
				this.removeEventListener( MouseEvent.ROLL_OUT, onMouseOut );
				this.removeEventListener( MouseEvent.CLICK, onClick );
			}
			
			if ( bg ) onMouseOut(null);
		}
		
		/**
		 * Methods
		 * 
		 */
		
		
		/** OVERRIDEN */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			this.graphics.clear();
			
			bgOver.graphics.clear();
			bgOver.graphics.beginFill( getSkinColor(OVERBG_COLOR) );
			if(getSkinColor(BORDER_WEIGHT) > 0)
				bgOver.graphics.lineStyle(getSkinColor(BORDER_WEIGHT),getSkinColor(BORDER_COLOR));
			bgOver.graphics.drawRect( 0, 0, 20, 40 );
			bgOver.graphics.endFill();
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, 20, getSkinColor(BG_GRADIENT_ANGLE)*Math.PI/180, 0, 0);
			
			var colors:Array = [getSkinColor(BG_GRADIENT_START_COLOR), getSkinColor(BG_GRADIENT_END_COLOR)];
			var alphas:Array = [getSkinColor(BG_GRADIENT_START_ALPHA), getSkinColor(BG_GRADIENT_END_ALPHA)];
			var ratios:Array = [getSkinColor(BG_GRADIENT_START_RATIO), getSkinColor(BG_GRADIENT_END_RATIO)];
			
			bg.graphics.clear();
			bg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr);
			if(getSkinColor(BORDER_WEIGHT) > 0)
				bg.graphics.lineStyle(getSkinColor(BORDER_WEIGHT),getSkinColor(BORDER_COLOR));
			bg.graphics.drawRect( 0, 0, 20, 40 );
			bg.graphics.endFill();
			
//			var filter:BitmapFilter = getBitmapFilter();
//			var myFilters:Array = new Array();
//			myFilters.push(filter);
//			bgClick.graphics.clear();
//			bgClick.graphics.copyFrom(bg.graphics);
//			bgClick.filters = myFilters;

			btn.x = this.width/2 - btn.width/2;
			btn.y = 14;
		}
				
		
		private function onMouseOver( e:MouseEvent ):void
		{
			bgOver.alpha = 1;
			bg.alpha = 0;
		}
		
		
		private function onMouseOut( e:MouseEvent ):void
		{
			bgOver.alpha = 0;
			bg.alpha = 1;
		}
		
		
		// NOTE: this methos is empty, but don't remove it
		protected function onClick( e:MouseEvent ) : void
		{
			//bg.alpha = 0;
			//bgOver.alpha = 0;
		}
		
		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 90;
			var alpha:Number = 1.0;
			var blurX:Number = 4;
			var blurY:Number = 4;
			var distance:Number = 0;
			var strength:Number = 0.90;
			var inner:Boolean = true;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		//----------------------------------
		//  toolTip
		//----------------------------------
		
		[Inspectable(category="General", defaultValue="null")]
		
		/**
		 *  @private
		 */
		private var _explicitToolTip:Boolean = false;
		
		/**
		 *  @private
		 */
		override public function set toolTip(value:String):void
		{
			super.toolTip = value;
			
			_explicitToolTip = value != null;
		}

		
	}
}