<?php
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$group_id = $_POST['group_id'];
$user_id = $_POST['user_id'];

$target_dir = "uploads/images/";
$target_file = $target_dir . basename($_FILES["image"]["name"]);
move_uploaded_file($_FILES["image"]["tmp_name"], $target_file);

$sql = "INSERT INTO messages (group_id, user_id, message, image_path) VALUES ('$group_id', '$user_id', '', '$target_file')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $conn->error]);
}

$conn->close();
?>
