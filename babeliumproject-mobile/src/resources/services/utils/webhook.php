<?php

require_once 'Config.php';
require_once 'Datasource.php';

$settings = new Config();
$json_input = file_get_contents('php://input');

$commit_info = json_decode($json_input, true);
$appRevision = $commit_info['revision'];

$logPath = $settings->logPath;
$projectSecretKey = $settings->project_secret_key;
$digest = hash_hmac("md5",$json_input,$projectSecretKey);

error_log("[".date("d/m/Y H:i:s")."] webhook request received.\n",3,$logPath.'/webhook.log');
error_log("\tJSON input: ".$json_input."\n",3,$logPath.'/webhook.log');

$headers = apache_request_headers();

if ($digest == $headers["Google-Code-Project-Hosting-Hook-Hmac"]){
        if(!empty($appRevision) && is_numeric($appRevision)){
                $sql = "UPDATE preferences SET prefValue= '%s' WHERE (prefName='appRevision')";

                $conn = new Datasource ( $settings->host, $settings->db_name, $settings->db_username, $settings->db_password );
                $conn->_execute ( $sql, $appRevision );
                error_log("\tCommited revision: ".$appRevision."\n", 3, $logPath.'/webhook.log');

        } else {
                error_log("\tWrong input received.\n", 3, $logPath.'/webhook.log');
        }
} else {
        error_log("\tAuthentication failed.\n", 3, $logPath.'/webhook.log');
}



?>