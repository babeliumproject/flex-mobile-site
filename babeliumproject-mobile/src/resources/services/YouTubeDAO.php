<?php

require_once 'Zend/Loader.php';
require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';
require_once 'utils/VideoProcessor.php';

require_once 'vo/ExerciseVO.php';
require_once 'vo/VideoSliceVO.php';

class YouTubeDAO {
	
	// Enter your Google account credentials
	private $email;
	private $passwd;
	private $devKey;
	
	// Video duration size
	private $maxDuration;
	
	private $filePath;
	private $imagePath;
	private $red5Path;
	private $exerciseFolder;
	private $conn;
	private $mediaHelper;
	
	function YouTubeDAO() {
		Zend_Loader::loadClass ( 'Zend_Gdata_YouTube' );
		Zend_Loader::loadClass ( 'Zend_Gdata_ClientLogin' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_Exception' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_Extension_Control' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_CaptchaRequiredException' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_HttpException' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_AuthException' );
		Zend_Loader::loadClass ( 'Zend_Gdata_YouTube_VideoEntry' );
		Zend_Loader::loadClass ( 'Zend_Gdata_App_Entry' );
		
		try {
			$verifySession = new SessionHandler();
		
			$settings = new Config();
		
			$this->filePath = $settings->filePath;
			$this->imagePath = $settings->imagePath;
			$this->red5Path = $settings->red5Path;
			$this->email = $settings->yt_user;
			$this->passwd = $settings->yt_password;
			$this->devKey = $settings->yt_developerKey;
		
			$this->maxDuration = $settings->maxDuration;
		
			$this->conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
			$this->mediaHelper = new VideoProcessor();
			$this->_getResourceDirectories();
		
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}
	
	private function authenticate() {
		try {
			$client = Zend_Gdata_ClientLogin::getHttpClient ( $this->email, $this->passwd, 'youtube' );
		} catch ( Zend_Gdata_App_CaptchaRequiredException $cre ) {
			//echo 'URL of CAPTCHA image: ' . $cre->getCaptchaUrl() . "\n";
			//echo 'Token ID: ' . $cre->getCaptchaToken() . "\n";
			//echo 'Captcha required: ' . $cre->getCaptchaToken () . "\n";
			throw new Exception ( "Captcha required: " . $cre->getCaptchaToken () . "\n" . "URL of CAPTCHA image: " . $cre->getCaptchaUrl () . "\n" );
		} catch ( Zend_Gdata_App_AuthException $ae ) {
			//return 'Problem authenticating: ' . $ae->exception () . "\n";
			throw new Exception ( "Problem authenticating: " . $ae->getMessage () . "\n" );
		}
		
		$client->setHeaders ( 'X-GData-Key', 'key=' . $this->devKey );
		return $client;
	}
	
	/*public function directClientLoginUpload(ExerciseVO $data) {
		
		set_time_limit(0);
		
		$httpClient = $this->authenticate ();
		
		//For time consuming operations such as uploading it is important to increase
		//the httpClient timeout, from the default 10 second value to your needs.
		$config = array('timeout' => 30);
		$httpClient->setConfig($config);
		
		$yt = new Zend_Gdata_YouTube ( $httpClient );
		$myVideoEntry = new Zend_Gdata_YouTube_VideoEntry ( );
		
		//We get the string representing the full path to our file
		$filePath = $this->filePath . "/" . $data->name;
		
		$filesource = $yt->newMediaFileSource ( $filePath );
		//$filesource->setContentType ( 'video/quicktime' );
		$filesource->setContentType ( 'video/x-flv' );
		
		$filesource->setSlug ( $filePath );
		
		$myVideoEntry->setMediaSource ( $filesource );
		
		$myVideoEntry->setVideoTitle ( $data->title );
		$myVideoEntry->setVideoDescription ( $data->description );
		// Note that category must be a valid YouTube category !
		$myVideoEntry->setVideoCategory ( 'Education' );
		
		// Set keywords, note that this must be a comma separated string
		// and that each keyword cannot contain whitespace
		$myVideoEntry->SetVideoTags ( $data->tags );
		
		// Optionally set some developer tags
		//$myVideoEntry->setVideoDeveloperTags ( array ('mydevelopertag', 'anotherdevelopertag' ) );
		//$myVideoEntry->setVideoPrivate ();
		

		// Upload URI for the currently authenticated user
		$uploadUrl = 'http://uploads.gdata.youtube.com/feeds/users/default/uploads';
		
		// Try to upload the video, catching a Zend_Gdata_App_HttpException
		// if availableor just a regular Zend_Gdata_App_Exception
		

		try {
			$newEntry = $yt->insertEntry ( $myVideoEntry, $uploadUrl, 'Zend_Gdata_YouTube_VideoEntry' );
		} catch ( Zend_Gdata_App_HttpException $httpException ) {
			throw new Exception ( "Upload Exception: " . $httpException->getRawResponseBody () ."\n" );
		} catch ( Zend_Gdata_App_Exception $e ) {
			throw new Exception ( "Application Exception: " . $e->getMessage () ."\n" );
		}
		//$test = array ($newEntry->mediaGroup->player[0]->url, $newEntry->getVideoId(), $filePath);
		

		$result = $newEntry->getVideoId ();
		return $result;
	
	}*/
	
	/*
	public function browserBasedClientLoginUploadToken(YouTubeMetadataVO $data) {
		
		$httpClient = $this->authenticate ();
		$yt = new Zend_Gdata_YouTube ( $httpClient );
		
		$myVideoEntry = new Zend_Gdata_YouTube_VideoEntry ( );
		$myVideoEntry->setVideoTitle ( $data->title );
		$myVideoEntry->setVideoDescription ( $data->description );
		
		// Note that category must be a valid YouTube category
		$myVideoEntry->setVideoCategory ( $data->category );
		$myVideoEntry->SetVideoTags ( $data->tags );
		
		$tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
		$tokenArray = $yt->getFormUploadToken ( $myVideoEntry, $tokenHandlerUrl );
		$tokenValue = $tokenArray ['token'];
		$postUrl = $tokenArray ['url'];
		$result = array ($tokenValue, $postUrl );
		
		return $result;
	}*/
	
	/*public function checkUploadedVideoStatus($videoId) {
		
		$httpClient = $this->authenticate ();
		$youTubeService = new Zend_Gdata_YouTube ( $httpClient );
		
		$feed = $youTubeService->getuserUploads ( 'default' );
		$message = 'No further status information available yet.';
		
		foreach ( $feed as $videoEntry ) {
			if ($videoEntry->getVideoId () == $videoId) {
				// check if video is in draft status
				try {
					$control = $videoEntry->getControl ();
				} catch ( Zend_Gdata_App_Exception $e ) {
					return 'ERROR - not able to retrieve control element ' . $e->getMessage ();
				}
				
				if ($control instanceof Zend_Gdata_App_Extension_Control) {
					if (($control->getDraft () != null) && ($control->getDraft ()->getText () == 'yes')) {
						$state = $videoEntry->getVideoState ();
						if ($state instanceof Zend_Gdata_YouTube_Extension_State) {
							$message = 'Upload status: ' . $state->getName () . ' ' . $state->getText ();
						} else {
							return $message;
						}
					}
				}
			}
		}
		return $message;
	
	}*/
	
	private function _getResourceDirectories(){
		$sql = "SELECT prefValue FROM preferences
				WHERE (prefName='exerciseFolder')";
		$result = $this->conn->_execute($sql);
		
		$row = $this->conn->_nextRow($result);
		$this->exerciseFolder = $row ? $row[0] : '';

	}
	
	public function processPendingSlices(){
		set_time_limit(0);
		$sql = "SELECT id, name, source, language, fk_user_id, title, thumbnail_uri, duration, status
				FROM exercise WHERE (status='Unsliced') ";
		$transcodePendingVideos = $this->_listQuery($sql);
		if(count($transcodePendingVideos) > 0){
			echo "  * There are video slices that need to be processed.\n";
			foreach($transcodePendingVideos as $pendingVideo){
				$this->setExerciseProcessing($pendingVideo->id);
				//Prepare for video to be downloaded and sliced up
				$sql2 = "SELECT id, name, watchUrl, start_time, duration
						 FROM video_slice WHERE (name = '%s')";
				$vSlice = new VideoSliceVO();
				$vSlice = $this->_listSliceQuery($sql2, $pendingVideo->name);
				//Call the download and slice function
				$creation = $this->createSlice($vSlice);		
				if ($creation) {
					//The video was downloaded and sliced up
					$sliceFileName = 'SLC'.$pendingVideo->name.'.flv';
					$path = $this->filePath.'/'.$sliceFileName;
					if(is_file($path) && filesize($path)>0){
						$outputHash = $this->mediaHelper->str_makerand(11,true,true);
						$outputName = $outputHash.".flv";
						
						try{
							//Check if the video already exists
							if(!$this->checkIfFileExists($path)){
								//Asuming everything went ok, take a snapshot of the video
								$outputImagePath = $this->imagePath .'/'. $outputHash . '.jpg';
								$snapshot_output = $this->mediaHelper->takeRandomSnapshot($path, $outputImagePath);
		
								//move the outputFile to it's final destination
								rename($path, $this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName);
								$duration = $vSlice->duration;
								
								//Set the exercise as available and update it's data
								$this->conn->_startTransaction();
								
								$updateResult = $this->setExerciseAvailable($pendingVideo->id, $outputHash, $outputHash.'.jpg', $duration, md5_file($this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName));
								if(!$updateResult){
									$this->conn->_failedTransaction();
									throw new Exception("Database operation error. Changes rollbacked.");
								}
								
								$updateSlice = $this->updateSliceName($outputHash,$vSlice->id);
								if(!$updateSlice){
									$this->conn->_failedTransaction();
									throw new Exception("Database operation error. Changes rollbacked.");
								}
								
								$creditUpdate = $this->_addCreditsForUploading($pendingVideo->userId);
								if(!$creditUpdate){
									$this->conn->_failedTransaction();
									throw new Exception("Database operation error. Changes rollbacked.");
								}
								
								$historyUpdate = $this->_addUploadingToCreditHistory($pendingVideo->userId, $pendingVideo->id);
								if(!$historyUpdate){
									$this->conn->_failedTransaction();
									throw new Exception("Database operation error. Changes rollbacked.");
								}
								
								$this->conn->_endTransaction();
								
								echo "\n";
								echo "          filename: ".$pendingVideo->name."\n";
								echo "          filesize: ".filesize($this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName)."\n";
								echo "          input path: ".$path."\n";
								echo "          output path: ".$this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName."\n";
								echo "          snapshot output: ".$snapshot_output."\n";
							} else {
								//Remove the non-valid files
								//@unlink($outputPath);
								$this->setExerciseRejected($pendingVideo->id);
								echo "\n";
								echo "          filename: ".$pendingVideo->name."\n";
								echo "          filesize: ".filesize($path)."\n";
								echo "          input path: ".$path."\n";
								echo "          error: Duplicated file\n";
							}
							//Remove the old files (original and slice)
							@unlink($path);
							$originalPath = $this->filePath.'/'.$pendingVideo->name.'.flv';
							@unlink($originalPath);
							
						} catch (Exception $e) {
						echo $e->getMessage()."\n";
						}
					}//end if(is_file)
				}else{
					//The video was not downloaded due to duration limit restrictions
					$this->setExerciseRejected($pendingVideo->id);
							echo "\n";
							echo "          filename: ".$pendingVideo->name."\n";
							echo "          filesize: ".filesize($path)."\n";
							echo "          input path: ".$path."\n";
							echo "          error: Duplicated file\n";
				
				}
			}//end for_each
				
		} else {
			echo "  * There aren't video slices that need to be processed.\n";		
		}
	
	}
	
	public function retrieveVideo($data) {

		$url = escapeshellcmd($data);
		$pattern = '/v=([A-Za-z0-9._%-]*)[&\w;=\+_\-]*/';
		preg_match($pattern, $url, $matches);
		$result = $matches[1];
			
		return $result;
	}
	
	public function retrieveUserVideo($data) {

		$url = escapeshellcmd($data);
		$pattern = '/\/([^\/]*)$/'; //Captures each character starting from the last / of the Url 
		preg_match($pattern, $url, $matches);
		$result = $matches[1];
	
		return $result;
	}
	
	public function createSlice (VideoSliceVO $data) {
		
		set_time_limit(0); // Bypass the execution time limit
		
		$name = $data->name;
		$watchUrl = $data->watchUrl;
		$start_time = $data->start_time;
		$duration = $data->duration;
		
		$outputFolder = $this->filePath;
		$outputVideo = $outputFolder."/".$name.'.flv';
		
		$sql = "SELECT prefValue FROM preferences WHERE (prefName = 'sliceDownCommandPath')";
		$pathComando = $this->_singleQuery($sql);	
		
		$maxDurationCheck = $this->checkVideoDuration($name);
		
		if($maxDurationCheck) {
		
			$comandoDescarga = $pathComando." -w -o ".$outputVideo." ".$watchUrl;
			$downloadVideo = exec($comandoDescarga); //Download temporarily Video
			$vidDescarga = $outputVideo;
			$sliceFileName = 'SLC'.$name.'.flv';
			$sliceVideo = $outputFolder."/".$sliceFileName;
	
			$comandoRecorte = "ffmpeg -y -i ".$vidDescarga." -ss ".$start_time." -t ".$duration." -s 320x240 -acodec libmp3lame -ar 22050 -ac 2 -f flv ".$sliceVideo; 	//Execute Slice
	
			$ffmpeg_output = exec($comandoRecorte);
			
		}
		
		if (is_file($sliceVideo)) {
			return true;	
		}else{
			return false;
		}
		
	}
	
	public function insertVideoSlice(VideoSliceVO $data, ExerciseVO $data2) {
	
		set_time_limit(0); // Bypass the execution time limit
		
		$watchUrl = $data->watchUrl;
		
		$sql = "SELECT prefValue FROM preferences WHERE (prefName = 'sliceDownCommandPath')";
		$pathComando = $this->_singleQuery($sql);	
		
		$comandoDescarga = $pathComando." -e --get-thumbnail ".$watchUrl;
		$thumbnail = exec($comandoDescarga); //Get VideoSlice's Thumbnail Uri
				
		$sql = "INSERT INTO video_slice (name, watchUrl, start_time, duration) VALUES ('%s', '%s', %d, %d)";
		$result = $this->_create($sql, $data->name, $data->watchUrl, $data->start_time, $data->duration);
		
		$sql2 = "INSERT INTO exercise (name, description, source, language, fk_user_id, tags, title, thumbnail_uri, duration, status, license, reference, adding_date) VALUES ('%s', '%s', '%s', '%s', %d, '%s', '%s', '%s', %d, '%s', '%s', '%s', NOW())";
		$result = $this->_create($sql2, $data2->name, $data2->description, $data2->source, $data2->language, $data2->userId, $data2->tags, $data2->title, $thumbnail, $data->duration, $data2->status, $data2->license, $data2->reference);
		
		return $result;
	}
	
	private function checkVideoDuration($videoId) {
		//Check that the video to be downloaded for the slicing process does not exceed maximum duration
		set_time_limit(0);
		
		$httpClient = $this->authenticate ();
		$yt = new Zend_Gdata_YouTube ( $httpClient );
		
		$myVideoEntry = $yt->getVideoEntry($videoId);
		$duration = $myVideoEntry->getVideoDuration();
		$limit = $this->maxDuration;
	
		if ($duration<=$limit) {	
			return true;
		}else{
			return false;
		}
	
	}
	
	private function updateSliceName($newName,$id){
	
		$sql = "UPDATE video_slice SET name='%s' WHERE (id=%d) ";
		return $this->_databaseUpdate($sql, $newName, $id);
	
	}
	
	private function _singleQuery() {
	
		$result = $this->conn->_execute ( func_get_args() );
		$row = $this->conn->_nextRow($result);
      	if ($row){
        	return $row[0];
      	}	
	}
	
	private function _create() {

		$this->conn->_execute ( func_get_args() );

		$sql = "SELECT last_insert_id()";
		$result = $this->conn->_execute ( $sql );

		$row = $this->conn->_nextRow ( $result );
		if ($row) {
			return true;
		} else {
			return false;
		}
	}
	
	private function _databaseUpdate() {
		$result = $this->conn->_execute ( func_get_args() );
		
		return $result;
	}
	
	private function setExerciseAvailable($exerciseId, $newName, $newThumbnail, $newDuration, $fileHash){

		$sql = "UPDATE exercise SET name='%s', thumbnail_uri='%s', duration='%s', filehash='%s', status='Available'
            	WHERE (id=%d) ";
		$this->conn->_execute ( $sql, $newName, $newThumbnail, $newDuration, $fileHash, $exerciseId );
		return $this->conn->_affectedRows();
	}

	private function setExerciseProcessing($exerciseId){
		$sql = "UPDATE exercise SET status='Processing' WHERE (id=%d) ";
		$this->conn->_execute($sql, $exerciseId);
		return $this->conn->_affectedRows();
	}

	private function setExerciseRejected($exerciseId){
		$sql = "UPDATE exercise SET status='Rejected' WHERE (id=%d) ";
		$this->conn->_execute($sql, $exerciseId);
		return $this->conn->_affectedRows();
	}

	private function _addCreditsForUploading($userId) {
		$sql = "UPDATE (users u JOIN preferences p)
				SET u.creditCount=u.creditCount+p.prefValue 
				WHERE (u.ID=%d AND p.prefName='uploadExerciseCredits') ";
		$this->conn->_execute ( $sql, $userId );
		return $this->conn->_affectedRows();
	}
	
	private function _addUploadingToCreditHistory($userId, $exerciseId){
		$sql = "SELECT prefValue FROM preferences WHERE ( prefName='uploadExerciseCredits' )";
		$result = $this->conn->_execute ( $sql );
		$row = $this->conn->_nextRow($result);
		if($row){
			$sql = "INSERT INTO credithistory (fk_user_id, fk_exercise_id, changeDate, changeType, changeAmount) ";
			$sql = $sql . "VALUES ('%d', '%d', NOW(), '%s', '%d') ";
			return $this->conn->insert ($sql, $userId, $exerciseId, 'upload', $row[0]);
		} else {
			return false;
		}
	}
	
	//Returns an array of objects
	private function _listQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new ExerciseVO ( );
			$temp->id = $row[0];
			$temp->name = $row[1];
			$temp->source = $row[2];
			$temp->language = $row[3];
			$temp->title = $row[4];
			$temp->thumbnailUri = $row[5];
			$temp->duration = $row[6];
			$temp->status = $row[7];
			$temp->userId = $row[8];

			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}
	
	//Returns an array of objects
	private function _listSliceQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );
		
		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new VideoSliceVO ( );
			$temp->id= $row [0];
			$temp->name = $row [1];
			$temp->watchUrl = $row [2];
			$temp->start_time = $row [3];
			$temp->duration = $row [4];
			
			array_push ( $searchResults, $temp );
		}
		if (count ( $searchResults ) > 0)
			return $temp;
		else
			return false;
	}
	
	private function checkIfFileExists($path){
		$fileExists = false;
		$currentHash = md5_file($path);
		$sql = "SELECT filehash FROM exercise";
		$videoHashes = $this->_listHash($sql);
		foreach($videoHashes as $existingHash){
			if ($existingHash == $currentHash){
				$fileExists = true;
				break;
			}
		}
		return $fileExists;
	}
	
}
?>