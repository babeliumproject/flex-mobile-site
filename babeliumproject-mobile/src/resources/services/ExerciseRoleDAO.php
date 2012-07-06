<?php

require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/ExerciseRoleVO.php';


class ExerciseRoleDAO
{

	private $conn;

	public function ExerciseRoleDAO()
	{
		try {
			$verifySession = new SessionHandler();
			$settings = new Config();
			$this->conn = new DataSource($settings->host, $settings->db_name, $settings->db_username, $settings->db_password);
		} catch (Exception $e) {
			throw new Exception ($e->getMessage());
		}
	}


	public function getExerciseRoles($exerciseId)
	{

		$sql = "SELECT MAX(id) as id, fk_exercise_id, character_name
				FROM exercise_role
				WHERE fk_exercise_id = '%d'
				GROUP BY character_name";

		$searchResults = $this->_listRolesQuery ( $sql, $exerciseId );

		return $searchResults;
	}

	private function _listRolesQuery(){
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new ExerciseRoleVO ( );
			$temp->id = $row[0];
			$temp->exerciseId = $row[1];
			$temp->characterName = $row[2];
			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}

}

?>