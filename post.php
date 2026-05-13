<?php
error_reporting(0);
ini_set('display_errors', 0);

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: index.html");
    exit();
}

function clean_input($value) {
    $value = trim($value ?? "");
    $value = strip_tags($value);
    $value = str_replace(["\r", "\n", "|"], " ", $value);
    return substr($value, 0, 100);
}

$username = clean_input($_POST["username"] ?? "");
$password = clean_input($_POST["password"] ?? "");

$maskedPassword = str_repeat("*", min(strlen($password), 12));
$time = date("Y-m-d H:i:s");
$ip = $_SERVER["REMOTE_ADDR"] ?? "unknown";

$data = "Time: $time | IP: $ip | Username: $username | Password: $maskedPassword\n";

file_put_contents("usernames.txt", $data, FILE_APPEND | LOCK_EX);

header("Location: success.html");
exit();
?>
