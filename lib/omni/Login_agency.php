<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

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
    die(json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Get POST data
$email = isset($_POST['email']) ? $_POST['email'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// Debugging: log received email and password
error_log("Received Email: $email, Password: $password");

// Prepare the SQL statement to fetch user details
$stmt = $conn->prepare("SELECT agency_id, agency_name, email, password FROM tb_agency WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $stmt->bind_result($agency_id, $agency_name, $email, $stored_password);
    $stmt->fetch();

    // Debugging: log fetched password
    error_log("Stored Password: $stored_password");

    // Verify the password (assuming the password is hashed)
    if (password_verify($password, $stored_password) || $password == $stored_password) {
        $response = array(
            'success' => true,
            'message' => 'Login successful',
            'profile_data' => array(
                'agency_id' => $agency_id,
                'agency_name' => $agency_name,
                'email' => $email
            )
        );
    } else {
        $response = array(
            'success' => false,
            'message' => 'Invalid email or password'
        );
    }
} else {
    $response = array(
        'success' => false,
        'message' => 'Invalid email or password'
    );
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Return the response as JSON
echo json_encode($response);
?>
