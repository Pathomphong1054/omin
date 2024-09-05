<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "localhost"; 
$username = "root";
$password = ""; 
$dbname = "omni"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$category = $_POST['category'];
$headline = $_POST['headline'];
$date = $_POST['date'];
$details = $_POST['details'];
$accident_vehicle = $_POST['accident_vehicle'];
$accident_distance = $_POST['accident_distance'];
$accident_time = $_POST['accident_time'];
$accident_location = $_POST['accident_location'];

// Handle image upload (single image)
$accident_image = '';
if (!empty($_FILES['image']['name'])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["image"]["name"]);
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $accident_image = $target_file;
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error uploading image']);
        exit();
    }
}

$sql = "INSERT INTO tb_accident (accident_name, accident_location, accident_time, accident_details, accident_image, accident_vehicle, accident_distance) 
        VALUES ('$headline', '$accident_location', '$accident_time', '$details', '$accident_image', '$accident_vehicle', '$accident_distance')";

if ($conn->query($sql) === TRUE) {
    $last_id = $conn->insert_id;

    // Save the notification
    $notification_sql = "INSERT INTO notifications (user_id, title, description) 
                         VALUES (1, 'Accident Report', 'Accident reported: $headline, Location: $accident_location, Time: $accident_time')";
    
    if ($conn->query($notification_sql) === TRUE) {
        echo json_encode(['status' => 'success', 'notification_id' => $last_id, 'message' => 'Report and notification saved successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error saving notification: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error saving report: ' . $conn->error]);
}

$conn->close();
?>
