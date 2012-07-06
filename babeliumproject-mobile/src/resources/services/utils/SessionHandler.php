<?php

/**
 * Import here the definitions of the classes of the data you're going to store in 
 * the $_SESSION superglobal to avoid PHP and Zend AMF errors.
 */
 require_once dirname(__FILE__).'/../vo/UserVO.php';
 require_once dirname(__FILE__).'/../vo/UserLanguageVO.php';
 require_once dirname(__FILE__).'/../vo/SubtitleLineVO.php';



class SessionHandler{
	
	//When an exception is thrown on the services side we should consider automatically
	//logging out the users for security purposes.
	
	public function SessionHandler($restrictedArea = false){
		if(session_id() == '')
			session_start();
		$this->avoidSessionFixation();
		
		if($restrictedArea)
			$this->avoidSessionHijacking();
	}

	private function avoidSessionFixation(){
		if (!isset($_SESSION['initiated']))
		{
			session_regenerate_id();
			$_SESSION['initiated'] = true;
		}
	}

	/**
	 * For now, we disable the IP check. Many ISPs have load-balance based dynamic IPs so it could be a bother for the user.
	 * 
	 * @throws Exception
	 */
	private function avoidSessionHijacking(){
		if( isset($_SESSION['logged']) && isset($_SESSION['uid']) && isset($_SESSION['user-agent-hash']) /*&& isset($_SESSION['user-addr'])*/){

			if ( $_SESSION['logged'] == false || $_SESSION['uid'] == 0 || $_SESSION['user-agent-hash'] != sha1($_SERVER['HTTP_USER_AGENT']) /*|| $_SESSION['user-addr'] != $_SERVER['REMOTE_ADDR']*/ )
			{
				throw new Exception("Unauthorized");
			}
		} else {
			throw new Exception("Unauthorized");
		}
	}
}

?>