<?php
header('Content-Type: application/json; charset=utf-8');

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "omni";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// Retrieve form data
$nameSurname = $_POST['name_surname'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$confirmPassword = $_POST['confirm_password'] ?? '';
$gender = $_POST['gender'] ?? '';
$birthday = $_POST['birthday'] ?? '';
$phone = $_POST['phone'] ?? '';
$address = $_POST['address'] ?? '';
$agency = $_POST['agency'] ?? '';
$image = $_FILES['image'] ?? null;

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["status" => "error", "message" => "Invalid email format"]);
    exit();
}

// Check if passwords match
if ($password !== $confirmPassword) {
    echo json_encode(["status" => "error", "message" => "Passwords do not match"]);
    exit();
}

// Validate agency
$checkAgencySql = "SELECT agency_id FROM tb_agency WHERE agency_id = ?";
$stmt = $conn->prepare($checkAgencySql);
if ($stmt === false) {
    echo json_encode(["status" => "error", "message" => "Error preparing statement: " . $conn->error]);
    exit();
}

$stmt->bind_param("i", $agency);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Invalid agency_id"]);
    $stmt->close();
    $conn->close();
    exit();
}

$stmt->close();

// Handle image upload
$imagePath = '';
if ($image && $image['tmp_name']) {
    $targetDir = "uploads/";
    $targetFile = $targetDir . basename($image["name"]);
    if (move_uploaded_file($image["tmp_name"], $targetFile)) {
        $imagePath = $targetFile;
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to upload image"]);
        exit();
    }
}

// Hash the password
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Insert user into the database
$sql = "INSERT INTO tb_users (user_name_surname, user_email, user_password, user_gender, user_birthday, user_phone, user_address, agency_id, user_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    echo json_encode(["status" => "error", "message" => "Error preparing statement: " . $conn->error]);
    exit();
}

$stmt->bind_param("sssssssis", $nameSurname, $email, $hashedPassword, $gender, $birthday, $phone, $address, $agency, $imagePath);

if ($stmt->execute()) {
    $user_id = $stmt->insert_id;
    echo json_encode(["status" => "success", "user_id" => $user_id]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $stmt->error]);
}

// Close connection
$stmt->close();
$conn->close();
?>
