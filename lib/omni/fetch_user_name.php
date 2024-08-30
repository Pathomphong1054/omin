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

$user_id = $_POST['user_id']; // หรือ $_GET['user_id']

// ตรวจสอบว่าผู้ใช้นั้นเป็น User หรือ Agency
$sql = "SELECT name FROM tb_users WHERE user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(['status' => 'success', 'name' => $row['name']]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'User not found']);
}

$conn->close();
?>
