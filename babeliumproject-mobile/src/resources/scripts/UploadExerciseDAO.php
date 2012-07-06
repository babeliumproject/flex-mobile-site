<?php

if(!defined('SERVICE_PATH'))
define('SERVICE_PATH', '/var/www/babelium/services');

require_once SERVICE_PATH . '/utils/Datasource.php';
require_once SERVICE_PATH . '/utils/Config.php';
require_once SERVICE_PATH . '/utils/VideoProcessor.php';

class UploadExerciseDAO{

	private $filePath;
	private $imagePath;
	private $red5Path;

	private $evaluationFolder;
	private $exerciseFolder;
	private $responseFolder;

	private $conn;
	private $mediaHelper;

	public function UploadExerciseDAO(){
		$settings = new Config();
		$this->filePath = $settings->filePath;
		$this->imagePath = $settings->imagePath;
		$this->red5Path = $settings->red5Path;

		$this->conn = new Datasource($settings->host, $settings->db_name, $settings->db_username, $settings->db_password);
		$this->mediaHelper = new VideoProcessor();

		$this->_getResourceDirectories();
	}

	private function _getResourceDirectories(){
		$sql = "SELECT prefValue FROM preferences
				WHERE (prefName='exerciseFolder' OR prefName='responseFolder' OR prefName='evaluationFolder') 
				ORDER BY prefName";
		$result = $this->conn->_execute($sql);

		$row = $this->conn->_nextRow($result);
		$this->evaluationFolder = $row ? $row[0] : '';
		$row = $this->conn->_nextRow($result);
		$this->exerciseFolder = $row ? $row[0] : '';
		$row = $this->conn->_nextRow($result);
		$this->responseFolder = $row ? $row[0] : '';
	}

	public function processPendingVideos(){
		set_time_limit(0);
		$sql = "SELECT id, name, source, language, title, thumbnail_uri, duration, status, fk_user_id
				FROM exercise WHERE (status='Unprocessed') ";
		$transcodePendingVideos = $this->_listQuery($sql);
		if(count($transcodePendingVideos) > 0){
			echo "  * There are videos that need to be processed.\n";
			foreach($transcodePendingVideos as $pendingVideo){
				//We want the whole process to be rollbacked when something unexpected happens
				$this->conn->_startTransaction();
				$processingFlag = $this->setExerciseProcessing($pendingVideo->id);
				$path = $this->filePath.'/'.$pendingVideo->name;
				if(is_file($path) && filesize($path)>0 && $processingFlag){
					$outputHash = $this->mediaHelper->str_makerand(11,true,true);
					$outputName = $outputHash . ".flv";
					$outputPath = $this->filePath .'/'. $outputName;

					try {
						$encoding_output = $this->mediaHelper->transcodeToFlv($path,$outputPath);
							
						//Check if the video already exists
						if(!$this->checkIfFileExists($outputPath)){
							//Asuming everything went ok, take a snapshot of the video
							$outputImagePath = $this->imagePath .'/'. $outputHash . '.jpg';
							$snapshot_output = $this->mediaHelper->takeRandomSnapshot($outputPath, $outputImagePath);

							//move the outputFile to it's final destination
							$renameResult = rename($outputPath, $this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName);
							if(!$renameResult){
								throw new Exception("Couldn't move transcoded file. Changes rollbacked.");
							}
								
							$mediaData = $this->mediaHelper->retrieveMediaInfo($this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName);
							$duration = $mediaData->duration;

							//Set the exercise as available and update it's data
							//$this->conn->_startTransaction();
								
							$updateResult = $this->setExerciseAvailable($pendingVideo->id, $outputHash, $outputHash.'.jpg', $duration, md5_file($this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName));
							if(!$updateResult){
								//$this->conn->_failedTransaction();
								throw new Exception("Database operation error. Changes rollbacked.");
							}
								
							$creditUpdate = $this->_addCreditsForUploading($pendingVideo->userId);
							if(!$creditUpdate){
								//$this->conn->_failedTransaction();
								throw new Exception("Database operation error. Changes rollbacked.");
							}
								
							$historyUpdate = $this->_addUploadingToCreditHistory($pendingVideo->userId, $pendingVideo->id);
							if(!$historyUpdate){
								//$this->conn->_failedTransaction();
								throw new Exception("Database operation error. Changes rollbacked.");
							}
								
							$this->conn->_endTransaction();
								
							echo "\n";
							echo "          filename: ".$pendingVideo->name."\n";
							echo "          filesize: ".filesize($path)."\n";
							echo "          input path: ".$path."\n";
							echo "          output path: ".$this->red5Path .'/'. $this->exerciseFolder .'/'. $outputName."\n";
							echo "          encoding output: ".$encoding_output."\n";
							echo "          snapshot output: ".$snapshot_output."\n";
								
							//Remove the old file
							@unlink($path);
						} else {
								
							$this->setExerciseRejected($pendingVideo->id);
							echo "\n";
							echo "          filename: ".$pendingVideo->name."\n";
							echo "          filesize: ".filesize($path)."\n";
							echo "          input path: ".$path."\n";
							echo "          error: Duplicated file\n";
							//Remove the old files
							@unlink($outputPath);
							@unlink($path);
						}

							
					} catch (Exception $e) {
						$this->conn->_failedTransaction();
						echo "          error: ". $e->getMessage()."\n";
					}
				} else {
					$this->conn->_failedTransaction();
					echo "\n";
					echo "          filename: ".$pendingVideo->name."\n";
					echo "          input path: ".$path."\n";
					echo "          error: File not valid or not found\n";
				}
			}
		} else {
			echo "  * There aren't videos that need to be processed.\n";
		}
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
			return $this->conn->_insert ($sql, $userId, $exerciseId, 'upload', $row[0]);
		} else {
			return false;
		}
	}


	private function _listQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new stdClass();
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

	private function _listHash(){
		$searchResults = array();
		$result = $this->conn->_execute(func_get_args());

		while ($row = $this->conn->_nextRow ($result)){
			array_push($searchResults, $row[0]);
		}
		return $searchResults;
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
