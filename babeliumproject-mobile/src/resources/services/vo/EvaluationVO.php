<?php

class EvaluationVO{
	
	public $id;
	public $responseId; //The resource that has been assessed
	public $overallScore;
	public $intonationScore;
	public $fluencyScore;
	public $rhythmScore;
	public $spontaneityScore;
	public $comment;
	public $addingDate;
	
	//When the same responseId has more than one entry this returns the average scores.
	public $overallScoreAverage;
	public $intonationScoreAverage;
	public $fluencyScoreAverage;
	public $rhythmScoreAverage;
	public $spontaneityScoreAverage; 
	
	//When the video has video comments this fields are filled up with that video's data
	public $evaluationVideoId;
	public $evaluationVideoFileIdentifier;
	public $evaluationVideoThumbnailUri;	
	
	//When retrieving the responses that need to be assessed... we also need info about the
	//exercise that was followed to record the response that lead to the need of an assessment. 
	public $exerciseId;
	public $exerciseName;
	public $exerciseSource;
	public $exerciseTitle;
	public $exerciseLanguage;
	public $exerciseDuration;
	public $exerciseThumbnailUri;
	public $exerciseAvgDifficulty;
	
	
	public $responseFileIdentifier;
	public $responseSource;
	public $responseThumbnailUri;
	public $responseDuration;
	public $responseCharacterName;
	public $responseRatingAmount;
	public $responseAddingDate;
	public $responseUserName;
	public $responseSubtitleId;
	
	public $userName;
	
	public $transcriptionSystem;
      
    public $_explicitType = "EvaluationVO";
	
}

?>