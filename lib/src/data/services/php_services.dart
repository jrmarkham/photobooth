import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';



// PHP POSTS
const String PHP_IMAGE_POST = "https://sandbox.markhamenterprises.com/photos/";
const String PHP_PBD_POST = "https://sandbox.markhamenterprises.com/docs/";

// convert to class singleton service
abstract class BasePHPService {
  Future<bool> postPBD(String _name, String _dir, PBDObject _pbdObject, int _backTracks);
  Future<bool> postImageBase64(String _base64, String _name, String _dir);
}

class PHPService extends BasePHPService {
  // static singleton
  static final PHPService _instance = PHPService.internal();
  factory PHPService() => _instance;
  PHPService.internal();
  // DIO is a service I use to post to php it wraps things better than
  final Dio dio = Dio();

  Future<bool> postPBD(String _name, String _dir, PBDObject _pbdObject, int _backTracks) async {
    // save image
    bool success = false;
    final String _fn = _name;
    final json = jsonEncode(_pbdObject.strokes);

    final FormData fd = FormData.fromMap({
      'image':
          await MultipartFile.fromFile(_pbdObject.image.path, filename: _fn +'.png'),
      'dir': _dir, 'strokes':json, 'json_name':_name+'.json', 'backs': _backTracks
    });

    try {
      await dio
          .post(PHP_PBD_POST,
              data: fd,
              options: Options(method: 'POST', responseType: ResponseType.json))
          .then((response) {
        debugPrint('response ${response.toString()}');

        if (response.toString().contains('success')) {
          success = true;
        }
      }).catchError((error) {
        success = false;
        debugPrint('error ${error.toString()}');
      });
    } catch (e) {
      success = false;
      debugPrint('error ${e.toString()}');
    }

    return success;
  }

  Future<bool> postImageBase64(
      String _base64, String _name, String _dir) async {
    bool success = false;

    final FormData fd =
        FormData.fromMap({'base64': _base64, 'name': _name + '.png', 'dir': _dir});

    try {
      await dio
          .post(PHP_IMAGE_POST,
              data: fd,
              options: Options(method: 'POST', responseType: ResponseType.json))
          .then((response) {
        debugPrint('response ${response.toString()}');

        if (response.toString().contains('success')) {
          success = true;
        }
      }).catchError((error) {
        success = false;
        debugPrint('error ${error.toString()}');
      });
    } catch (e) {
      success = false;
      debugPrint('error ${e.toString()}');
    }
    return success;
  }


}
