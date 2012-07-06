<?php

require_once 'utils/Datasource.php';
require_once 'utils/Config.php';
require_once 'utils/SessionHandler.php';
require_once 'utils/EmailAddressValidator.php';
require_once 'utils/Mailer.php';
require_once 'vo/UserVO.php';
require_once 'vo/ExerciseVO.php';

require_once 'ExerciseDAO.php';


/**
 * This class is used to make queries related to an VO object. When the results
 * are stored on our VO class AMFPHP parses this data and makes it available for
 * AS3/Flex use.
 *
 * It must be placed under amfphp's services folder, once we have successfully
 * installed amfphp's files in apache's web folder.
 *
 */
class UserDAO {
	private $conn;

	public function UserDAO(){
		$settings = new Config();
		try {
			$verifySession = new SessionHandler();
			$this->conn = new Datasource($settings->host, $settings->db_name, $settings->db_username, $settings->db_password);
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	public function getTopTenCredited()
	{
		$sql = "SELECT name, creditCount FROM users AS U WHERE U.active = 1 ORDER BY creditCount DESC LIMIT 10";

		$searchResults = $this->_listQuery($sql);

		return (count($searchResults))? $searchResults : false ;
	}

	public function keepAlive(){

		try {
			$verifySession = new SessionHandler(true);

			$sessionId = session_id();

			//Check that there's not another active session for this user
			$sql = "SELECT * FROM user_session WHERE ( session_id = '%s' AND fk_user_id = '%d' AND closed = 0 )";
			$result = $this->conn->_execute ( $sql, $sessionId, $_SESSION['uid'] );
			$row = $this->conn->_nextRow($result);
			if($row){
				$sql = "UPDATE user_session SET keep_alive = 1 WHERE fk_user_id = '%d' AND closed=0";

				return $this->conn->_execute($sql, $_SESSION['uid']);
			}
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	public function changePass($oldpass, $newpass)
	{
		try {
			$verifySession = new SessionHandler(true);

			$sql = "SELECT * FROM users WHERE id = %d AND password = '%s'";
			$result = $this->conn->_execute($sql, $_SESSION['uid'], $oldpass);
			$row = $this->conn->_nextRow($result);
			if (!$row)
			return false;

			$sql = "UPDATE users SET password = '%s' WHERE id = %d AND password = '%s'";
			$result = $this->conn->_execute($sql, $newpass, $_SESSION['uid'], $oldpass);

			return true;
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}

	//The parameter should be an array of UserLanguageVO
	public function modifyUserLanguages($languages) {

		try {
			$verifySession = new SessionHandler(true);

			$sql = "SELECT prefValue FROM preferences WHERE ( prefName='positives_to_next_level' )";
			$positivesToNextLevel = $this->_getPositivesToNextLevel($sql);

			$currentLanguages = $_SESSION['user-languages'];

			$this->conn->_startTransaction();

			//Delete the languages that have changed
			$sql = "DELETE FROM user_languages WHERE fk_user_id = '%d'";
			$result = $this->conn->_execute($sql, $_SESSION['uid']);

			if(!$result || !$this->conn->_affectedRows()){
				$this->conn->_failedTransaction();
				throw new Exception("Language modify failed");
			}

			//Insert the new languages
			$params = array();

			$sql = "INSERT INTO user_languages (fk_user_id, language, level, purpose, positives_to_next_level) VALUES ";
			foreach($languages as $language) {
				$sql .= " ('%d', '%s', '%d', '%s', '%d'),";
				array_push($params, $_SESSION['uid'], $language->language, $language->level, $language->purpose, $positivesToNextLevel);
			}
			unset($language);
			$sql = substr($sql,0,-1);
			// put sql query and all params in one array
			$merge = array_merge((array)$sql, $params);

			$result = $this->_vcreate($merge);

			if (!$result){
				$this->conn->_failedTransaction();
				throw new Exception("Language modify failed");
			} else {
				$this->conn->_endTransaction();
			}

			$result = $this->_getUserLanguages();
			if($result){
				$_SESSION['user-languages'] = $result;
			}
			return $result;
				
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}

	}
	
	public function modifyUserPersonalData($personalData){
		try {
			$verifySession = new SessionHandler(true);
			
			$validator = new EmailAddressValidator();
			if(!$validator->check_email_address($personalData->email)){
				return 'wrong_email';
			} else {
			
				$currentPersonalData = $_SESSION['user-data'];
			
				$sql = "UPDATE users SET realName='%s', realSurname='%s', email='%s' WHERE id='%d'";
			
				$updateData = $this->conn->_execute($sql, $personalData->realName, $personalData->realSurname, $personalData->email, $_SESSION['uid']);
				if($updateData){
					$currentPersonalData->realName = $personalData->realName;
					$currentPersonalData->realSurname = $personalData->realSurname;
					$currentPersonalData->email = $personalData->email;
					$_SESSION['user-data'] = $currentPersonalData;
					return $personalData;
				} else {
					return 'wrong_data';
				}
			}
			
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}	
	}
	
	public function retrieveUserVideos(){
		try {
			$verifySession = new SessionHandler(true);
			
			$sql = "SELECT e.id, e.title, e.description, e.language, e.tags, e.source, e.name, e.thumbnail_uri, e.adding_date,
		               e.duration, avg (suggested_level) as avgLevel, e.status, license, reference, a.id
				FROM exercise e 
	 				 LEFT OUTER JOIN exercise_score s ON e.id=s.fk_exercise_id
       				 LEFT OUTER JOIN exercise_level l ON e.id=l.fk_exercise_id
       				 LEFT OUTER JOIN subtitle a ON e.id=a.fk_exercise_id
     			WHERE e.fk_user_id = %d AND e.status <> 'Unavailable' 
				GROUP BY e.id
				ORDER BY e.adding_date DESC";
			
			$searchResults = $this->_exerciseListQuery($sql, $_SESSION['uid']);
			
			return $searchResults;
			
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}	
	}
	
	private function _exerciseListQuery() {
		$exercise = new ExerciseDAO();
		$searchResults = array ();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$temp = new ExerciseVO ( );

			$temp->id = $row[0];
			$temp->title = $row[1];
			$temp->description = $row[2];
			$temp->language = $row[3];
			$temp->tags = $row[4];
			$temp->source = $row[5];
			$temp->name = $row[6];
			$temp->thumbnailUri = $row[7];
			$temp->addingDate = $row[8];
			$temp->duration = $row[9];
			$temp->avgDifficulty = $row[10];
			$temp->status = $row[11];
			$temp->license = $row[12];
			$temp->reference = $row[13];
			$temp->isSubtitled = $row[14] ? true : false;

			$temp->avgRating = $exercise->getExerciseAvgBayesianScore($temp->id)->avgRating;

			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}
	
	public function deleteSelectedVideos($selectedVideos){
		try {
			$verifySession = new SessionHandler(true);
			
			$whereClause = '';
			$names = array();
			
			if(count($selectedVideos) > 0){
				foreach($selectedVideos as $selectedVideo){
					$whereClause .= " name = '%s' OR";
					array_push($names, $selectedVideo->name);
				}
				unset($selectedVideo);
				$whereClause = substr($whereClause,0,-2);
			
				$sql = "UPDATE exercise SET status='Unavailable' WHERE ( fk_user_id=%d AND" . $whereClause ." )";
				
				$merge = array_merge((array)$sql, (array)$_SESSION['uid'], $names);
				$updateData = $this->conn->_execute($merge);

				return $updateData ? true : false;
			}
			
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}	
	}
	
	public function modifyVideoData($videoData){
		try{
			$verifySession = new SessionHandler(true);
			
			$sql = "UPDATE exercise SET title='%s', description='%s', tags='%s', license='%s', reference='%s', language='%s' 
					WHERE ( name='%s' AND fk_user_id=%d )";
			
			$updateData = $this->conn->_execute($sql, $videoData->title, $videoData->description, $videoData->tags, $videoData->license, $videoData->reference, $videoData->language, $videoData->name, $_SESSION['uid']);
			
			$sql = "INSERT INTO exercise_level (fk_exercise_id, fk_user_id, suggested_level) VALUES (%d, %d, %d)";
			
			$insertData = $this->conn->_execute($sql, $videoData->id, $_SESSION['uid'], $videoData->avgDifficulty);
			
			return $updateData && $insertData ? true : false;
			
			
		} catch (Exception $e){
			throw new Exception ($e->getMessage());
		}
	}

	private function _getPositivesToNextLevel(){
		$result = $this->conn->_execute(func_get_args());
		if($row = $this->conn->_nextRow($result))
		return $row[0];
		else
		return 0;
	}

	private function _getUserLanguages(){
		$sql = "SELECT language, level, positives_to_next_level, purpose
				FROM user_languages WHERE (fk_user_id='%d')";
		return $this->_listUserLanguagesQuery($sql, $_SESSION['uid']);
	}



	private function _listUserLanguagesQuery(){
		$searchResults = array();

		$result = $this->conn->_execute(func_get_args());
		while($row = $this->conn->_nextRow($result)){
			$temp = new UserLanguageVO();
			$temp->language = $row[0];
			$temp->level = $row[1];
			$temp->positivesToNextLevel = $row[2];
			$temp->purpose = $row[3];

			array_push($searchResults, $temp);
		}
		return $searchResults;
	}

	public function restorePass($username)
	{
		$id = -1;
		$email = "";
		$user = "";
		$realName = "";

		$aux = "name";
		if ( Mailer::checkEmail($username) )
			$aux = "email";

		// Username or email checking
		$sql = "SELECT id, name, email, realName FROM users WHERE $aux = '%s'";
		$result = $this->conn->_execute($sql, $username);
		$row = $this->conn->_nextRow($result);

		if ($row)
		{
			$id = $row[0];
			$user = $row[1];
			$email = $row[2];
			$realName = $row[3];
		}

		if ( $realName == '' || $realName == 'unknown' ) 
			$realName = $user;

		// User dont exists
		if ( $id == -1 ) 
			return "Unregistered user";

		$newPassword = $this->_createNewPassword();
		
		$this->conn->_startTransaction();

		$sql = "UPDATE users SET password = '%s' WHERE id = %d";
		$result = $this->conn->_execute($sql, sha1($newPassword), $id);
		
		if($this->conn->_affectedRows() == 1){

			$args = array(
							'REAL_NAME' => $realName,
							'USERNAME' => $user,
							'PASSWORD' => $newPassword,
							'SIGNATURE' => 'The Babelium Project Team');

			$mail = new Mailer($email);

			if ( !$mail->makeTemplate("restorepass", $args, "es_ES") ) return null;

			$subject = "Your password has been reseted";

			$mail->send($mail->txtContent, $subject, $mail->htmlContent);
			
			$this->conn->_endTransaction();

			return "Done";
		} else {
			$this->conn->_failedTransaction();
			throw new Exception("Error while restoring user password");
		}
	}

	// Returns an array of Users
	private function _listQuery()
	{
		$searchResults = array();
		$result = $this->conn->_execute(func_get_args());

		while ($row = $this->conn->_nextRow($result))
		{
			$temp = new UserVO();
			$temp->name = $row[0];
			$temp->creditCount = $row[1];
			array_push($searchResults, $temp);
		}

		return $searchResults;
	}

	private function _createNewPassword()
	{
		$pass = "";
		$chars = "zbcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		$length = rand(8, 14);

		// Generate password
		for ( $i = 0; $i < $length; $i++ )
		$pass .= substr($chars, rand(0, strlen($chars)-1), 1);  // java: chars.charAt( random );

		return $pass;
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
