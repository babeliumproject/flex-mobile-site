<?php

require_once 'Datasource.php';
require_once 'Config.php';
require_once 'Zend/Mail.php';
require_once 'Zend/Mail/Transport/Smtp.php';
require_once 'EmailAddressValidator.php';

class Mailer
{
	
	private $_conn;
	private $_settings;
	private $_userMail;
	private $_userRealName;
	private $_validUser;

	// Template related vars
	private $_tplDir;
	private $_template;
	private $_tplFile;
	private $_keys;
	private $_values;

	public $txtContent;
	public $htmlContent;

	public function Mailer($username)
	{
		$this->_settings = new Config();
		$this->_conn = new DataSource($this->_settings->host, $this->_settings->db_name, $this->_settings->db_username, $this->_settings->db_password);

		$this->_tplDir = $this->_settings->templatePath . "/";


		$this->_validUser = $this->_getUserInfo($username);
	}

	private function _getUserInfo($username)
	{
		if (!$username)
			return false;

		$aux = "name";
		if ( Mailer::checkEmail($username) )
			$aux = "email";

		$sql = "SELECT name, email FROM users WHERE (".$aux." = '%s') ";
		$result = $this->_conn->_execute($sql, $username);
		$row = $this->_conn->_nextRow($result);

		if ($row)
		{
			$this->_userRealName = $row[0];
			$this->_userMail = $row[1];
		}
		else
			return false;

		return true;
	}

	public function send($body, $subject, $htmlBody = null)
	{
		if ( !$this->_validUser )
			return false;

		// SMTP Server config
		$config = array('auth' => 'login',
						'username' => $this->_settings->smtp_server_username,
						'password' => $this->_settings->smtp_server_password,
						'ssl' => $this->_settings->smtp_server_ssl,
						'port' => $this->_settings->smtp_server_port
		);
 
		$transport = new Zend_Mail_Transport_Smtp($this->_settings->smtp_server_host, $config);


		$mail = new Zend_Mail('UTF-8');
		$mail->setBodyText(utf8_decode($body));
		if ( $htmlBody != null )
			$mail->setBodyHtml($htmlBody);
		$mail->setFrom($this->_settings->smtp_mail_setFromMail, $this->_settings->smtp_mail_setFromName);
		$mail->addTo($this->_userMail, $this->_userRealName);
		$mail->setSubject($subject);
		
		try {
			$mail->send($transport);
		} catch (Exception $e) {
			error_log("[".date("d/m/Y H:i:s")."] Problem while sending notification mail to ". $this->_userMail . ":" . $e->getMessage() . "\n",3,$this->_settings->logPath.'/mail_smtp.log');
			return false;
		}
		error_log("[".date("d/m/Y H:i:s")."] Notification mail successfully sent to ". $this->_userMail . "\n",3,$this->_settings->logPath.'/mail_smtp.log');
		return true;
	}

	public static function checkEmail($email)
	{
		$reg = "/^[^0-9][a-zA-Z0-9_-]+([.][a-zA-Z0-9_-]+)*[@][a-zA-Z0-9_-]+([.][a-zA-Z0-9_-]+)*[.][a-zA-Z]{2,4}$/";
		return preg_match($reg, $email);
	}
	
	public static function checkEmailWithValidator($email)
	{
		$validator = new EmailAddressValidator();
		return $validator->check_email_address($email);
	}
	
	public function makeTemplate($templateFile, $templateArgs, $language)
	{
		$this->_tplFile = $this->_tplDir . $language . "/" . $templateFile;

		$this->_keys = array();
		$this->_values = array();
		
		while ( list($tmp1,$tmp2) = each($templateArgs) )
		{
			array_push($this->_keys, "/{" . $tmp1 . "}/");
			array_push($this->_values, $tmp2);
		}

		$txtFile = $this->_tplFile.".txt";
		$htmlFile = $this->_tplFile.".html";

		// txt content
		if ( !$fd = fopen($txtFile, "r") ) return false;
		$this->_template = fread($fd, filesize($txtFile));
		fclose($fd);
		$this->txtContent = preg_replace($this->_keys, $this->_values, $this->_template);
		

		// html content
		if ( !$fd = fopen($htmlFile, "r") ) return false;
		$this->_template = fread($fd, filesize($htmlFile));
		fclose($fd);
		$this->htmlContent = preg_replace($this->_keys, $this->_values, $this->_template);

		return true;
	}

}

?>
