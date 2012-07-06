<?php

require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/CreditHistoryVO.php';

/**
 * This service should be available only to valid and authenticated users.
 * Credit related queries are stored in this service.
 */

class CreditDAO {
	
	private $conn;
	
	public function CreditDAO() {

		try {
			$verifySession = new SessionHandler(true);
			$settings = new Config ( );
			$this->conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}

	}
	
	public function getCurrentDayCreditHistory() {
		$sql = "SELECT c.changeDate, c.changeType, c.changeAmount, c.fk_exercise_id, e.name, c.fk_response_id, r.file_identifier 
				FROM (((credithistory c INNER JOIN users u ON c.fk_user_id=u.id) INNER JOIN exercise e ON e.id=c.fk_exercise_id) LEFT OUTER JOIN response r on r.id=c.fk_response_id) 
				WHERE (c.fk_user_id = %d AND CURDATE() <= c.changeDate ) ORDER BY changeDate DESC ";
		
		return $this->_listQuery ( $sql, $_SESSION['uid'] );
	}
	
	public function getLastWeekCreditHistory() {
		$sql = "SELECT c.changeDate, c.changeType, c.changeAmount, c.fk_exercise_id, e.name, c.fk_response_id, r.file_identifier 
				FROM (((credithistory c INNER JOIN users u ON c.fk_user_id=u.id) INNER JOIN exercise e ON e.id=c.fk_exercise_id) LEFT OUTER JOIN response r on r.id=c.fk_response_id) 
				WHERE (c.fk_user_id = %d AND DATE_SUB(CURDATE(),INTERVAL 7 DAY) <= c.changeDate ) ORDER BY changeDate DESC ";
		
		return $this->_listQuery ( $sql, $_SESSION['uid'] );
	}
	
	public function getLastMonthCreditHistory() {
		$sql = "SELECT c.changeDate, c.changeType, c.changeAmount, c.fk_exercise_id, e.name, c.fk_response_id, r.file_identifier 
				FROM (((credithistory c INNER JOIN users u ON c.fk_user_id=u.id) INNER JOIN exercise e ON e.id=c.fk_exercise_id) LEFT OUTER JOIN response r on r.id=c.fk_response_id) 
				WHERE (c.fk_user_id = %d AND DATE_SUB(CURDATE(),INTERVAL 30 DAY) <= c.changeDate ) ORDER BY changeDate DESC ";
		
		return $this->_listQuery ( $sql, $_SESSION['uid'] );
	}
	
	public function getAllTimeCreditHistory() {
		$sql = "SELECT c.changeDate, c.changeType, c.changeAmount, c.fk_exercise_id, e.name, c.fk_response_id, r.file_identifier 
				FROM (((credithistory c INNER JOIN users u ON c.fk_user_id=u.id) INNER JOIN exercise e ON e.id=c.fk_exercise_id) LEFT OUTER JOIN response r on r.id=c.fk_response_id) 
				WHERE (c.fk_user_id = %d ) ORDER BY changeDate DESC ";
		
		return $this->_listQuery ( $sql, $_SESSION['uid'] );
	}
	
	//Returns an array of objects
	private function _listQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );
		
		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new CreditHistoryVO ( );
			$temp->changeDate = $row [0];
			$temp->changeType = $row [1];
			$temp->changeAmount = $row [2];
			$temp->videoExerciseId = $row [5];
			$temp->videoExerciseName = $row [6];
			$temp->videoResponseId = $row [7];
			$temp->videoResponseName = $row [8];
			//$temp->videoEvaluationId = $row[9];
			//$temp->videoEvaluationName = $row[10];
			

			array_push ( $searchResults, $temp );
		}
		if (count ( $searchResults ) > 0)
			return $searchResults;
		else
			return false;
	}
	
}

?>