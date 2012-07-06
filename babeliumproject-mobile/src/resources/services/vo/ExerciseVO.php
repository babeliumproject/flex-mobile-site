<?php

class ExerciseVO {
	
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
	public $license;
	public $reference;
	
	public $avgRating;
	public $ratingCount;
	
	public $avgDifficulty;
	
	public $isSubtitled;
	
	//score an idIndex are used in SearchModule, see ExerciseVO.as for more information
	public $score;
	public $idIndex;
	
	public $itemSelected;
	
	public $_explicitType = "ExerciseVO";

}

?>