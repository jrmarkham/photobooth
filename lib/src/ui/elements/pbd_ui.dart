import 'package:flutter/material.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/elements/color_dropdown.dart';

class PhotoBoothUI extends StatelessWidget {
  final UIBloc _uiBloc;
  final bool _pbdAvailable;
  final bool _loadAvailable;
  final bool _backAvailable;
  final ColorSelect _currentColor;
  final Function _setColor;
  PhotoBoothUI(this._uiBloc, this._pbdAvailable, this._loadAvailable, this._backAvailable, this._currentColor, this._setColor);


  @override
  Widget build(BuildContext context) {
    final Function newFileFunction = _pbdAvailable
        ? () => _uiBloc.add(UIEventPhotoBoothTrigger(UIBoothTrigger.reset))
        : null;
    final Function openFunction = _loadAvailable
        ? () => _uiBloc.add(UIEventPhotoBoothTrigger(UIBoothTrigger.load))
        : null;
    final Function saveFunction = _pbdAvailable
        ? () => _uiBloc.add(UIEventPhotoBoothTrigger(UIBoothTrigger.save))
        : null;
    final Function imageSelectFunction = () => _uiBloc.add(UIEventNav(UINav.imageSelect));

    final Function undoFunction = _backAvailable
        ? () => _uiBloc.add(UIEventPhotoBoothTrigger(UIBoothTrigger.undo))
        : null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
              decoration: appBorder(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  iconButton(
                      icon: iconNewFile,
                      function: newFileFunction,
                      tooltip: btnNewFile),
                  iconButton(
                      icon: iconOpen, function: openFunction, tooltip: btnOpen),
                  iconButton(
                      icon: iconSave, function: saveFunction, tooltip: btnSave),
                  iconButton(
                      icon: iconImage,
                      function: imageSelectFunction,
                      tooltip: btnImage),
                  iconButton(
                      icon: iconUndo, function: undoFunction, tooltip: btnUndo),
                 ColorDropdown(_currentColor, _setColor)
                ],
              )),
    );
  }
}
