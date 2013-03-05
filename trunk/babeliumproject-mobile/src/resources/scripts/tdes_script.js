//AD  <- Needed to identify//

var app = new Avidemux();
var ds = new DirectorySearch();
var orgDir = '/opt/red5_1_0b/webapps/oflaDemo/streams/exercises';
var destDir = '/tmp/tdes';
var reg =new RegExp(".$");

var sep="/";
var reg2 =new RegExp("\/.*\/");
var extension;
var target;

//      select files from original & target directories
      //orgDir=fileReadSelect();
      //destDir=fileWriteSelect();
//      orgDir=pathOnly(orgDir);
 //     destDir=pathOnly(destDir);
//      strip last \\ or //
  //    orgDir=orgDir.replace(reg,"");
   //   destDir=destDir.replace(reg,"");
      print("orgDir : <"+orgDir+">");
      print("destDir : <"+destDir+">");
//
// Go
//
if(ds.Init(orgDir))
{
  while(ds.NextFile())
  {
      // Only process file we want i.e. AVI
      if(!ds.isNotFile && !ds.isDirectory && !ds.isHidden && !ds.isArchive && !ds.isSingleDot && !ds.isDoubleDot)
      {
          extension=ds.GetExtension();
	  target=ds.GetFileName();
          if(extension == "flv" && target.indexOf("tdes") == 0)
          {
              target=destDir+sep+target;
              print("***"+ds.GetFileName()+"-->"+target);
              processFile(orgDir+sep+ds.GetFileName(),target);
              }
          //print("File: "+ds.GetFileName()+" is "+ds.GetFileSize()+" bytes, extension "+extension);
      }
  }
  print("We just searched in directory \"" + ds.GetFileDirectory() + "\"");
  ds.Close();
}
else
  displayError("Error initializing the directory search");
displayInfo("Finished !");



function processFile(filename, targetfile){
	//** Video **
	// 01 videos source 
	app.load(filename);

	//** Postproc **
	app.video.setPostProc(3,3,0);

	app.video.fps1000 = 29972;

	//** Filters **
	//This crop is thought for videos with a resolution of 360p
	//app.video.addFilter("crop","left=66","right=56","top=0","bottom=100");
	app.video.addFilter("crop","left=32","right=32","top=0","bottom=64");

	//** Video Codec conf **
	app.video.codecPlugin("92B544BE-59A3-4720-86F0-6AD5A2526FD2", "Xvid", "CQ=4", "<?xml version='1.0'?><XvidConfig><presetConfiguration><name>&lt;default&gt;</name><type>default</type></presetConfiguration><XvidOptions><threads>0</threads><vui><sarAsInput>false</sarAsInput><sarHeight>1</sarHeight><sarWidth>1</sarWidth></vui><motionEstimation>high</motionEstimation><rdo>dct</rdo><bFrameRdo>false</bFrameRdo><chromaMotionEstimation>true</chromaMotionEstimation><qPel>false</qPel><gmc>false</gmc><turboMode>false</turboMode><chromaOptimiser>false</chromaOptimiser><fourMv>false</fourMv><cartoon>false</cartoon><greyscale>false</greyscale><interlaced>none</interlaced><frameDropRatio>0</frameDropRatio><maxIframeInterval>300</maxIframeInterval><maxBframes>2</maxBframes><bFrameSensitivity>0</bFrameSensitivity><closedGop>false</closedGop><packed>false</packed><quantImin>1</quantImin><quantPmin>1</quantPmin><quantBmin>1</quantBmin><quantImax>31</quantImax><quantPmax>31</quantPmax><quantBmax>31</quantBmax><quantBratio>150</quantBratio><quantBoffset>100</quantBoffset><quantType>h.263</quantType><intraMatrix><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value><value>8</value></intraMatrix><interMatrix><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value><value>1</value></interMatrix><trellis>true</trellis><singlePass><reactionDelayFactor>16</reactionDelayFactor><averagingQuantiserPeriod>100</averagingQuantiserPeriod><smoother>100</smoother></singlePass><twoPass><keyFrameBoost>10</keyFrameBoost><maxKeyFrameReduceBitrate>20</maxKeyFrameReduceBitrate><keyFrameBitrateThreshold>1</keyFrameBitrateThreshold><overflowControlStrength>5</overflowControlStrength><maxOverflowImprovement>5</maxOverflowImprovement><maxOverflowDegradation>5</maxOverflowDegradation><aboveAverageCurveCompression>0</aboveAverageCurveCompression><belowAverageCurveCompression>0</belowAverageCurveCompression><vbvBufferSize>0</vbvBufferSize><maxVbvBitrate>0</maxVbvBitrate><vbvPeakBitrate>0</vbvPeakBitrate></twoPass></XvidOptions></XvidConfig>");

	//** Audio **
	app.audio.reset();
	app.audio.codec("Lame",128,20,"80 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 ");
	app.audio.normalizeMode=0;
	app.audio.normalizeValue=0;
	app.audio.delay=0;
	app.audio.mixer="NONE";
	app.setContainer("AVI");
	app.save(targetfile);
	return 1;
	//setSuccess(1);
	//app.Exit();
}

//End of script
