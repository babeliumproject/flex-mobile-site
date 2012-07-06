<?php

/**
 * This class is used by AMFPHP to store the data retrieved from our database
 * using this object's DAO class.
 *
 * It must be placed under amfphp's services folder, once we have successfully
 * installed amfphp's files in apache's web folder.
 *
 */
class UserVO {
	
	public $id;
	public $name;
	public $email;
	public $creditCount;
	public $realName;
	public $realSurname;
	public $active;
	public $joiningDate;
	public $isAdmin;
	
	public $userLanguages; //An array of UserLanguageVO objects

	//This string specifies the path to a same kind ValueObject AS3 class in our Flex application
	public $_explicitType = "UserVO";
}
?>