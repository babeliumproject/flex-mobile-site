<?php

class NewUserVO
	{
	
	public $name;
	public $pass;
	public $realName;
	public $realSurname;
	public $email;
	public $activationHash;
	
	public $languages;

	//This string specifies the path to a same kind ValueObject AS3 class in our Flex application
	public $_explicitType = "NewUserVO";
	}
?>
