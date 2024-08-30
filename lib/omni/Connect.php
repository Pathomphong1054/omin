<?php

// error_reporting(0); 
// ini_set('display_errors', 0); 

$servername = "localhost"; 
$username = "root";        
$password = "";            
$dbname = "omni";  


$con = new mysqli($servername, $username, $password, $dbname);


if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}
?>