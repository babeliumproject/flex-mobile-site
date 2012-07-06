<?php

require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/TranscriptionsVO.php';

class TranscriptionsDAO {

	private $conn;

	public function TranscriptionsDAO() {
		try {
			$verifySession = new SessionHandler(true);

			$settings = new Config();
			$this->conn = new Datasource($settings->host, $settings->db_name, $settings->db_username, $settings->db_password);
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	public function getResponseTranscriptions($responseId) {
		$valueObject = new TranscriptionsVO();

		$sql = "SELECT T.id AS transID, R.id AS responseID, R.fk_exercise_id AS exerciseID, T.adding_date AS transAddDate, T.status AS status, T.transcription AS transcription, T.transcription_date AS transDate, T.system AS system 
				FROM transcription AS T INNER JOIN response AS R ON T.id=R.fk_transcription_id 
				WHERE ( R.id = %d ) ";
		$result = $this->conn->_execute($sql, $responseId);

		$row = $this->conn->_nextRow($result);
		if ($row) {
			$valueObject->responseTranscriptionID = $row[0];
			$valueObject->responseID = $row[1];
			$valueObject->exerciseID = $row[2];
			$valueObject->responseTranscriptionAddingDate = $row[3];
			$valueObject->responseTranscriptionStatus = $row[4];
			$valueObject->responseTranscription = $row[5];
			$valueObject->responseTranscriptionDate = $row[6];
			$valueObject->responseTranscriptionSystem = $row[7];
		} else
		return null;

		$sql = "SELECT T.id AS transID, E.id AS exerciseID, T.adding_date AS transAddDate, T.status AS status, T.transcription AS transcription, T.transcription_date AS transDate, T.system AS system 
				FROM transcription AS T INNER JOIN exercise AS E ON T.id=E.fk_transcription_id 
				WHERE (E.id = %d)";
		$result = $this->conn->_execute($sql, $valueObject->exerciseID);

		$row = $this->conn->_nextRow($result);
		if ($row) {
			$valueObject->exerciseTranscriptionID = $row[0];
			$valueObject->exerciseID = $row[1];
			$valueObject->exerciseTranscriptionAddingDate = $row[2];
			$valueObject->exerciseTranscriptionStatus = $row[3];
			$valueObject->exerciseTranscription = $row[4];
			$valueObject->exerciseTranscriptionDate = $row[5];
			$valueObject->exerciseTranscriptionSystem = $row[6];
		} else
		return null;

		return $valueObject;
	}

	public function enableTranscriptionToExercise($exerciseId, $transcriptionSystem) {
		if ($exerciseId > 0 && $transcriptionSystem != null && $_SERVER['uid'] > 0) {

			if(!$this->checkAutoevaluationSupportExercise($exerciseId, $transcriptionSystem))
			return "transcription not supported for this video";
				
			//Check if user is admin
			$sql = "SELECT isAdmin FROM users WHERE id = %d";
			$result = $this->conn->_execute($sql, $_SESSION['uid']);
			$row = $this->conn->_nextRow($result);
			if ($row[0] <= 0)
			return "only admin users can enable transcriptions to exercises";
				
			$sql = "SELECT * FROM transcription AS T INNER JOIN exercise AS E ON T.id=E.fk_transcription_id WHERE E.id = %d";
			$result = $this->conn->_execute($sql, $exerciseId);
			$row = $this->conn->_nextRow($result);
			if ($row == null) {
				$insert = "INSERT INTO transcription (id, adding_date, status, transcription, transcription_date, system) VALUES (null, now(), 'pending' , null, null, '%s')";
				$i = $this->conn->_insert($insert, strtolower($transcriptionSystem));
				if ($i > 0) {
					$update = "UPDATE exercise SET fk_transcription_id = LAST_INSERT_ID() WHERE id = %d";
					if ($this->conn->_execute($update, $exerciseId) > 0)
					return $i;
					else
					return "error";
				} else
				return -1;
			} else
			return "transcription already exists";
		} else
		return "wrong data";
	}

	public function enableTranscriptionToResponse($responseId, $transcriptionSystem) {
		if ($responseId > 0 && $transcriptionSystem != null) {

			if(!$this->checkAutoevaluationSupportResponse($responseId, $transcriptionSystem))
			return "transcription not supported for this video";

			$sql = "SELECT * FROM transcription AS T INNER JOIN response AS R ON T.id=R.fk_transcription_id WHERE R.id = %d";
			$result = $this->conn->_execute($sql, $responseId);
			$row = $this->conn->_nextRow($result);
			if ($row == null) {
				$insert = "INSERT INTO transcription (id, adding_date, status, transcription, transcription_date, system) VALUES (null, now(), 'pending' , null, null, '%s')";
				$i = $this->conn->_insert($insert, strtolower($transcriptionSystem));
				if ($i > 0) {
					$update = "UPDATE response SET fk_transcription_id = LAST_INSERT_ID() WHERE id = %d";
					if ($this->conn->_execute($update, $responseId) > 0)
					return $i;
					else
					return "error";
				} else
				return -1;
			} else
			return "transcription already exists";
		} else
		return "wrong data";
	}

	// transcriptionSystem = spinvox (maybe we will change this system in the future)
	public function checkAutoevaluationSupportResponse($responseId, $transcriptionSystem) {
		if ($responseId > 0 && $transcriptionSystem != null) {
			$sql = "SELECT prefValue FROM preferences WHERE prefName='%s.max_duration'";
			$result = $this->conn->_execute($sql, strtolower($transcriptionSystem));
			$row = $this->conn->_nextRow($result);
			if ($row)
			$maxDuration = $row[0];
			else
			$maxDuration = 0;

			// if
			// original video has a transcription
			// and video's response hasn't
			// and transcriptionSystem supports actual language (original video's language. The video's language code may be something like en_EN so the first part (en) must be extracted)
			// and response's duration <= transcription System's allowed duration
			//  return true
			// else return false;
			$sql = "SELECT R.id
			           FROM 
			                  response AS R 
			                     INNER JOIN exercise AS E ON R.fk_exercise_id=E.id  
			                     INNER JOIN preferences AS P ON SUBSTRING_INDEX(E.language, '_', 1)=P.prefValue 
			        WHERE 
			           R.id=%d 
			             AND 
			           P.prefName = '%s.language' 
			             AND 
			           E.fk_transcription_id IS NOT NULL 
			             AND 
			             R.fk_transcription_id IS NULL";
				
			if ($maxDuration > 0)
			$sql = $sql . " AND R.duration<=%s";
				
			$result = $this->conn->_execute($sql, $responseId, strtolower($transcriptionSystem), $maxDuration);
			$row = $this->conn->_nextRow($result);
			if ($row)
			return true;
			else
			return false;
		} else
		return false;
	}

	public function checkAutoevaluationSupportExercise($exerciseId, $transcriptionSystem) {
		if ($exerciseId > 0 && $transcriptionSystem != null) {
			$sql = "SELECT prefValue FROM preferences WHERE prefName='%s.max_duration'";
			$result = $this->conn->_execute($sql, strtolower($transcriptionSystem));
			$row = $this->conn->_nextRow($result);
			if ($row)
			$maxDuration = $row[0];
			else
			$maxDuration = 0;

			// if
			// original video doesn't have a transcription
			// and transcriptionSystem supports video's language (The video's language code may be something like en_EN so the first part (en) must be extracted)
			// and video's duration <= transcription System's allowed duration
			//  return true
			// else return false;
			$sql = "SELECT E.id
					FROM exercise AS E 
						INNER JOIN preferences AS P ON SUBSTRING_INDEX(E.language, '_', 1)=P.prefValue 
					WHERE 
						E.id=%d AND P.prefName = '%s.language' 
						AND 
						E.fk_transcription_id IS NULL";
				
			if ($maxDuration > 0)
			$sql = $sql . " AND E.duration<=%d";
				
			$result = $this->conn->_execute($sql, $exerciseId, strtolower($transcriptionSystem), $maxDuration);
			$row = $this->conn->_nextRow($result);
			if ($row)
			return true;
			else
			return false;
		} else
		return false;
	}

}
?>