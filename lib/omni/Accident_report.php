<?php
header('Content-Type: application/json');

// เชื่อมต่อกับฐานข้อมูล
$servername = "localhost"; 
$username = "root";
$password = ""; 
$dbname = "omni"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// ตรวจสอบว่ามีข้อมูลส่งเข้ามาหรือไม่
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $category = isset($_POST['category']) ? $_POST['category'] : '';
    $headline = isset($_POST['headline']) ? $_POST['headline'] : '';
    $date = isset($_POST['date']) ? $_POST['date'] : '';
    $details = isset($_POST['details']) ? $_POST['details'] : '';
    $accident_vehicle = isset($_POST['accident_vehicle']) ? $_POST['accident_vehicle'] : '';
    $accident_distance = isset($_POST['accident_distance']) ? $_POST['accident_distance'] : '';
    $accident_time = isset($_POST['accident_time']) ? $_POST['accident_time'] : '';
    $accident_location = isset($_POST['accident_location']) ? $_POST['accident_location'] : '';
    
    // ตรวจสอบและอัปโหลดไฟล์ภาพ
    $imagePaths = [];
    if (isset($_FILES['images'])) {
        $uploadDir = 'uploads/'; // โฟลเดอร์ที่ใช้เก็บรูปภาพ
        foreach ($_FILES['images']['tmp_name'] as $key => $tmpName) {
            $fileName = basename($_FILES['images']['name'][$key]);
            $targetFilePath = $uploadDir . $fileName;
            
            if (move_uploaded_file($tmpName, $targetFilePath)) {
                $imagePaths[] = $targetFilePath;
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Failed to upload image: ' . $fileName]);
                exit();
            }
        }
    }

    $imageString = implode(',', $imagePaths);

    // สร้างคำสั่ง SQL เพื่อเพิ่มข้อมูลเข้าในฐานข้อมูล
    $stmt = $conn->prepare("INSERT INTO tb_accident (accident_name, accident_location, accident_time, accident_details, accident_vehicle, accident_distance, created_at, accident_image) 
            VALUES (?, ?, ?, ?, ?, ?, NOW(), ?)");
    
    $stmt->bind_param("sssssss", $headline, $accident_location, $accident_time, $details, $accident_vehicle, $accident_distance, $imageString);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Accident report submitted successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to submit accident report']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
