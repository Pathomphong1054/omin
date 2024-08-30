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
$message = $_POST['message'];

// ตรวจสอบว่ามีการอัพโหลดไฟล์ภาพหรือไม่
if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
    $target_dir = "uploads/";
    $imageFileType = strtolower(pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION));
    $target_file = $target_dir . uniqid() . '.' . $imageFileType;

    // พยายามอัพโหลดไฟล์ภาพ
    if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
        // ถ้าอัพโหลดสำเร็จ, บันทึก path ของภาพลงในฐานข้อมูล
        $image_path = $target_file;
    } else {
        // ถ้าอัพโหลดไม่สำเร็จ, ส่ง error กลับ
        echo json_encode(['status' => 'error', 'message' => 'Failed to upload image']);
        $conn->close();
        exit();
    }
} else {
    // ถ้าไม่มีภาพ, ตั้งค่า $image_path เป็น NULL
    $image_path = NULL;
}

// บันทึกข้อความและ path ของภาพลงในฐานข้อมูล
$sql = "INSERT INTO messages (group_id, user_id, message, image_path) VALUES ('$group_id', '$user_id', '$message', '$image_path')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Message sent']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $conn->error]);
}

$conn->close();
?>
