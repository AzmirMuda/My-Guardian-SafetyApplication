<?php
if (!isset($_POST)){
	$response = array('status' => 'failed','data' => null);
	sendJsonResponse($response);
	die();
}

include_once("dbconnect.php");
$userid = $_POST['userid'];
$prname = $_POST['prname'];
$prdesc=$_POST['prdesc'];
$prprice = $_POST['prprice'];
$state=$_POST['state'];
$local = $_POST['local'];
$lat = $_POST['lat'];
$lon = $_POST['lon'];
$image=$_POST['image'];


$sqlinsert = "INSERT INTO `tbl_products`(`user_id`, `product_name`, `prodcut_desc`, `product_price`,
 `product_state`, `product_local`, `product_lat`, `product_lng`) 
VALUES ('$userid','$prname','$prdesc','$prprice','$state','$local','$lat','$lon')";

$response = array('status' => 'success','data' => $sqlinsert);
	sendJsonResponse($response);


function sendJsonResponse($sentArray)
{
	header('content-Type: application/json');
	echo json_encode($sentArray);
}

?>