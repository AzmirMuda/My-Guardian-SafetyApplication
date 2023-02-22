<?php
if (!isset($_POST)){
	$response = array('status' => 'failed','data' => null);
	sendJsonResponse($response);
	die();
}
include_once("dbconnect.php");
$productName = $_POST['productName'];
$productName = "DELETE * FROM `tbl_products` WHERE productName = '$productName'";
try{
	if ($conn->query($sqldelete) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
		   sendJsonResponse($response);
	}

	else{
		$response = array('status' => 'failed','data' => null);
		sendJsonResponse($response);
	}
}
	catch(Exception $e){
	$response = array('status' => 'failed', 'data' => null);
		   sendJsonResponse($response);
	
}
$conn->close();

function sendJsonResponse($sentArray)
{
	header('content-Type: application/json');
	echo json_encode($sentArray);
}

?>