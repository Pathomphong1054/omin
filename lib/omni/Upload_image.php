<?php
header('Content-Type: application/json');
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
    $target_file = $target_dir . basename($_FILES["image"]["name"]);
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    // Check if image file is a actual image or fake image
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if ($check === false) {
        die(json_encode(['status' => 'error', 'message' => 'File is not an image.']));
    }

    // Check file size (limit 5MB)
    if ($_FILES["image"]["size"] > 5000000) {
        die(json_encode(['status' => 'error', 'message' => 'Sorry, your file is too large.']));
    }

    // Allow certain file formats
    if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg") {
        die(json_encode(['status' => 'error', 'message' => 'Sorry, only JPG, JPEG, & PNG files are allowed.']));
    }

    // Check if file already exists and save the file with a unique name
    if (file_exists($target_file)) {
        $target_file = $target_dir . uniqid() . '.' . $imageFileType;
    }

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $image_url = "http://10.5.50.82/omni/" . $target_file;

        // Update profile image URL in the database
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
