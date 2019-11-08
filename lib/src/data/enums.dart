import 'package:flutter/material.dart';

enum UINav { photoBooth, imageSelect  }

// BOOTH
enum UIBoothTrigger { reset, undo, save}
// add 6 colors
enum ColorSelect {
  red,
  blue,
  yellow,
  green,
  purple,
  orange,
  brown,
  grey,
  black,
  white,
  amber,
  cyan,
  indigo,
  pink,
  teal,
  lime
}

Color getColor(ColorSelect color) {
  Color _color;
  switch (color) {
    case ColorSelect.red:
      _color = Colors.red;
      break;
    case ColorSelect.blue:
      _color = Colors.blue;
      break;
    case ColorSelect.yellow:
      _color = Colors.yellow;
      break;
    case ColorSelect.green:
      _color = Colors.green;
      break;
    case ColorSelect.purple:
      _color = Colors.purple;
      break;
    case ColorSelect.orange:
      _color = Colors.orange;
      break;
    case ColorSelect.brown:
      _color = Colors.brown;
      break;
    case ColorSelect.white:
      _color = Colors.white;
      break;
    case ColorSelect.grey:
      _color = Colors.grey;
      break;
    case ColorSelect.black:
      _color = Colors.black;
      break;
    case ColorSelect.amber:
      _color = Colors.amber;
      break;
    case ColorSelect.cyan:
      _color = Colors.cyan;
      break;
    case ColorSelect.indigo:
      _color = Colors.indigo;
      break;
    case ColorSelect.pink:
      _color = Colors.pink;
      break;
    case ColorSelect.teal:
      _color = Colors.teal;
      break;
    case ColorSelect.lime:
      _color = Colors.lime;
      break;
  }
  return _color;
}
// IMAGE GETTER

enum UIImageTrigger { camera, gallery, save, edit }
