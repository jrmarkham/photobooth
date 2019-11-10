import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/data/models/pbd.dart';

abstract class PBDEvent extends Equatable {
  const PBDEvent();
}

// INIT PBD
class PBDEventInit extends PBDEvent{
  @override
  List<Object> get props => [];
}

class PBDEventReset extends PBDEvent{
  @override
  List<Object> get props => [];
}

class PBDEventStage extends PBDEvent{
  @override
  List<Object> get props => [];
}



// PHOTO BOOTH UI
// When an image is retrieved
// it needs to be save to the current PBD
class PBDEventSaveImagePBD extends PBDEvent{
  @override
  List<Object> get props => [];
}


class PBDEventSetColor extends PBDEvent{
  final ColorSelect newColor;
  PBDEventSetColor(this.newColor);

  @override
  List<Object> get props => [newColor];
}

class PBDEventAddStroke extends PBDEvent{
  final List<Offset> offsets;
  PBDEventAddStroke(this.offsets);

  @override
  List<Object> get props => [offsets];
}

class PBDEventRemoveStroke extends PBDEvent{
  @override
  List<Object> get props => [];
}


// IMAGE LOADING AND EDIT UI -- no DRAWING INTERFACE
class PBDEventSelectImage extends PBDEvent{

  @override
  List<Object> get props => [];
}

class PBDEventSetSelectImage extends PBDEvent{
  final File imageFile;
  PBDEventSetSelectImage(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}


class PBDEventEditSelectImage extends PBDEvent{

  @override
  List<Object> get props => [];
}



class PBDEventPostImage extends PBDEvent{
final String data;
final String name;
final String directory;
PBDEventPostImage(this.data, this.name, this.directory);
  @override
  List<Object> get props => [data, name, directory];
}

class PBDEventPostPBD extends PBDEvent{
  final String name;
  final String directory;
  PBDEventPostPBD(this.name, this.directory);
  @override
  List<Object> get props => [name, directory];
}


// load image and data refresh w/ save PBD
class PBDEventLoadPBD extends PBDEvent{

  @override
  List<Object> get props => [];
}

