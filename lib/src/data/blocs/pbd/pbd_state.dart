import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/models/pbd.dart';

abstract class PBDState extends Equatable {
  const PBDState();
}

class PBDStateInit extends PBDState {
  @override
  List<Object> get props => [];
}

class PBDStateLoading extends PBDState {
  @override
  List<Object> get props => [];
}

class PBDStateLoaded extends PBDState {
  final PBDObject pbdObject;
  final bool backTrack;
  final ColorSelect curColor;
  final bool localSave;
  PBDStateLoaded(this.pbdObject, this.backTrack, this.curColor, this.localSave);
  @override
  List<Object> get props => [pbdObject, backTrack, curColor, localSave];
}

class PBDStateImageLoad extends PBDState {
  final File imageFile;
  PBDStateImageLoad(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}

class PBDStateImageEdit extends PBDState {
  final File imageFile;
  PBDStateImageEdit(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}
// save response
class PBDStateSaveResponse extends PBDState {
  final bool response;
  PBDStateSaveResponse(this.response);
  @override
  List<Object> get props => [response];
}