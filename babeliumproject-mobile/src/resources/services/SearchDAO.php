<?php

require_once 'utils/Config.php';
require_once 'utils/Datasource.php';
require_once 'utils/SessionHandler.php';

require_once 'vo/ExerciseVO.php';

require_once 'Zend/Search/Lucene.php';

class SearchDAO {
	private $conn;
	private $indexPath;
	private $index;

	public function SearchDAO() {
		try {
			$verifySession = new SessionHandler();
			$settings = new Config ( );
			$this->indexPath = $settings->indexPath;
			$this->conn = new Datasource ($settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
		} catch (Exception $e) {
			throw new Exception($e->getMessage());
		}
	}
	
	public function initialize(){
		try{
			$this->index = Zend_Search_Lucene::open($this->indexPath);
		}catch (Zend_Search_Lucene_Exception $ex){
			try{
				$this->createIndex();
				$this->index = Zend_Search_Lucene::open($this->indexPath);
			}catch(Zend_Search_Lucene_Exception $exc){
				$this->initialize();
			}
		}
	}

	public function launchSearch($search) {
		$searchResults = array();
		
		//Return empty array if empty query
		if($search == '')
			return;

		//Opens the index
		$this->initialize();

		//To recognize numerics
		//Zend_Search_Lucene_Analysis_Analyzer::setDefault(new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive());

		//Remove the limitations of fuzzy and wildcard searches
		Zend_Search_Lucene_Search_Query_Wildcard::setMinPrefixLength(0);
		Zend_Search_Lucene_Search_Query_Fuzzy::setDefaultPrefixLength(0);

			
		$finalSearch=$this->fuzzySearch($search);
		$query = Zend_Search_Lucene_Search_QueryParser::parse($finalSearch);
			
		//We do the search and send it
		try {
			$hits = $this->index->find($query);
		}
		catch (Zend_Search_Lucene_Exception $ex) {
			$hits = array();
		}
		 
		foreach ($hits as $hit) {
			$temp = new ExerciseVO( );
				
			$temp->id = $hit->idEx;
			$temp->title = $hit->title;
			$temp->description = $hit->description;
			$temp->language = $hit->language;
			$temp->tags = $hit->tags;
			$temp->source = $hit->source;
			$temp->name = $hit->name;
			$temp->thumbnailUri = $hit->thumbnailUri;
			$temp->addingDate = $hit->addingDate;
			$temp->duration = $hit->duration;
			$temp->userName = $hit->userName;
			$temp->avgRating = $hit->avgRating;
			$temp->avgDifficulty = $hit->avgDifficulty;
			$temp->score = $hit->score;
			$temp->idIndex = $hit->id;
				
			array_push ( $searchResults, $temp );
		}
		return $searchResults;
	}

	public function fuzzySearch($search){
		//Decide whether to make the fuzzy search
		$auxSearch=$search;
		$finalSearch=$search;
		$count =0;
		$array_substitution=array("+","-", "&","|","!", "(",")", "{","}", "[","]", "^","~", "*","?",":","\\","/","\"", "or","and","not");

		$auxSearch=str_replace($array_substitution, ',', $auxSearch, $count);
		if ($count==0){
			$finalSearch=str_replace(' ', '~ ', $search);
			$finalSearch=$finalSearch . "~";
		}
		return $finalSearch;
	}

	public function setTagToDB($search){
		if ($search!=''){
			$sql = "SELECT amount FROM tagcloud WHERE tag='%s'";
			$result = $this->conn->_execute ($sql, $search);
			if ($row = $this->conn->_nextRow ($result)){
				//The tag already exists, so updating the quantity
				$newAmount= 1 + $row[0];
				$sql = "UPDATE tagcloud SET amount = ". $newAmount . " WHERE tag='%s'";
				$result = $this->conn->_execute ($sql, $search);
			}else{
				//Insert the tag
				$sql = "INSERT INTO tagcloud (tag, amount) VALUES ('%s', 0)";
				$result = $this->conn->_execute ($sql, $search);
			}
		}
		return $result;
	}

	public function reCreateIndex(){
		$this->deleteIndexRecursive($this->indexPath);
		//rmdir($this->indexPath);
		$this->createIndex();
	}

	private function deleteIndexRecursive($dirname){
		// Sanity check
		if (!file_exists($dirname)) {
			return false;
		}

		// Simple delete for a file
		if (is_file($dirname) || is_link($dirname)) {
			return unlink($dirname);
		}

		// Loop through the folder
		$dir = dir($dirname);
		while (false !== $entry = $dir->read()) {
			// Skip pointers
			if ($entry == '.' || $entry == '..') {
				continue;
			}

			// Recursive
			$this->deleteIndexRecursive($dirname . DIRECTORY_SEPARATOR . $entry);
		}

		// Clean up
		return $dir->close();
		//return rmdir($dirname);
	}

	public function createIndex() {
		//Query for the index
		$sql = "SELECT e.id, e.title, e.description, e.language, e.tags, e.source, e.name, e.thumbnail_uri,
       					e.adding_date, e.fk_user_id, e.duration, u.name, avg(suggested_score) as avgScore, 
       					avg (suggested_level) as avgLevel
				 FROM   exercise e INNER JOIN users u ON e.fk_user_id= u.ID
       				    LEFT OUTER JOIN exercise_score s ON e.id=s.fk_exercise_id
       				    LEFT OUTER JOIN exercise_level l ON e.id=l.fk_exercise_id
       			 WHERE (e.status = 'Available')
				 GROUP BY e.id;";
		$result = $this->conn->_execute ( $sql );

		//Create the index
		$this->index = Zend_Search_Lucene::create($this->indexPath);

		//To recognize numerics
		Zend_Search_Lucene_Analysis_Analyzer::setDefault(new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive());

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$this->addDoc($row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],
			$row[7],$row[8],$row[9],$row[10],$row[11],$row[12],$row[13]);
		}
		$this->index->commit();
		$this->index->optimize();
	}
	
	public function addDocumentIndex($idDB){

		//Query for the index
		$sql = "SELECT e.id, e.title, e.description, e.language, e.tags, e.source, e.name, e.thumbnail_uri,
       					e.adding_date, e.duration, u.name, avg(suggested_score) as avgScore, 
       					avg (suggested_level) as avgLevel
				 FROM   exercise e INNER JOIN users u ON e.fk_user_id= u.ID
       				    LEFT OUTER JOIN exercise_score s ON e.id=s.fk_exercise_id
       				    LEFT OUTER JOIN exercise_level l ON e.id=l.fk_exercise_id
       			 
       			 WHERE (e.status = 'Available' and e.id=$idDB)
				 GROUP BY e.id";
		$result = $this->conn->_execute ( $sql );

		//Opens the index
		$this->initialize();

		while ( $row = $this->conn->_nextRow ( $result ) ) {
			$this->addDoc($row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],
			$row[7],$row[8],$row[9],$row[10],$row[11],$row[12]);
		}
		$this->index->commit();
		$this->index->optimize();
	}

	public function deleteDocumentIndex($idDB){
		//Opens the index
		$this->initialize();
		//Retrieving and deleting document
		$term = new Zend_Search_Lucene_Index_Term($idDB, 'idEx');
		$docIds  = $this->index->termDocs($term);
		foreach ($docIds as $id) {
			//$doc = $this->index->getDocument($id);
			//$this->index->delete($doc->id);
			$this->index->delete($id);
		}
		$this->index->commit();
		$this->index->optimize();
	}

	private function addDoc($idEx,$title,$description,$language,$tags,$source,$name,
	$thumbnailUri,$addingDate,$duration,$userName,
	$avgRating,$avgDifficulty){
		$doc = new Zend_Search_Lucene_Document();
			
		$doc->addField(Zend_Search_Lucene_Field::Text('idEx', $idEx, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('title', $title, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('description', $description, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('language', $language, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('tags', $tags, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::UnIndexed('source', $source, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::UnIndexed('name', $name, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::UnIndexed('thumbnailUri', $thumbnailUri, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::UnIndexed('addingDate', $addingDate, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::UnIndexed('duration', $duration, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('userName', $userName, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('avgRating', $avgRating, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Text('avgDifficulty', $avgDifficulty, 'utf-8'));
		$this->index->addDocument($doc);
	}
}

?>