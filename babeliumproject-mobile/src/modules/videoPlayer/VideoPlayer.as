/**
 * NOTES
 *
 * Player needs a way to tell if a video exsists when streaming video.
 */

package modules.videoPlayer
{
        import events.CloseConnectionEvent;
        import events.StartConnectionEvent;
        
        import flash.display.Sprite;
        import flash.events.AsyncErrorEvent;
        import flash.events.Event;
        import flash.events.IOErrorEvent;
        import flash.events.NetStatusEvent;
        import flash.events.SecurityErrorEvent;
        import flash.events.TimerEvent;
        import flash.media.SoundTransform;
        import flash.media.Video;
        import flash.net.NetConnection;
        import flash.net.NetStream;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.utils.Dictionary;
        import flash.utils.Timer;
        
        import flashx.textLayout.operations.PasteOperation;
        
        import model.DataModel;
        
        import modules.videoPlayer.controls.AudioSlider;
        import modules.videoPlayer.controls.ElapsedTime;
        import modules.videoPlayer.controls.PlayButton;
        import modules.videoPlayer.controls.ScrubberBar;
        import modules.videoPlayer.controls.SkinableComponent;
        import modules.videoPlayer.controls.StopButton;
        import modules.videoPlayer.events.PlayPauseEvent;
        import modules.videoPlayer.events.ScrubberBarEvent;
        import modules.videoPlayer.events.StopEvent;
        import modules.videoPlayer.events.VideoPlayerEvent;
        import modules.videoPlayer.events.VolumeEvent;
        
        import mx.binding.utils.BindingUtils;
//        import mx.controls.Alert;
        import mx.core.UIComponent;
        import mx.events.FlexEvent;
        import mx.utils.ObjectUtil;
        
  //      import view.common.CustomAlert;

        public class VideoPlayer extends SkinableComponent
        {
                /**
                 * Skin related variables
                 */
                private const SKIN_PATH:String="resources/videoPlayer/skin/";
                private var _skinableComponents:Dictionary;
                private var _skinLoader:URLLoader;
                private var _loadingSkin:Boolean=false;
                public static const BG_COLOR:String="bgColor";
                public static const BORDER_COLOR:String="borderColor";
                public static const VIDEOBG_COLOR:String="videoBgColor";

                /**
                 * Variables
                 *
                 */
                protected var _video:Video;
                protected var _ns:NetStream;
                protected var _nc:NetConnection;

                private var _videoSource:String=null;
                protected var _streamSource:String=null;
                private var _state:String=null;
                private var _autoPlay:Boolean=false;
                private var _smooth:Boolean=true;
                private var _currentTime:Number=0;
                private var _autoScale:Boolean=true;
                protected var _duration:Number=0;
                protected var _started:Boolean=false;
                protected var _defaultMargin:Number=0;

                private var _bgVideo:Sprite;
                public var _ppBtn:PlayButton;
                public var _stopBtn:StopButton;
                protected var _eTime:ElapsedTime;
                protected var _bg:Sprite;
                protected var _videoBarPanel:UIComponent;
                protected var _sBar:ScrubberBar;
                protected var _audioSlider:AudioSlider;
                protected var _videoHeight:Number=200;
                protected var _videoWidth:Number=320;

                private var _timer:Timer;

                public static const PLAYBACK_READY_STATE:int=0;
                public static const PLAYBACK_STARTED_STATE:int=1;
                public static const PLAYBACK_STOPPED_STATE:int=2;
                public static const PLAYBACK_FINISHED_STATE:int=3;
                public static const PLAYBACK_PAUSED_STATE:int=4;
                public static const PLAYBACK_UNPAUSED_STATE:int=5;
                public static const PLAYBACK_BUFFERING_STATE:int=6;

                [Bindable]
                public var playbackState:int;

                /**
                 * CONSTRUCTOR
                 **/
                public function VideoPlayer(name:String="VideoPlayer")
                {
                        super(name);

                        _skinableComponents=new Dictionary();

                        _bg=new Sprite();

                        _bgVideo=new Sprite();

                        _video=new Video();
                        _video.smoothing=_smooth;

                        _videoBarPanel=new UIComponent();
                        _ppBtn=new PlayButton();
                        _stopBtn=new StopButton();
                        _videoBarPanel.addChild(_ppBtn);
                        _videoBarPanel.addChild(_stopBtn);

                        _sBar=new ScrubberBar();

                        _videoBarPanel.addChild(_sBar);

                        _eTime=new ElapsedTime();

                        _videoBarPanel.addChild(_eTime);

                        _audioSlider=new AudioSlider();

                        _videoBarPanel.addChild(_audioSlider);

                        //Event Listeners
                        addEventListener(VideoPlayerEvent.VIDEO_SOURCE_CHANGED, onSourceChange);
                        addEventListener(FlexEvent.CREATION_COMPLETE, onComplete);
                        addEventListener(VideoPlayerEvent.VIDEO_FINISHED_PLAYING, onVideoFinishedPlaying);
                        _ppBtn.addEventListener(PlayPauseEvent.STATE_CHANGED, onPPBtnChanged);
                        _stopBtn.addEventListener(StopEvent.STOP_CLICK, onStopBtnClick);
                        _audioSlider.addEventListener(VolumeEvent.VOLUME_CHANGED, onVolumeChange);

                        /**
                         * Adds components to player
                         */
                        addChild(_bg);
                        addChild(_bgVideo);
                        addChild(_video);
                        addChild(_videoBarPanel);

                        /**
                         * Adds skinable components to dictionary
                         */
                        putSkinableComponent(COMPONENT_NAME, this);
                        putSkinableComponent(_audioSlider.COMPONENT_NAME, _audioSlider);
                        putSkinableComponent(_eTime.COMPONENT_NAME, _eTime);
                        putSkinableComponent(_ppBtn.COMPONENT_NAME, _ppBtn);
                        putSkinableComponent(_sBar.COMPONENT_NAME, _sBar);
                        putSkinableComponent(_stopBtn.COMPONENT_NAME, _stopBtn);

                        // Loads default skin
                        skin="default";
                }


                /**
                 * Video streaming source
                 *
                 */
                public function set videoSource(location:String):void
                {
                		
                        _videoSource=location;
                        _video.visible=true;

                        if (location != "")
                                dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_SOURCE_CHANGED));
                        else
                                resetAppearance();
                }

                public function get videoSource():String
                {
                        return _videoSource;
                }

                /**
                 * Flash server
                 */
                public function set streamSource(location:String):void
                {
                
                        _streamSource=location;
                }

                public function get streamSource():String
                {
                        return _streamSource;
                }

                /**
                 * Autoplay
                 */
                public function set autoPlay(tf:Boolean):void
                {
                
                        _autoPlay=tf;
                }

                public function get autoPlay():Boolean
                {
                        return _autoPlay;
                }

                /**
                 * Smooting
                 */
                public function set videoSmooting(tf:Boolean):void
                {
                
                        _autoPlay=_smooth;
                }

                public function get videoSmooting():Boolean
                {
                        return _smooth;
                }

                /**
                 * Autoscale
                 */
                public function set autoScale(flag:Boolean):void
                {
                
                        _autoScale=flag;
                }

                public function get autoScale():Boolean
                {
                        return _autoScale;
                }

                /**
                 * Seek
                 */
                public function set seek(flag:Boolean):void
                {
                
                        if (flag)
                        {
                                _sBar.addEventListener(ScrubberBarEvent.SCRUBBER_DROPPED, onScrubberDropped);
                                _sBar.addEventListener(ScrubberBarEvent.SCRUBBER_DRAGGING, onScrubberDragging);
                        }
                        else
                        {
                                _sBar.removeEventListener(ScrubberBarEvent.SCRUBBER_DROPPED, onScrubberDropped);
                                _sBar.removeEventListener(ScrubberBarEvent.SCRUBBER_DRAGGING, onScrubberDragging);
                        }

                        _sBar.enableSeek(flag);
                }

                public function seekTo(time:Number):void
                {
                
                        this.onScrubberDragging(null);
                        _sBar.updateProgress(time, _duration);
                        this.onScrubberDropped(null);
                }

                /**
                 * Enable/disable controls
                 **/
                public function set controlsEnabled(flag:Boolean):void
                {
                
                        flag ? enableControls() : disableControls();

                }

                public function toggleControls():void
                {
                
                        (_ppBtn.enabled) ? disableControls() : enableControls();
                }

                public function enableControls():void
                {
                
                        _ppBtn.enabled=true;
                        _stopBtn.enabled=true;
                }

                public function disableControls():void
                {
                
                        _ppBtn.enabled=false;
                        _stopBtn.enabled=false;
                }

                /**
                 * Skin HashMap related commands
                 */
                protected function putSkinableComponent(name:String, cmp:SkinableComponent):void
                {
                
                        _skinableComponents[name]=cmp;
                }

                protected function getSkinableComponent(name:String):SkinableComponent
                {
                        return _skinableComponents[name];
                }

                public function setSkin(fileName:String):void
                {
                
                        skin=fileName;
                }

                /**
                 * Duration
                 */
                public function get duration():Number
                {
                        return _duration;
                }

                /**
                 * Skin loader
                 */
                public function set skin(name:String):void
                {
                
                        var fileName:String=SKIN_PATH + name + ".xml";

                        if (_loadingSkin)
                        { // Maybe some skins will try to load at same time
                                flash.utils.setTimeout(setSkin, 20, name);
                                return;
                        }

                        var xmlURL:URLRequest=new URLRequest(fileName);
                        _skinLoader=new URLLoader(xmlURL);
                        _skinLoader.addEventListener(Event.COMPLETE, onSkinFileRead);
                        _skinLoader.addEventListener(IOErrorEvent.IO_ERROR, onSkinFileReadingError);
                        _loadingSkin=true;
                }

                /**
                 * Parses Skin file
                 */
                public function onSkinFileRead(e:Event):void
                {
                
                        var xml:XML=new XML(_skinLoader.data);

                        for each (var xChild:XML in xml.child("Component"))
                        {
                                var componentName:String=xChild.attribute("name").toString();
                                var cmp:SkinableComponent=getSkinableComponent(componentName);

                                if (cmp == null)
                                        continue;
                                for each (var xElement:XML in xChild.child("Property"))
                                {
                                        var propertyName:String=xElement.attribute("name").toString();
                                        var propertyValue:String=xElement.toString();
                                        cmp.setSkinProperty(propertyName, propertyValue);
                                }
                        }

                        updateDisplayList(0, 0); // repaint();
                        _loadingSkin=false;
                }

                public function onSkinFileReadingError(e:Event):void
                {
                        _loadingSkin=false;
                }

                /** Overriden */

                override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
                {
                
                        super.updateDisplayList(unscaledWidth, unscaledHeight);

                        this.graphics.clear();

                        _bgVideo.graphics.clear();
                        _bgVideo.graphics.beginFill(getSkinColor(VIDEOBG_COLOR));
                        _bgVideo.graphics.drawRoundRect(_defaultMargin, _defaultMargin, _videoWidth, _videoHeight, 5, 5);
                        _bgVideo.graphics.endFill();

                        _videoBarPanel.width=_videoWidth;
                        _videoBarPanel.height=40;
                        _videoBarPanel.y=_defaultMargin + _videoHeight;
                        _videoBarPanel.x=_defaultMargin;

                        _ppBtn.x=0;
                        _ppBtn.refresh();

                        _stopBtn.x=_ppBtn.x + _ppBtn.width;
                        _stopBtn.refresh();

                        _sBar.x=_stopBtn.x + _stopBtn.width;
                        _sBar.refresh();

                        _eTime.refresh();

                        _audioSlider.refresh();

                        _sBar.width=_videoWidth - _ppBtn.width - _stopBtn.width - _eTime.width - _audioSlider.width;

                        _eTime.x=_sBar.x + _sBar.width;
                        _audioSlider.x=_eTime.x + _eTime.width;

                        drawBG();
                }

                /**
                 * Set width/height of video widget
                 */
                override public function set width(w:Number):void
                {
                
                        totalWidth=w;
                        _videoWidth=w - 2 * _defaultMargin;
                        this.updateDisplayList(0, 0); // repaint
                }

                override public function set height(h:Number):void
                {
                
                        totalHeight=h;
                        _videoHeight=h - 2 * _defaultMargin;
                        this.updateDisplayList(0, 0); // repaint
                }

                /**
                 * Set total width/height of videoplayer
                 */
                protected function set totalWidth(w:Number):void
                {
                
                        super.width=w;
                }

                protected function set totalHeight(h:Number):void
                {

                        super.height=h;
                }

                /**
                 * Draws a background for videoplayer
                 */
                protected function drawBG():void
                {

                        totalHeight=_defaultMargin * 2 + _videoHeight + _videoBarPanel.height;

                        _bg.graphics.clear();

                        _bg.graphics.beginFill(getSkinColor(BORDER_COLOR));
                        _bg.graphics.drawRoundRect(0, 0, width, height, 15, 15);
                        _bg.graphics.endFill();
                        _bg.graphics.beginFill(getSkinColor(BG_COLOR));
                        _bg.graphics.drawRoundRect(3, 3, width - 6, height - 6, 12, 12);
                        _bg.graphics.endFill();
                }

                /**
                 * On creation complete
                 */
                private function onComplete(e:FlexEvent):void
                {
                        //Establish a binding to listen the status of netConnection
                        BindingUtils.bindSetter(onStreamNetConnect, DataModel.getInstance(), "netConnected");

                        // Dispatch CREATION_COMPLETE event
                        dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CREATION_COMPLETE));
                }

                /**
                 * On stream connect
                 */
                private function onStreamNetConnect(value:Boolean):void
                {

                        if (DataModel.getInstance().netConnected == true)
                        {
                                //Get the netConnection reference
                                _nc=DataModel.getInstance().netConnection;

                                
                                playVideo();
                                _ppBtn.State=PlayButton.PAUSE_STATE;
                                if (!_autoPlay)
                                {       
                                        pauseVideo();
                                }

                                enableControls();

                                this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CONNECTED));
                        }
                        else{
                                disableControls();
                                
                                if (_streamSource){
                                        connectToStreamingServer(_streamSource);
                                }
                        }
                }
                
                public function connectToStreamingServer(streamSource:String):void
                {
                        
                        if (!DataModel.getInstance().netConnection.connected)
                                new StartConnectionEvent(streamSource).dispatch();
                        else
                                onStreamNetConnect(true);
                }
                
                public function disconnectFromStreamingService():void
                {
                        
                        if (DataModel.getInstance().netConnection.connected)
                                new CloseConnectionEvent().dispatch();
                }


                private function netStatus(e:NetStatusEvent):void
                {
                        trace("Exercise status: " + e.info.code);
        
                        switch (e.info.code)
                        {
                                case "NetStream.Play.StreamNotFound":
                                        trace("Stream not found code: " + e.info.code + " for video " + _videoSource);
                                        break;
                                case "NetStream.Play.Stop":
                                        playbackState=PLAYBACK_STOPPED_STATE;
                                        break;
                                case "NetStream.Play.Start":
                                        playbackState=PLAYBACK_READY_STATE;
                                        break;
                                case "NetStream.Buffer.Full":
                                        if (playbackState == PLAYBACK_UNPAUSED_STATE)
                                                playbackState=PLAYBACK_STARTED_STATE;
                                        if (playbackState == PLAYBACK_READY_STATE)
                                        {
                                                playbackState=PLAYBACK_STARTED_STATE;
                                                dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STARTED_PLAYING));
                                        }
                                        if(playbackState == PLAYBACK_BUFFERING_STATE)
                                                playbackState = PLAYBACK_STARTED_STATE;
                                        break;
                                case "NetStream.Buffer.Empty":
                                        if (playbackState == PLAYBACK_STOPPED_STATE)
                                        {
                                                playbackState=PLAYBACK_FINISHED_STATE;
                                                dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_FINISHED_PLAYING));
                                        }
                                        else
                                                playbackState=PLAYBACK_BUFFERING_STATE;
                                        break;
                                case "NetStream.Pause.Notify":
                                        playbackState=PLAYBACK_PAUSED_STATE;
                                        break;
                                case "NetStream.Unpause.Notify":
                                        playbackState=PLAYBACK_UNPAUSED_STATE;
                                        break;
                                default:
                                        break;
                        }
                }

                protected function asyncErrorHandler(event:AsyncErrorEvent):void
                {
                        // Avoid debug messages
                }

                protected function netIOError(event:IOErrorEvent):void
                {
                        // Avoid debug messages
                }

                public function onCuePoint(obj:Object):void
                {
                        // Avoid debug messages
                }

                /**
                 * Stream controls
                 */
				public function playVideo():void
				{
					if(!_nc){
						_ppBtn.State=PlayButton.PLAY_STATE;
						return;
					}
					if (!_nc.connected)
					{
						_ppBtn.State=PlayButton.PLAY_STATE;
						return;
					}
					
					if (_ns != null)
						_ns.close();
					
					_ns=new NetStream(_nc);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
					_ns.soundTransform=new SoundTransform(_audioSlider.getCurrentVolume());
					_ns.client=this;
					_video.attachNetStream(_ns);
					
					if (_videoSource != '')
					{
						try
						{
							trace("[INFO] Exercise stream: Selected video " + _videoSource);
							_ns.play(_videoSource);
						}
						catch (e:Error)
						{
							trace("[ERROR] Exercise stream: Can't play. Not connected to the server");
							return;
						}
						
						_started=true;
						
						if (_timer)
							_timer.stop();
						_timer=new Timer(300);
						_timer.addEventListener(TimerEvent.TIMER, updateProgress);
						_timer.start();
					}
				}


                public function stopVideo():void
                {
                        if (_ns)
                        {
                                _ns.play(false);
                                _video.clear();
                                //_ns.pause();
                                //_ns.seek(0);
                        }

                        _ppBtn.State=PlayButton.PLAY_STATE;
                }

                public function endVideo():void
                {
                
                        stopVideo();
                        if (_ns)
                                _ns.close();
                        if(_timer && _timer.running)
                                _timer.stop();
                }


                public function pauseVideo():void
                {
                
                        if (_ns)
                        {
                                _ns.pause();
                        }
                        _ppBtn.State=PlayButton.PLAY_STATE;
                }

                public function resumeVideo():void
                {
                
                        if (_ns)
                        {
                                _ns.seek(_currentTime);
                                _ns.resume();
                                        //trace(_currentTime, _ns.time);
                        }
                        _ppBtn.State=PlayButton.PAUSE_STATE;
                }


                public function onPlayStatus(e:Object):void
                {
                        //trace(e);
                }

                /**
                 * On video information retrieved
                 */
                public function onMetaData(msg:Object):void
                {
                
                        /*
                           trace("metadata: ");

                           for (var a:* in msg)
                           trace(a + " : " + msg[a]);
                         */

                        _duration=msg.duration;

                        this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.METADATA_RETRIEVED));

                        _video.width=msg.width;
                        _video.height=msg.height;

                        scaleVideo();
                        drawBG();
                }

                public function onBWDone():void
                {

                }

                /**
                 * On video source changed
                 */
                public function onSourceChange(e:VideoPlayerEvent):void
                {
                        trace("Requested to play another video");
                        //trace(e.currentTarget);

                        //if (_ns)
                        //{
                                playVideo();
                                _ppBtn.State=PlayButton.PAUSE_STATE;

                                if (!autoPlay)
                                        pauseVideo();
                        //}
                }

                /**
                 * On play button clicked
                 */
                protected function onPPBtnChanged(e:PlayPauseEvent):void
                {
                        if(!_ns)
                                return;
                        if (_ppBtn.getState() == PlayButton.PAUSE_STATE)
                        {
                                if (_ns.time != 0)
                                {
                                        resumeVideo();
                                }
                                else
                                {
                                        playVideo();
                                }

                        }
                        else
                        {
                                pauseVideo();
                        }
                }

                /**
                 * On stop button clicked
                 */
                protected function onStopBtnClick(e:StopEvent):void
                {
                        stopVideo();
                }

                /**
                 * Updatting video progress
                 */
                private function updateProgress(e:TimerEvent):void
                {
                        if (!_ns)
                                return; //Fail safe in case someone drags the scrubber.

                        _currentTime=_ns.time;
                        _sBar.updateProgress(_currentTime, _duration);

                        // if not streaming show loading progress
                        if (!_streamSource)
                                _sBar.updateLoaded(_ns.bytesLoaded / _ns.bytesTotal);

                        _eTime.updateElapsedTime(_currentTime, _duration);
                }

                /**
                 * Seek & Resume video when scrubber stops dragging
                 * or when progress bar has been clicked
                 */
                protected function onScrubberDropped(e:Event):void
                {
                        if (!_ns)
                                return;

                        _timer.stop();

                        _ns.seek(_sBar.seekPosition(_duration));

                        if (_state == PlayButton.PAUSE_STATE) // before seek was playing, so resume video
                        {
                                _ppBtn.State=PlayButton.PAUSE_STATE;
                                _ns.resume();
                        }

                        _timer.start();
                }

                /**
                 * Pauses video when scrubber starts dragging
                 **/
                private function onScrubberDragging(e:Event):void
                {
                        if (!_ns)
                                return;

                        _state=_ppBtn.getState();

                        if (_ppBtn.getState() == PlayButton.PAUSE_STATE) // do pause
                        {
                                _ppBtn.State=PlayButton.PLAY_STATE;
                                _ns.pause();
                                _timer.stop();
                        }
                }

                /**
                 * On video finished playing
                 */
                protected function onVideoFinishedPlaying(e:VideoPlayerEvent):void
                {
                        trace("onVideoFinishedPlaying");
                        stopVideo();
                }


                /**
                 * On volume change
                 */
                private function onVolumeChange(e:VolumeEvent):void
                {
                        if (!_ns)
                                return;

                        _ns.soundTransform=new SoundTransform(e.volumeAmount);

                        //trace(_ns.soundTransform.volume, e.volumeAmount);
                }

                /**
                 * Scaling video image
                 */
                protected function scaleVideo():void
                {
                        if (!autoScale)
                        {
                                var scaleY:Number=_videoHeight / _video.height;
                                var scaleX:Number=_videoWidth / _video.width;
                                var scaleC:Number=scaleX < scaleY ? scaleX : scaleY;

                                _video.y=Math.floor(_videoHeight / 2 - (_video.height * scaleC) / 2);
                                _video.x=Math.floor(_videoWidth / 2 - (_video.width * scaleC) / 2);
                                _video.y+=_defaultMargin;
                                _video.x+=_defaultMargin;

                                _video.width*=scaleC;
                                _video.height*=scaleC;

                                // 1 black pixel, being smarter
                                _video.y+=1;
                                _video.height-=2;
                                _video.x+=1;
                                _video.width-=2;
                        }
                        else
                        {
                                _video.width=_videoWidth;
                                _video.height=_videoHeight;
                                _video.y=_defaultMargin + 2;
                                _video.height-=4;
                                _video.x=_defaultMargin + 2;
                                _video.width-=4;
                        }
                }

                /**
                 * Resets videoplayer appearance
                 **/
                protected function resetAppearance():void
                {
                        _sBar.updateProgress(0, 10);
                        _video.attachNetStream(null);
                        _video.visible=false;
                        _eTime.updateElapsedTime(0, 0);
                }
        }
}