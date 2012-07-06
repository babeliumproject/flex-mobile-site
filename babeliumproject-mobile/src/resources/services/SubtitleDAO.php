<?php


require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';
require_once 'utils/CosineMeasure.php';

require_once 'vo/ExerciseVO.php';
require_once 'vo/ExerciseRoleVO.php';
require_once 'vo/SubtitleLineVO.php';
require_once 'vo/SubtitleAndSubtitleLinesVO.php';
require_once 'vo/UserVO.php';

class SubtitleDAO {

	private $conn;

	public function SubtitleDAO() {
		try {
			$verifySession = new SessionHandler();
			$settings = new Config ( );
			$this->conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	public function getExerciseRoles($exerciseId) {

		$sql = "SELECT MAX(id),fk_exercise_id,character_name
				FROM exercise_role WHERE (fk_exercise_id = %d) 
				GROUP BY exercise_role.character_name ";

		$searchResults = $this->_listRolesQuery ( $sql, $exerciseId );

		return $searchResults;
	}


	public function getSubtitlesSubtitleLines($subtitleId) {
		$sql = "SELECT SL.id, SL.show_time, SL.hide_time, SL.text, SL.fk_exercise_role_id, ER.character_name, S.id
				FROM subtitle_line AS SL INNER JOIN subtitle AS S ON SL.fk_subtitle_id = S.id 
				INNER JOIN exercise AS E ON E.id = S.fk_exercise_id 
				RIGHT OUTER JOIN exercise_role AS ER ON ER.id=SL.fk_exercise_role_id
				WHERE (SL.fk_subtitle_id = %d)";

		$searchResults = $this->_listSubtitleLinesQuery ($sql, $subtitleId);

		return $searchResults;
	}

	/**
	 * Returns an array of subtitle lines for the given exercise.
	 *
	 * When subtitleId is not set the returned lines are the latest available ones.
	 * When subtitleId is set the returned lines are the ones of that particular subtitle.
	 * @param SubtitleAndSubtitleLineVO $subtitle
	 */
	public function getSubtitleLines($subtitle) {

		$subtitleId = $subtitle->id;
		$exerciseId = $subtitle->exerciseId;
		$language = $subtitle->language;

		if(!$subtitleId){

			$sql = "SELECT  SL.id,SL.show_time,SL.hide_time, SL.text, SL.fk_exercise_role_id, ER.character_name, S.id
            		FROM (subtitle_line AS SL INNER JOIN subtitle AS S ON 
						 SL.fk_subtitle_id = S.id) INNER JOIN exercise AS E ON E.id = 
						 S.fk_exercise_id RIGHT OUTER JOIN exercise_role AS ER ON ER.id=SL.fk_exercise_role_id
					WHERE  S.id = (SELECT MAX(SS.id)
						       	   FROM subtitle SS 
						       	   WHERE SS.fk_exercise_id ='%d' AND SS.language = '%s') ";


			$searchResults = $this->_listSubtitleLinesQuery ( $sql, $exerciseId, $language );
		} else {
			$sql = "SELECT  SL.id,SL.show_time,SL.hide_time, SL.text, SL.fk_exercise_role_id, ER.character_name, S.id
            		FROM (subtitle_line AS SL INNER JOIN subtitle AS S ON 
						 SL.fk_subtitle_id = S.id) INNER JOIN exercise AS E ON E.id = 
						 S.fk_exercise_id RIGHT OUTER JOIN exercise_role AS ER ON ER.id=SL.fk_exercise_role_id
					WHERE  S.id='%d'";	
			$searchResults = $this->_listSubtitleLinesQuery ( $sql, $subtitleId );
		}

		//Store the last retrieved subtitle lines to check if there are changes when saving the subtitles.
		$_SESSION['unmodified-subtitles'] = $searchResults;

		return $searchResults;
	}

	public function getSubtitleLinesUsingId($subtitleId) {
		$sql = "SELECT SL.id,SL.show_time,SL.hide_time, SL.text, SL.fk_exercise_role_id, ER.character_name, S.id
            	FROM (subtitle_line AS SL INNER JOIN subtitle AS S ON SL.fk_subtitle_id = S.id) 
            		 RIGHT OUTER JOIN exercise_role AS ER ON ER.id=SL.fk_exercise_role_id 
				WHERE ( S.id = %d )";

		$searchResults = $this->_listSubtitleLinesQuery ( $sql, $subtitleId );

		return $searchResults;
	}


	public function saveSubtitles($subtitleData){
		try {
			$verifySession = new SessionHandler(true);
			return $this->saveSubtitlesAuth($subtitleData);
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}


	//We retrieve an instance of SubtitleAndSubtitleLinesVO
	private function saveSubtitlesAuth($subtitles) {

		$result = 0;
		$subtitleLines = $subtitles->subtitleLines;
		$exerciseId = $subtitles->exerciseId;
		
		if(!$this->_subtitlesWereModified($subtitleLines))
 			return "Provided subtitles have no modifications";
 
 		if(($errors = $this->_checkSubtitleErrors($subtitleLines)) != "")
 			return $errors;
			

		$this->conn->_startTransaction();

		//Insert the new subtitle on the database
		$s_sql = "INSERT INTO subtitle (fk_exercise_id, fk_user_id, language, adding_date) ";
		$s_sql .= "VALUES ('%d', '%d', '%s', NOW() ) ";
		$subtitleId = $this->conn->_insert($s_sql, $subtitles->exerciseId, $_SESSION['uid'], $subtitles->language );
		if(!$subtitleId){
			$this->conn->_failedTransaction();
			throw new Exception("Subtitle save failed");
		}

		//Insert the new exercise_roles
		$er_sql = "INSERT INTO exercise_role (fk_exercise_id, fk_user_id, character_name) VALUES ";
		$params = array();
			
		foreach($subtitleLines as $line){
			if(count($distinctRoles)==0){
				$distinctRoles[] = $line->exerciseRoleName;
				$er_sql .= " ('%d', '%d', '%s' ),";
				array_push($params, $subtitles->exerciseId, $_SESSION['uid'], $line->exerciseRoleName );
			}
			else if(!in_array($line->exerciseRoleName,$distinctRoles)){
				$distinctRoles[] = $line->exerciseRoleName;
				$er_sql .= " ('%d', '%d', '%s' ),";
				array_push($params, $subtitles->exerciseId, $_SESSION['uid'], $line->exerciseRoleName);
			}
		}
		unset($line);
		$er_sql = substr($er_sql,0,-1);
		// put sql query and all params in one array
		$merge = array_merge((array)$er_sql, $params);
		$lastRoleId = $this->_vcreate($merge);
		if(!lastRoleId){
			$this->conn->_failedTransaction();
			throw new Exception("Subtitle save failed");
		}


		//Insert the new subtitle_lines
		$params = array();
		$userRoles = $this->_getUserRoles($subtitles->exerciseId, $_SESSION['uid']);
		$sl_sql = "INSERT INTO subtitle_line (fk_subtitle_id, show_time, hide_time, text, fk_exercise_role_id) VALUES ";
		foreach($subtitleLines as $line){
			foreach($userRoles as $role){
				if ($role->characterName == $line->exerciseRoleName){
					$line->exerciseRoleId = $role->id;
					$sl_sql .= " ('%d', '%s', '%s', '%s', '%d' ),";
					array_push($params, $subtitleId, $line->showTime, $line->hideTime, $line->text, $line->exerciseRoleId);
					break;
				}
			}
			unset($role);
		}
		unset($line);
		$sl_sql = substr($sl_sql,0,-1);
		// put sql query and all params in one array
		$merge = array_merge((array)$sl_sql, $params);
		$lastSubtitleLineId = $this->_vcreate($merge);
		if(!$lastSubtitleLineId){
			$this->conn->_failedTransaction();
			throw new Exception("Subtitle save failed");
		}

		//Update the user's credit count
		$creditUpdate = $this->_addCreditsForSubtitling();
		if(!$creditUpdate){
			$this->conn->_failedTransaction();
			throw new Exception("Credit addition failed");
		}

		//Update the credit history
		$creditHistoryInsert = $this->_addSubtitlingToCreditHistory($exerciseId);
		if(!creditHistoryInsert){
			$this->conn->_failedTransaction();
			throw new Exception("Credit history update failed");
		}

		if ($subtitleId && $lastRoleId && $lastSubtitleLineId && $creditUpdate && $creditHistoryInsert){
			$this->conn->_endTransaction();

			$result = $this->_getUserInfo();
		}

		return $result;

	}

	private function _getUserRoles($exerciseId, $userId){
		$sql = "SELECT MAX(id),fk_exercise_id, character_name
		    	FROM exercise_role WHERE (fk_exercise_id = %d AND fk_user_id= %d) 
		    	GROUP BY exercise_role.character_name ";

		$searchResults = $this->_listRolesQuery ( $sql, $exerciseId, $userId );

		return $searchResults;
	}

	private function _addCreditsForSubtitling() {
		$sql = "UPDATE (users u JOIN preferences p)
				SET u.creditCount=u.creditCount+p.prefValue 
				WHERE (u.ID=%d AND p.prefName='subtitleAdditionCredits') ";
		return $this->conn->_execute ( $sql, $_SESSION['uid'] );
	}

	private function _addSubtitlingToCreditHistory($exerciseId){
		$sql = "SELECT prefValue FROM preferences WHERE ( prefName='subtitleAdditionCredits' )";
		$result = $this->conn->_execute ( $sql );
		$row = $this->conn->_nextRow($result);
		if($row){

			$sql = "INSERT INTO credithistory (fk_user_id, fk_exercise_id, changeDate, changeType, changeAmount) ";
			$sql = $sql . "VALUES ('%d', '%d', NOW(), '%s', '%d') ";
			return $this->conn->_insert($sql, $_SESSION['uid'], $exerciseId, 'subtitling', $row[0]);
		} else {
			return false;
		}
	}

	private function _getUserInfo(){

		$sql = "SELECT name, creditCount, joiningDate, isAdmin FROM users WHERE (id = %d) ";

		return $this->_singleQuery($sql, $_SESSION['uid']);
	}

	private function _singleQuery(){
		$valueObject = new UserVO();
		$result = $this->conn->_execute(func_get_args());

		$row = $this->conn->_nextRow($result);
		if ($row)
		{
			$valueObject->name = $row[0];
			$valueObject->creditCount = $row[1];
			$valueObject->joiningDate = $row[2];
			$valueObject->isAdmin = $row[3]==1;
		}
		else
		{
			return false;
		}
		return $valueObject;
	}

	private function _subtitlesWereModified($compareSubject)
	{
		$modified=false;
		$unmodifiedSubtitlesLines = $_SESSION['unmodified-subtitles'];
		if (count($unmodifiedSubtitlesLines) != count($compareSubject))
		$modified=true;
		else
		{
			for ($i=0; $i < count($unmodifiedSubtitlesLines); $i++)
			{
				$unmodifiedItem = $unmodifiedSubtitlesLines[$i];
				$compareItem = $compareSubject[$i];
				if (($unmodifiedItem->text != $compareItem->text) || ($unmodifiedItem->showTime != $compareItem->showTime) || ($unmodifiedItem->hideTime != $compareItem->hideTime))
				{
					$modified=true;
					break;
				}
			}
		}
		return $modified;
	}

	private function _checkSubtitleErrors($subtitleCollection)
	{
		$errorMessage="";
			
		//Check empty roles, time overlappings and empty texts
		for ($i=0; $i < count($subtitleCollection); $i++)
		{
			if ($subtitleCollection[$i]->exerciseRoleId < 1)
				$errorMessage.="The role on the line " . ($i + 1) . " is empty.\n";
			$lineText = $subtitleCollection[$i]->text;
			$lineText = preg_replace("/[ ,\;.\:\-_?¿¡!€$']*/", "", $lineText);
			if (count($lineText) < 1)
				$errorMessage.="The text on the line " . ($i + 1) . " is empty.\n";
			if ($i > 0)
			{
				if ($subtitleCollection[($i-1)]->hideTime >= $subtitleCollection[$i]->showTime)
					$errorMessage.="The subtitle on the line " . $i . " overlaps with the next subtitle.\n";
			}
		}
		return $errorMessage;
	}

	private function _modificationRate($compareSubject){
		$unmodifiedSubtitlesLines = $_SESSION['unmodified-subtitles'];
		$currentText = '';
		$unmodifiedText = '';
		
		foreach ($compareSubject as $cline)
			$currentText .= preg_replace("/[ ,\;.\:\-_?¿¡!€$']*/", "", $cline->text)."\n";
		foreach ($unmodifiedSubtitlesLines as $uline)
			$unmodifiedText .= preg_replace("/[ ,\;.\:\-_?¿¡!€$']*/", "", $uline->text)."\n";
		$cosmeas = new CosineMeasure($currentText,$unmodifiedText);
		$cosmeas->compareTexts(); 
		$modificationRate = (strlen($unmodifiedText) - similar_text($unmodifiedText, $currentText)) * (strlen($unmodifiedText)/100);
		
	}
	

	public function getExerciseSubtitles($exerciseId){
		$sql = "SELECT s.id, s.fk_exercise_id, u.name, s.language, s.translation, s.adding_date
				FROM subtitle s inner join users u on s.fk_user_id=u.ID
				WHERE fk_exercise_id='%d'
				ORDER BY s.adding_date DESC";
		$searchResults = $this->_listSubtitlesQuery ( $sql, $exerciseId );

		return $searchResults;
	}

	private function _deletePreviousSubtitles($exerciseId){
		//Retrieve the subtitle id to be deleted
		$sql = "SELECT DISTINCT s.id
				FROM subtitle_line sl INNER JOIN subtitle s ON sl.fk_subtitle_id = s.id
				WHERE (s.fk_exercise_id= '%d' )";

		$subtitleIdToDelete = $this->_singleSubtitleIdQuery($sql, $exerciseId);

		if($subtitleIdToDelete){
			//Delete the subtitle_line entries ->
			$sl_delete = "DELETE FROM subtitle_line WHERE (fk_subtitle_id = '%d')";
			$this->conn->_execute($sl_delete, $subtitleIdToDelete);

			//The first query should suffice to delete all due to ON DELETE CASCADE clauses but
			//as it seems this doesn't work we delete the rest manually.

			//Delete the exercise_role entries
			$er_delete = "DELETE FROM exercise_role WHERE (fk_exercise_id = '%d')";
			$this->conn->_execute($er_delete, $exerciseId);

			//Delete the subtitle entry
			$s_delete = "DELETE FROM subtitle WHERE (id ='%d')";
			$this->conn->_execute($s_delete, $subtitleIdToDelete);
		}
	}

	private function _singleSubtitleIdQuery(){
		$subtitleId = 0;
		$result = $this->conn->_execute(func_get_args());
		$row = $this->conn->_nextRow($result);
		if ($row){
			$subtitleId = $row[0];
		} else {
			return false;
		}
		return $subtitleId;
	}

	private function _listSubtitlesQuery(){
		$searchResults = array();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow($result)){
			$temp = new SubtitleAndSubtitleLinesVO();
			$temp->id = $row[0];
			$temp->exerciseId = $row[1];
			$temp->userName = $row[2];
			$temp->language = $row[3];
			$temp->translation = $row[4];
			$temp->addingDate = $row[5];
			array_push($searchResults, $temp);
		}

		return $searchResults;
	}

	private function _listSubtitleLinesQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new SubtitleLineVO ( );
			$temp->id = $row [0];
			$temp->showTime = $row [1];
			$temp->hideTime = $row [2];
			$temp->text=$row [3];
			$temp->exerciseRoleId=$row[4];
			$temp->exerciseRoleName=$row[5];
			$temp->subtitleId=$row[6];
			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}

	private function _listRolesQuery() {
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new ExerciseRoleVO ( );
			$temp->id = $row [0];
			$temp->exerciseId = $row [1];
			$temp->characterName = $row [2];
			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}

	private function _vcreate($params) {

		$this->conn->_execute ( $params );

		$sql = "SELECT last_insert_id()";
		$result = $this->conn->_execute ( $sql );

		$row = $this->conn->_nextRow ( $result );
		if ($row) {
			return $row [0];
		} else {
			return false;
		}
	}
}

?>