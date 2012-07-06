<?php 

require_once 'UploadExerciseDAO.php';
echo "[".date("d/m/Y H:i:s")."] Commencing video processing task...\n"; 
$uploadExerciseDAO = new UploadExerciseDAO();
$uploadExerciseDAO->processPendingVideos(); 

?>
