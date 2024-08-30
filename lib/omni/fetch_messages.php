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

// ดึงค่า group_id จาก GET request
$group_id = intval($_GET['group_id']);

// สร้างคำสั่ง SQL เพื่อดึงข้อมูลแชท
$query = "SELECT m.*, 
          CASE 
            WHEN u.user_name_surname IS NOT NULL THEN u.user_name_surname 
            ELSE a.agency_name 
          END AS name,
          CASE 
            WHEN u.user_image IS NOT NULL THEN u.user_image 
            ELSE a.agency_image 
          END AS profile_image
          FROM messages m 
          LEFT JOIN tb_users u ON m.user_id = u.user_id 
          LEFT JOIN tb_agency a ON m.user_id = a.agency_id 
          WHERE m.group_id = $group_id 
          ORDER BY m.created_at ASC";

$result = $conn->query($query);

// ตรวจสอบและส่งข้อมูลกลับเป็น JSON
if ($result && $result->num_rows > 0) {
    $messages = [];
    while ($row = $result->fetch_assoc()) {
        $messages[] = $row;
    }
    echo json_encode($messages);
} else {
    echo json_encode([]);
}

// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();
?>
