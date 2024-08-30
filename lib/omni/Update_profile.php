<?php
header('Content-Type: application/json');
ini_set('display_errors', 0); // ปิดการแสดงผลข้อผิดพลาด

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni"; // ฐานข้อมูลของคุณ

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Get POST data
$user_id = intval($_POST['id']);
$user_type = $_POST['user_type'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$profile_image = isset($_FILES['profile_image']) ? $_FILES['profile_image']['name'] : '';

if ($profile_image) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["profile_image"]["name"]);
    move_uploaded_file($_FILES["profile_image"]["tmp_name"], $target_file);
} else {
    $profile_image = NULL;
}

$sql = "";
if ($user_type == 'User') {
    $birthdate = $_POST['birthdate'];
    $gender = $_POST['gender'];
    $address = $_POST['address'];
    if ($profile_image) {
        $sql = "UPDATE tb_users SET user_name_surname=?, user_birthday=?, user_gender=?, user_phone=?, 
                user_email=?, user_address=?, user_image=? WHERE user_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssssssi", $name, $birthdate, $gender, $phone, $email, $address, $profile_image, $user_id);
    } else {
        $sql = "UPDATE tb_users SET user_name_surname=?, user_birthday=?, user_gender=?, user_phone=?, 
                user_email=?, user_address=? WHERE user_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssi", $name, $birthdate, $gender, $phone, $email, $address, $user_id);
    }
} elseif ($user_type == 'Agency') {
    $agency_details = $_POST['agency_details'];
    if ($profile_image) {
        $sql = "UPDATE tb_agency SET agency_name=?, agency_call=?, email=?, agency_image=? WHERE agency_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssi", $name, $phone, $email, $profile_image, $user_id);
    } else {
        $sql = "UPDATE tb_agency SET agency_name=?, agency_call=?, email=? WHERE agency_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssi", $name, $phone, $email, $user_id);
    }
}

if ($stmt->execute()) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
