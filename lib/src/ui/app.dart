import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/elements/image_ui.dart';
import 'package:photobooth/src/ui/elements/pbd_stage.dart';
import 'package:photobooth/src/ui/elements/pbd_ui.dart';
import 'package:photobooth/src/ui/elements/save_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  UIBloc _uiBloc;
  PBDBloc _pbdBloc;
  String appTitle;

// Content available
  bool _imageAvailable;
  bool _pbdAvailable;
  bool _backTrack;
  bool _saveAvailable;
  ColorSelect _curColor = ColorSelect.red;
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    appTitle = title;
    _imageAvailable = false;
    _pbdAvailable = false;
    _saveAvailable = false;
    _pbdBloc = BlocProvider.of<PBDBloc>(context);
    _uiBloc = BlocProvider.of<UIBloc>(context);
    _pbdBloc.add(PBDEventInit());
    _uiBloc.add(UIEventInit());
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _uiBloc.close();
    _pbdBloc.close();
  }

  // set style connects to style file and set sizes based on device dimensions//
  initDevice(BuildContext context) {
    setDeviceDimensions(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
  }

  Widget getUI(UINav uiNav) {
    final Function setColorFunction =
        (ColorSelect _newColor) => _pbdBloc.add(PBDEventSetColor(_newColor));
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8.0),
          uiNav == UINav.photoBooth
              ? PhotoBoothUI(_uiBloc, _pbdAvailable, _saveAvailable, _backTrack,
                  _curColor, setColorFunction)
              : ImageSelectorUI(_uiBloc, _imageAvailable),
          SizedBox(height: 8.0),
          Center(child: PBDStage(_globalKey)),
        ]);
  }

  // USING A PLUGIN FORM IMAGE COLLECTION
  // THIS PLUGIN IS CORE TO FLUTTER DEV TEAM
  void getImage(ImageSource _is) async {
    // IMAGE INTERFACE GETS IMAGE IMAGE
    try {
      final File _image = await ImagePicker.pickImage(source: _is);
      if (_image != null) _pbdBloc.add(PBDEventSetSelectImage(_image));
    } on PlatformException {
      informAlert(context, 'error', 'error messages');
    }
  }

  void editImage(File _image) async {
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
      informAlert(context, 'error', 'error messages');
    }
  }

  void saveImage(String name, String directory) async{
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    String bs64 = base64Encode(pngBytes);
    _pbdBloc.add(PBDEventPostImage(bs64, name, directory));
  }

  @override
  Widget build(BuildContext context) {
    initDevice(context);
    final Function saveImageFunction = (String name, String dir) => saveImage(name, dir);
    final Function savePBDFunction = (String name, String dir) => _pbdBloc.add(PBDEventPostPBD(name, dir));
    final SaveFormPage saveFormPage = SaveFormPage(saveImageFunction, savePBDFunction);
    return MultiBlocListener(
      // set up all bloc listener here
      // coordinate between blocs call each other events
      // use bloc builders as ui on the pages //

      listeners: [
        BlocListener<UIBloc, UIState>(
            listener: (BuildContext context, UIState state) {
          if (state is UIStateLoaded) {
            setState(() {
              if (state.boothTrigger != null) {
                // do trigger and return //
                // reset the photo booth document
                switch (state.boothTrigger) {
                  case UIBoothTrigger.reset:
                    _pbdBloc.add(PBDEventReset());
                    return;
                    // back track last draw //
                  case UIBoothTrigger.undo:
                    _pbdBloc.add(PBDEventRemoveStroke());
                    return;
                  case UIBoothTrigger.save:
                    fullScreenDialog(context, saveHeader, saveFormPage);
                    return;
                }
              }

              if (state.imageTrigger != null) {
                // do trigger and return //
                switch (state.imageTrigger) {
                  case UIImageTrigger.camera:
                    // open camera ui on phone
                    // add image retrieved to image select ui //
                    getImage(ImageSource.camera);
                    return;
                  case UIImageTrigger.gallery:
                    // open gallery ui on phone
                    // add image retrieved to image select ui //
                    getImage(ImageSource.gallery);
                    return;
                  case UIImageTrigger.edit:
                    // open edit ui on phone
                    // add image retrieved to image select ui //
                    // need image so call thru pbdBloc
                    _pbdBloc.add(PBDEventEditSelectImage());
                    return;
                  case UIImageTrigger.save:
                    // save image to the current photo booth document
                    // the image will be used as a back ground image
                    // save image redirect to photo booth
                    _pbdBloc.add(PBDEventSaveImagePBD());
                    // redirect to photo booth //
                    _uiBloc.add(UIEventNav(UINav.photoBooth));

                    return;
                }
              }

              // redirect if necessary
              switch (state.uiNav) {
                case UINav.imageSelect:
                  // update pbdBloc
                  _pbdBloc.add(PBDEventSelectImage());
                  appTitle = imageSelectHeader;
                  return;

                case UINav.photoBooth:
                  // return to stage via a close // no update
                  _pbdBloc.add(PBDEventStage());
                  appTitle = title;
                  return;
              }
            });
          }
        }),
        // read updates from the photo booth bloc
        BlocListener<PBDBloc, PBDState>(
            listener: (BuildContext context, PBDState state) {
          // PHOTO BOOTH STATES
          if (state is PBDStateLoaded) {
            setState(() {
              _pbdAvailable = state.pbdObject.image != null ||
                  state.pbdObject.strokes.length > 0;
              _backTrack = state.backTrack;
              _curColor = state.curColor;
            });
          }

          // POST RESPONSE
          if (state is PBDStateSaveResponse) {
           informAlert(context, 'respons', 'response ${state.response.toString()}');
          }

          // IMAGE SELECT STATE
          if (state is PBDStateImageLoad) {
            setState(() {
              _imageAvailable = state.imageFile != null;
            });
            // empty
          }

          // edit image
          if (state is PBDStateImageEdit) {
            editImage(state.imageFile);
            // empty
          }
        }),
      ],

      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle, style: titleTextStyle()),
          ),

          // bloc build for ui -- toggle between main
          // Core detector for closing mobile keyboard
          body: GestureDetector(
              // close key boards
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: BlocBuilder(
                  bloc: _uiBloc,
                  builder: (BuildContext context, UIState state) {
                    if (state is UIStateLoaded) {
                      switch (state.uiNav) {
                        case UINav.imageSelect:
                        case UINav.photoBooth:
                          return getUI(state.uiNav);
                      }
                    }
                    // default return
                    return appLoading();
                  })),
        ),
      ),
    );
  }
}
