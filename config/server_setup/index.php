<?php
$file = "/server_setup/Servers.txt";
$bAccessLogs = false;
$bErrorLogs = true;

$f = fopen($file, "r");
while ( $line = fgets($f, 1000) ) {
    if($bAccessLogs){
        echo "<br>===>>Access Logs : ".trim($line)."<<===<br>";
        echo system("tail -50 /var/log/httpd/".trim($line)."-access_log");
    }
    if($bErrorLogs){
        echo "<br><br>===>>Error Logs : ".trim($line)."<<===<br>";
        echo system("tail -50 /var/log/httpd/".trim($line)."-error_log");
    }
    echo "<br><br>";
}
?>