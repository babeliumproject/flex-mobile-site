<?php

define('SERVICE_PATH', '/var/www/babelium/services');

require_once SERVICE_PATH . '/utils/Datasource.php';
require_once SERVICE_PATH . '/utils/Config.php';


/**
 *
 * This class should be only launched by CRON tasks, therefore it should be placed outside the scope of public access
 *
 * @author inko
 *
 */
class PeriodicTaskDAO{

	private $conn;
	private $filePath;
	private $red5Path;

	private $exerciseFolder = '';
	private $responseFolder = '';
	private $evaluationFolder = '';

	public function PeriodicTaskDAO(){
		$settings = new Config ( );
		$this->filePath = $settings->filePath;
		$this->red5Path = $settings->red5Path;
		$this->conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
		$this->_getResourceDirectories();
	}

	public function deleteAllUnreferenced(){
		//$this->_getResourceDirectories();
		$this->_deleteUnreferencedExercises();
		if($this->exerciseFolder != $this->responseFolder)
		$this->_deleteUnreferencedResponses();
		if($this->exerciseFolder != $this->evaluationFolder)
		$this->_deleteUnreferencedEvaluations();
	}

	public function deleteInactiveUsers($days){
		if($days<7)
		return;
		else{
			$sql = "DELETE FROM users
					WHERE (DATE_SUB(CURDATE(),INTERVAL '%d' DAY) > joiningDate AND active = 0 AND activation_hash <> '')";
			$result = $this->conn->_execute($sql,$days);
		}
	}

	public function deactivateReportedVideos(){

		$sql = "SELECT prefValue FROM preferences WHERE (prefName='reports_to_delete')";
		$result = $this->conn->_execute($sql);
		$row = $this->conn->_nextRow ($result);
		if ($row){

			$reportsToDeletion = $row[0];

			$sql = "UPDATE exercise AS E SET status='Unavailable'
		       	    WHERE '%d' <= (SELECT count(*) 
		        		          FROM exercise_report WHERE fk_exercise_id=E.id ) ";
			return $this->conn->_execute($sql, $reportsToDeletion);
		}
	}

	public function monitorizeSessionKeepAlive(){
		$sql = "UPDATE user_session SET duration = TIMESTAMPDIFF(SECOND,session_date,CURRENT_TIMESTAMP), closed=1
				WHERE (keep_alive = 0 AND closed=0 AND duration=0)";

		$result = $this->conn->_execute($sql);

		$sql = "UPDATE user_session SET keep_alive = 0
				WHERE (keep_alive = 1 AND closed = 0)";

		$result = $this->conn->_execute($sql);
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

	private function _deleteUnreferencedExercises(){
		$sql = "SELECT name FROM exercise";
			
		$exercises = $this->_listFiles($sql);

		if($this->exerciseFolder)
		$exercisesPath = $this->red5Path .'/'.$this->exerciseFolder;
		else
		$exercisesPath = $this->red5Path;
		$this->_deleteFiles($exercisesPath, $exercises);

	}

	private function _deleteUnreferencedResponses(){
		$sql = "SELECT file_identifier FROM response";

		$responses = $this->_listFiles($sql);

		if($this->responseFolder)
		$responsesPath = $this->red5Path .'/'.$this->responseFolder;
		else
		$responsesPath = $this->red5Path;
		$this->_deleteFiles($responsesPath, $responses);

	}

	private function _deleteUnreferencedEvaluations(){
		$sql = "SELECT video_identifier FROM evaluation_video";

		$evaluations = $this->_listFiles($sql);

		if($this->evaluationFolder)
		$evaluationsPath = $this->red5Path .'/'.$this->evaluationFolder;
		else
		$evaluationsPath = $this->red5Path;
		$this->_deleteFiles($evaluationsPath, $evaluations);
	}

	private function _listFiles($sql){
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );
		while($row = $this->conn->_nextRow($result)){
			$file = $row[0] .'.flv';
			array_push($searchResults, $file);
		}
		return $searchResults;
	}

	private function _deleteFiles($pathToInspect, $referencedResources){
		if($referencedResources){
			$folder = dir($pathToInspect);

			while (false !== ($entry = $folder->read())) {
				$entryFullPath = $pathToInspect.'/'.$entry;
				if(!is_dir($entryFullPath)){
					$entryInfo = pathinfo($entryFullPath);
					if($entryInfo['extension'] == 'flv' && !in_array($entry, $referencedResources)){
						//array_push($resourcesToDelete, $exercisesPath.'/'.$entry);
						@unlink($entryFullPath);
						@unlink($entryFullPath.'.meta');
					}
				}
			}
			$folder->close();
		}
	}
}