<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

error_reporting(E_ERROR | E_PARSE);

$servername = "localhost"; 
$username = "root";
$password = ""; 
$dbname = "omni"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : 0;

if ($user_id > 0 && isset($_FILES['image'])) {
    $target_dir = "uploads/";
    $file_name = basename($_FILES["image"]["name"]);
    $imageFileType = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
    $unique_file_name = uniqid() . '.' . $imageFileType;
    $target_file = $target_dir . $unique_file_name;

    // ตรวจสอบว่าไฟล์ที่อัพโหลดเป็นรูปภาพจริงหรือไม่
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if ($check === false) {
        die(json_encode(['status' => 'error', 'message' => 'File is not an image.']));
    }

    // ตรวจสอบขนาดไฟล์ (จำกัด 5MB)
    if ($_FILES["image"]["size"] > 5000000) {
        die(json_encode(['status' => 'error', 'message' => 'Sorry, your file is too large.']));
    }

    // อนุญาตให้เฉพาะไฟล์ JPG, JPEG, และ PNG เท่านั้น
    if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg") {
        die(json_encode(['status' => 'error', 'message' => 'Sorry, only JPG, JPEG, & PNG files are allowed.']));
    }

    // ถ้าการอัปโหลดไฟล์สำเร็จ
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $image_url = "http://10.5.50.82/omni/uploads/" . $target_file;

        // อัพเดต URL ของรูปภาพโปรไฟล์ในฐานข้อมูล
        $sql = "UPDATE tb_users SET user_image = '$image_url' WHERE user_id = $user_id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(['status' => 'success', 'image_url' => $image_url]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error updating record: ' . $conn->error]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Sorry, there was an error uploading your file.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user ID or no image file uploaded.']);
}

$conn->close();
?>
