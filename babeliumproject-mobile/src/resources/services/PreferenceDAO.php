<?php


require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/PreferenceVO.php';


class PreferenceDAO {

	private $conn;

	public function PreferenceDAO(){
		try {
			$verifySession = new SessionHandler();
			$settings = new Config();
			$this->conn = new Datasource($settings->host, $settings->db_name, $settings->db_username, $settings->db_password);
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	public function getAppPreferences(){
		$sql = "SELECT * FROM preferences";

		$searchResults = $this->_listQuery($sql);

		return $searchResults;
	}

	private function _listQuery($sql){
		$searchResults = array();
		$preferenceData = array();
		$result = $this->conn->_execute($sql);

		while ($row = $this->conn->_nextRow($result))
		{
			$temp = new PreferenceVO();
			$temp->prefName = $row[1];
			$temp->prefValue = $row[2];
			$preferenceData[$row[1]] = $row[2];
			array_push($searchResults, $temp);
		}
		$_SESSION['preferenceData'] = $preferenceData;
		return $searchResults;
	}
}

?>