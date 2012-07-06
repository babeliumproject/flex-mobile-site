<?php

class UserLanguageVO{
	
	const PURPOSE_EVALUATE = 'evaluate';
	const PURPOSE_PRACTICE = 'practice';
	
	public $id;
	public $userId;
	public $language; //Use the language's two digit code: ES, EU, FR, EN...
	public $level; //Level goes from 1 to 6. 7 used for mother tongue
	public $purpose;
	public $positivesToNextLevel; //An indicator of how many assessments or steps are needed to advance to the next level

	public $_explicitType = "UserLanguageVO";
	
}
?>