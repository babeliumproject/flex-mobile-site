package modules.videoPlayer.controls
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import modules.videoPlayer.events.VolumeEvent;
	
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	import mx.events.EffectEvent;

	public class AudioSlider extends SkinableComponent
	{
		/**
		 * Skin constants
		 */
		public static const BG_COLOR:String = "bgColor";
		public static const BARBG_COLOR:String = "barBgColor";
		public static const BAR_COLOR:String = "barColor";
		public static const SCRUBBER_COLOR:String = "scrubberColor";
		public static const SCRUBBERBORDER_COLOR:String = "scrubberBorderColor";
		public static const MUTEOVERBG_COLOR:String = "muteOverBgColor";
		public static const MUTE_COLOR:String = "muteColor";
		
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
		
		private var _defaultWidth:Number = 80;
		private var _defaultHeight:Number = 40;
		
		private var _bg:Sprite;
		private var _sliderArea:Sprite;
		private var _amount:Sprite;
		private var _scrubber:Sprite;
		
		private var _defaultY:Number = 0;
		private var _defaultX:Number = 0;
		
		private var a1:AnimateProperty;
		private var a2:AnimateProperty;
		
		private var _currentVolume:Number = 0.5;
		
		private var _muteBtn:Sprite;
		private var _mutOverBg:Sprite;
		private var _muted:Boolean = false;
		private var _mutedX:Number = 0;
		private var _doingMute:Boolean = false;
		
		
		public function AudioSlider()
		{
			super("AudioSlider"); // Required for setup skinable component
			
			width = _defaultWidth;
			height = _defaultHeight;
			
			_bg = new Sprite();
			
			_sliderArea = new Sprite();
			_sliderArea.useHandCursor = true;
			_sliderArea.buttonMode = true;
			
			_amount = new Sprite();
			_amount.useHandCursor = true;
			_amount.buttonMode = true;
			
			_scrubber = new Sprite();
			_scrubber.useHandCursor = true;
			_scrubber.buttonMode = true;
			
			_muteBtn = new Sprite();
			_muteBtn.useHandCursor = true;
			_muteBtn.buttonMode = true;
			
			_mutOverBg = new Sprite();
			_mutOverBg.useHandCursor = true;
			_mutOverBg.buttonMode = true;
			
			addChild( _bg );
			addChild( _mutOverBg );
			addChild( _muteBtn );
			addChild( _sliderArea );
			addChild( _amount );
			addChild( _scrubber );
			
			
			//EventListeners
			
			_scrubber.addEventListener( MouseEvent.MOUSE_DOWN, onScrubberMouseDown );
			_sliderArea.addEventListener( MouseEvent.CLICK, onAreaClick );
			_amount.addEventListener( MouseEvent.CLICK, onAreaClick );
			_muteBtn.addEventListener( MouseEvent.MOUSE_OVER, muteOver );
			_mutOverBg.addEventListener( MouseEvent.MOUSE_OVER, muteOver );
			_muteBtn.addEventListener( MouseEvent.MOUSE_OUT, muteOut );
			_mutOverBg.addEventListener( MouseEvent.MOUSE_OUT, muteOut );
			_muteBtn.addEventListener( MouseEvent.CLICK, muteClicked );
			_mutOverBg.addEventListener( MouseEvent.CLICK, muteClicked );
		}
		
		override public function availableProperties(obj:Array = null) : void
		{
			super.availableProperties([BG_COLOR,BARBG_COLOR,BAR_COLOR,SCRUBBER_COLOR,
							SCRUBBERBORDER_COLOR,MUTE_COLOR,MUTEOVERBG_COLOR]);
		}
		
		
		/**
		 * Getters and Setters
		 * 
		 */
		public function getCurrentVolume( ):Number
		{
			return _currentVolume;
		}
		
		public function get muted() : Boolean
		{
			return _muted;
		}
		
		public function set muted(flag:Boolean) : void
		{
			if ( flag == _muted ) return;
			
			_sliderArea.useHandCursor = !flag;
			_sliderArea.buttonMode = !flag;
			
			_amount.useHandCursor = !flag;
			_amount.buttonMode = !flag;
			
			_scrubber.useHandCursor = !flag;
			_scrubber.buttonMode = !flag;

			_muteBtn.useHandCursor = !flag;
			_muteBtn.buttonMode = !flag;

			_mutOverBg.useHandCursor = !flag;
			_mutOverBg.buttonMode = !flag;
			
			if ( !flag )
			{
				_scrubber.addEventListener( MouseEvent.MOUSE_DOWN, onScrubberMouseDown );
				_sliderArea.addEventListener( MouseEvent.CLICK, onAreaClick );
				_amount.addEventListener( MouseEvent.CLICK, onAreaClick );
				_muteBtn.addEventListener( MouseEvent.MOUSE_OVER, muteOver );
				_mutOverBg.addEventListener( MouseEvent.MOUSE_OVER, muteOver );
				_muteBtn.addEventListener( MouseEvent.MOUSE_OUT, muteOut );
				_mutOverBg.addEventListener( MouseEvent.MOUSE_OUT, muteOut );
				_muteBtn.addEventListener( MouseEvent.CLICK, muteClicked );
				_mutOverBg.addEventListener( MouseEvent.CLICK, muteClicked );
			}
			else
			{
				_scrubber.removeEventListener( MouseEvent.MOUSE_DOWN, onScrubberMouseDown );
				_sliderArea.removeEventListener( MouseEvent.CLICK, onAreaClick );
				_amount.removeEventListener( MouseEvent.CLICK, onAreaClick );
				_muteBtn.removeEventListener( MouseEvent.MOUSE_OVER, muteOver );
				_mutOverBg.removeEventListener( MouseEvent.MOUSE_OVER, muteOver );
				_muteBtn.removeEventListener( MouseEvent.MOUSE_OUT, muteOut );
				_mutOverBg.removeEventListener( MouseEvent.MOUSE_OUT, muteOut );
				_muteBtn.removeEventListener( MouseEvent.CLICK, muteClicked );
				_mutOverBg.removeEventListener( MouseEvent.CLICK, muteClicked );
			}

			muteClicked(null); // Click event
		}
		
		
		/** 
		 * Methods
		 * 
		 */
		
		
		/** Overriden */
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if( width == 0 ) width = _defaultWidth;
			if( height == 0 ) height = _defaultHeight;
			
			// Create Background
			var matr:Matrix = new Matrix();
			matr.createGradientBox(height, height, getSkinColor(BG_GRADIENT_ANGLE)*Math.PI/180, 0, 0);
			
			var colors:Array = [getSkinColor(BG_GRADIENT_START_COLOR), getSkinColor(BG_GRADIENT_END_COLOR)];
			var alphas:Array = [getSkinColor(BG_GRADIENT_START_ALPHA), getSkinColor(BG_GRADIENT_END_ALPHA)];
			var ratios:Array = [getSkinColor(BG_GRADIENT_START_RATIO), getSkinColor(BG_GRADIENT_END_RATIO)];
			
			_bg.graphics.clear();
			_bg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr);
			if(getSkinColor(BORDER_WEIGHT) > 0)
				_bg.graphics.lineStyle(getSkinColor(BORDER_WEIGHT),getSkinColor(BORDER_COLOR));
			_bg.graphics.drawRect( 0, 0, width, height );
			_bg.graphics.endFill();		
			
			// mute button
			_mutOverBg.graphics.clear();
			_mutOverBg.graphics.beginFill( getSkinColor(MUTEOVERBG_COLOR) );
			_mutOverBg.graphics.drawRect( 0, 10, 20, 20 );
			_mutOverBg.graphics.endFill();
			
			_mutOverBg.alpha = 0;
			
			_muteBtn.graphics.clear();
			_muteBtn.graphics.beginFill( getSkinColor(MUTE_COLOR) );
			_muteBtn.graphics.drawRect( 0, 2, 3, 6 );
			_muteBtn.graphics.moveTo( 5, 2 );
			_muteBtn.graphics.lineTo( 9, 0 );
			_muteBtn.graphics.lineTo( 9, 10 );
			_muteBtn.graphics.lineTo( 5, 8 );
			_muteBtn.graphics.endFill();
			
			_muteBtn.x = _mutOverBg.width/2 - _muteBtn.width/2;
			_muteBtn.y = _mutOverBg.height/2+4;
			
			
			
			// Slider Drag Area
			_sliderArea.graphics.clear();
			_sliderArea.graphics.beginFill( getSkinColor(BARBG_COLOR) );
			_sliderArea.graphics.drawRect( 0, 0, width-30, 10 );
			_sliderArea.graphics.endFill();
			
			_sliderArea.x = width - _sliderArea.width - 5;
			_sliderArea.y = height/2 - _sliderArea.height/2;
			
			_amount.graphics.clear();
			_amount.graphics.beginFill( getSkinColor(BAR_COLOR) );
			_amount.graphics.drawRect( 0, 0, 1, 10 );
			_amount.graphics.endFill();
			
			_amount.x = _sliderArea.x;
			_amount.y = _sliderArea.y;
			
			_scrubber.graphics.clear();
			_scrubber.graphics.beginFill( getSkinColor(SCRUBBER_COLOR) );
			_scrubber.graphics.lineStyle( 1, getSkinColor(SCRUBBERBORDER_COLOR) );
			_scrubber.graphics.drawRect( 0, 0, 10, 15 );
			_scrubber.graphics.endFill();
			
			_defaultX = _sliderArea.x;
			_defaultY = _scrubber.y = height/2 - _scrubber.height/2;
			
			_scrubber.x = _sliderArea.width/2 + _sliderArea.x - _scrubber.width/2;
			_amount.width = _sliderArea.width/2 - _scrubber.width/2;
			
		}
		
		
		private function onScrubberMouseDown( e:MouseEvent ):void
		{
			addEventListener( Event.ENTER_FRAME, updateAmount );
			
			_scrubber.startDrag( false, new Rectangle( _sliderArea.x, _defaultY, _sliderArea.width - _scrubber.width, 0 ) );
			
			this.parentApplication.addEventListener( MouseEvent.MOUSE_UP, onScrubberDrop );
		}
		
		
		private function onScrubberDrop( e:MouseEvent ):void
		{
			_muted = false;
			
			this.parentApplication.removeEventListener( MouseEvent.MOUSE_UP, onScrubberDrop );
			
			_scrubber.stopDrag();
			
			removeEventListener( Event.ENTER_FRAME, updateAmount );
			
			volumeChanged();
			
			updateAmount();
		}
		
		
		private function updateAmount( e:Event = null ):void
		{
			_amount.width = _scrubber.x - _defaultX;
		}
		
		
		private function onAreaClick( e:MouseEvent ):void
		{
			var _x:Number = mouseX;
			
			if( _x > ( _sliderArea.x + _sliderArea.width - _scrubber.width ) ) _x = _sliderArea.x + _sliderArea.width - _scrubber.width;
			
			
			a1 = new AnimateProperty();
			a1.target = _scrubber;
			a1.property = "x";
			a1.toValue = _x;
			a1.duration = 250;
			a1.play();
			a1.addEventListener( EffectEvent.EFFECT_END, volumeChanged );
			
			a2 = new AnimateProperty();
			a2.target = _amount;
			a2.property = "width";
			a2.toValue = _x - _defaultX;
			a2.duration = 250;
			a2.play();
			
		}
		
		
		private function volumeChanged( e:EffectEvent = null ):void
		{
			_currentVolume = _amount.width / ( _sliderArea.width - _scrubber.width );
			
			dispatchEvent( new VolumeEvent( VolumeEvent.VOLUME_CHANGED, _currentVolume ) );
		}
		
		
		private function muteOver( e:MouseEvent ):void
		{
			_mutOverBg.alpha = 1;
		}
		
		
		private function muteOut( e:MouseEvent ):void
		{
			_mutOverBg.alpha = 0;
		}
		
		
		private function muteClicked( e:MouseEvent ):void
		{
			if ( _doingMute ) return; // Avoiding stack overflow
			
			_doingMute = true;
			
			var _x:Number = _muted == true ? _mutedX : _defaultX;
			
			if( _currentVolume == 0 && !_muted ) 
			{
				_x = _defaultX + _sliderArea.width/2 - _scrubber.width;
				_currentVolume = 0.5;
				_muted = true;
			}
			
			if( !_muted ) _mutedX = _scrubber.x;
			
			a1 = new AnimateProperty();
			a1.target = _scrubber;
			a1.property = "x";
			a1.toValue = _x;
			a1.duration = 250;
			a1.play();
			a1.addEventListener( EffectEvent.EFFECT_END, function( e:EffectEvent ):void
			{
				if( _muted )
				{
					dispatchEvent( new VolumeEvent( VolumeEvent.VOLUME_CHANGED, _currentVolume ) );
					_muted = false;
					
				} else
				{
					dispatchEvent( new VolumeEvent( VolumeEvent.VOLUME_CHANGED, 0 ) );
					_muted = true;
				}
				
				_doingMute = false;
			} );
			
			a2 = new AnimateProperty();
			a2.target = _amount;
			a2.property = "width";
			a2.toValue = _x - _defaultX;
			a2.duration = 250;
			a2.play();
		}
		
	}
}