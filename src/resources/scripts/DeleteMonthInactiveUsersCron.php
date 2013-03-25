<?php

/**
 * This periodic task is meant to be launched every 30 minutes. 
 * See crontab_lines.example file for configuration examples.
 * 
 */

require_once 'PeriodicTaskDAO.php';

$periodicTaskDAO = new PeriodicTaskDAO();

//Removes the users that haven't activated their account for the period of time given as a parameter.
$periodicTaskDAO->deleteInactiveUsers(30);

?>