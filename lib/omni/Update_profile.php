<?php
header('Content-Type: application/json');
error_reporting(0); // ปิดการแสดงข้อความแจ้งเตือน

$servername = "localhost"; 
$username = "root";
$password = ""; 
$dbname = "omni"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$user_id = $_POST['id'];
$name = $_POST['name'];
$birthdate = $_POST['birthdate'];
$gender = $_POST['gender'];
$agency = $_POST['agency'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];
$profile_image = $_POST['profile_image'];

$sql = "UPDATE tb_users SET user_name_surname = '$name', user_birthdate = '$birthdate', user_gender = '$gender', 
        agency_id = '$agency', user_email = '$email', user_phone = '$phone', user_address = '$address', 
        user_image = '$profile_image' WHERE user_id = $user_id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Profile updated successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error updating profile: ' . $conn->error]);
}

$conn->close();
exit();
?>
