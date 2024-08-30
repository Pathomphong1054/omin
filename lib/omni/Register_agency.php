<?php
header('Content-Type: application/json');

// ตั้งค่าการเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// รับข้อมูลจากการสมัครสมาชิก
$agency_name = $_POST['agency_name'] ?? '';
$agency_details = $_POST['agency_details'] ?? '';
$agency_wed = $_POST['agency_wed'] ?? '';
$agency_call = $_POST['agency_call'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$userType = 'Agency';

// ตรวจสอบว่ามีข้อมูลทั้งหมดหรือไม่
if (empty($agency_name) || empty($email) || empty($password)) {
    echo json_encode(['status' => 'error', 'message' => 'Please fill all required fields.']);
    exit();
}

// สร้าง hash สำหรับรหัสผ่าน
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// จัดการภาพหากมีการอัปโหลดมา
$imageData = null;
$imageFileName = null;

if (isset($_FILES['agency_image']['tmp_name'])) {
    $imageFileName = uniqid() . basename($_FILES['agency_image']['name']);
    $targetDir = "uploads/";
    $targetFile = $targetDir . $imageFileName;

    if (move_uploaded_file($_FILES['agency_image']['tmp_name'], $targetFile)) {
        $imageData = $targetFile;
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to upload image.']);
        exit();
    }
}

// เตรียมคำสั่ง SQL สำหรับการแทรกข้อมูล
$stmt = $conn->prepare("INSERT INTO tb_agency (agency_name, agency_details, agency_wed, agency_call, email, password, agency_image, userType) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
if ($stmt === false) {
    echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $conn->error]);
    exit();
}

// ผูกค่าที่จะใช้ในคำสั่ง SQL
$stmt->bind_param("ssssssss", $agency_name, $agency_details, $agency_wed, $agency_call, $email, $hashedPassword, $imageData, $userType);

// รันคำสั่ง SQL
if ($stmt->execute()) {
    $agency_id = $stmt->insert_id; // ดึงค่า agency_id ที่ถูกสร้างขึ้น
    echo json_encode(['status' => 'success', 'agency_id' => $agency_id]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $stmt->error]);
}

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
