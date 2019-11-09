<?php


header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
header('Access-Control-Allow-Credentials: true');
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers:{$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

/**
 * Created by PhpStorm.
 * User: johnmarkham
 * Date: 2019-01-17
 * Time: 12:34
 */

// This service copies the data(json) and the orginal image(png).
// file location: https://sandbox.markhamenterprises.com/docs/pbd/

// NEW POST 
$dir_user = $_POST["dir"];
$json_name = $_POST["json_name"];
$target_dir = "pbd/";
$backs = $_POST["backs"];

$dir = $target_dir . $dir_user;
if( !is_dir( $dir ) ){
    mkdir( $dir, 0777, true );
    chmod($dir, 0777);
}

$target_file = $dir  . "/". basename($_FILES["image"]["name"]) ;
$target_json = $dir  . "/". $json_name;
$strokes = json_decode($_POST["strokes"], true);

$array = Array (
    "image"=> "http://sandbox.markhamenterprises.com/docs/". $target_file,
    "backs"=> $backs,
    "strokes" => $strokes

);
$json = json_encode($array);

$target_file = $dir  . "/". basename($_FILES["image"]["name"]) ;
$target_json = $dir  . "/". $json_name;

if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
    if (file_put_contents($target_json, $json)){
        echo "success";
    } else {
        echo "error.";
    }
} else {
    echo "error";
}
