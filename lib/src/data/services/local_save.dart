
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PHP POSTS
const String IMAGE_PATH = "image_path";
const String STROKE_COUNT = "strokes";
const String BACK_COUNT = "backs";

// convert to class singleton service
abstract class BaseSharedPrefService {
  // check initial data
  Future<bool> initLoadSaved();
  Future<bool> savePBDObject(PBDObject pbdObject, int backs);

  // load
  Future<PBDObject> getPBDObject();
  Future<int> getBacks();
}

class SharedPrefService extends BaseSharedPrefService {
  // static singleton
  static final SharedPrefService _instance = SharedPrefService.internal();
  factory SharedPrefService() => _instance;
  PBDObject _pbdObject;
  int _backs;

  SharedPrefService.internal();
  SharedPreferences _prefs;
  Future<bool> savePBDObject(PBDObject pbdObject, int backs) async {
    _prefs = await SharedPreferences.getInstance();
    // save items locally for immediate reload
    _pbdObject = PBDObject(pbdObject.image, pbdObject.strokes.toList());

    // pbdObject;
    _backs = backs;

    _prefs.setString(IMAGE_PATH, _pbdObject.image.path);
    _prefs.setInt(BACK_COUNT, _backs);
    final int len = _pbdObject.strokes == null ? 0 : _pbdObject.strokes.length;
    _prefs.setInt(STROKE_COUNT, len);
    for (int i = 0; i < len; i++) {
      final String colorSave = 'color' + i.toString();
      final String offsets = 'offsets' + i.toString();
      final Stroke stroke = _pbdObject.strokes[i];
      _prefs.setInt(colorSave, stroke.color.index);
      _prefs.setString(offsets, stroke.offsetString);
    }
    return true;
  }

  Future<PBDObject> getPBDObject() async {
    // rebuild for pref data
    if (_pbdObject == null) _pbdObject = await _buildSavePBDObject();
    return _pbdObject;
  }

  Future<int> getBacks() async {
    if (_backs == null) {
      // rebuild for pref data
      _prefs = await SharedPreferences.getInstance();
      _backs =
          _prefs.getInt(BACK_COUNT) == null ? 0 : _prefs.getInt(BACK_COUNT);
    }

    return _backs;
  }

  Future<bool> initLoadSaved() async {
    // rebuild for pref data
    if (_pbdObject == null) _pbdObject = await _buildSavePBDObject();
    if (_backs == null) {
      // rebuild for pref data
      _prefs = await SharedPreferences.getInstance();
      _backs =
          _prefs.getInt(BACK_COUNT) == null ? 0 : _prefs.getInt(BACK_COUNT);
    }

    return _pbdObject != null && _backs != null;
  }

  Future<PBDObject> _buildSavePBDObject() async {
    _prefs = await SharedPreferences.getInstance();
    File image;
    try{
      if (_prefs.getString(IMAGE_PATH) != null)
        // image may not be found by simulator
       image = File(_prefs.getString(IMAGE_PATH)).existsSync() ? File(_prefs.getString(IMAGE_PATH)):null;

    }catch (e){
      debugPrint('::::ERROR:::: ${e.toString()}');
    }

      List<Stroke> strokes = [];
      final int len =
      _prefs.getInt(STROKE_COUNT) == null ? 0 : _prefs.getInt(STROKE_COUNT);

      // run thru saved data and rebuild stroke data
      for (int i = 0; i < len; i++) {
        final String colorSave = 'color' + i.toString();
        final String offsets = 'offsets' + i.toString();
        final String _offsetStr = _prefs.getString(offsets);
        final List<Offset> offList = [];
        final List<String> list = _offsetStr.split("#");
        list.forEach((item) {
          // get numbers
          final List<String> coords = item.split(",");
          final Offset offset =
          Offset(double.parse(coords[0]), double.parse(coords[1]));
          offList.add(offset);
        });
        offList.add(null);
        final Stroke stroke =
        Stroke(ColorSelect.values[_prefs.getInt(colorSave)], offList);

        strokes.add(stroke);
      }

      return PBDObject(image, strokes);
    }
  }

