<?php

class SearchVO {
	
	public $id;
	public $name;
	public $title;
	public $description;
	public $tags;
	public $language;
	public $source;
	
	public $userId;
	public $userName;
	
	public $thumbnailUri;
	public $addingDate;
	public $duration;
	public $transcriptionId;
	public $status;
	
	public $avgRating;
	public $avgDifficulty;
	
	public $score;
	
	public $_explicitType = "SearchVO";

}

?>