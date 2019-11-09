
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';

// Functions for loading image getting and edit interface.
// These plugin use native ui to manipulate teh images and camera on the phone.

// USING A PLUGIN FORM IMAGE COLLECTION
// THIS PLUGIN IS CORE TO FLUTTER DEV TEAM


void getImage(ImageSource _is, PBDBloc _pbdBloc) async {
    // IMAGE INTERFACE GETS IMAGE IMAGE
    try {
        final File _image = await ImagePicker.pickImage(source: _is);
        if (_image != null) _pbdBloc.add(PBDEventSetSelectImage(_image));
    } on PlatformException {
        debugPrint('PlatformException');
    }
}

void editImage(File _image, PBDBloc _pbdBloc) async {
    // EDIT IMAGE INTERFACE GETS IMAGE IMAGE
    try {
        final File _updateImage = await ImageCropper.cropImage(
            sourcePath: _image.path,
            aspectRatioPresets: [CropAspectRatioPreset.original],
            androidUiSettings: AndroidUiSettings(
                lockAspectRatio: true,
                toolbarTitle: labelCropper,
                initAspectRatio: CropAspectRatioPreset.original),
            iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 1.0)); // ratioX: 1.0, ratioY: 1.0);
        if (_updateImage != null)
            _pbdBloc.add(PBDEventSetSelectImage(_updateImage));
    } on PlatformException {
        debugPrint('PlatformException');
    }
}

void saveImage(String name, String directory, PBDBloc _pbdBloc, GlobalKey _globalKey) async{
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    String bs64 = base64Encode(pngBytes);
    _pbdBloc.add(PBDEventPostImage(bs64, name, directory));
}

