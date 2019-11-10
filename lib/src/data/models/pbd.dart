import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:photobooth/src/data/enums.dart';

class PBDObject extends Equatable {
  final File image;
  final List<Stroke> strokes;

  PBDObject(this.image, this.strokes);

  @override
  List<Object> get props => [image, strokes];

  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(PBDObject _object) {
    return <String, dynamic>{
      'image': _object.image,
      'strokes': _object.strokes
    };
  }
}

class Stroke extends Equatable {
  final ColorSelect color;
  final List<Offset> offsets;

  Stroke(this.color, this.offsets);

  @override
  List<Object> get props => [color, offsets];

  Map<String, dynamic> toJson() => _itemToJson(this);
  Map<String, dynamic> _itemToJson(Stroke _stroke) {
    return <String, dynamic>{
      'color': _stroke.color.index,
      'offsets': _getOffsetString()
    };
  }

  String get offsetString => _getOffsetString();

  String _getOffsetString() {
    String str = '';
    this.offsets.forEach((item) {
      if (item != null) {
        if (str == '')
          str = item.dx.toString() + ',' + item.dy.toString();
        else
          str += '#' + item.dx.toString() + ',' + item.dy.toString();
      }
    });

    return str;
  }
}
