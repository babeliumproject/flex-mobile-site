#!/usr/bin/php -q
<?php require_once 'YouTubeDAO.php';
      echo "[".date("d/m/Y H:i:s")."] Commencing video slice processing task...\n"; 
      $YouTubeDAO = new YouTubeDAO();
      $YouTubeDAO->processPendingSlices(); ?>
