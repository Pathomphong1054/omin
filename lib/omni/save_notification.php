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

$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : 0;
$accident_id = isset($_POST['accident_id']) ? intval($_POST['accident_id']) : 0;

if ($user_id > 0 && $accident_id > 0) {
    // Fetch accident details
    $accident_sql = "SELECT * FROM tb_accident WHERE accident_id = ?";
    $stmt = $conn->prepare($accident_sql);
    $stmt->bind_param("i", $accident_id);
    $stmt->execute();
    $accident_result = $stmt->get_result();

    if ($accident_result->num_rows > 0) {
        $accident = $accident_result->fetch_assoc();
        $title = "Accident Report: " . $accident['accident_name'];
        $description = "Location: " . $accident['accident_location'] .
                        "\nTime: " . $accident['accident_time'] .
                        "\nDetails: " . $accident['accident_details'] .
                        "\nVehicle: " . $accident['accident_vehicle'] .
                        "\nImage: " . $accident['accident_image'];

        // Save notification
        $notif_sql = "INSERT INTO notifications (user_id, title, description, created_at) VALUES (?, ?, ?, NOW())";
        $stmt = $conn->prepare($notif_sql);
        $stmt->bind_param("iss", $user_id, $title, $description);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success']);
        } else {
            echo json_encode(['status' => 'error', 'message' => $stmt->error]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Accident not found']);
    }
    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user ID or accident ID']);
}

$conn->close();
?>
