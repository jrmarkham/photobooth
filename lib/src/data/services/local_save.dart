import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';



// PHP POSTS
const String PHP_IMAGE_POST = "https://sandbox.markhamenterprises.com/photos/";
const String PHP_PBD_POST = "https://sandbox.markhamenterprises.com/docs/";

// convert to class singleton service
abstract class BaseSharedPrefService {
  Future<bool> savePBDObject();
  // load
  Future<PBDObject> getPBDObject();
}

class SharedPrefService extends BaseSharedPrefService {
  // static singleton
  static final SharedPrefService _instance = SharedPrefService.internal();
  factory SharedPrefService() => _instance;
  SharedPrefService.internal();
  // DIO is a service I use to post to php it wraps things better than
  Future<bool> savePBDObject()async => true;
  Future<PBDObject> getPBDObject()async => PBDObject(null, null);
//
//  _saveImage();
//  _saveStrokes();
}
