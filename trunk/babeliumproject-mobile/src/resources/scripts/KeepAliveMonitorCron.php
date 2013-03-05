<?php

/**
 * This periodic task is meant to be launched every 5 minutes. 
 * See crontab_lines.example file for configuration examples.
 * 
 */

require_once 'PeriodicTaskDAO.php';

$periodicTaskDAO = new PeriodicTaskDAO();
$periodicTaskDAO->monitorizeSessionKeepAlive();

?>