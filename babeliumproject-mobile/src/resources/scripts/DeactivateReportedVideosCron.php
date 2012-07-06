
<?php 

require_once 'PeriodicTaskDAO.php';

$periodicTask = new PeriodicTaskDAO();
$periodicTask->deactivateReportedVideos(); 
      
?>