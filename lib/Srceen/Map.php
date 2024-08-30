<?php
header('Content-Type: application/json; charset=utf-8');

$servername = "localhost";
$username = "root";
$password = ""; // ใส่รหัสผ่านที่คุณใช้สำหรับผู้ใช้ root ของ MySQL
$dbname = "omni";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// รับข้อมูลจาก POST
$accident_name = $_POST['accident_name'] ?? '';
$accident_location = $_POST['accident_location'] ?? '';
$accident_time = $_POST['accident_time'] ?? '';
$accident_details = $_POST['accident_details'] ?? '';
$accident_vehicle = $_POST['accident_vehicle'] ?? '';
$agency_id = $_POST['agency_id'] ?? 0;
$imageaccident_id = $_POST['imageaccident_id'] ?? 0;

// จัดการอัปโหลดไฟล์
$uploadDir = 'uploads/';
$image_path = null;

// ตรวจสอบข้อมูลที่ได้รับ
if (empty($accident_name) || empty($accident_locations) || empty($accident_time) || empty($accident_details) || empty($accident_vehicle) ) {
    die(json_encode(["success" => false, "message" => "Please fill all fields."]));
}

// เข้ารหัสรหัสผ่าน
$hashed_password = password_hash($password, PASSWORD_BCRYPT);

// เตรียมคำสั่ง SQL
$stmt = $conn->prepare("INSERT INTO tb_accident (accident_name, accident_location, accident_time, accident_details, accident_image, accident_vehicle, accident_distance, agency_id, imageaccident_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("sssssss", $accident_name, $accident_location, $accident_time, $accident_details, $accident_vehicle, $agency_id, $imageaccident_id);

// ดำเนินการคำสั่ง SQL
if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Accident report submitted successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Execute statement failed: " . $stmt->error]);
}

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
