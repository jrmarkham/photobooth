import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/models/pbd.dart';
import 'package:photobooth/src/data/services/php_services.dart';
import './bloc.dart';

/*
Photo


 */
const int BACKTRACK_MAX = 6;
class PBDBloc extends Bloc<PBDEvent, PBDState> {
  @override
  PBDState get initialState => PBDStateInit();
  PBDObject _pbdObject;
  File _imageFile;
  final List<Stroke> _strokeList = [];
  int backTracks = 0;
  bool _backTrack = false;
  ColorSelect _currentColor = ColorSelect.red;
  // BLOC for displaying and the photo and drawing ui
  // updates will be coordinated w/ image function and ui calls//


  // post data service
  final BasePHPService _phpServices = PHPService();

  @override
  Stream<PBDState> mapEventToState(
    PBDEvent event,
  ) async* {

    if(event is PBDEventInit){
      // should be empty object
      _imageFile = null;
      _backTrack = false;
      _pbdObject = PBDObject(_imageFile, _strokeList);
      yield PBDStateLoading();
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    // reset pbd stage
    if(event is PBDEventReset){
      // should be empty object
      // _imageFile = null;
      _strokeList.clear(); // empty strokes //
      _imageFile = null;
      _backTrack = false;
      _currentColor = ColorSelect.red;
      _pbdObject = PBDObject(_imageFile, _strokeList);
      yield PBDStateLoading();
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }
    // return to pbd

    if(event is PBDEventStage){
      // no updates to document
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    // adding image to object
    if(event is PBDEventSaveImagePBD){
      // add image file to PBDoc
      _pbdObject = PBDObject(_imageFile, _strokeList);
      yield PBDStateLoading();
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    if(event is PBDEventSetColor){
      _currentColor = event.newColor;
      yield PBDStateLoading();
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    if(event is PBDEventAddStroke){
      final stroke = Stroke(_currentColor, event.offsets);
      _strokeList.add(stroke);
      _pbdObject = PBDObject(_imageFile, _strokeList);

      if(backTracks> 0)backTracks --;
      _backTrack = _strokeList.length > 0 && backTracks < BACKTRACK_MAX;
      yield PBDStateLoading();
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    if(event is PBDEventRemoveStroke){
      _strokeList.removeLast();
      backTracks++;
      _backTrack = _strokeList.length > 0 && backTracks < BACKTRACK_MAX;
      _pbdObject = PBDObject(_imageFile, _strokeList);
    yield PBDStateLoading();
    yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    // save functions
    // save image to server
    if(event is PBDEventPostImage){
      bool success = await _phpServices.postImageBase64(event.data, event.name, event.directory);
      yield PBDStateSaveResponse(success);
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }

    // save photobooth data to server
    if(event is PBDEventPostPBD){
     bool success = await _phpServices.postPBD(event.name, event.directory, _pbdObject);
      yield PBDStateSaveResponse(success);
      yield PBDStateLoaded(_pbdObject, _backTrack, _currentColor);
    }





    // Called for getting new image for editing or replacement
    if(event is PBDEventSelectImage){
      yield PBDStateImageLoad(_imageFile);
    }

    // loading a new image from gallery or camera
    if(event is PBDEventSetSelectImage){
      _imageFile = event.imageFile;
      yield PBDStateImageLoad(_imageFile);
    }

    // set to Edit
    if(event is PBDEventEditSelectImage){
      if(_imageFile != null) {
        yield PBDStateImageEdit(_imageFile);
        return;
      }
      yield PBDStateImageLoad(_imageFile);
    }
  }
}
