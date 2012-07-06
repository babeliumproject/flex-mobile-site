<?php

require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/MotdVO.php';

require_once 'EvaluationDAO.php';
require_once 'ExerciseDAO.php';

class HomepageDAO{

	private $conn;

	public function HomepageDAO(){
		try {
			$verifySession = new SessionHandler();
			$settings = new Config ();
			$this->conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}

	}

	public function unsignedMessagesOfTheDay($messageLocale){

		$sql = "SELECT title, message, code, language, resource FROM motd WHERE ( CURDATE() >= displayDate AND language='%s' AND displaywhenloggedin = false ) ";

		$searchResults = $this->_listMessagesOfTheDayQuery($sql, $messageLocale);

		return $searchResults;

	}

	public function signedMessagesOfTheDay($messageLocale){

		$sql = "SELECT title, message, code, language, resource FROM motd WHERE ( CURDATE() >= displayDate AND language='%s' AND displaywhenloggedin = true ) ";

		$searchResults = $this->_listMessagesOfTheDayQuery($sql, $messageLocale);

		return $searchResults;

	}

	private function _listMessagesOfTheDayQuery($query){

		$searchResults = array();
		$result = $this->conn->_execute ( func_get_args() );

		while ( $row = $this->conn->_nextRow($result)){
			$temp = new MotdVO();
			$temp->title = $row[0];
			$temp->message = $row[1];
			$temp->code = $row[2];
			$temp->language = $row[3];
			$temp->resourceUrl = $row[4];

			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}


	public function usersLatestReceivedAssessments(){
		$sql = "SELECT D.file_identifier, D.id, D.rating_amount, D.character_name, D.fk_subtitle_id,
		               D.adding_date, D.source, D.thumbnail_uri, D.duration,
		               C.name, A.score_overall, A.score_intonation, A.score_fluency, A.score_rhythm,
		               A.score_spontaneity, A.comment, A.adding_date,
		               E.id, E.name, E.duration, E.language, E.thumbnail_uri, E.title, E.source 
			    FROM evaluation A 
			    	 INNER JOIN response D ON A.fk_response_id = D.id
			    	 INNER JOIN exercise E ON D.fk_exercise_id = E.id
			    	 INNER JOIN users C ON A.fk_user_id = C.id
				WHERE (D.fk_user_id = '%d') 
				ORDER BY A.adding_date DESC";
		
		/*
		 * If we change the data displaying widget later on we could add this to the sql statement
		 * 
		 * LEFT OUTER JOIN exercise_level F ON E.id=F.fk_exercise_id
		 * LEFT OUTER JOIN evaluation_video B ON A.id = B.fk_evaluation_id 
		 */

		$searchResults = $this->_listAssessedResponsesQuery ( $sql, $_SESSION['uid'] );

		return $this->sliceResultsByNumber($searchResults,5);
	}

	private function _listAssessedResponsesQuery(){
		$searchResults = array();
		$result = $this->conn->_execute(func_get_args());

		while ($row = $this->conn->_nextRow($result)){
			$temp = new EvaluationVO();

			$temp->responseFileIdentifier = $row[0];
			$temp->responseId = $row[1];
			$temp->responseRatingAmount = $row[2];
			$temp->responseCharacterName = $row[3];
			$temp->responseSubtitleId = $row[4];
			$temp->responseAddingDate = $row[5];
			$temp->responseSource = $row[6];
			$temp->responseThumbnailUri = $row[7];
			$temp->responseDuration = $row[8];
			$temp->responseUserName = $row[9];

			$temp->overallScore = $row[10];
			$temp->intonationScore = $row[11];
			$temp->fluencyScore = $row[12];
			$temp->rhythmScore = $row[13];
			$temp->spontaneityScore = $row[14];
			$temp->comment = $row[15];
			$temp->addingDate = $row[16];

			$temp->exerciseId = $row[17];
			$temp->exerciseName = $row[18];
			$temp->exerciseDuration = $row[19];
			$temp->exerciseLanguage = $row[20];
			$temp->exerciseThumbnailUri = $row[21];
			$temp->exerciseTitle = $row[22];
			$temp->exerciseSource = $row[23];

			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}

	public function usersLatestGivenAssessments(){

		$results = array();

		//List of all the assessments done by the user
		$evaluation = new EvaluationDAO();
		$givenAssessments = $evaluation->getResponsesAssessedByCurrentUser();

		return $this->sliceResultsByNumber($givenAssessments, 5);
	}
	
	private function sliceResultsByNumber($searchResults, $length){
		$results = array();
		
		if( count($searchResults) > $length )
			$results = array_slice($searchResults, 0, $length);
		else
			$results = $searchResults;

		return $results;
	}
	
	private function sliceResultsByDate($searchResults, $timeInterval){
		$results = array();
		$currentTime = time();

		 //Filter the results and show only the assessments done in the last weeek
		 foreach($searchResults as $searchResult){
			$evalTime = strtotime($searchResult->addingDate);
			if ($evalTime <= $currentTime && ($currentTime - $evalTime) < $timeInterval)
				array_push($results, $searchResult);
		}
		return $results;
	}

	public function usersLatestUploadedVideos(){

	}

	public function topScoreMostViewedVideos(){
		
		$sql = "SELECT e.id, e.title, e.description, e.language, e.tags, e.source, e.name, e.thumbnail_uri, e.adding_date,
		               e.duration, u.name, avg (suggested_level) as avgLevel, e.status, license, reference, a.id
				FROM exercise e 
					 INNER JOIN users u ON e.fk_user_id= u.ID
	 				 LEFT OUTER JOIN exercise_score s ON e.id=s.fk_exercise_id
       				 LEFT OUTER JOIN exercise_level l ON e.id=l.fk_exercise_id
       				 LEFT OUTER JOIN subtitle a ON e.id=a.fk_exercise_id
       			WHERE e.status = 'Available'
				GROUP BY e.id
				ORDER BY e.adding_date DESC";

		$searchResults = $this->_exerciseListQuery($sql);
		$exercise = new ExerciseDAO();
		$filteredResults = $exercise->filterByLanguage($searchResults, 'practice');
		
		usort($filteredResults, array($this, 'sortResultsByScore'));
		$slicedResults = $this->sliceResultsByNumber($filteredResults, 10);
		
		return $slicedResults;
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
			$temp->userName = $row[10];
			$temp->avgDifficulty = $row[11];
			$temp->status = $row[12];
			$temp->license = $row[13];
			$temp->reference = $row[14];
			$temp->isSubtitled = $row[15] ? true : false;

			$temp->avgRating = $exercise->getExerciseAvgBayesianScore($temp->id)->avgRating;

			array_push ( $searchResults, $temp );
		}

		return $searchResults;
	}
	
	private function sortResultsByScore($exerciseA, $exerciseB){
		if ($exerciseA->avgRating == $exerciseB->avgRating) {
        	return 0;
    	}
    	return ($exerciseA->avgRating < $exerciseB->avgRating) ? -1 : 1;
	}

	public function latestAvailableVideos(){
		$sql = "SELECT e.id, e.title, e.description, e.language, e.tags, e.source, e.name, e.thumbnail_uri, e.adding_date,
		               e.duration, u.name, avg (suggested_level) as avgLevel, e.status, license, reference, a.id
				FROM exercise e 
					 INNER JOIN users u ON e.fk_user_id= u.ID
	 				 LEFT OUTER JOIN exercise_score s ON e.id=s.fk_exercise_id
       				 LEFT OUTER JOIN exercise_level l ON e.id=l.fk_exercise_id
       				 LEFT OUTER JOIN subtitle a ON e.id=a.fk_exercise_id
       			WHERE e.status = 'Available'
				GROUP BY e.id
				ORDER BY e.adding_date DESC";

		$searchResults = $this->_exerciseListQuery($sql, $_SESSION['uid']);
		$exercise = new ExerciseDAO();
		$filteredResults = $exercise->filterByLanguage($searchResults, 'practice');
		$slicedResults = $this->sliceResultsByNumber($filteredResults, 10);
		return $slicedResults;
	}


}
