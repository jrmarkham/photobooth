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

// NEW POST 
// This service writes the compied stage image as a png.
// file location: https://sandbox.markhamenterprises.com/photos/images/

$name = $_POST["name"];
$dir_user = $_POST["dir"];
$target_dir = "images/";
$base64String = $_POST["base64"];

// check directory and add directory if missing
$dir = $target_dir . $dir_user;
if( !is_dir( $dir ) ){
    mkdir( $dir, 0777, true );
    chmod($dir, 0777);
}
$post = $dir . '/'. $name;

if(file_put_contents($post, base64_decode($base64String))){
    echo "success";
} else {
    echo "error.";
}
