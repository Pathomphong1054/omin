<?php
header('Content-Type: application/json');

// Database connection settings
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Get parameters from URL
$user_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$user_type = isset($_GET['type']) ? strtolower($_GET['type']) : '';

if ($user_id <= 0 || empty($user_type)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user ID or type']);
    exit();
}

// Define the query based on user type
$sql = '';
if ($user_type === 'agency') {
    $sql = "SELECT agency_id AS user_id, agency_name AS name, email, agency_call AS phone, agency_image 
            FROM tb_agency WHERE agency_id = ?";
} elseif ($user_type === 'user') {
    $sql = "SELECT user_id, user_name_surname AS name, user_gender AS gender, user_birthday AS birthdate, 
            user_phone AS phone, user_email AS email, user_address AS address, user_image AS profile_image, agency_id 
            FROM tb_users WHERE user_id = ?";
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user type']);
    exit();
}

// Prepare and execute the query
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die(json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $conn->error]));
}

$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result && $result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    if ($user_type === 'agency' && !empty($user['agency_image'])) {
        // กำหนดเส้นทางที่ถูกต้องของรูปภาพสำหรับ agency
        $user['profile_image'] = 'uploads/' . basename($user['agency_image']);
    } elseif ($user_type === 'user' && !empty($user['profile_image'])) {
        // กำหนดเส้นทางที่ถูกต้องของรูปภาพสำหรับ user
        $user['profile_image'] = 'uploads/' . basename($user['profile_image']);
    } else {
        $user['profile_image'] = 'uploads/default.png';
    }
    
    echo json_encode(['status' => 'success', 'data' => $user]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'User not found']);
}



$stmt->close();
$conn->close();
?>
