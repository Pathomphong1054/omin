<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// เชื่อมต่อฐานข้อมูล
$servername = "localhost"; 
$username = "root"; 
$password = ""; 
$dbname = "omni"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Query เพื่อดึงข้อมูลแจ้งเตือน
$sql = "SELECT accident_name, accident_location, accident_time, accident_details, accident_image, created_at FROM tb_accident ORDER BY created_at DESC";
$result = $conn->query($sql);

$notifications = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $notifications[] = $row;  // ดึงข้อมูลและเก็บใน array
    }
    echo json_encode(['status' => 'success', 'data' => $notifications]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No notifications found']);
}

$conn->close();
?>
