<?php
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$sql = "SELECT accident_name, accident_location, accident_time, accident_details, accident_image, created_at FROM tb_accident ORDER BY created_at DESC";
$result = $conn->query($sql);

$notifications = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $notifications[] = $row;
    }
}

echo json_encode($notifications);

$conn->close();
?>
