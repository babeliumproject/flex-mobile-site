<?php

class Datasource
{
	
	private $dbLink;

	public function Datasource($dbHost, $dbName, $dbuser, $dbpasswd)
	{
		$this->dbLink = mysqli_connect ($dbHost, $dbuser, $dbpasswd);
		if(!$this->dbLink)
			$this->_checkConnectionErrors();

		$dbSelected = mysqli_select_db ($this->dbLink, $dbName);
		if(!$dbSelected)
			$this->_checkErrors();

		$dbCharsetSet = mysqli_set_charset($this->dbLink, 'utf8');
		if(!$dbCharsetSet)
			$this->_checkErrors();
	}
	
	/**
	 * This task can only be performed on InnoDB tables.
	 * Turn off the autocommit until several changes are made to the database.
	 */
	public function _startTransaction(){
		mysqli_autocommit($this->dbLink,FALSE);
	}
	
	/**
	 * This task can only be performed on InnoDB tables.
	 * The transaction performed as expected. Commit all the changes and set the auto commit back to normal.
	 */
	public function _endTransaction(){
		mysqli_commit($this->dbLink);
		mysqli_autocommit($this->dbLink,TRUE);
	}
	
	/**
	 * One or more queries in the current transaction didn't give the expected output. Undo all the changes so far.
	 */
	public function _failedTransaction(){
		mysqli_rollback($this->dbLink);
		mysqli_autocommit($this->dbLink,TRUE);
	}

	public function _execute()
	{
		if ( is_array(func_get_arg(0)) )
			return $this->_vexecute(func_get_arg(0)); // Gets an array of parameters
		else
			return $this->_vexecute(func_get_args()); // Gets separate parameters
	}
	 
	public function _vexecute($params)
	{
		$query = array_shift($params);

		for ( $i = 0; $i < count($params); $i++ )
		$params[$i] = mysqli_real_escape_string($this->dbLink, $params[$i]);

		$query = vsprintf($query, $params);

		$result = mysqli_query($this->dbLink, $query);
		if(!$result)
			$this->_checkErrors($query);

		return $result;
	}

	public function _nextRow ($result)
	{
		$row = mysqli_fetch_array($result);
		return $row;
	}
	
	public function _insert (){
		$this->_execute ( func_get_args() );

		$sql = "SELECT last_insert_id()";
		$result = $this->_execute ( $sql );

		$row = $this->_nextRow ( $result );
		if ($row) {
			return $row [0];
		} else {
			return false;
		}
	}
	
	public function _affectedRows() {
		return mysqli_affected_rows($this->dbLink);
	}

	private function _checkConnectionErrors(){
		$errno = mysqli_connect_errno();
		if($errno){
			error_log("Database connection error #".$errno.": ".mysqli_connect_error()."\n",3,"/tmp/db_error.log");
			throw new Exception("Database connection error.\n");
		} else {
			return;
		}

	}

	private function _checkErrors($sql = "")
	{
		$errno = mysqli_errno($this->dbLink);
		$error = mysqli_error($this->dbLink);
		$sqlstate=mysqli_sqlstate($this->dbLink);

		if($sqlstate){
			//Rollback the uncommited changes just in case
			$this->_failedTransaction();
			error_log("Database error #" .$errno. " (".$sqlstate."): ".$error."\n",3,"/tmp/db_error.log");
			if($sql != "")
				error_log("Caused by the following SQL command: ".$sql."\n",3,"/tmp/db_error.log");
			throw new Exception("Database operation error.\n");
		}
		else
		{
			return;
		}
	}
}

?>